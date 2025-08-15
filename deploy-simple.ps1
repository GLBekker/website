# Simple FTP Deployment Script for Virtual Life Website
param(
    [Parameter(Mandatory=$true)]
    [string]$Password
)

$ftpHost = "ftp://41.185.13.154"
$ftpUser = "virtuall"
$remotePath = "/virtual-life.co.za/"

# Files to upload
$files = @(
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

Write-Host "Starting FTP deployment..." -ForegroundColor Green
Write-Host "Host: $ftpHost" -ForegroundColor Yellow

# Create FTP credentials
$creds = New-Object System.Net.NetworkCredential($ftpUser, $Password)

$success = 0
$failed = 0

# Create directories first
$directories = @("templates", "images")
foreach ($dir in $directories) {
    Write-Host "Creating directory: $dir" -ForegroundColor Yellow
    $uri = $ftpHost + $remotePath + $dir
    
    try {
        $request = [System.Net.FtpWebRequest]::Create($uri)
        $request.Credentials = $creds
        $request.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $request.UsePassive = $true
        
        $response = $request.GetResponse()
        $response.Close()
        Write-Host "  Directory created!" -ForegroundColor Green
    }
    catch {
        # Directory might already exist
        Write-Host "  Directory may already exist" -ForegroundColor Gray
    }
}

Write-Host ""

# Upload main files
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Uploading: $file" -ForegroundColor Cyan
        $uri = $ftpHost + $remotePath + $file
        
        try {
            $request = [System.Net.FtpWebRequest]::Create($uri)
            $request.Credentials = $creds
            $request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
            $request.UseBinary = $true
            $request.UsePassive = $true
            
            $content = [System.IO.File]::ReadAllBytes($file)
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
        Write-Host "  File not found: $file" -ForegroundColor Yellow
    }
}

# Upload template files
if (Test-Path "templates") {
    $templateFiles = Get-ChildItem -Path "templates" -Filter "*.html"
    foreach ($file in $templateFiles) {
        $localFile = "templates\$($file.Name)"
        $remoteFile = "templates/$($file.Name)"
        
        if (Test-Path $localFile) {
            Write-Host "Uploading: $localFile" -ForegroundColor Cyan
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
    }
}

# Upload image files
if (Test-Path "images") {
    $imageFiles = Get-ChildItem -Path "images" -Filter "*.*"
    foreach ($file in $imageFiles) {
        $localFile = "images\$($file.Name)"
        $remoteFile = "images/$($file.Name)"
        
        if (Test-Path $localFile) {
            Write-Host "Uploading: $localFile" -ForegroundColor Cyan
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
    }
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Deployment Summary" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Successful: $success" -ForegroundColor Green
if ($failed -gt 0) {
    Write-Host "Failed: $failed" -ForegroundColor Red
}
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Website URL: http://virtual-life.co.za" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan