@echo off
title Nuh Uh - Fullscreen Working

:: Hide batch window (background run)
if not defined MINIMIZED set MINIMIZED=1 && start /min "" cmd /c "%~f0" && exit
@cd /d "%~dp0"

:: Initial 10 Uh oh popups (pairs) - regular modal so Task Manager is easy
for /l %%i in (1,1,5) do (
    echo x=MsgBox("Uh oh", vbCritical + vbOKOnly, "Error") > "%temp%\uhoh_a%%i.vbs"
    start "" cscript //nologo "%temp%\uhoh_a%%i.vbs"

    echo x=MsgBox("Uh oh", vbCritical + vbOKOnly, "Error") > "%temp%\uhoh_b%%i.vbs"
    start "" cscript //nologo "%temp%\uhoh_b%%i.vbs"

    timeout /t 1 >nul

    :waitpair
    tasklist | find "cscript" >nul
    if %errorlevel%==0 (timeout /t 1 >nul & goto waitpair)

    del "%temp%\uhoh_a%%i.vbs" >nul 2>&1
    del "%temp%\uhoh_b%%i.vbs" >nul 2>&1
)

:: Your exact video link
set "VIDEO=https://www.youtube.com/watch?v=Hv32u1KsRpU&list=RDHv32u1KsRpU&start_radio=1"

:: Browser setup
set "BROWSER=chrome.exe"
set "FLAGS=--start-fullscreen --autoplay-policy=no-user-gesture-required --noerrdialogs --disable-infobars --disable-pinch --overscroll-history-navigation=0"

if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles%\Google\Chrome\Application\chrome.exe"

if not exist "%BROWSER%" (
    set "BROWSER=msedge.exe"
    set "FLAGS=--start-fullscreen --autoplay-policy=no-user-gesture-required"
)

:: Launch in fullscreen (referrer works, no Error 153)
start "" "%BROWSER%" %FLAGS% "%VIDEO%"

:: Extra 20 Uh oh popups (total 30)
set count=0
:popuploop
if %count% GEQ 20 goto watcher

echo x=MsgBox("Uh oh", vbCritical + vbOKOnly, "Error") > "%temp%\uhoh_extra%count%.vbs"
start "" cscript //nologo "%temp%\uhoh_extra%count%.vbs"

set /a count+=1
timeout /t 3 >nul
goto popuploop

:watcher
:: Reopen if closed + Nuh uh
:watch
timeout /t 2 >nul

tasklist | findstr /i "%BROWSER%" >nul
if %errorlevel%==0 goto watch

echo x=MsgBox("Nuh uh", vbCritical + vbOKOnly, "Nope") > "%temp%\nuhuh.vbs"
start "" cscript //nologo "%temp%\nuhuh.vbs"
timeout /t 1 >nul
del "%temp%\nuhuh.vbs" >nul 2>&1

start "" "%BROWSER%" %FLAGS% "%VIDEO%"
goto watch