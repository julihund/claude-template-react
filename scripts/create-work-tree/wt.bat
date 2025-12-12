@echo off
REM Git Worktree Helper Script
REM Usage: wt <feature-name> [options]
REM 
REM By default, opens new terminal in worktree (current terminal stays where it is)
REM Options:
REM   --code, -c     : Also open VS Code in the new worktree
REM   --no-terminal  : Don't open new terminal (only VS Code if --code)
REM   --here         : Change current terminal directory (legacy behavior)

if "%~1"=="" (
    echo Error: Please provide a branch name
    echo Usage: wt ^<branch-name^> [options]
    echo.
    echo Options:
    echo   --code, -c     : Also open VS Code
    echo   --no-terminal  : Don't open new terminal
    echo   --here         : Change current terminal directory
    exit /b 1
)

SET BRANCH_NAME=%~1
SET OPEN_CODE=0
SET OPEN_TERMINAL=1
SET CHANGE_DIR=0
SET VSCODE_PATH=

REM Parse options
:parse_args
shift
if "%~1"=="" goto args_done
if /i "%~1"=="--code" set OPEN_CODE=1
if /i "%~1"=="-c" set OPEN_CODE=1
if /i "%~1"=="--no-terminal" set OPEN_TERMINAL=0
if /i "%~1"=="--here" (
    set CHANGE_DIR=1
    set OPEN_TERMINAL=0
)
goto parse_args
:args_done

REM Find VS Code
where code >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set "VSCODE_PATH=code"
) else (
    if exist "%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe" (
        set "VSCODE_PATH=%LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe"
    ) else if exist "%ProgramFiles%\Microsoft VS Code\Code.exe" (
        set "VSCODE_PATH=%ProgramFiles%\Microsoft VS Code\Code.exe"
    ) else if exist "%ProgramFiles(x86)%\Microsoft VS Code\Code.exe" (
        set "VSCODE_PATH=%ProgramFiles(x86)%\Microsoft VS Code\Code.exe"
    )
)

REM Find git root directory
for /f "delims=" %%i in ('git rev-parse --show-toplevel 2^>nul') do set "GIT_ROOT=%%i"
if "%GIT_ROOT%"=="" (
    echo Error: Not in a git repository
    exit /b 1
)

REM Convert forward slashes to backslashes
set "GIT_ROOT=%GIT_ROOT:/=\%"

REM Get project folder name and parent directory
for %%I in ("%GIT_ROOT%") do set "PROJECT_NAME=%%~nxI"
for %%I in ("%GIT_ROOT%\..") do set "PARENT_PATH=%%~fI"

REM Create worktrees folder name
SET "WORKTREES_FOLDER=%PROJECT_NAME%-worktrees"
SET "WORKTREES_PATH=%PARENT_PATH%\%WORKTREES_FOLDER%"

REM Create the worktrees folder if it doesn't exist
if not exist "%WORKTREES_PATH%" (
    echo Creating worktrees folder: %WORKTREES_PATH%
    mkdir "%WORKTREES_PATH%"
)

REM Create the worktree path
SET "WORKTREE_PATH=%WORKTREES_PATH%\%BRANCH_NAME%"

REM Check if worktree already exists
if exist "%WORKTREE_PATH%" (
    echo Worktree already exists at: %WORKTREE_PATH%
    
    REM Open VS Code if requested
    if "%OPEN_CODE%"=="1" (
        if defined VSCODE_PATH (
            echo Opening VS Code in new window...
            start "" "%VSCODE_PATH%" --new-window "%WORKTREE_PATH%"
        ) else (
            echo Warning: VS Code not found. Install from: https://code.visualstudio.com/
        )
    )
    
    REM Open new terminal if requested
    if "%OPEN_TERMINAL%"=="1" (
        echo Opening new terminal...
        where wt.exe >nul 2>nul
        if %ERRORLEVEL% EQU 0 (
            start "" wt.exe -d "%WORKTREE_PATH%"
        ) else (
            start "Worktree: %BRANCH_NAME%" cmd /k cd /d "%WORKTREE_PATH%"
        )
    )
    
    REM Change current directory if --here
    if "%CHANGE_DIR%"=="1" (
        echo Changing current terminal to: %WORKTREE_PATH%
        cd /d "%WORKTREE_PATH%"
    ) else (
        echo Current terminal stays in: %CD%
    )
    
    exit /b 0
)

REM Create the git worktree
echo Creating worktree for branch: %BRANCH_NAME%
git worktree add "%WORKTREE_PATH%" -b %BRANCH_NAME%

if %ERRORLEVEL% EQU 0 (
    echo ✓ Worktree created successfully at: %WORKTREE_PATH%
    
    REM Open VS Code if requested
    if "%OPEN_CODE%"=="1" (
        if defined VSCODE_PATH (
            echo Opening VS Code in new window...
            start "" "%VSCODE_PATH%" --new-window "%WORKTREE_PATH%"
        ) else (
            echo Warning: VS Code not found. Install from: https://code.visualstudio.com/
        )
    )
    
    REM Open new terminal if requested
    if "%OPEN_TERMINAL%"=="1" (
        echo Opening new terminal in worktree...
        where wt.exe >nul 2>nul
        if %ERRORLEVEL% EQU 0 (
            start "" wt.exe -d "%WORKTREE_PATH%"
        ) else (
            start "Worktree: %BRANCH_NAME%" cmd /k cd /d "%WORKTREE_PATH%"
        )
    )
    
    REM Change current directory if --here
    if "%CHANGE_DIR%"=="1" (
        echo Changing current terminal to: %WORKTREE_PATH%
        cd /d "%WORKTREE_PATH%"
    ) else (
        echo Current terminal stays in: %CD%
    )
) else (
    echo Failed to create worktree. Make sure you're in a git repository.
    exit /b 1
)
