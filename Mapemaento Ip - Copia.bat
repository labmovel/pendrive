@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Escaneador de Rede com Nomes - Maristas

echo ==============================================================
echo   A iniciar a varredura corporativa (maristas.local)...
echo ==============================================================

echo [1/2] A acordar os computadores na rede...
for /L %%i in (1,1,100) do (
    start /b ping -n 1 -w 20 10.8.128.%%i >nul
)
timeout /t 3 /nobreak >nul

echo.
echo [2/2] A consultar o Servidor DNS para obter os Nomes...
echo ==============================================================
echo IP Address        ^| MAC Address       ^| Nome da Maquina
echo --------------------------------------------------------------

for /f "tokens=1,2" %%A in ('arp -a ^| findstr "10.8.128." ^| findstr /i /v "Interface"') do (
    set "IP_PC=%%A"
    set "MAC_PC=%%B"
    set "NOME_PC=Nao_Registrado"

    :: Tentativa 1: Consulta direta ao Servidor DNS do colégio (nslookup)
    for /f "tokens=2" %%N in ('nslookup !IP_PC! 2^>nul ^| findstr /i /c:"Nome:" /c:"Name:"') do (
        set "NOME_PC=%%N"
    )
    
    :: Tentativa 2: Se o DNS falhar, tenta o ping reverso como plano B
    if "!NOME_PC!"=="Nao_Registrado" (
        for /f "tokens=3" %%N in ('ping -a -n 1 -w 20 !IP_PC! ^| findstr /i "Disparando"') do (
            if not "%%N"=="!IP_PC!" set "NOME_PC=%%N"
        )
    )

    echo !IP_PC!      ^| !MAC_PC! ^| !NOME_PC!
)

echo --------------------------------------------------------------
echo Varredura concluida com sucesso!
echo ==============================================================
pause