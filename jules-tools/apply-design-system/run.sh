#!/bin/bash

# --- Apply Design System Tool ---
# This script takes an HTML file, links a project's main CSS file to it,
# and generates a high-fidelity screenshot using Playwright.

# --- Helper function for usage message ---
usage() {
    echo "Usage: $0 --html-file <path_to_html> --css-file <path_to_css> --output <output_path.png>"
    echo ""
    echo "Arguments:"
    echo "  --html-file   Required. The path to the structurally approved HTML file."
    echo "  --css-file    Required. The path to the project's main stylesheet (design system)."
    echo "  --output      Required. The path for the final mockup PNG image."
    exit 1
}

# --- Parse Command-Line Arguments ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --html-file) HTML_FILE="$2"; shift ;;
        --css-file) CSS_FILE="$2"; shift ;;
        --output) OUTPUT_FILE="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# --- Validate Required Arguments ---
if [ -z "$HTML_FILE" ] || [ -z "$CSS_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Error: Missing required arguments."
    usage
fi

if [ ! -f "$HTML_FILE" ] || [ ! -f "$CSS_FILE" ]; then
    echo "Error: HTML or CSS file not found."
    exit 1
fi

# --- Main Logic ---
echo "💅 Tasarım sistemi uygulanıyor ve mockup oluşturuluyor: $OUTPUT_FILE"

# Create a temporary Playwright script
SCRIPT_PATH=$(mktemp /tmp/jules_mockup_script_XXXXXX.js)

# Get absolute paths for file URLs to work correctly
ABS_HTML_FILE=$(realpath "$HTML_FILE")
ABS_CSS_FILE=$(realpath "$CSS_FILE")

cat > "$SCRIPT_PATH" << EOF
const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();

    // Go to the local HTML file
    await page.goto('file://${ABS_HTML_FILE}');

    // Link the project's design system CSS file.
    await page.addStyleTag({ path: '${ABS_CSS_FILE}' });

    // Give some time for fonts or other async styles to load
    await page.waitForTimeout(500);

    // Set a standard viewport
    await page.setViewportSize({ width: 1280, height: 720 });

    // Take the screenshot
    await page.screenshot({ path: '${OUTPUT_FILE}', fullPage: true });

    await browser.close();
})();
EOF

# Ensure playwright is installed
if ! npm list playwright > /dev/null 2>&1; then
    echo "⚠️ Playwright is not installed. Please run 'npm install playwright'."
fi

# Run the temporary Playwright script
node "$SCRIPT_PATH"

# Clean up the temporary script
rm "$SCRIPT_PATH"

echo "✅ Mockup başarıyla oluşturuldu: $OUTPUT_FILE"
