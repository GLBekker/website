# Virtual Life Website Deployment Guide

## FTP Deployment Configuration

This website is configured to deploy to the Virtual Life FTP server at:
- **Host**: 41.185.13.154
- **Username**: virtuall
- **Remote Path**: /virtual-life.co.za/
- **Website URL**: http://virtual-life.co.za

## Deployment Methods

### Method 1: Using the Batch Script (Recommended for Windows)
1. Double-click `deploy.bat` in the project root
2. Enter your FTP password when prompted
3. The script will automatically upload all website files

### Method 2: Using PowerShell Script
```powershell
.\deploy.ps1 -Password "your_ftp_password"
```

### Method 3: Using VS Code FTP-Sync Extension
1. Install the "ftp-sync" extension in VS Code
2. The configuration is already set up in `.vscode/ftp-sync.json`
3. Add your password to the configuration file
4. Use the command palette (Ctrl+Shift+P) and run "FTP-Sync: Upload"

### Method 4: Using VS Code Launch Configuration
1. Open VS Code
2. Press F5 or go to Run > Start Debugging
3. Select "Deploy to Virtual Life FTP" from the dropdown
4. Enter your FTP password when prompted

## Files Included in Deployment

The deployment includes:
- All HTML files (index.html, game.html, sheep_rumble.html, terms.html, design_system.html)
- CSS file (style.css)
- Images (sentient.png, sentient2.png, vlLogo.png)
- Templates directory
- Images directory

## Security Notes

- **Never commit your FTP password to version control**
- The password field in `.vscode/ftp-sync.json` should remain empty
- Always enter your password manually when deploying

## Troubleshooting

### Common Issues:

1. **Connection Timeout**
   - Check your internet connection
   - Verify the FTP server is accessible
   - Try using passive mode (already enabled in scripts)

2. **Authentication Failed**
   - Double-check your password
   - Ensure the username is correct (virtuall)

3. **Upload Failed**
   - Check file permissions on the server
   - Verify the remote path exists
   - Ensure files aren't locked locally

4. **PowerShell Execution Policy Error**
   - Run PowerShell as Administrator
   - Execute: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`

## Manual FTP Deployment

If automated deployment fails, you can use any FTP client:
1. FileZilla, WinSCP, or similar FTP client
2. Connect using the credentials above
3. Upload all files to the /virtual-life.co.za/ directory

## Support

For deployment issues, contact Virtual Life support:
- Email: office@virtual-life.co.za
- Phone: (074) 348-8311