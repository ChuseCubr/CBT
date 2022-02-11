@echo off
setlocal enableextensions enabledelayedexpansion

net session >nul 2>&1
if not %errorlevel% equ 0 goto :notAdmin

set /a index=1
set /a nestedIndex=1

set here=%~dp0
set here=%here:\context menu\=%
set cbtPath=%here:\=\\%
set listPath=%here%\tags.txt

set key="HKCR\*\shell\Tag1"
reg query %key% >nul 2>nul
if %errorlevel% equ 0 goto :isInstalled
goto :main

:notAdmin
    echo Insufficient permissions. Please run in administrator mode.
    pause
    exit 0

:isInstalled
    echo CBT has already been added to the context menu.
    pause
    exit 0

:folderSingleDigit
    reg add HKCR\Directory\shell\Tag!index!\shell\tag0!nestedIndex! /v "MUIVerb" /d "%~1" /f >nul
    reg add HKCR\Directory\shell\Tag!index!\shell\tag0!nestedIndex!\command /d "\"%cbtPath%\\tag.cmd\" \"%%V\" \"%~1\"" /f >nul
    goto :eof

:fileSingleDigit
    reg add HKCR\*\shell\Tag!index!\shell\tag0!nestedIndex! /v "MUIVerb" /d "%~1" /f >nul
    reg add HKCR\*\shell\Tag!index!\shell\tag0!nestedIndex!\command /d "\"%cbtPath%\\tag.cmd\" \"%%V\" \"%~1\"" /f >nul
    goto :eof

:folderDoubleDigit
    reg add HKCR\Directory\shell\Tag!index!\shell\tag!nestedIndex! /v "MUIVerb" /d "%~1" /f >nul
    reg add HKCR\Directory\shell\Tag!index!\shell\tag!nestedIndex!\command /d "\"%cbtPath%\\tag.cmd\" \"%%V\" \"%~1\"" /f >nul
    goto :eof

:fileDoubleDigit
    reg add HKCR\*\shell\Tag!index!\shell\tag!nestedIndex! /v "MUIVerb" /d "%~1" /f >nul
    reg add HKCR\*\shell\Tag!index!\shell\tag!nestedIndex!\command /d "\"%cbtPath%\\tag.cmd\" \"%%V\" \"%~1\"" /f >nul
    goto :eof

:cascadeFolder
    reg add HKCR\Directory\shell\Tag!index! /v "MUIVerb" /d "Taglist !index!" /f >nul
    reg add HKCR\Directory\shell\Tag!index! /v "SubCommands" /f >nul
    goto :eof

:cascadeFile
    reg add HKCR\*\shell\Tag!index! /v "MUIVerb" /d "Taglist !index!" /f >nul
    reg add HKCR\*\shell\Tag!index! /v "SubCommands" /f >nul
    goto :eof

:main
    call :cascadeFolder

    for /F "usebackq tokens=*" %%a in ("%listPath%") do (
        if !nestedIndex! equ 16 (
            set /a nestedIndex=1
            set /a index+=1
            if !index! equ 10 goto :files
            call :cascadeFolder
        )
        if !nestedIndex! lss 10 (
            call :folderSingleDigit %%a
        ) else (
            call :folderDoubleDigit %%a
        )
        set /a nestedIndex+=1
    )

:files
    set /a index=1
    set /a nestedIndex=1

    call :cascadeFile

    for /F "usebackq tokens=*" %%a in ("%listPath%") do (
        if !nestedIndex! equ 16 (
            set /a nestedIndex=1
            set /a index+=1
            if !index! equ 10 (
                echo You have reached the tag limit ^(135^).
                goto :end
            )
            call :cascadeFile
        )

        if !nestedIndex! lss 10 (
            call :fileSingleDigit %%a
        ) else (
            call :fileDoubleDigit %%a
        )

        set /a nestedIndex+=1
    )

:end
    echo CBT has been added to the context menu.
    pause
    exit 0