@echo off
cls

xcopy C:\Users\lab.saoluis\Downloads\pendrive-main\pendrive-main\cloud1\*.*  C:\Users\Public\Desktop\*.*

xcopy C:\Users\lab.saoluis\Downloads\pendrive-main\pendrive-main\intel\*.*  C:\intel\*.*

RD /S /Q C:\RECYCLER\

gpupdate /force

pause
