@echo off
setlocal
set MLSDK=%MLSDK%
if "%MLSDK%"=="" set MLSDK=C:/Users/nicks/MagicLeap/mlsdk/v0.19.0
set MLDB=%MLSDK%\tools\mldb\mldb.exe
@echo.
@echo Uninstalling existing application. Failures here can almost always be ignored.
%MLDB% %DEVICE% uninstall com.bubbletheorem.xrt
@echo.
@echo.
@echo Uninstall completed
