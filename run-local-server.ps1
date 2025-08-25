Write-Host "Starting local web server for invoice generator..." -ForegroundColor Green
Write-Host ""
Write-Host "Open your browser and go to: http://localhost:8000/invoice-generator.html" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Cyan
Write-Host ""

# Try Python 3 first, then Python 2
try {
    python -m http.server 8000
} catch {
    try {
        python3 -m http.server 8000
    } catch {
        Write-Host "Python not found. Please install Python to run the local server." -ForegroundColor Red
        Write-Host "Alternatively, you can use any other local web server." -ForegroundColor Yellow
        pause
    }
}