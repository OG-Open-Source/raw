@echo off
setlocal enabledelayedexpansion

:: 檢查是否提供了目錄參數
if "%~1"=="" (
	echo 請提供目錄路徑
	echo 用法: apmd.cmd [目錄路徑]
	exit /b 1
)

:: 設置目標目錄
set "TARGET_DIR=%~1"

:: 檢查目錄是否存在
if not exist "!TARGET_DIR!" (
	echo 錯誤：目錄 "!TARGET_DIR!" 不存在
	exit /b 1
)

:: 獲取目標目錄的名稱
for %%I in ("!TARGET_DIR!") do set "DIR_NAME=%%~nxI"

:: 顯示根目錄
echo ^> [%DIR_NAME%/](.)^<br^>

:: 處理目錄結構
call :process_dir "!TARGET_DIR!" 1
goto :eof

:process_dir
set "current_dir=%~1"
set "level=%~2"
set "first_item=1"

:: 獲取相對於根目錄的當前目錄名
for %%I in ("!current_dir!") do set "CURRENT_DIR_NAME=%%~nxI"

:: 先處理子目錄（排除隱藏目錄）
for /f "tokens=*" %%D in ('dir /b /a:d "!current_dir!" 2^>nul ^| findstr /v "^\..*"') do (
	if not "!first_item!"=="1" (
		echo ^>
	)
	echo ^>  ^> [%%D/](%%D/^)^<br^>

	:: 處理子目錄中的文件
	pushd "!current_dir!\%%D"
	:: 先處理非 README.md 和非 CNAME 文件
	for /f "tokens=*" %%F in ('dir /b /a:-d 2^>nul ^| findstr /v "^\..*" ^| findstr /v /i "^README\.md$ ^CNAME$"') do (
		echo ^>  ^>  ^> [%%F](%%D/%%F^)^<br^>
	)
	:: 最後處理 README.md（如果存在）
	if exist "README.md" (
		echo ^>  ^>  ^> [README.md](%%D/README.md^)^<br^>
	)
	popd

	set "first_item=0"
)

:: 處理當前目錄的文件
set "has_files=0"
pushd "!current_dir!"
:: 先處理非 README.md 和非 CNAME 文件
for /f "tokens=*" %%F in ('dir /b /a:-d 2^>nul ^| findstr /v "^\..*" ^| findstr /v /i "^README\.md$ ^CNAME$"') do (
	if not "!has_files!"=="1" (
		if not "!first_item!"=="1" echo ^>
		set "has_files=1"
	)
	if "!CURRENT_DIR_NAME!"=="%DIR_NAME%" (
		echo ^>  ^> [%%F](%%F^)^<br^>
	) else (
		echo ^>  ^> [%%F](!CURRENT_DIR_NAME!/%%F^)^<br^>
	)
)

:: 最後處理 README.md（如果存在）
if exist "README.md" (
	if not "!has_files!"=="1" (
		if not "!first_item!"=="1" echo ^>
	)
	if "!CURRENT_DIR_NAME!"=="%DIR_NAME%" (
		echo ^>  ^> [README.md](README.md^)^<br^>
	) else (
		echo ^>  ^> [README.md](!CURRENT_DIR_NAME!/README.md^)^<br^>
	)
)
popd

exit /b
