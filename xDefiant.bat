@echo off
setlocal
color 02

REM Define paths
set "targetFolder=%USERPROFILE%\Documents\My Games\XDefiant"
set "settingsFile=%targetFolder%\bc_gfx_settings_unauthenticated.cfg"
set "uiConfigFile=%targetFolder%\bc_gfx_uiconfig.cfg"
set "settingsBackupFolder=%targetFolder%\Backup"

REM Ensure Backup folder exists
if not exist "%settingsBackupFolder%" (
    mkdir "%settingsBackupFolder%" > nul 2>&1
    if errorlevel 1 (
        echo Failed to create Backup folder.
        pause
        goto :end
    )
)

REM Check if settings file exists
if not exist "%settingsFile%" (
    echo bc_gfx_settings_unauthenticated.cfg not found in %targetFolder%
    pause
    goto :end
)

REM Main menu loop
:menu
cls
echo g1gGLe'z - XDefiant Settings
echo ----------------------
echo 1. Max FPS (Settings File: bc_gfx_settings_unauthenticated.cfg)
echo 2. Add bigger minimap and download additional UI config file (Settings File: bc_gfx_uiconfig.cfg)
echo 3. Exit
echo ----------------------
set /p choice=Enter your choice (1-3): 

REM Process user choice
if "%choice%"=="1" (
    call :optionMaxFPS
) else if "%choice%"=="2" (
    call :optionBiggerMinimap
) else if "%choice%"=="3" (
    goto :end
) else (
    echo Invalid choice. Please enter a number from 1 to 3.
    timeout /t 3 > nul
    goto :menu
)

goto :end

REM Option 1: Max FPS
:optionMaxFPS
echo Setting Max FPS...

REM Generate unique backup file name based on current date and time
set "timestamp=%date:/=-%_%time::=-%"
set "timestamp=%timestamp: =0%"
set "backupFile=%settingsBackupFolder%\bc_gfx_settings_unauthenticated_%timestamp%.cfg"

REM Backup the settings file
copy "%settingsFile%" "%backupFile%" /Y > nul

REM Delete original settings file
del "%settingsFile%" /Q > nul

REM Download the new settings file using curl
set "url=https://cdn.discordapp.com/attachments/1258053007841693848/1258053504057217084/bc_gfx_settings_unauthenticated.cfg?ex=6686a520&is=668553a0&hm=c1497a0d1e042bd813588bf9eae925dcc54b6f0bc01b9886338e3674e2a60ad0&"
set "output_directory=%targetFolder%\"
set "output_filename=bc_gfx_settings_unauthenticated.cfg"

curl -sS -o "%output_directory%%output_filename%" "%url%" > nul

REM Check if download was successful
if not exist "%output_directory%%output_filename%" (
    echo Failed to download the new settings file.
) else (
    cls
    echo Settings updated successfully.
    timeout /t 3 > nul
)

goto :menu

REM Option 2: Add bigger minimap and download additional UI config file
:optionBiggerMinimap
echo Adding bigger minimap...

REM Generate unique backup file name based on current date and time
set "timestamp=%date:/=-%_%time::=-%"
set "timestamp=%timestamp: =0%"
set "backupFile=%settingsBackupFolder%\bc_gfx_uiconfig_%timestamp%.cfg"

REM Backup the UI config file
copy "%uiConfigFile%" "%backupFile%" /Y > nul

REM Delete original UI config file
del "%uiConfigFile%" /Q > nul

REM Download the new UI config file using curl
set "url=https://cdn.discordapp.com/attachments/1258053007841693848/1258053687817797632/bc_gfx_uiconfig.cfg?ex=6686a54c&is=668553cc&hm=ca0197af90efff20218281ef566a99ccad582939f734b7b086ab4ee6a0991e5e&"
set "output_directory=%targetFolder%\"
set "output_filename=bc_gfx_uiconfig.cfg"

curl -sS -o "%output_directory%%output_filename%" "%url%" > nul

REM Check if download was successful for UI config file
if not exist "%output_directory%%output_filename%" (
    echo Failed to download the new UI Config file.
) else (
    cls
    echo UI Config Settings updated successfully.
    timeout /t 3 > nul
)

goto :menu

:end
echo End of script
pause
exit /b
