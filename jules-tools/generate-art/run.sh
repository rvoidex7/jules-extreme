#!/bin/bash
set -e; TOOL_DIR=$(dirname "$0");
python "${TOOL_DIR}/run.py" "$@"
OUTPUT_NAME=""; args_copy=("$@");
for i in "${!args_copy[@]}"; do if [[ "${args_copy[$i]}" == "--output" ]]; then OUTPUT_NAME="${args_copy[$i+1]}"; break; fi; done
if [ -z "$OUTPUT_NAME" ]; then exit 1; fi; SVG_FILE="${OUTPUT_NAME}.svg"; PNG_FILE="${OUTPUT_NAME}.png";
if [ ! -f "$SVG_FILE" ]; then exit 1; fi; echo "🖼️ SVG->PNG...";
SCRIPT_PATH=$(mktemp); ABS_SVG_FILE=$(realpath "$SVG_FILE");
cat > "$SCRIPT_PATH" << EOL
const { chromium } = require('playwright');
(async () => {
    const b = await chromium.launch(); const p = await b.newPage();
    await p.setViewportSize({ width: 800, height: 800 });
    await p.goto('file://${ABS_SVG_FILE}', { waitUntil: 'networkidle' });
    const el = await p.\$('svg'); await el.screenshot({ path: '${PNG_FILE}' });
    await b.close();
})();
EOL
export NODE_PATH=./node_modules; node "$SCRIPT_PATH"; rm "$SCRIPT_PATH";
echo "✅ Done: ${SVG_FILE}, ${PNG_FILE}"
