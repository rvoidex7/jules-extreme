#!/bin/bash

# --- Generate Art Tool (Wrapper Script) ---
# This script orchestrates the art generation process:
# 1. It calls the core Python script (run.py) to generate an SVG file.
# 2. It then uses Playwright to convert the generated SVG into a PNG file.

set -e # Exit immediately if any command fails.

# --- Get the directory of the script ---
TOOL_DIR=$(dirname "$0")

# --- Parse Command-Line Arguments ---
# We'll just pass all arguments directly to the Python script.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 --prompt <prompt> --output <base_output_name>"
    echo ""
    echo "This script generates both an .svg and a .png file."
    exit 0
fi

# --- Step 1: Run the Python script to generate SVG ---
echo "🧠 Yapay zeka sanatçısı düşünmeye başlıyor... (SVG oluşturuluyor)"
python "${TOOL_DIR}/run.py" "$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo "❌ Python betiği çalışırken bir hata oluştu."
    exit $RETVAL
fi

# Extract the output filename from the arguments
OUTPUT_NAME=""
# Create a copy of arguments to iterate over, as the original $@ is needed for python
args_copy=("$@")
for i in "${!args_copy[@]}"; do
  if [[ "${args_copy[$i]}" == "--output" ]]; then
    # The output name is the next element in the array
    OUTPUT_NAME="${args_copy[$i+1]}"
    break
  fi
done

if [ -z "$OUTPUT_NAME" ]; then
    echo "❌ --output argümanı komut içinde bulunamadı."
    exit 1
fi

SVG_FILE="${OUTPUT_NAME}.svg"
PNG_FILE="${OUTPUT_NAME}.png"

if [ ! -f "$SVG_FILE" ]; then
    echo "❌ SVG dosyası bulunamadı. Python betiği beklendiği gibi çalışmadı."
    exit 1
fi

# --- Step 2: Convert SVG to PNG using Playwright ---
echo "🖼️ SVG, PNG formatına dönüştürülüyor..."

SCRIPT_PATH=$(mktemp /tmp/jules_png_converter_XXXXXX.js)
ABS_SVG_FILE=$(realpath "$SVG_FILE")

cat > "$SCRIPT_PATH" << EOF
const { chromium } = require('playwright');

(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();
    await page.goto('file://${ABS_SVG_FILE}');

    // Find the SVG element to get its dimensions
    const svgElement = await page.\$('svg');
    const boundingBox = await svgElement.boundingBox();

    await page.setViewportSize({
        width: Math.ceil(boundingBox.width),
        height: Math.ceil(boundingBox.height)
    });

    await page.screenshot({ path: '${PNG_FILE}' });
    await browser.close();
})();
EOF

# Ensure playwright is installed
if ! npm list playwright > /dev/null 2>&1; then
    echo "⚠️ Playwright is not installed. Please run 'npm install playwright'."
fi

# Run the temporary Playwright script, ensuring it can find local node_modules
export NODE_PATH=./node_modules
node "$SCRIPT_PATH"

# Clean up
rm "$SCRIPT_PATH"

echo "✅ Tamamlandı! Çıktı dosyaları: ${SVG_FILE} ve ${PNG_FILE}"
