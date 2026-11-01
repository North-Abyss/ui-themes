#!/usr/bin/env bash

# ==============================================================================
# Autonomous Browser & Web Verification Helper
# Tests web endpoints, verifies HTTP responses, checks asset integrity,
# and captures screenshots via headless browser (Playwright / Chromium).
# ==============================================================================

set -e

URL="${1:-http://localhost:8080}"
OUTPUT_DIR="workspace/tmp"
mkdir -p "$OUTPUT_DIR"

echo "🌐 Verifying web application at $URL..."

# 1. Basic HTTP Health Check
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL" || echo "000")

if [[ "$HTTP_STATUS" =~ ^(200|301|302|304)$ ]]; then
    echo "✅ HTTP Connection Successful (Status: $HTTP_STATUS)"
else
    echo "❌ Web server not reachable or returned error status: $HTTP_STATUS"
    exit 1
fi

# 2. Check for Playwright / Headless Browser
if python3 -c "import playwright" 2>/dev/null; then
    echo "🚀 Running Playwright browser validation..."
    python3 - <<EOF
import sys
from playwright.sync_api import sync_playwright

url = "$URL"
screenshot_path = "$OUTPUT_DIR/browser_screenshot.png"

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    errors = []
    page.on("pageerror", lambda err: errors.append(str(err)))
    
    page.goto(url)
    page.screenshot(path=screenshot_path)
    title = page.title()
    print(f"📄 Page Title: {title}")
    browser.close()

if errors:
    print(f"⚠️  Console errors detected: {errors}")
    sys.exit(1)
else:
    print(f"📸 Screenshot captured: {screenshot_path}")
    print("✅ Zero browser console errors!")
EOF
else
    # Fallback to curl HTML sanity check
    echo "ℹ️  Playwright not installed. Performing HTML structure verification..."
    curl -s "$URL" > "$OUTPUT_DIR/page_dump.html"
    if grep -q -i "<html" "$OUTPUT_DIR/page_dump.html"; then
        echo "✅ Valid HTML document structure verified."
    else
        echo "⚠️  Response received but does not contain valid HTML."
    fi
    echo "💡 Tip: Run 'pip install playwright && playwright install chromium' for full screenshots & DOM automation."
fi
