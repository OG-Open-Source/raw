# apmd.cmd by OG-Open-Source

一個用於自動生成目錄結構的 Windows 批次檔案，可快速產生 Markdown 格式的目錄導航。

---

## 目錄
- [簡介](#簡介)
- [特性](#特性)
- [安裝](#安裝)
- [使用方法](#使用方法)
- [示例](#示例)
- [配置](#配置)
- [常見問題](#常見問題)
- [貢獻指南](#貢獻指南)
- [許可證](#許可證)

---

## 簡介
apmd.cmd 是一個專門設計用於生成目錄結構的 Windows 批次檔案。它能夠遍歷指定目錄，並生成一個 Markdown 格式的目錄結構，特別適合用於文檔導航。生成的結構完全相容於 GitHub Pages 或其他 Markdown 閱讀器。

## 特性
- 自動遍歷目錄結構並生成 Markdown 格式輸出
- 支援多層級目錄結構（最大深度 2 層）
- 智能排序：目錄優先，檔案次之
- 特殊檔案處理：README.md 置底顯示，自動忽略 CNAME 和隱藏檔案
- 相容性強：生成的連結格式適用於 GitHub Pages 和主流 Markdown 渲染器
- 支援包含空格的路徑名稱

## 安裝
1. 下載 apmd.cmd 檔案
2. 將檔案放置在系統 PATH 環境變數包含的目錄中（可選）

```batch
# 下載檔案
curl -sSLO 'https://raw.ogtt.tk/space/apmd.cmd'

# 移動到系統路徑（可選）
move apmd.cmd %SystemRoot%
```

## 使用方法
執行腳本時需要提供目標目錄路徑：

```batch
apmd.cmd [directory_path]
```

### 參數說明：
- `directory_path`：要生成目錄結構的目標路徑
  - 支援相對路徑和絕對路徑
  - 路徑包含空格時需要使用引號

## 示例

```batch
# 使用絕對路徑
apmd.cmd "C:\project\docs"

# 使用相對路徑
apmd.cmd ..\docs

# 包含空格的路徑
apmd.cmd "My Documents"
```

### 輸出示例：
```markdown
> [docs/](.)
>
>  > [images/](images/)<br>
>  >  > [diagram.png](images/diagram.png)<br>
>  >  > [style.css](images/style.css)<br>
>  >  > [README.md](images/README.md)<br>
>
>  > [scripts/](scripts/)<br>
>  >  > [main.js](scripts/main.js)<br>
>
>  > [index.md](index.md)<br>
>  > [README.md](README.md)<br>
```

## 配置
本工具不需要額外配置檔案，但需要確保系統支援以下功能：

- Windows 命令提示字元
- 延遲環境變數擴充功能（自動啟用）

## 常見問題

### Q：腳本無法處理某些特殊字元的檔案名稱？
A：檔案名稱中不應包含 `<`、`>`、`|` 等特殊字元，這些字元可能導致腳本執行錯誤。

### Q：為什麼某些檔案沒有顯示在輸出中？
A：腳本會自動忽略以下檔案：
- 以 `.` 開頭的隱藏檔案
- CNAME 檔案
- 超過 2 層深度的檔案

### Q：生成的連結在某些平台無法正常工作？
A：確保目標平台支援相對路徑連結。某些特殊的 Markdown 渲染器可能需要調整連結格式。

## 貢獻指南
歡迎提供改進建議和程式碼貢獻：

1. Fork 本專案
2. 創建新的功能分支
3. 提交您的更改
4. 發起合併請求

## 許可證
本專案採用 MIT 許可證。