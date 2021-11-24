:: @echo off
type %1
for /r %%o in (cd %1, %CD%) do (
    set o = %%~ni
)
echo %1
echo "%~dp0unluac_2021_08_29b.jar"
echo %output%
set preoutput = %1
set out = %preoutput:~-3%
java -jar "%~dp0unluac_2021_08_29b.jar" "%1" > "%1%.lua"