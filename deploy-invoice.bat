@echo off
setlocal

echo ======================================
echo Deploying secured invoice to IIS folder
echo ======================================
echo Target: ftp://virtuall@41.185.13.154/virtual-life.co.za/private/invoice/
echo.
set /p password="Enter FTP Password: "

echo Starting...
powershell -ExecutionPolicy Bypass -File "%~dp0deploy-invoice.ps1" -Password "%password%"
echo.
pause

endlocal
