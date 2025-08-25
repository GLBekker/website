@echo off
echo Starting local web server for invoice generator...
echo.
echo Open your browser and go to: http://localhost:8000/invoice-generator.html
echo.
echo Press Ctrl+C to stop the server
echo.
python -m http.server 8000
pause