@echo off
cls

:: Copia tudo de cloud1
xcopy "D:\cloud1\*" "C:\Users\Public\Desktop\" /E /H /I /Y

:: Copia tudo de intel (arquivos, pastas e subpastas)
xcopy "D:\intel\*" "C:\intel\" /E /H /I /Y

del "C:\Users\Public\Desktop\Aplicativos Cloud.lnk" /Q

RD /S /Q C:\RECYCLER\

gpupdate /force

pause