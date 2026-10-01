@echo off
chcp 65001 > nul

:: ============================================================
:: 1. ENCERRA NAVEGADORES, OFFICE, TEAMS E ONEDRIVE
:: ============================================================
taskkill /f /im chrome.exe /im msedge.exe /im firefox.exe /im acrobat.exe > nul 2>&1
taskkill /f /im WINWORD.EXE /im EXCEL.EXE /im POWERPNT.EXE /im OUTLOOK.EXE > nul 2>&1
taskkill /f /im ms-teams.exe /im Teams.exe /im OneDrive.exe > nul 2>&1

:: ============================================================
:: 2. REMOVE CONTAS MICROSOFT E CREDENCIAIS SALVAS
:: ============================================================
powershell -Command "cmdkey /list | ForEach-Object { if ($_ -match 'Target:\s*(.+)') { $t = $matches[1].Trim(); if ($t -match 'Microsoft|Office|SSO|WindowsLive|OneDrive|Session') { cmdkey /delete:$t } } }" > nul 2>&1

rmdir /s /q "%LOCALAPPDATA%\Microsoft\OneAuth" > nul 2>&1
rmdir /s /q "%LOCALAPPDATA%\Microsoft\IdentityCache" > nul 2>&1
rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy" > nul 2>&1

reg delete "HKCU\Software\Microsoft\Office\16.0\Common\Identity\Identities" /f > nul 2>&1
reg delete "HKCU\Software\Microsoft\Office\16.0\Common\Identity\Profiles" /f > nul 2>&1

:: ============================================================
:: 3. RESTAURA NOME DA LIXEIRA
:: ============================================================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}" /ve /d "Lixeira" /f > nul 2>&1

:: ============================================================
:: 4. ESVAZIA LIXEIRA E LIMPA A ÁREA DE TRANSFERÊNCIA (CTRL+C)
:: ============================================================
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" > nul 2>&1
cmd /c "echo off | clip" > nul 2>&1

:: ============================================================
:: 5. LIMPA HISTÓRICO, CACHE E COOKIES DOS NAVEGADORES
:: ============================================================

:: Google Chrome
set "CHROME_DIR=%LOCALAPPDATA%\Google\Chrome\User Data\Default"
if exist "%CHROME_DIR%" (
    del /f /q "%CHROME_DIR%\History*" > nul 2>&1
    del /f /q "%CHROME_DIR%\Visited Links" > nul 2>&1
    del /f /q "%CHROME_DIR%\Web Data*" > nul 2>&1
    del /f /q "%CHROME_DIR%\Cookies*" > nul 2>&1
    del /f /q "%CHROME_DIR%\Network\Cookies*" > nul 2>&1
    del /f /q /s "%CHROME_DIR%\Cache\*.*" > nul 2>&1
    del /f /q /s "%CHROME_DIR%\Code Cache\*.*" > nul 2>&1
)

:: Microsoft Edge
set "EDGE_DIR=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default"
if exist "%EDGE_DIR%" (
    del /f /q "%EDGE_DIR%\History*" > nul 2>&1
    del /f /q "%EDGE_DIR%\Visited Links" > nul 2>&1
    del /f /q "%EDGE_DIR%\Web Data*" > nul 2>&1
    del /f /q "%EDGE_DIR%\Cookies*" > nul 2>&1
    del /f /q "%EDGE_DIR%\Network\Cookies*" > nul 2>&1
    del /f /q /s "%EDGE_DIR%\Cache\*.*" > nul 2>&1
    del /f /q /s "%EDGE_DIR%\Code Cache\*.*" > nul 2>&1
)

:: Mozilla Firefox
set "FF_DIR=%LOCALAPPDATA%\Mozilla\Firefox\Profiles"
if exist "%FF_DIR%" (
    for /d %%P in ("%FF_DIR%\*") do del /f /q /s "%%P\cache2\*.*" > nul 2>&1
)
set "FF_ROAMING=%APPDATA%\Mozilla\Firefox\Profiles"
if exist "%FF_ROAMING%" (
    for /d %%P in ("%FF_ROAMING%\*") do (
        del /f /q "%%P\places.sqlite*" > nul 2>&1
        del /f /q "%%P\cookies.sqlite*" > nul 2>&1
    )
)

:: ============================================================
:: 6. LIMPA ARQUIVOS TEMPORÁRIOS, RECENTES, RECOMENDAÇÕES E JUMP LISTS
:: ============================================================

:: Temp do sistema
del /f /q /s "%TEMP%\*.*" > nul 2>&1
for /d %%D in ("%TEMP%\*") do rmdir /s /q "%%D" > nul 2>&1

:: Arquivos Recentes, Recomendados (Menu Iniciar) e Jump Lists da barra de tarefas
del /f /q /s "%APPDATA%\Microsoft\Windows\Recent\*.*" > nul 2>&1
del /f /q /s "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*.*" > nul 2>&1
del /f /q /s "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*.*" > nul 2>&1

:: Histórico de comandos digitados no Executar (Win + R)
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f > nul 2>&1

:: Histórico de caminhos digitados no Explorer
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f > nul 2>&1

:: Histórico do registro de documentos recentes
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f > nul 2>&1

:: ============================================================
:: 7. LIMPA AS PASTAS DO USUÁRIO
:: ============================================================
call :LIMPAPASTA "C:\Users\lab.saoluis\OneDrive - MARISTA BRASIL\Área de Trabalho"
call :LIMPAPASTA "C:\Users\lab.saoluis\OneDrive - MARISTA BRASIL\Documentos"
call :LIMPAPASTA "C:\Users\lab.saoluis\OneDrive - MARISTA BRASIL\Imagens"
call :LIMPAPASTA "C:\Users\lab.saoluis\Downloads"
call :LIMPAPASTA "C:\Users\lab.saoluis\Videos"

goto :eof

:LIMPAPASTA
if exist "%~1" (
    del /f /q /s "%~1\*.*" > nul 2>&1
    for /d %%D in ("%~1\*") do rmdir /s /q "%%D" > nul 2>&1
)
goto :eof