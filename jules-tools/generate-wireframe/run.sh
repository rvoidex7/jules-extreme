#!/bin/bash

# --- Generate Lo-Fi Wireframe Tool ---
# This script takes an HTML file, applies a "wireframe" CSS to it,
# and generates a screenshot using Playwright.

# --- Helper function for usage message ---
usage() {
    echo "Usage: $0 --html-file <path_to_html> --output <output_path.png>"
    echo ""
    echo "Arguments:"
    echo "  --html-file   Required. The path to the temporary HTML file to be wireframed."
    echo "  --output      Required. The path for the final wireframe PNG image."
    exit 1
}

# --- Parse Command-Line Arguments ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --html-file) HTML_FILE="$2"; shift ;;
        --output) OUTPUT_FILE="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# --- Validate Required Arguments ---
if [ -z "$HTML_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Error: Missing required arguments."
    usage
fi

if [ ! -f "$HTML_FILE" ]; then
    echo "Error: HTML file not found at '$HTML_FILE'"
    exit 1
fi

# --- Main Logic ---
echo "🎨 Wireframe oluşturuluyor: $OUTPUT_FILE"

# Create a temporary Playwright script to perform the screenshot
SCRIPT_PATH=$(mktemp /tmp/jules_wireframe_script_XXXXXX.js)
TOOL_DIR=$(dirname "$0") # Gets the directory where the script is located

cat > "$SCRIPT_PATH" << EOF
const { chromium } = require('playwright');
const fs = require('fs');

(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();

    // Go to the local HTML file
    await page.goto('file://${HTML_FILE}');

    // Inject the wireframe CSS. This overrides all other styles.
    await page.addStyleTag({ path: '${TOOL_DIR}/wireframe.css' });

    // Set a standard viewport for consistency
    await page.setViewportSize({ width: 1280, height: 720 });

    // Take the screenshot
    await page.screenshot({ path: '${OUTPUT_FILE}', fullPage: true });

    await browser.close();
})();
EOF

# Ensure playwright is installed
if ! npm list playwright > /dev/null 2>&1; then
    echo "⚠️ Playwright is not installed. Please run 'npm install playwright'."
    # Optionally, you could install it automatically: npm install playwright
fi

# Run the temporary Playwright script
node "$SCRIPT_PATH"

# Clean up the temporary script
rm "$SCRIPT_PATH"

echo "✅ Wireframe başarıyla oluşturuldu: $OUTPUT_FILE"
