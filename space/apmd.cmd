@echo off
setlocal enabledelayedexpansion

:: Initialize variables for hidden files and directories
set "HIDDEN_DIRS="
set "HIDDEN_FILES="

:: Parse command line arguments
:parse_args
if "%~1"=="" goto :end_parse
if "%~1"=="-d" (
    set "HIDDEN_DIRS=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="-f" (
    set "HIDDEN_FILES=%~2"
    shift
    shift
    goto :parse_args
)
set "TARGET_DIR=%~1"
shift
goto :parse_args
:end_parse

:: Check if directory parameter is provided
if "%TARGET_DIR%"=="" (
    echo Please provide directory path
    echo Usage: apmd.cmd [directory_path] [-d "hidden_dirs"] [-f "hidden_files"]
    echo Example: apmd.cmd "." -d ".git node_modules" -f "space/50mib.txt _config.yml"
    echo Note: For files, you can use:
    echo       - filename.ext        ^(hide all matching files^)
    echo       - ./filename.ext      ^(hide only in current directory^)
    echo       - path/filename.ext   ^(hide in specific path^)
    exit /b 1
)

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

:: Calculate relative path from root
set "REL_PATH="
if not "!CURRENT_DIR_NAME!"=="%DIR_NAME%" set "REL_PATH=!CURRENT_DIR_NAME!/"

:: Process subdirectories first (exclude hidden directories and specified hidden dirs)
for /f "tokens=*" %%D in ('dir /b /a:d "!current_dir!" 2^>nul ^| findstr /v "^\..*"') do (
    set "skip_dir="
    for %%H in (!HIDDEN_DIRS!) do if "%%D"=="%%H" set "skip_dir=1"
    if not defined skip_dir (
        if not "!first_item!"=="1" (
            echo ^>
        )
        echo ^>  ^> [%%D/](%%D/^)^<br^>

        :: Process files in subdirectory
        pushd "!current_dir!\%%D"
        :: Process files (excluding hidden files and specified hidden files)
        for /f "tokens=*" %%F in ('dir /b /a:-d 2^>nul ^| findstr /v "^\..*"') do (
            set "skip_file="
            for %%H in (!HIDDEN_FILES!) do (
                set "hide_pattern=%%H"
                if "!hide_pattern:~0,2!"=="./" (
                    rem Skip ./pattern only in root directory
                    if "!REL_PATH!"=="" if "%%F"=="!hide_pattern:~2!" set "skip_file=1"
                ) else if "!hide_pattern!"=="!REL_PATH!%%D/%%F" (
                    rem Skip specific path/file
                    set "skip_file=1"
                ) else if not "!hide_pattern:*/=!"=="!hide_pattern!" (
                    rem Skip if pattern contains path separator
                    if "!hide_pattern!"=="%%F" set "skip_file=1"
                ) else if "!hide_pattern!"=="%%F" (
                    rem Skip if exact match (for global patterns)
                    set "skip_file=1"
                )
            )
            if not defined skip_file (
                if not "%%F"=="README.md" (
                    echo ^>  ^>  ^> [%%F](%%D/%%F^)^<br^>
                )
            )
        )
        :: Process README.md last (if exists)
        if exist "README.md" (
            echo ^>  ^>  ^> [README.md](%%D/README.md^)^<br^>
        )
        popd
        set "first_item=0"
    )
)

:: Process files in current directory
set "has_files=0"
pushd "!current_dir!"
:: Process non-README.md files first
for /f "tokens=*" %%F in ('dir /b /a:-d 2^>nul ^| findstr /v "^\..*"') do (
    set "skip_file="
    for %%H in (!HIDDEN_FILES!) do (
        set "hide_pattern=%%H"
        if "!hide_pattern:~0,2!"=="./" (
            rem Skip ./pattern only in root directory
            if "!REL_PATH!"=="" if "%%F"=="!hide_pattern:~2!" set "skip_file=1"
        ) else if "!hide_pattern!"=="!REL_PATH!%%F" (
            rem Skip specific path/file
            set "skip_file=1"
        ) else if not "!hide_pattern:*/=!"=="!hide_pattern!" (
            rem Skip if pattern contains path separator
            if "!hide_pattern!"=="%%F" set "skip_file=1"
        ) else if "!hide_pattern!"=="%%F" (
            rem Skip if exact match (for global patterns)
            set "skip_file=1"
        )
    )
    if not defined skip_file (
        if not "%%F"=="README.md" (
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