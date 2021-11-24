@echo off
type %1
cmd for /r %%~nxI in (cd %1, %CD%) do (
    cmd set out = %%~ni
)
echo %1
echo "%~dp0unluac_2021_08_29b.jar"
cmd set preoutput = %1
if defined %preoutput% (
    echo %output%
    set out = %preoutput:~-3%
    java -jar "%~dp0unluac_2021_08_29b.jar" "%1" > "%1%.lua"
    pause
)