@echo off
cls

xcopy C:\Users\lab.saoluis\Downloads\pendrive\cloud1\*.*  C:\Users\Public\Desktop\*.*

xcopy C:\Users\lab.saoluis\Downloads\pendrive\cloud1\*.*  C:\intel\*.*

RD /S /Q C:\RECYCLER\

gpupdate /force

pause
