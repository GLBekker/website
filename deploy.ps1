# PowerShell FTP Deployment Script for Virtual Life Website
# Usage: .\deploy.ps1 -Password "your_ftp_password"

param(
    [Parameter(Mandatory=$true)]
    [string]$Password
)

$ftpHost = "ftp://41.185.13.154"
$ftpUser = "virtuall"
$remotePath = "/virtual-life.co.za/"
$localPath = Get-Location

# Files to upload (automatically find all relevant files)
$filesToUpload = @(
    "index.html",
    "style.css",
    "game.html",
    "sheep_rumble.html",
    "terms.html",
    "design_system.html",
    "templates.html",
    "sentient.png",
    "sentient2.png"
)

# Add all files in subdirectories
$templatesFiles = Get-ChildItem -Path "templates" -Filter "*.html" -ErrorAction SilentlyContinue | ForEach-Object { "templates/$($_.Name)" }
$imagesFiles = Get-ChildItem -Path "images" -Filter "*.*" -ErrorAction SilentlyContinue | ForEach-Object { "images/$($_.Name)" }

$filesToUpload += $templatesFiles
$filesToUpload += $imagesFiles

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Starting FTP deployment to Virtual Life website..." -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Host: $ftpHost" -ForegroundColor Yellow
Write-Host "Remote Path: $remotePath" -ForegroundColor Yellow
Write-Host "Total files to upload: $($filesToUpload.Count)" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Create FTP credentials
$ftpCredentials = New-Object System.Net.NetworkCredential($ftpUser, $Password)

# Track upload statistics
$successCount = 0
$failCount = 0
$skipCount = 0

# Create directories first if they don't exist
$directories = @("templates", "images")
foreach ($dir in $directories) {
    try {
        $remoteDirPath = $ftpHost + $remotePath + $dir
        $ftpRequest = [System.Net.FtpWebRequest]::Create($remoteDirPath)
        $ftpRequest.Credentials = $ftpCredentials
        $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $ftpRequest.UsePassive = $true
        $response = $ftpRequest.GetResponse()
        $response.Close()
        Write-Host "Created directory: $dir" -ForegroundColor Green
    }
    catch {
        # Directory might already exist, which is fine
    }
}

$fileIndex = 0
foreach ($file in $filesToUpload) {
    $fileIndex++
    $localFile = Join-Path $localPath $file
    
    if (Test-Path $localFile) {
        $remotefile = $ftpHost + $remotePath + $file.Replace("\", "/")
        
        try {
            $fileSize = [math]::Round((Get-Item $localFile).Length / 1KB, 2)
            Write-Host "[$fileIndex/$($filesToUpload.Count)] Uploading: $file (${fileSize}KB)" -ForegroundColor Cyan
            
            # Create FTP request
            $ftpRequest = [System.Net.FtpWebRequest]::Create($remotefile)
            $ftpRequest.Credentials = $ftpCredentials
            $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
            $ftpRequest.UseBinary = $true
            $ftpRequest.UsePassive = $true
            
            # Read file content
            $fileContent = [System.IO.File]::ReadAllBytes($localFile)
            $ftpRequest.ContentLength = $fileContent.Length
            
            # Upload file
            $requestStream = $ftpRequest.GetRequestStream()
            $requestStream.Write($fileContent, 0, $fileContent.Length)
            $requestStream.Close()
            
            $response = $ftpRequest.GetResponse()
            Write-Host "  ✓ Uploaded successfully" -ForegroundColor Green
            $response.Close()
            $successCount++
        }
        catch {
            Write-Host "  ✗ Failed to upload: $_" -ForegroundColor Red
            $failCount++
        }
    }
    else {
        if (-not [string]::IsNullOrWhiteSpace($file)) {
            Write-Host "  ⚠ File not found: $file" -ForegroundColor Yellow
            $skipCount++
        }
    }
}

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Deployment Summary" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "✓ Successful uploads: $successCount" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "✗ Failed uploads: $failCount" -ForegroundColor Red
}
if ($skipCount -gt 0) {
    Write-Host "⚠ Skipped files: $skipCount" -ForegroundColor Yellow
}
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Website URL: http://virtual-life.co.za" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan