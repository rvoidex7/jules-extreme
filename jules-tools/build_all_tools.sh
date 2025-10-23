#!/bin/bash
set -e
echo "🛠️ Tüm jules-tools araçları en güncel halleriyle inşa ediliyor..."

# --- 1. generate-art ---
echo "  -> İnşa: generate-art"
(
mkdir -p jules-tools/generate-art
cat > jules-tools/generate-art/requirements.txt << 'EOF'
svgwrite
EOF
cat > jules-tools/generate-art/run.py << 'EOF'
import svgwrite, argparse, re, os
ART_PRIMITIVES = {"vücut": {"draw_func": "draw_body"}, "zırh": {"draw_func": "draw_armor"}, "vizör": {"draw_func": "draw_visor"}, "kafa": {"draw_func": "draw_head"}, "göz": {"draw_func": "draw_eye"}, "çene": {"draw_func": "draw_chin"}}
VALID_COLORS = {"kırmızı": "red", "mavi": "blue", "yeşil": "green", "sarı": "yellow", "parlak sarı": "#FFD700", "siyah": "black", "beyaz": "white", "mor": "purple", "turuncu": "orange", "metalik gri": "#8E8E8E", "parlak mor": "#9933FF", "parlayan mavi": "#00FFFF"}
DEFAULT_COLORS = {"göz": "yellow", "çene": "grey", "kafa": "darkgrey", "vücut": "black", "zırh": "grey", "vizör": "cyan"}
def draw_body(dwg, color, pos, mods): dwg.add(dwg.polygon([(p[0] + pos[0], p[1] + pos[1]) for p in [(-50, -100), (50, -100), (80, 150), (-80, 150)]], fill=color))
def draw_head(dwg, color, pos, mods): dwg.add(dwg.circle(center=pos, r=120, fill=color))
def draw_armor(dwg, color, pos, mods):
    if "omuz" in mods["loc"]: dwg.add(dwg.rect(insert=(pos[0] - 80, pos[1] - 90), size=(30, 60), fill=color)); dwg.add(dwg.rect(insert=(pos[0] + 50, pos[1] - 90), size=(30, 60), fill=color))
    if "göğüs" in mods["loc"]: dwg.add(dwg.rect(insert=(pos[0] - 25, pos[1] - 50), size=(50, 80), fill=color))
def draw_visor(dwg, color, pos, mods):
    if "yatay çizgi" in mods["shape"]: dwg.add(dwg.rect(insert=(pos[0] - 40, pos[1] - 10), size=(80, 15), fill=color, rx=5, ry=5)); dwg.add(dwg.rect(insert=(pos[0] - 45, pos[1] - 15), size=(90, 25), fill=color, rx=8, ry=8, opacity=0.5))
def draw_eye(dwg, color, pos, mods):
    size = 100 if "büyük" in mods["adj"] else 50
    if "yuvarlak" in mods["shape"]: dwg.add(dwg.circle(center=pos, r=size/2, fill=color)); dwg.add(dwg.circle(center=pos, r=size/2 + 5, fill=color, opacity=0.3))
def draw_chin(dwg, color, pos, mods):
    if "altında" in mods["loc"]:
        points = [(x + pos[0], y + pos[1] + 60) for x,y in [(-60, 50), (60, 50), (40, 90), (-40, 90)]]
        dwg.add(dwg.polygon(points, fill=color))
def parse_advanced_prompt(prompt):
    instructions = []; prompt = prompt.lower(); sentences = re.split(r'[.]\s*', prompt)
    for sentence in sentences:
        for keyword in ART_PRIMITIVES.keys():
            if keyword in sentence:
                mods = {"loc": "", "shape": "", "adj": ""}; color = None
                for name, code in VALID_COLORS.items():
                    if name in sentence: color = code
                all_words = sentence.split(); keyword_index = all_words.index( keyword ) if keyword in all_words else -1
                mods["adj"] = " ".join(all_words[:keyword_index])
                match = re.search(r'(\w+\s*\w*)\s*şeklinde', sentence); mods["shape"] = match.group(1) if match else " ".join(all_words[keyword_index+1:])
                match = re.search(r'(\w+)\s*(?:üzerinde|da|de|altında)', sentence); mods["loc"] = match.group(1) if match else ""
                instructions.append({"primitive": keyword, "color": color or DEFAULT_COLORS.get(keyword), "mods": mods}); break
    instructions.sort(key=lambda x: list(ART_PRIMITIVES.keys()).index(x["primitive"])); return instructions
def render_elements(dwg, instructions):
    center_x, center_y = 400, 400; positions = {"kafa": (center_x, center_y), "vücut": (center_x, center_y + 150), "zırh": (center_x, center_y + 100), "vizör": (center_x, center_y), "göz": (center_x, center_y - 20), "çene": (center_x, center_y)}
    for inst in instructions:
        primitive_key = inst["primitive"]; draw_func_name = ART_PRIMITIVES[primitive_key]["draw_func"]; draw_func = globals().get(draw_func_name)
        if draw_func:
            args = {"dwg": dwg, "color": inst["color"], "pos": positions.get(primitive_key, (center_x, center_y))}
            if "mods" in inst and "mods" in draw_func.__code__.co_varnames: args["mods"] = inst["mods"]
            draw_func(**args)
def main():
    parser = argparse.ArgumentParser(); parser.add_argument("--prompt", type=str, required=True); parser.add_argument("--output", type=str, required=True)
    args = parser.parse_args(); print(f"🎨 Art: '{args.prompt}' (v2.2)")
    instructions = parse_advanced_prompt(args.prompt)
    if not instructions: print("⚠️ Prompt error."); return
    output_svg_path = f"{args.output}.svg"; dwg = svgwrite.Drawing(output_svg_path, size=('800px', '800px')); dwg.add(dwg.rect(size=('100%', '100%'), fill='none'))
    render_elements(dwg, instructions)
    output_dir = os.path.dirname(output_svg_path)
    if output_dir: os.makedirs(output_dir, exist_ok=True)
    dwg.save(); print(f"✅ SVG: {output_svg_path}")
if __name__ == "__main__": main()
EOF
cat > jules-tools/generate-art/run.sh << 'EOF'
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
EOF
)

# --- 2. generate-wireframe ---
echo "  -> İnşa: generate-wireframe"
(
mkdir -p jules-tools/generate-wireframe
cat > jules-tools/generate-wireframe/wireframe.css << 'EOF'
* { color: #000 !important; background-color: #FFF !important; box-shadow: none !important; border-radius: 0 !important; font-family: 'Courier New', monospace !important; border: 1px solid #CCC !important; margin: 4px !important; padding: 8px !important; }
img, svg { background-color: #DDD !important; border: 1px dashed #999 !important; width: 100px; height: 100px; }
EOF
cat > jules-tools/generate-wireframe/run.sh << 'EOF'
#!/bin/bash
set -e; TOOL_DIR=$(dirname "$0"); HTML_FILE=""; OUTPUT_FILE="";
while [[ "$#" -gt 0 ]]; do case $1 in --html-file) HTML_FILE="$2"; shift ;; --output) OUTPUT_FILE="$2"; shift ;; *) exit 1 ;; esac; shift; done
if [ -z "$HTML_FILE" ] || [ -z "$OUTPUT_FILE" ]; then exit 1; fi
SCRIPT_PATH=$(mktemp); ABS_HTML_FILE=$(realpath "$HTML_FILE");
cat > "$SCRIPT_PATH" << EOL
const { chromium } = require('playwright');
(async () => {
    const b = await chromium.launch(); const p = await b.newPage();
    await p.goto('file://${ABS_HTML_FILE}');
    await p.addStyleTag({ path: '${TOOL_DIR}/wireframe.css' });
    await p.screenshot({ path: '${OUTPUT_FILE}', fullPage: true });
    await b.close();
})();
EOL
export NODE_PATH=./node_modules; node "$SCRIPT_PATH"; rm "$SCRIPT_PATH";
echo "✅ Wireframe: $OUTPUT_FILE"
EOF
)

# --- 3. apply-design-system ---
echo "  -> İnşa: apply-design-system"
(
mkdir -p jules-tools/apply-design-system
cat > jules-tools/apply-design-system/run.sh << 'EOF'
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
EOF
)

# --- 4. new-entity ---
echo "  -> İnşa: new-entity"
(
mkdir -p jules-tools/new-entity
cat > jules-tools/new-entity/run.sh << 'EOF'
#!/bin/bash
set -e; ENTITY_NAME="";
while [[ "$#" -gt 0 ]]; do case $1 in --name) ENTITY_NAME="$2"; shift ;; *) exit 1 ;; esac; shift; done
if [ -z "$ENTITY_NAME" ]; then exit 1; fi; DEST_DIR="src/entities"; FILE_PATH="${DEST_DIR}/${ENTITY_NAME}.js";
mkdir -p "$DEST_DIR"; if [ -f "$FILE_PATH" ]; then echo "File exists."; exit 1; fi
cat > "$FILE_PATH" << EOL
import * as THREE from 'three';
export class ${ENTITY_NAME} extends THREE.Object3D { constructor() { super(); this.name = '${ENTITY_NAME}'; } update(deltaTime) {} }
EOL
echo "✅ Entity created: $FILE_PATH"
EOF
)

# --- Make all runnable ---
chmod +x jules-tools/*/run.sh

echo "✅ Tüm araçların inşası tamamlandı."
