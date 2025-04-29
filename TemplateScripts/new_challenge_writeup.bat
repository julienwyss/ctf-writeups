@echo off
setlocal enabledelayedexpansion

REM === CONFIGURATION ===
REM Get the directory of the script and move one level up
set "SCRIPT_PATH=%~dp0"
set "BASE_PATH=%SCRIPT_PATH:~0,-1%"
for %%I in ("%BASE_PATH%\..") do set "BASE_PATH=%%~fI"
REM Remove trailing backslash if present
if "%BASE_PATH:~-1%"=="\" set "BASE_PATH=%BASE_PATH:~0,-1%"

REM === STEP 1: CHOOSE EVENT ===
echo.
echo === Select an Event Folder ===
set i=0
for /D %%D in ("%BASE_PATH%\*") do (
    if /I not "%%~nxD"=="TemplateScripts" (
        set /A i+=1
        set "event[!i!]=%%~nxD"
        echo !i!. %%~nxD
    )
)

set /p CHOICE=Select event number: 
set "EVENT=!event[%CHOICE%]!"

if not defined EVENT (
    echo Invalid choice. Exiting.
    exit /b
)

set "EVENT_PATH=%BASE_PATH%\%EVENT%"

REM === STEP 2: CHOOSE CATEGORY ===
echo.
echo === Select a Category Folder in '%EVENT%' ===
set j=0
for /D %%D in ("%EVENT_PATH%\*") do (
    if /I not "%%~nxD"=="images" (
        set /A j+=1
        set "cat[!j!]=%%~nxD"
        echo !j!. %%~nxD
    )
)

set /p CAT_CHOICE=Select category number: 
set "CATEGORY=!cat[%CAT_CHOICE%]!"

if not defined CATEGORY (
    echo Invalid choice. Exiting.
    exit /b
)

set "CATEGORY_PATH=%EVENT_PATH%\%CATEGORY%"

REM === STEP 3: ENTER CHALLENGE INFO ===
echo.
:askTitle
set /p TITLE=Enter challenge title (required): 
if "!TITLE!"=="" (
    echo [ERROR] Title is required. Please enter a value.
    goto askTitle
)
set /p FLAG=Enter flag or keyword (optional): || SET "FLAG=^<mark^>unknown^<^/mark^>"
set /p DIFFICULTY=Enter difficulty (optional): || SET "DIFFICULTY=unknown"
set /p DESCRIPTION=Enter short description (optional): || SET "DESCRIPTION=^[Add description here...^]"

REM === FORMAT FILENAME ===
set "FILENAME=%TITLE%"
set "FILENAME=%FILENAME: =_%"
set "FILENAME=%FILENAME:"=%"
set "FILEPATH=%CATEGORY_PATH%\%FILENAME%.md"

REM === CREATE WRITEUP FILE ===
if not exist "%README_PATH%" (
    (
        echo # %TITLE%
        echo.
        echo ^| Titel          ^| Kategorie ^| flag ^| Difficulty ^|
        echo ^| :---        ^|    :----   ^|:--- ^|  :--- ^|
        echo ^| %TITLE% ^| %CATEGORY%  ^| %FLAG% ^| %DIFFICULTY% ^|
        echo.
        echo ## Description
        echo %DESCRIPTION%
        echo.
        echo ## Attachments
        echo [Add any attachments or links here...]
        echo.
        echo ## Solution
        echo [Write your solution here...]
    ) > "%FILEPATH%"

    if exist "!FILEPATH!" (
    echo File created successfully: "!FILEPATH!"
) else (
    echo Failed to create file. Check path and permissions.
)
) else (
    echo README.md already exists.
)

REM === DEFINE CATEGORY README PATH ===
set "README_PATH=%CATEGORY_PATH%\Readme.md"

REM === ENSURE CATEGORY README EXISTS ===
if not exist "%README_PATH%" (
    (
        echo # %CATEGORY% Writeups
        echo.
        echo Writeups for %CATEGORY% challenges in %EVENT%.
        echo.
        echo ## List of solved Challenges
        echo.
    ) > "%README_PATH%"
    echo Created new category README.md
)

REM === ADD CHALLENGE TO CATEGORY README ===
echo Adding challenge to category README...

REM Check if challenge already listed
findstr /C:"- [%TITLE%](" "%README_PATH%" >nul
if not errorlevel 1 (
    echo Challenge already listed in README.
    goto skip_readme_append
)

REM Add entry after '## List of solved Challenges', preserving blank lines
(
    for /f "tokens=1,* delims=:" %%A in ('findstr /n "^" "%README_PATH%"') do (
        set "line=%%B"
        setlocal enabledelayedexpansion
        echo(!line!
        if "!line!"=="## List of solved Challenges" (
            echo - [%TITLE%](%FILENAME%.md^)
        )
        endlocal
    )
) > "%README_PATH%.tmp"

move /Y "%README_PATH%.tmp" "%README_PATH%" >nul
echo Challenge added to category README.

:skip_readme_append


pause
