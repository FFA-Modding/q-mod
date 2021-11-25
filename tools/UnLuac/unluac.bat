@echo off

type %1
:: Récupère le fichier droppé et le met dans la variable %1

echo %1
echo "%~dp0unluac_2021_08_29b.jar"
echo "%~dp1%~n1.lua"
:: Print les infos dans la console

java -jar "%~dp0unluac_2021_08_29b.jar" "%1" > "%~dp1%~n1.lua"
:: %~dp0 = %~ (Début de variable) d = directory (lieux) p = path (chemin d'accès) 0 = fichier initié (unluac.bat)
:: %~dp1 = directory path 1 (Chemin d'accès au répertoire du fichier initié "1" donc le fichier drop)
:: %~n1 = name 1 (Nom du fichier "1" donc nom du fichier drop)