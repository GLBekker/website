# PowerShell FTP Deployment Script for Secured Invoice Folder (IIS)
# Usage: .\deploy-invoice.ps1 -Password "your_ftp_password"

param(
    [Parameter(Mandatory=$true)]
    [string]$Password
)

$ftpHost = "ftp://41.185.13.154"
$ftpUser = "virtuall"
$remoteBase = "/virtual-life.co.za/private/invoice/"
$localPath = (Get-Location).Path

# Files to upload to the secured folder
$filesToUpload = @(
    @{ Local = "invoice-generator.html"; Remote = "index.html" }, # serve as default document
    @{ Local = "invoice-generator.html"; Remote = "invoice-generator.html" }, # optional direct link
    @{ Local = "invoice-ledger.html"; Remote = "ledger.html" },
    @{ Local = "statement-generator.html"; Remote = "statement-generator.html" },
    @{ Local = "images/vlLogo.png"; Remote = "images/vlLogo.png" }
)

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Deploying invoice generator to secured folder..." -ForegroundColor Green
Write-Host ("Target: {0}{1}" -f $ftpHost,$remoteBase) -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Cyan

$creds = New-Object System.Net.NetworkCredential($ftpUser, $Password)

# Ensure remote directories exist
$dirs = @(
    "/virtual-life.co.za/private",
    "/virtual-life.co.za/private/invoice",
    "/virtual-life.co.za/private/invoice/images"
)

foreach ($dir in $dirs) {
    try {
        $uri = $ftpHost + $dir
        $req = [System.Net.FtpWebRequest]::Create($uri)
        $req.Credentials = $creds
        $req.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $req.UsePassive = $true
        $resp = $req.GetResponse()
        $resp.Close()
        Write-Host ("Created: {0}" -f $dir) -ForegroundColor Green
    } catch {
        # likely already exists; ignore
        Write-Host ("Exists: {0}" -f $dir) -ForegroundColor DarkGray
    }
}

$ok = 0; $fail = 0; $skip = 0
$i = 0
foreach ($item in $filesToUpload) {
    $i++
    $localFile = Join-Path $localPath $($item.Local)
    $remoteFile = $ftpHost + $remoteBase + ($item.Remote.Replace("\\", "/"))

    if (-not (Test-Path $localFile)) {
        Write-Host "[$i] Missing local file: $($item.Local)" -ForegroundColor Yellow
        $skip++
        continue
    }

    try {
        $sizeKB = [math]::Round((Get-Item $localFile).Length / 1024, 2)
        Write-Host ("[{0}] Uploading: {1} -> {2} ({3}KB)" -f $i, $item.Local, $item.Remote, $sizeKB) -ForegroundColor Cyan
        $req = [System.Net.FtpWebRequest]::Create($remoteFile)
        $req.Credentials = $creds
        $req.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $req.UseBinary = $true
        $req.UsePassive = $true

        $bytes = [System.IO.File]::ReadAllBytes($localFile)
        $req.ContentLength = $bytes.Length
        $stream = $req.GetRequestStream()
        $stream.Write($bytes, 0, $bytes.Length)
        $stream.Close()

        $resp = $req.GetResponse()
        $resp.Close()
        Write-Host "   Uploaded" -ForegroundColor Green
        $ok++
    } catch {
        Write-Host ("   Failed: {0}" -f $_) -ForegroundColor Red
        $fail++
    }
}

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ("Summary: OK={0}  Failed={1}  Skipped={2}" -f $ok,$fail,$skip) -ForegroundColor Yellow
Write-Host "Remote URL (after auth): https://virtual-life.co.za/private/invoice/" -ForegroundColor Cyan
Write-Host "Note: ensure IIS Basic Auth is enabled on that folder and the authorized user has NTFS Read permissions." -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Cyan
