import cv2
import json
import os
import sys
import subprocess
import pandas as pd
import pytesseract
import re

try:
    with open('config.json', 'r', encoding='utf-8') as f:
        CONFIG = json.load(f)
except Exception as e:
    print(f"Failed to load config.json: {e}")
    sys.exit(1)

def get_stream_url(video_url):
    """Use yt-dlp to get the best m3u8 stream URL"""
    try:
        cmd = ["python", "-m", "yt_dlp", "-f", "bestvideo[ext=mp4]/best", "-g"]
        if os.path.exists("cookies.txt"):
            cmd.extend(["--cookies", "cookies.txt"])
        cmd.append(video_url)
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Failed to extract stream URL for {video_url}: {e}")
        print(f"yt-dlp stdout:\n{e.stdout}")
        print(f"yt-dlp stderr:\n{e.stderr}")
        return None
    except Exception as e:
        print(f"Failed to extract stream URL for {video_url}: {e}")
        return None

def preprocess_roi(frame, roi_config, padding):
    h, w = frame.shape[:2]
    y1 = max(0, int(roi_config['y_range'][0] * h) - padding)
    y2 = min(h, int(roi_config['y_range'][1] * h) + padding)
    x1 = max(0, int(roi_config['x_range'][0] * w) - padding)
    x2 = min(w, int(roi_config['x_range'][1] * w) + padding)
    
    roi = frame[y1:y2, x1:x2]
    roi = cv2.resize(roi, None, fx=2.5, fy=2.5, interpolation=cv2.INTER_CUBIC)
    gray = cv2.cvtColor(roi, cv2.COLOR_BGR2GRAY)
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    enhanced = clahe.apply(gray)
    _, thresh = cv2.threshold(enhanced, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)
    return thresh

def clean_ocr_text(text):
    text = re.sub(r'[OoD]', '0', text)
    text = re.sub(r'[lI1|]', '/', text)
    text = re.sub(r'[B&]', '8', text)
    return text.strip()

def process_video(video_url):
    print(f"Starting to process video: {video_url}")
    stream_url = get_stream_url(video_url)
    if not stream_url:
        return [], [], []

    cap = cv2.VideoCapture(stream_url)
    if not cap.isOpened():
        print(f"Failed to open stream for {video_url}")
        return [], [], []

    master_data = []
    circle_data = []
    bandit_data = []
    
    state = "OUT_OF_MATCH"
    match_id = None
    game_start_time = None
    video_start_sec = 0
    current_circle = -1
    consecutive_small_circle = 0
    consecutive_missing = 0
    bandit_count = 0
    bandit_cooldown = 0
    
    anchors = CONFIG['ui_anchors']
    padding = CONFIG.get('padding', 15)
    
    current_msec = 0
    step_msec = 2000 # 0.5 FPS -> 2 seconds
    
    # 限制本地端測試跑 5 分鐘影片內容 (600,000 毫秒) 避免超時
    max_msec = int(os.getenv("MAX_VIDEO_MSEC", "300000")) 
    
    while True:
        cap.set(cv2.CAP_PROP_POS_MSEC, current_msec)
        ret, frame = cap.read()
        if not ret or (max_msec > 0 and current_msec > max_msec):
            break
            
        video_sec = int(current_msec / 1000)
        frame = cv2.resize(frame, (1920, 1080))
        
        # 1. OCR for Circle Info
        circle_roi = preprocess_roi(frame, anchors['circle_info'], padding)
        circle_text = pytesseract.image_to_string(circle_roi, config='--oem 3 --psm 7')
        circle_text = clean_ocr_text(circle_text)
        
        circle_match = re.search(r'([0-8])\s*/\s*8', circle_text)
        detected_circle = int(circle_match.group(1)) if circle_match else -1

        # 2. System Time
        time_roi = preprocess_roi(frame, anchors['system_time'], padding)
        time_text = pytesseract.image_to_string(time_roi, config='--oem 3 --psm 7')
        time_text = re.sub(r'[^\d:]', '', time_text)
        sys_time = time_text if len(time_text) >= 5 else "00:00:00"

        if state == "OUT_OF_MATCH":
            if detected_circle >= 0:
                state = "IN_MATCH"
                video_id = video_url.split("v=")[-1]
                match_id = f"{video_id}_{sys_time}"
                game_start_time = sys_time if detected_circle == 0 else "N/A (中途錄影)"
                video_start_sec = video_sec
                current_circle = detected_circle
                consecutive_missing = 0
                bandit_count = 0
                bandit_cooldown = 0
        elif state == "IN_MATCH":
            if detected_circle == -1:
                consecutive_missing += 1
                if consecutive_missing >= 10:
                    master_data.append({
                        "Match_ID": match_id, "Video_URL": video_url, "Game_Start_Time": game_start_time,
                        "Video_Start_Sec": video_start_sec, "Is_Complete_Match": (current_circle == 8), "Bandit_Count": bandit_count
                    })
                    state = "OUT_OF_MATCH"
                    match_id = None
            else:
                consecutive_missing = 0
                if detected_circle > current_circle:
                    current_circle = detected_circle
                    circle_data.append({
                        "Match_ID": match_id, "Circle_Level": current_circle,
                        "Achieved_Time": sys_time, "Video_Seconds": video_sec
                    })
                elif detected_circle < current_circle:
                    consecutive_small_circle += 1
                    if consecutive_small_circle >= 3:
                        master_data.append({
                            "Match_ID": match_id, "Video_URL": video_url, "Game_Start_Time": game_start_time,
                            "Video_Start_Sec": video_start_sec, "Is_Complete_Match": False, "Bandit_Count": bandit_count
                        })
                        state = "IN_MATCH"
                        video_id = video_url.split("v=")[-1]
                        match_id = f"{video_id}_{sys_time}"
                        game_start_time = sys_time if detected_circle == 0 else "N/A (中途錄影)"
                        video_start_sec = video_sec
                        current_circle = detected_circle
                        consecutive_small_circle = 0
                        bandit_count = 0
                else:
                    consecutive_small_circle = 0
                    
            if state == "IN_MATCH" and current_circle >= 1:
                if bandit_cooldown > 0:
                    bandit_cooldown -= 1
                else:
                    chat_roi = preprocess_roi(frame, anchors['system_chat'], padding)
                    # chi_sim 語系需要環境安裝，這裡做個容錯
                    try:
                        chat_text = pytesseract.image_to_string(chat_roi, lang='chi_sim', config='--oem 3 --psm 6')
                        chat_text = chat_text.replace('\n', '').replace(' ', '')
                        if re.search(r'(前往|速往|出现了)', chat_text):
                            bandit_count += 1
                            bandit_data.append({
                                "Match_ID": match_id, "Event_Time": sys_time, "Video_Seconds": video_sec, "Players_Alive": 0 
                            })
                            bandit_cooldown = 15 # 廣播冷卻，30秒內不再重複抓同一個
                    except Exception as e:
                        pass # Ignore if chi_sim is missing locally

        current_msec += step_msec
        
    cap.release()
    
    if state == "IN_MATCH":
        master_data.append({
            "Match_ID": match_id, "Video_URL": video_url, "Game_Start_Time": game_start_time,
            "Video_Start_Sec": video_start_sec, "Is_Complete_Match": False, "Bandit_Count": bandit_count
        })
        
    return master_data, circle_data, bandit_data

def main():
    if len(sys.argv) > 1:
        batch_json = sys.argv[1]
        try:
            urls = json.loads(batch_json)
        except:
            urls = [batch_json]
    else:
        # Default behavior to read from videos.txt if no arguments
        urls = []
        if os.path.exists("videos.txt"):
            with open("videos.txt", "r", encoding="utf-8") as f:
                for line in f:
                    if line.strip() and not line.startswith("#"):
                        urls.append(line.strip())

    all_master, all_circle, all_bandit = [], [], []
    
    for url in urls:
        m, c, b = process_video(url)
        all_master.extend(m)
        all_circle.extend(c)
        all_bandit.extend(b)
        
    chunk_id = os.getenv("GITHUB_RUN_ID", "local")
    
    pd.DataFrame(all_master).to_csv(f"chunk_{chunk_id}_master.csv", index=False)
    pd.DataFrame(all_circle).to_csv(f"chunk_{chunk_id}_circle.csv", index=False)
    pd.DataFrame(all_bandit).to_csv(f"chunk_{chunk_id}_bandit.csv", index=False)
    print("Processing complete. CSV chunks generated.")

if __name__ == "__main__":
    main()
