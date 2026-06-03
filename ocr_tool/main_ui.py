import tkinter as tk
from tkinter import ttk, messagebox
import json
import os
import threading
import time
from datetime import datetime
import mss
import cv2
import numpy as np
import pytesseract
import re
import csv
import config

CONFIG_FILE = "config.json"
DATA_LOG_FILE = "mafei_data.csv"

class OverlayBox:
    def __init__(self, parent, name, default_rect, color):
        self.name = name
        self.win = tk.Toplevel(parent)
        self.win.title(name)
        
        if default_rect:
            x, y, w, h = default_rect['left'], default_rect['top'], default_rect['width'], default_rect['height']
            self.win.geometry(f"{w}x{h}+{x}+{y}")
        else:
            self.win.geometry("200x200+100+100")
            
        self.win.attributes("-alpha", 0.6)
        self.win.attributes("-topmost", True)
        self.win.configure(bg=color)
        
        lbl = tk.Label(self.win, text=name, bg=color, fg="white", font=("Arial", 16, "bold"))
        lbl.pack(expand=True)
        
        self.win.protocol("WM_DELETE_WINDOW", lambda: None)

    def get_region(self):
        self.win.update_idletasks()
        return {
            "left": self.win.winfo_x(),
            "top": self.win.winfo_y(),
            "width": self.win.winfo_width(),
            "height": self.win.winfo_height()
        }
        
    def hide(self):
        self.win.withdraw()
        
    def show(self):
        self.win.deiconify()

class OCRMonitorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("JX3 Mafei Tracker (Template Matching)")
        self.root.geometry("350x550")
        self.root.attributes("-topmost", True)
        
        self.is_monitoring = False
        self.monitor_thread = None
        self.match_start_time = None
        
        self.red_dot_cooldown = False
        self.red_dot_missing_count = 0
        
        self.templates = []
        
        self.app_config = {
            "keywords": config.KEYWORD_MAFEI,
            "countdown_keywords": config.KEYWORD_COUNTDOWN,
            "text_region": None,
            "map_region": None,
            "surv_region": None
        }
        self.load_config()
        self.load_templates()
        self.init_csv()
        
        self.boxes = {}
        self.create_overlay_boxes()
        self.setup_ui()

    def load_templates(self):
        template_dir = getattr(config, "TEMPLATE_DIR", "templates")
        if not os.path.exists(template_dir):
            os.makedirs(template_dir)
            
        self.templates = []
        for file in os.listdir(template_dir):
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                path = os.path.join(template_dir, file)
                # Load template in BGR
                tmpl = cv2.imread(path)
                if tmpl is not None:
                    self.templates.append((file, tmpl))
        print(f"Loaded {len(self.templates)} templates.")

    def create_overlay_boxes(self):
        self.boxes['text'] = OverlayBox(self.root, "<文字監控>", self.app_config.get("text_region"), "blue")
        self.boxes['map'] = OverlayBox(self.root, "<地圖監控>", self.app_config.get("map_region"), "red")
        self.boxes['surv'] = OverlayBox(self.root, "<人數監控>", self.app_config.get("surv_region"), "green")

    def init_csv(self):
        if not os.path.exists(DATA_LOG_FILE):
            with open(DATA_LOG_FILE, mode='w', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                writer.writerow(["刷新時間", "刷新座標", "刷新時人數"])

    def load_config(self):
        if os.path.exists(CONFIG_FILE):
            try:
                with open(CONFIG_FILE, "r", encoding="utf-8") as f:
                    saved = json.load(f)
                    self.app_config.update(saved)
            except Exception as e:
                print(f"Failed to load config: {e}")

    def save_settings(self):
        try:
            self.app_config["text_region"] = self.boxes['text'].get_region()
            self.app_config["map_region"] = self.boxes['map'].get_region()
            self.app_config["surv_region"] = self.boxes['surv'].get_region()
            
            # Save keywords
            cd_text = self.start_kw_entry.get().strip()
            self.app_config["countdown_keywords"] = [k.strip() for k in cd_text.split(',') if k.strip()]
            
            mf_text = self.mafei_kw_entry.get().strip()
            self.app_config["keywords"] = [k.strip() for k in mf_text.split(',') if k.strip()]
            
            with open(CONFIG_FILE, "w", encoding="utf-8") as f:
                json.dump(self.app_config, f, ensure_ascii=False, indent=4)
            messagebox.showinfo("成功", "設定已儲存！")
        except Exception as e:
            messagebox.showerror("錯誤", f"儲存失敗: {e}")

    def setup_ui(self):
        tk.Label(self.root, text="操作面板", font=("Arial", 16, "bold")).pack(pady=5)
        
        # Keyword Config Section
        kw_frame = tk.LabelFrame(self.root, text="<偵測文字調整>", padx=10, pady=5)
        kw_frame.pack(fill="x", padx=10, pady=5)
        
        tk.Label(kw_frame, text="起始觸發文字 (逗號分隔):").pack(anchor="w")
        self.start_kw_entry = tk.Entry(kw_frame)
        self.start_kw_entry.pack(fill="x")
        self.start_kw_entry.insert(0, ",".join(self.app_config.get("countdown_keywords", [])))
        
        tk.Label(kw_frame, text="馬匪提示文字 (選填, 逗號分隔):").pack(anchor="w", pady=(5,0))
        self.mafei_kw_entry = tk.Entry(kw_frame)
        self.mafei_kw_entry.pack(fill="x")
        self.mafei_kw_entry.insert(0, ",".join(self.app_config.get("keywords", [])))
        
        # Buttons
        tk.Button(self.root, text="<儲存介面>", command=self.save_settings, bg="orange", font=("Arial", 12)).pack(fill="x", padx=20, pady=5)
        
        self.start_btn = tk.Button(self.root, text="開始監控", bg="green", fg="white", font=("Arial", 12), command=self.toggle_monitoring)
        self.start_btn.pack(fill="x", padx=20, pady=5)
        
        self.status_label = tk.Label(self.root, text="狀態: 待命中", fg="gray", font=("Arial", 10))
        self.status_label.pack(pady=2)
        
        self.match_time_label = tk.Label(self.root, text="開場時間: 尚未開始", fg="blue", font=("Arial", 10))
        self.match_time_label.pack(pady=2)

        tk.Label(self.root, text="事件日誌:").pack(anchor="w", padx=10, pady=(5,0))
        log_frame = tk.Frame(self.root)
        log_frame.pack(fill="both", expand=True, padx=10, pady=(0, 10))
        scrollbar = tk.Scrollbar(log_frame)
        scrollbar.pack(side="right", fill="y")
        self.log_listbox = tk.Listbox(log_frame, yscrollcommand=scrollbar.set, font=("Arial", 9))
        self.log_listbox.pack(side="left", fill="both", expand=True)
        scrollbar.config(command=self.log_listbox.yview)

    def log_message(self, msg):
        time_str = datetime.now().strftime("%H:%M:%S")
        self.log_listbox.insert(tk.END, f"[{time_str}] {msg}")
        self.log_listbox.yview(tk.END)

    def toggle_monitoring(self):
        if not self.is_monitoring:
            self.load_templates() # Reload templates in case user added some
            
            if not self.templates:
                messagebox.showwarning("警告", "templates 資料夾內沒有圖片！程式將無法在地圖上找到目標。")
                
            for box in self.boxes.values(): box.hide()
            self.save_settings()
            
            self.is_monitoring = True
            self.start_btn.config(text="停止監控", bg="red")
            self.status_label.config(text="狀態: 監控中...", fg="green")
            self.log_message("監控已啟動")
            
            self.match_start_time = None
            self.match_time_label.config(text="開場時間: 尚未開始")
            self.red_dot_cooldown = False
            self.red_dot_missing_count = 0
            
            self.monitor_thread = threading.Thread(target=self.monitor_loop, daemon=True)
            self.monitor_thread.start()
        else:
            self.is_monitoring = False
            self.start_btn.config(text="開始監控", bg="green")
            self.status_label.config(text="狀態: 待命中", fg="gray")
            self.log_message("監控已停止")
            for box in self.boxes.values(): box.show()

    def do_ocr(self, sct, region, lang='chi_sim'):
        if not region or region['width'] <= 0 or region['height'] <= 0: return ""
        sct_img = sct.grab(region)
        img = np.array(sct_img)
        gray = cv2.cvtColor(img, cv2.COLOR_BGRA2GRAY)
        text = pytesseract.image_to_string(gray, lang=lang)
        return text

    def map_to_500_grid(self, px, py, width, height):
        ratio_x = px / width
        mapped_x = int(ratio_x * 500)
        ratio_y = (height - py) / height
        mapped_y = int(ratio_y * 500)
        return max(0, min(500, mapped_x)), max(0, min(500, mapped_y))

    def find_template(self, sct, region):
        if not region or region['width'] <= 0 or region['height'] <= 0 or not self.templates: return None
        
        sct_img = sct.grab(region)
        img = np.array(sct_img)
        bgr = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
        
        threshold = getattr(config, "TEMPLATE_THRESHOLD", 0.8)
        
        best_match_val = -1
        best_match_loc = None
        best_tmpl_shape = None
        
        for name, tmpl in self.templates:
            # Ensure template is not larger than region
            if tmpl.shape[0] > bgr.shape[0] or tmpl.shape[1] > bgr.shape[1]:
                continue
                
            res = cv2.matchTemplate(bgr, tmpl, cv2.TM_CCOEFF_NORMED)
            min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)
            
            if max_val >= threshold and max_val > best_match_val:
                best_match_val = max_val
                best_match_loc = max_loc
                best_tmpl_shape = tmpl.shape
                
        if best_match_loc:
            # Calculate center of the matched template
            w, h = best_tmpl_shape[1], best_tmpl_shape[0]
            cX = best_match_loc[0] + w // 2
            cY = best_match_loc[1] + h // 2
            
            grid_x, grid_y = self.map_to_500_grid(cX, cY, region['width'], region['height'])
            return (grid_x, grid_y)
            
        return None

    def log_data_to_csv(self, elapsed_str, location_str, survivors_str):
        try:
            with open(DATA_LOG_FILE, mode='a', newline='', encoding='utf-8') as f:
                writer = csv.writer(f)
                writer.writerow([elapsed_str, location_str, survivors_str])
        except Exception as e:
            self.root.after(0, self.log_message, f"CSV 錯誤: {e}")

    def monitor_loop(self):
        with mss.mss() as sct:
            while self.is_monitoring:
                try:
                    text_reg = self.app_config.get("text_region")
                    map_reg = self.app_config.get("map_region")
                    surv_reg = self.app_config.get("surv_region")
                    
                    if not self.match_start_time:
                        text_content = self.do_ocr(sct, text_reg)
                        if any(kw in text_content for kw in self.app_config["countdown_keywords"]):
                            self.match_start_time = time.time()
                            self.root.after(0, self.log_message, "偵測到起始文字，計時啟動！")
                            def update_lbl():
                                self.match_time_label.config(text=f"開場時間: {datetime.now().strftime('%H:%M:%S')}")
                            self.root.after(0, update_lbl)
                            time.sleep(3)
                    
                    dot_coord = self.find_template(sct, map_reg)
                    
                    if dot_coord:
                        self.red_dot_missing_count = 0
                        
                        if not self.red_dot_cooldown:
                            self.red_dot_cooldown = True
                            
                            elapsed_time = "N/A"
                            if self.match_start_time:
                                elapsed_time = int(time.time() - self.match_start_time)
                                
                            survivors = "N/A"
                            if surv_reg:
                                surv_text = self.do_ocr(sct, surv_reg)
                                nums = re.findall(r'\d+', surv_text)
                                if nums:
                                    survivors = nums[0]
                                    
                            loc_str = f"({dot_coord[0]},{dot_coord[1]})"
                            self.log_data_to_csv(str(elapsed_time), loc_str, survivors)
                            
                            msg = f"記錄馬匪! 時間:{elapsed_time}s, 座標:{loc_str}, 人數:{survivors}"
                            self.root.after(0, self.log_message, msg)
                    else:
                        if self.red_dot_cooldown:
                            self.red_dot_missing_count += 1
                            if self.red_dot_missing_count > 10:
                                self.red_dot_cooldown = False
                                self.root.after(0, self.log_message, "馬匪圖示消失，重新待命。")
                                
                except Exception as e:
                    print(f"Monitor error: {e}")
                    
                time.sleep(config.SCAN_INTERVAL_SECONDS)

if __name__ == "__main__":
    if os.path.exists(config.TESSERACT_CMD_PATH):
        pytesseract.pytesseract.tesseract_cmd = config.TESSERACT_CMD_PATH
    root = tk.Tk()
    app = OCRMonitorApp(root)
    root.mainloop()
