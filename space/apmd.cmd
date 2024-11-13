@echo off
setlocal enabledelayedexpansion

:: Check if directory parameter is provided
if "%~1"=="" (
    echo Please provide directory path
    echo Usage: apmd.cmd [directory_path]
    exit /b 1
)

:: Set target directory
set "TARGET_DIR=%~1"

:: Check if directory exists
if not exist "!TARGET_DIR!" (
    echo Error: Directory "!TARGET_DIR!" does not exist
    exit /b 1
)

:: Get target directory name
for %%I in ("!TARGET_DIR!") do set "DIR_NAME=%%~nxI"

:: Display root directory
echo ^> [%DIR_NAME%/](.)^<br^>

:: Process directory structure
call :process_dir "!TARGET_DIR!" 1
goto :eof

:process_dir
set "current_dir=%~1"
set "level=%~2"
set "first_item=1"

:: Get current directory name relative to root
for %%I in ("!current_dir!") do set "CURRENT_DIR_NAME=%%~nxI"

:: Process subdirectories first (exclude hidden directories)
for /f "tokens=*" %%D in ('dir /b /a:d "!current_dir!" 2^>nul ^| findstr /v "^\..*"') do (
    if not "!first_item!"=="1" (
        echo ^>
    )
    echo ^>  ^> [%%D/](%%D/^)^<br^>

    :: Process files in subdirectory
    pushd "!current_dir!\%%D"
    :: Process non-README.md and non-CNAME files first
    for /f "tokens=*" %%F in ('dir /b /a:-d 2^>nul ^| findstr /v "^\..*" ^| findstr /v /i "^README\.md$ ^CNAME$"') do (
        echo ^>  ^>  ^> [%%F](%%D/%%F^)^<br^>
    )
    :: Process README.md last (if exists)
    if exist "README.md" (
        echo ^>  ^>  ^> [README.md](%%D/README.md^)^<br^>
    )
    popd

    set "first_item=0"
)

:: Process files in current directory
set "has_files=0"
pushd "!current_dir!"
:: Process non-README.md and non-CNAME files first
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

:: Process README.md last (if exists)
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
