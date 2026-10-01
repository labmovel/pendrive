@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Escaneador de Telefones - Faixa 150

echo ==============================================================
echo   A varrer a faixa de telefones (10.8.150.x)... Aguarde.
echo ==============================================================

:: Dispara pings para toda a faixa 150 de 1 até 255
for /L %%i in (1,1,255) do (
    start /b ping -n 1 -w 20 10.8.150.%%i >nul
)
:: Aguarda alguns segundos para os aparelhos responderem
timeout /t 5 /nobreak >nul

echo.
echo ==============================================================
echo   Dispositivos Ativos na Faixa 150 (IP e MAC Address):
echo ==============================================================
echo IP Address        ^| Endereço MAC
echo --------------------------------------------------------------

:: Filtra e exibe todos os IPs e MACs encontrados na faixa 150
for /f "tokens=1,2" %%A in ('arp -a ^| findstr "10.8.150\."') do (
    set "IP_DEV=%%A"
    set "MAC_DEV=%%B"
    echo !IP_DEV!      ^| !MAC_DEV!
)

echo --------------------------------------------------------------
echo Varredura concluida com sucesso!
echo ==============================================================
pause