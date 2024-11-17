# apmd.cmd
一個用於 Windows 系統下自動生成 Markdown 目錄結構的批次工具。

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
apmd.cmd 是一個專為 Windows 環境開發的批次工具，能夠自動遍歷目錄並生成 Markdown 格式的目錄導航結構。它特別適合用於文檔管理和 GitHub Pages 項目。

## 特性
- 自動生成 Markdown 格式的目錄結構
- 支援最深 2 層的目錄遍歷
- 智能排序：目錄優先於檔案
- 自動處理特殊檔案（如 README.md）
- 支援多種檔案隱藏模式
- 完全相容 GitHub Pages
- 支援含空格的檔案路徑

## 安裝
```batch
# 下載檔案
curl -sSLO "https://raw.ogtt.tk/space/apmd.cmd"

# 移動到系統路徑（選擇性）
move apmd.cmd %SystemRoot%
```

{:.important}
> 確保將檔案放置在系統 PATH 包含的目錄中以便全域使用。

## 使用方法
基本命令格式：

```batch
apmd.cmd [directory_path] [-d "hidden_dirs"] [-f "hidden_files"]
```

### 參數說明
- `directory_path`：目標目錄路徑
- `-d "hidden_dirs"`：要隱藏的目錄列表
- `-f "hidden_files"`：要隱藏的檔案列表

{:.note}
> 檔案隱藏支援三種模式：
> - 全域模式：`filename.ext`
> - 當前目錄：`./filename.ext`
> - 指定路徑：`path/filename.ext`

## 示例
```batch
# 基本使用
apmd.cmd "."

# 隱藏指定目錄
apmd.cmd "." -d "node_modules .git"

# 隱藏特定檔案（全域）
apmd.cmd "." -f "_config.yml package-lock.json"

# 隱藏特定路徑下的多個檔案
apmd.cmd "." -f "docs/_config.yml space/test.txt"

# 只隱藏當前目錄的檔案
apmd.cmd "." -f "./local-only.txt"

# 組合使用
apmd.cmd "." -d "node_modules" -f "./local.txt docs/secret.md"
```

### 輸出示例
```markdown
> [docs/](.)<br>
>  > [image/](image/)<br>
>  >  > [diagram.png](image/diagram.png)<br>
>  >  > [style.css](image/style.css)<br>
>  >  > [README.md](image/README.md)<br>
>
>  > [scripts/](scripts/)<br>
>  >  > [main.js](scripts/main.js)<br>
>
>  > [index.md](index.md)<br>
>  > [README.md](README.md)<br>
```

## 配置
本工具採用無配置檔案設計，所有設定通過命令列參數完成。

{:.tip}
> 使用前請確保 Windows 命令提示字元可正常運作。

## 常見問題

**Q：如何隱藏特定目錄下的所有檔案？**<br>
A：使用 `-d` 參數直接隱藏整個目錄即可。例如：`apmd.cmd "." -d "private_folder"`

**Q：如何只隱藏某個目錄下的特定檔案？**<br>
A：使用 `-f` 參數並指定完整路徑。例如：`apmd.cmd "." -f "docs/secret.txt"`

**Q：為什麼某些檔案沒有顯示在輸出中？**<br>
A：檔案可能被以下規則隱藏：
- 以 `.` 開頭的隱藏檔案
- 通過 `-d` 或 `-f` 參數指定的檔案
- 超過 2 層深度的檔案

**Q：為什麼某些檔案未顯示？**<br>
A：可能原因：
- 檔案位於第 3 層以上目錄
- 檔案名稱以 `.` 開頭
- 檔案被隱藏參數指定

## 貢獻指南
1. Fork 專案
2. 創建功能分支
3. 提交更改
4. 發起 Pull Request

## 許可證
本專案採用 MIT 許可證。
