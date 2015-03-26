@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

SET inRoot=D:\MongoDB
mkdir %inRoot%\Server
for /r %%i in (mongodb*.msi) do (

msiexec.exe /q /i "%%i" INSTALLLOCATION="%inRoot%\Server"
)
echo %inRoot%
mkdir %inRoot%\data\db
mkdir %inRoot%\data\log
echo logpath=%inRoot%\data\log\mongod.log> "%inRoot%\Server\mongod.cfg"
echo dbpath=%inRoot%\data\db>> "%inRoot%\Server\mongod.cfg"

