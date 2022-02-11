@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if not %errorlevel% equ 0 goto :notAdmin

set key="HKCR\*\shell\Tag1"
reg query %key% >nul 2>nul
if %errorlevel% equ 1 goto :isUninstalled
goto :main

:notAdmin
    echo Insufficient permissions. Please run in administrator mode.
    pause
    exit 0

:isUninstalled
    echo CBT has not been added to the context menu.
    pause
    exit 0

:main
    for /l %%a in (1, 1, 9) do (
        reg query HKCR\Directory\shell\Tag%%a >nul 2>nul
        if !errorlevel! equ 0 (
            reg delete HKCR\Directory\shell\Tag%%a /f >nul
            reg delete HKCR\*\shell\Tag%%a /f >nul
        )
    )
    echo CBT has been removed from the context menu.
    pause
    exit 0