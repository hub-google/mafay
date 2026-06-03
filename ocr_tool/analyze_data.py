import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
import ast

plt.rcParams['font.sans-serif'] = ['Microsoft YaHei', 'SimHei'] 
plt.rcParams['axes.unicode_minus'] = False

DATA_FILE = "mafei_data.csv"

def load_data():
    if not os.path.exists(DATA_FILE):
        print(f"找不到資料檔: {DATA_FILE}")
        return None
        
    try:
        df = pd.read_csv(DATA_FILE)
        df['Match_Elapsed_Seconds'] = pd.to_numeric(df['刷新時間'], errors='coerce')
        df['Survivors'] = pd.to_numeric(df['刷新時人數'], errors='coerce')
        
        # Parse Location_X_Y "(X,Y)" into separate columns
        def parse_coord(coord_str):
            try:
                if coord_str.startswith('(') and coord_str.endswith(')'):
                    return ast.literal_eval(coord_str)
            except:
                pass
            return (None, None)

        coords = df['刷新座標'].astype(str).apply(parse_coord)
        df['Map_X'] = [c[0] for c in coords]
        df['Map_Y'] = [c[1] for c in coords]
        
        df = df[df['Match_Elapsed_Seconds'] > 0]
        return df
    except Exception as e:
        print(f"讀取資料失敗: {e}")
        return None

def analyze_location_heatmap(df):
    valid_coords = df.dropna(subset=['Map_X', 'Map_Y'])
    if valid_coords.empty:
        print("沒有有效的座標資料可以繪製熱區圖。")
        return
        
    plt.figure(figsize=(10, 8))
    # 2D Kernel Density Estimate (Heatmap)
    sns.kdeplot(
        data=valid_coords, x="Map_X", y="Map_Y", 
        fill=True, cmap="Reds", alpha=0.8, thresh=0.05
    )
    # Plot the exact points as well
    sns.scatterplot(data=valid_coords, x="Map_X", y="Map_Y", color="black", s=20)
    
    # Invert Y axis because image coordinates start top-left
    plt.gca().invert_yaxis()
    
    plt.title('馬匪刷新位置地圖熱區分佈')
    plt.xlabel('地圖 X 座標')
    plt.ylabel('地圖 Y 座標')
    plt.tight_layout()
    plt.savefig('location_heatmap.png')
    print("已儲存 location_heatmap.png")
    plt.show()

def analyze_time_vs_survivors(df):
    plt.figure(figsize=(10, 6))
    
    sns.scatterplot(data=df, x='Match_Elapsed_Seconds', y='Survivors', s=100, color="blue", alpha=0.6)
    sns.regplot(data=df, x='Match_Elapsed_Seconds', y='Survivors', scatter=False, color='red', line_kws={"linestyle":"--"})
    
    plt.title('馬匪刷新時間與存活人數關聯性分析')
    plt.xlabel('開場後經歷時間 (秒)')
    plt.ylabel('存活人數')
    plt.grid(True, linestyle='--', alpha=0.7)
    plt.tight_layout()
    plt.savefig('time_vs_survivors.png')
    print("已儲存 time_vs_survivors.png")
    plt.show()

def print_summary(df):
    print("\n=== 絕境戰場馬匪數據分析摘要 ===")
    print(f"總記錄筆數: {len(df)}")
    
    if not df.empty:
        avg_time = df['Match_Elapsed_Seconds'].mean()
        avg_surv = df['Survivors'].mean()
        print(f"平均刷新時間: {avg_time:.1f} 秒")
        print(f"平均存活人數: {avg_surv:.1f} 人")
        
        valid_c = df.dropna(subset=['Map_X', 'Map_Y'])
        if not valid_c.empty:
            print(f"成功捕捉座標次數: {len(valid_c)}")
        
        corr = df[['Match_Elapsed_Seconds', 'Survivors']].corr().iloc[0, 1]
        print(f"時間與人數相關係數: {corr:.3f}")
        
    print("=================================\n")

if __name__ == "__main__":
    df = load_data()
    if df is not None and not df.empty:
        print_summary(df)
        try:
            analyze_location_heatmap(df)
            analyze_time_vs_survivors(df)
        except Exception as e:
            print(f"繪圖失敗: {e}")
    else:
        print("沒有足夠的有效資料可供分析。")
