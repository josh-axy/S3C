@if (@a==@b) @end /*
@echo off
setlocal enabledelayedexpansion
:start
::For easier updates and better understanding it is reccommended to view this file in Notepad++.
::Special thanks to Hansgruber76 and Dead-Walking From the XeroState community for helping with debugging and features!
::================================================================================
::EVERYTHING HERE IS AUTOMATICALLY GENERATED FROM THE POPUP DIALOGS, NO TOUCHY! For those worried about what the script does I did include descriptions of what the functions do.
::================================================================================

echo ==========================================================================================================
echo ==========================================================================================================
echo " _____ _              _____ _ _   _                _____         _          _____ _                     "
echo "|   __| |_ ___ ___   |     |_| |_|_|___ ___ ___   |     |___ ___| |_ ___   |     | |___ ___ ___ ___ ___ "
echo "|__   |  _| .'|  _|  |   --| |  _| |- _| -_|   |  |   --| .'|  _|   | -_|  |   --| | -_| .'|   | -_|  _|"
echo "|_____|_| |__,|_|    |_____|_|_| |_|___|___|_|_|  |_____|__,|___|_|_|___|  |_____|_|___|__,|_|_|___|_|  "
echo ==========================================================================================================
echo ==========================================================================================================
echo.
echo.

::Set the working directory to the scripts directory so we can properly check for the Config.txt existence. This doesn't do much for the first run, but subsequent loops this pulls us out of the launcher directory so we arent working in the wrong one.
cd /D "%~dp0"

::Here we check if the file "Config.txt" exists. If it does we go straight to reading it's values. If it doesnt we ask the user to select the necessary folders. As we can't have multiple javascript sections, and the dialog label is contained in that section we can only have one of, we use a msg box to inform the user what they are looking for.
IF EXIST "Config.txt" (
	goto configexists
    )
) else (
	msg * "First select the folder containing your RSI Launcher executable."
    for /f "delims=" %%I in ('cscript /nologo /e:jscript "%~f0"') do (
        echo %%I> Config.txt
)
	msg * "Next select the folder containing your LIVE and PTU folders."
	for /f "delims=" %%I in ('cscript /nologo /e:jscript "%~f0"') do (
        echo %%I>> Config.txt
)
:configexists

::This portion reads the Config file that either exists or was generated above, setting each line in sequence to the variables defined.
< "Config.txt" (
  set /p "LauncherBase="
  set /p "GameBase="
)

::Script automatically grabs drive assignments from user directories set above for later use. (First two characters of the path). This may confuse some, why do we need this information? As this is a batch script it needs to be able to dynamically switch drives The way drive changes happen in batch, or windows CMD is the user or script gives the drive letter followed by a colon So to change to drive D from Drive C (default) you or the script enters "D:". Conveniently these two characters are at the very start of the paths you provide above so we just use those values! So When you see %GameDrive% by itself on a line, windows interprets that as a drive change request and bobs your uncle.
SET GameDrive=%GameBase:~0,2%
SET LauncherDrive=%LauncherBase:~0,2%

::Create temporary variable and ask user if they would like to clean the games caches. This accepts upper and lower case values. The brackets around N are standard formating that mark the action taken if only enter is pressed at the prompt. Changing the brackets to enclose Y will not change the default behavior as our script only checks if the value equals Y. This is for user understanding only.
SET /P AREYOUSURE=Do you wish to clean game cache? (Y/[N])

::Check user input, if the input doesn't equal Y then go to ":run" bypassing cache cleanup functions. (Jump to line 98 if not Y or y).
IF /I "%AREYOUSURE%" NEQ "Y" GOTO RUN

::Navigate to the drive containing SC
%GameDrive%

::Cleanup old cache and data files from LIVE. A short rundown of the logic. IF "directory" exists, remove it, and tell user of success. ELSE Tell user folder doesn't exist and continue.
IF EXIST "%GameBase%\LIVE\USER\Client\0\AutoPerfCaptures\" (
	RMDIR /S /Q "%GameBase%\LIVE\USER\Client\0\AutoPerfCaptures" && ECHO LIVE - Clearing AutoPerfCaptures: [92mSUCCESS![0m
) else (
	echo LIVE - [93mAutoPerfCaptures folder has not been rebuilt yet, skipping.[0m
)
IF Exist "%GameBase%\LIVE\USER\Client\0\shaders\" (
	RMDIR /S /Q "%GameBase%\LIVE\USER\Client\0\shaders" && ECHO LIVE - Clearing Shaders: [92mSUCCESS![0m
) else (
	echo LIVE - [93mShaders folder has not been rebuilt yet, skipping.[0m
)
IF EXIST "%GameBase%\LIVE\USER\Client\0\DebugGUI\" (
	RMDIR /S /Q "%GameBase%\LIVE\USER\Client\0\DebugGUI" && ECHO LIVE - Clearing DebugGUI: [92mSUCCESS![0m
) else (
	echo LIVE - [93mDebugGUI folder has not been rebuilt yet, skipping.[0m
)
::This is part of the cleanup, it removes GENERATED config files, it does not touch other things we consider config files such as graphics and controls settings. Rundown. We try to delete any ".cfg" files found ONLY in the base directory of "0". if we find them we remove them so the game can rebuild fresh ones and tell the user. Or we tell the user there weren't any files found.
del "%GameBase%\LIVE\USER\Client\0\*.cfg" 2>&1 1>nul | findstr "^" > nul && echo LIVE - [93mNo cfg files to clean yet![0m || echo LIVE - Cleaning old cfg files: [92mSUCCESS![0m

::Cleanup old cache and data files from PTU
IF EXIST "%GameBase%\PTU\USER\Client\0\AutoPerfCaptures\" (
	RMDIR /S /Q "%GameBase%\PTU\USER\Client\0\AutoPerfCaptures"  && ECHO PTU - Clearing AutoPerfCaptures: [92mSUCCESS![0m
) else (
	echo PTU - [93mAutoPerfCaptures folder has not been rebuilt yet, skipping.[0m
)
IF Exist "%GameBase%\PTU\USER\Client\0\shaders\" (
	RMDIR /S /Q "%GameBase%\PTU\USER\Client\0\shaders" && ECHO PTU - Clearing Shaders: [92mSUCCESS![0m
) else (
	echo PTU - [93mShaders folder has not been rebuilt yet, skipping.[0m
)
IF EXIST "%GameBase%\PTU\USER\Client\0\DebugGUI\" (
	RMDIR /S /Q "%GameBase%\PTU\USER\Client\0\DebugGUI" && ECHO PTU - Clearing DebugGUI: [92mSUCCESS![0m
) else (
	echo PTU - [93mDebugGUI folder has not been rebuilt yet, skipping.[0m
)

del "%GameBase%\PTU\USER\Client\0\*.cfg" 2>&1 1>nul | findstr "^" > nul && echo PTU - [93mNo cfg files to clean yet![0m || echo PTU - Cleaning old cfg files: [92mSUCCESS![0m

::PTU Remove Cache folder in 3.17 Local App Data Directory
cd "%localappdata%\Star Citizen\sc-alpha*"
IF EXIST "shaders" (
	RMDIR /S /Q "shaders" && ECHO PTU - Clearing AppLocal Shaders Cache: [92mSUCCESS![0m
) else (
	echo PTU - [93mAppLocal Shaders folder has not been rebuilt yet, skipping.[0m
)

::Script destination if folder deletion is skipped.
:RUN

::Navigate to drive containing SC Launcher
%LauncherDrive%

::Navigate to folder containing RSILAUNCHER
cd "%LauncherBase%"

:: Start Launcher
ECHO Cleanup complete!
ECHO Starting RSI Launcher!
ECHO If you wish to clean the cache again quickly, close the RSI Launcher and this script will reset for another pass.
"RSI Launcher.exe" >nul 2>&1

::clear the screen to keep it pretty!
cls

::when the launcher is closed go back to the top and reset for another run, this allows rapid restarts.
goto start

::The following is the javascript portion of the batch file, definitely no touchy!
:: JScript portion */

    var shl = new ActiveXObject("Shell.Application");
    var folder = shl.BrowseForFolder(0, "Please choose a folder.", 0, 0x00);
    WSH.Echo(folder ? folder.self.path : '');
