# Invoice Generator Setup

## CORS Issue Fix

The invoice generator needs to load the `invoice-template.html` file, but browsers block this when running directly from the file system due to CORS (Cross-Origin Resource Sharing) restrictions.

## Solutions:

### Option 1: Run Local Web Server (Recommended)

1. **Using Python** (if you have Python installed):
   - Double-click `run-local-server.bat` (Windows)
   - Or run `python -m http.server 8000` in the terminal
   - Open browser to: `http://localhost:8000/invoice-generator.html`

2. **Using Node.js** (if you have Node.js installed):
   ```bash
   npx http-server -p 8000
   ```

3. **Using PHP** (if you have PHP installed):
   ```bash
   php -S localhost:8000
   ```

### Option 2: Disable CORS in Browser (Temporary)

**Chrome:**
```bash
chrome.exe --user-data-dir="C:/Chrome dev session" --disable-web-security
```

**Firefox:**
- Type `about:config` in address bar
- Set `security.fileuri.strict_origin_policy` to `false`

### Option 3: Use Live Server Extension

If using VS Code:
1. Install "Live Server" extension
2. Right-click on `invoice-generator.html`
3. Select "Open with Live Server"

## Security Note

This invoice generator contains sensitive business functionality and should NOT be hosted online without proper authentication and security measures.

## Usage

1. Start local server using one of the methods above
2. Open the invoice generator in your browser
3. Add/select clients
4. Fill in invoice details
5. Add services
6. Generate invoice

The generated invoice will open in a new window and can be printed or saved as PDF.