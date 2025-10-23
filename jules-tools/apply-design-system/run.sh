#!/bin/bash
set -e; HTML_FILE=""; CSS_FILE=""; OUTPUT_FILE="";
while [[ "$#" -gt 0 ]]; do case $1 in --html-file) HTML_FILE="$2"; shift ;; --css-file) CSS_FILE="$2"; shift ;; --output) OUTPUT_FILE="$2"; shift ;; *) exit 1 ;; esac; shift; done
if [ -z "$HTML_FILE" ] || [ -z "$CSS_FILE" ] || [ -z "$OUTPUT_FILE" ]; then exit 1; fi
SCRIPT_PATH=$(mktemp); ABS_HTML_FILE=$(realpath "$HTML_FILE"); ABS_CSS_FILE=$(realpath "$CSS_FILE");
cat > "$SCRIPT_PATH" << EOL
const { chromium } = require('playwright');
(async () => {
    const b = await chromium.launch(); const p = await b.newPage();
    await p.goto('file://${ABS_HTML_FILE}');
    await p.addStyleTag({ path: '${ABS_CSS_FILE}' });
    await p.waitForTimeout(1000);
    await p.screenshot({ path: '${OUTPUT_FILE}', fullPage: true });
    await b.close();
})();
EOL
export NODE_PATH=./node_modules; node "$SCRIPT_PATH"; rm "$SCRIPT_PATH";
echo "✅ Mockup: $OUTPUT_FILE"
