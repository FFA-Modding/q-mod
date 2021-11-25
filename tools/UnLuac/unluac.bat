@echo off
type %1
::cmd for /r %%~n1 in (cd %1, %CD%) do (
::    cmd set out = %~n1
::)
echo %1
echo "%~dp0unluac_2021_08_29b.jar"
echo "%~dp1%~n1.lua"
set preoutput = %1
java -jar "%~dp0unluac_2021_08_29b.jar" "%1" > "%~dp1%~n1.lua"
pause