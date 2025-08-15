# Flat FTP Deployment Script - uploads all files to root directory
param(
    [Parameter(Mandatory=$true)]
    [string]$Password
)

$ftpHost = "ftp://41.185.13.154"
$ftpUser = "virtuall"
$remotePath = "/virtual-life.co.za/"

Write-Host "Starting FTP deployment (flat structure)..." -ForegroundColor Green
Write-Host "Host: $ftpHost" -ForegroundColor Yellow

# Create FTP credentials
$creds = New-Object System.Net.NetworkCredential($ftpUser, $Password)

$success = 0
$failed = 0

# Files to upload (all to root)
$filesToUpload = @{
    "index.html" = "index.html"
    "style.css" = "style.css"
    "game.html" = "game.html"
    "sheep_rumble.html" = "sheep_rumble.html"
    "terms.html" = "terms.html"
    "design_system.html" = "design_system.html"
    "templates.html" = "templates.html"
    "sentient.png" = "sentient.png"
    "sentient2.png" = "sentient2.png"
    "templates\change-request.html" = "change-request.html"
    "images\vlLogo.png" = "vlLogo.png"
}

foreach ($item in $filesToUpload.GetEnumerator()) {
    $localFile = $item.Key
    $remoteFile = $item.Value
    
    if (Test-Path $localFile) {
        Write-Host "Uploading: $localFile -> $remoteFile" -ForegroundColor Cyan
        $uri = $ftpHost + $remotePath + $remoteFile
        
        try {
            $request = [System.Net.FtpWebRequest]::Create($uri)
            $request.Credentials = $creds
            $request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
            $request.UseBinary = $true
            $request.UsePassive = $true
            
            $content = [System.IO.File]::ReadAllBytes($localFile)
            $request.ContentLength = $content.Length
            
            $stream = $request.GetRequestStream()
            $stream.Write($content, 0, $content.Length)
            $stream.Close()
            
            $response = $request.GetResponse()
            $response.Close()
            
            Write-Host "  Success!" -ForegroundColor Green
            $success++
        }
        catch {
            Write-Host "  Failed: $_" -ForegroundColor Red
            $failed++
        }
    }
    else {
        Write-Host "  File not found: $localFile" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Deployment Summary" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "✓ Successful: $success" -ForegroundColor Green
if ($failed -gt 0) {
    Write-Host "✗ Failed: $failed" -ForegroundColor Red
}
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Website URL: http://virtual-life.co.za" -ForegroundColor Cyan
Write-Host ""
Write-Host "Note: Files uploaded to root directory." -ForegroundColor Yellow
Write-Host "Update image paths in HTML if needed." -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Cyan