@echo off
echo ====================================
echo Virtual Life Website FTP Deployment
echo (Flat structure - all files to root)
echo ====================================
echo.
echo Target: ftp://virtuall@41.185.13.154/virtual-life.co.za/
echo.
set /p password="Enter FTP Password: "
echo.
echo Starting deployment...
powershell -ExecutionPolicy Bypass -File "%~dp0deploy-flat.ps1" -Password "%password%"
echo.
pause