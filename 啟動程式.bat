@echo off
chcp 65001 >nul
echo 正在檢查 Python 環境...

python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [錯誤] 找不到 Python！
    echo 請確保您已經安裝 Python 並且在安裝時勾選了 "Add Python to PATH"。
    echo 如果尚未安裝，請前往 https://www.python.org/downloads/ 下載。
    pause
    exit /b
)

if not exist ".venv" (
    echo 正在建立專屬虛擬環境...
    python -m venv .venv
)

echo 正在啟動虛擬環境與安裝依賴套件...
call .venv\Scripts\activate.bat
pip install -r ocr_tool\requirements.txt

echo 正在啟動馬匪監控程式...
python ocr_tool\main_ui.py
pause
