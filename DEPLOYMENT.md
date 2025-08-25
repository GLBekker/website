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
- Public HTML files (index.html, game.html, sheep_rumble.html, terms.html, design_system.html)
- CSS file (style.css)
- Images (sentient.png, sentient2.png, vlLogo.png)
- Templates directory
- Images directory

Excluded by default (internal tools):
- `invoice-generator.html`
- `invoice-generator-clean.html`
- `invoice-template.html`
- `INVOICE-GENERATOR-SETUP.md`

These files are intentionally excluded from deployment for security/privacy. VS Code ftp-sync is configured to ignore them in `.vscode/ftp-sync.json`, and the PowerShell deployment scripts only upload a fixed allowlist that does not include them.

If you ever need to publish the invoice tool, consider putting it behind HTTP authentication (see below) rather than making it publicly accessible.

## Security Notes

- **Never commit your FTP password to version control**
- The password field in `.vscode/ftp-sync.json` should remain empty
- Always enter your password manually when deploying

### Protecting Internal Pages (Optional)

If you need to host internal tools (e.g., invoice generator) with access control:

- Easiest (server-side) on Apache: move the tool into a subfolder (e.g., `/private/`) and place an `.htaccess` file requiring Basic Auth, with a corresponding `.htpasswd` file on the server. This requires HTTPS to be secure.
  Example `.htaccess`:
  
  ```
  AuthType Basic
  AuthName "Restricted"
  AuthUserFile /path/to/.htpasswd
  Require valid-user
  ```
  
  Generate credentials locally: `htpasswd -c .htpasswd youruser` (upload to a non-web-accessible path if possible).

- Alternatively: use a reverse-proxy access control (e.g., Cloudflare Access/Zero Trust) to gate the URL by email identity — no code changes needed.

- Avoid client-side-only logins for sensitive tools. A static HTML/JS login can be bypassed by viewing source.

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

## Secured Invoice Tool Deployment (IIS)

To deploy only the secured invoice generator into `/private/invoice` without touching the public site:

1. Ensure IIS Basic Authentication + authorization is configured on the `private/invoice` folder and that the authorized Windows user has NTFS Read permissions.
2. Run the dedicated script:

```powershell
./deploy-invoice.ps1 -Password "your_ftp_password"
```

This uploads only:
- `invoice-generator.html` as `index.html` (and also as `invoice-generator.html`)
- `images/vlLogo.png` to `/private/invoice/images/`

You can also use `deploy-invoice.bat` for a guided prompt on Windows.
