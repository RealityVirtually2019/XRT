@echo off
setlocal
set MLSDK=%MLSDK%
if "%MLSDK%"=="" set MLSDK=C:/Users/nicks/MagicLeap/mlsdk/v0.19.0
set MLDB=%MLSDK%\tools\mldb\mldb.exe
@echo.
@echo Installing existing application. Failures here indicate a problem with the device (connection or storage permissions) and are fatal.
%MLDB% %DEVICE% install -u "%~dp0\Unreal.mpk"
@if "%ERRORLEVEL%" NEQ "0" goto Error
@echo.
@echo Installation successful
%MLDB% %DEVICE% ps > nul
@if "%ERRORLEVEL%" NEQ "0" goto OobeError
goto:eof
:OobeError
@echo Device is not ready for use. Run "%MLDB% ps" from a command prompt for details.
goto Pause
:Error
@echo.
@echo There was an error installing the game. Look above for more info.
@echo.
@echo Things to try:
@echo Check that the device (and only the device) is listed with "%MLDB% devices" from a command prompt.
@echo Check if the device is ready for use with "%MLDB% ps" from a command prompt.
:Pause
@pause
