import json
import os
import sys
import subprocess

def expand_urls(url):
    """使用 yt-dlp 展開播放清單，若為單支影片則直接回傳"""
    print(f"Expanding URL: {url}")
    try:
        # 使用 extract_flat=True 來加速
        cmd = ["python", "-m", "yt_dlp", "--flat-playlist", "--dump-json", url]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        urls = []
        for line in result.stdout.strip().split('\n'):
            if not line:
                continue
            data = json.loads(line)
            # 過濾直播或即將首播 (粗略判斷)
            if data.get('is_live') is True or data.get('live_status') in ['is_live', 'is_upcoming']:
                print(f"Skipping live/upcoming video: {data.get('title', 'Unknown')}")
                continue
            
            video_id = data.get('id')
            if video_id:
                urls.append(f"https://www.youtube.com/watch?v={video_id}")
        return urls
    except subprocess.CalledProcessError as e:
        print(f"Failed to expand URL {url}: {e}")
        print(f"Stdout: {e.stdout}")
        print(f"Stderr: {e.stderr}")
        return []
    except Exception as e:
        print(f"Failed to expand URL {url}: {e}")
        return []

def main():
    videos_file = 'videos.txt'
    if not os.path.exists(videos_file):
        print(f"{videos_file} not found.")
        sys.exit(1)
        
    raw_urls = []
    with open(videos_file, 'r', encoding='utf-8-sig') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                raw_urls.append(line)
                
    if not raw_urls:
        print("No URLs found in videos.txt")
        # 回傳空陣列避免報錯
        github_output = os.getenv('GITHUB_OUTPUT')
        if github_output:
            with open(github_output, 'a', encoding='utf-8') as f:
                f.write(f"matrix=[]\n")
        sys.exit(0)

    all_urls = []
    for url in raw_urls:
        expanded = expand_urls(url)
        all_urls.extend(expanded)
        
    # 去重並保持順序
    seen = set()
    all_urls = [x for x in all_urls if not (x in seen or seen.add(x))]
    
    print(f"Total {len(all_urls)} videos to process.")
    
    max_machines = 20
    batch_size = max(1, (len(all_urls) + max_machines - 1) // max_machines)
    
    batches = []
    for i in range(0, len(all_urls), batch_size):
        batch = all_urls[i:i + batch_size]
        batches.append(batch)
        
    with open('matrix.json', 'w', encoding='utf-8') as f:
        json.dump(batches, f)
        
    # Write to GHA output
    github_output = os.getenv('GITHUB_OUTPUT')
    if github_output:
        with open(github_output, 'a', encoding='utf-8') as f:
            f.write(f"matrix={json.dumps(batches)}\n")
    else:
        print(f"Would output to GHA: matrix={json.dumps(batches)}")

if __name__ == '__main__':
    main()
