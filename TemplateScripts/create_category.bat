@echo off
setlocal enabledelayedexpansion

REM === CONFIGURATION ===
REM Get the directory of the script and move one level up
set "SCRIPT_PATH=%~dp0"
set "BASE_PATH=%SCRIPT_PATH:~0,-1%"
for %%I in ("%BASE_PATH%\..") do set "BASE_PATH=%%~fI"
REM Remove trailing backslash if present
if "%BASE_PATH:~-1%"=="\" set "BASE_PATH=%BASE_PATH:~0,-1%"

REM === LIST EVENT FOLDERS ===
echo.
echo Available event folders:
set i=0
for /D %%D in ("%BASE_PATH%\*") do (
    if /I not "%%~nxD"=="TemplateScripts" (
        set /A i+=1
        set "event[!i!]=%%~nxD"
        echo !i!. %%~nxD
    )
)

REM === SELECT EVENT FOLDER ===
:askEvent
set /p CHOICE=Select an event folder by number: 
set "EVENT=!event[%CHOICE%]!"
if not defined EVENT (
    echo Invalid choice. Exiting.
    goto askEvent
)

REM === GET CATEGORY NAME ===
:askCategoryTitle
set /p CATEGORY=Enter the name of the new category (e.g. Web, Pwn): 
if "!CATEGORY!"=="" (
    echo [ERROR] Category name is required. Please enter a value.
    goto askCategoryTitle
)

set "CATEGORY_PATH=%BASE_PATH%\%EVENT%\%CATEGORY%"
set "IMAGES_PATH=%CATEGORY_PATH%\images"
set "README_PATH=%CATEGORY_PATH%\README.md"
set "EVENT_README=%BASE_PATH%\%EVENT%\Readme.md"

REM === CREATE FOLDERS ===
if not exist "%CATEGORY_PATH%" (
    mkdir "%CATEGORY_PATH%"
    echo Created: %CATEGORY_PATH%
)

if not exist "%IMAGES_PATH%" (
    mkdir "%IMAGES_PATH%"
    echo Created: %IMAGES_PATH%
)

REM === CREATE README.md ===
if not exist "%README_PATH%" (
    (
        echo # %CATEGORY% Writeups
        echo.
        echo Writeups for %CATEGORY% challenges in %EVENT%.
        echo.
        echo ## List of solved Challenges
    ) > "%README_PATH%"
    echo Created: %README_PATH%
) else (
    echo README.md already exists.
)

REM === ADD CATEGORY TO EVENT README ===
if exist "%EVENT_README%" (
    echo Adding category to event README...

    REM === Check if category already exists
    findstr /C:"- [%CATEGORY%](" "%EVENT_README%" >nul
    if not errorlevel 1 (
        echo Category already listed in event README.
        goto end
    )

    REM === Track if category was inserted
    set "CATEGORY_INSERTED="

    REM === Read file line-by-line, preserving blank lines
    (
        for /f "usebackq tokens=1,* delims=:" %%A in (`findstr /n "^" "%EVENT_README%"`) do (
            set "line=%%B"
            setlocal enabledelayedexpansion
            echo(!line!
            if "!line!"=="## Categories" (
                echo - [%CATEGORY%](%CATEGORY%^)
                set "CATEGORY_INSERTED=1"
            )
            endlocal
        )
    ) > "%EVENT_README%.tmp"

    move /Y "%EVENT_README%.tmp" "%EVENT_README%" >nul
    echo Category added to event README.

) else (
    echo Event README not found. Skipping category addition.
)


pause
