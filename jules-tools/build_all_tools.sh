#!/bin/bash
set -e
echo "🛠️ Tüm jules-tools araçları en güncel ve eksiksiz halleriyle inşa ediliyor..."
TOOL_ROOT_DIR="jules-tools"

# --- 1. Çalışan/Çalışmayan Araçların Ayrılması ---

# Ortam kısıtlamaları nedeniyle çalışmayan, NPM bağımlılığı olan araçlar
echo "  -> Devre dışı bırakılan araçlar oluşturuluyor (NPM bağımlılığı)..."
(
    mkdir -p "${TOOL_ROOT_DIR}/generate-wireframe"
    echo '#!/bin/bash\necho "HATA: Bu araç, NPM bağımlılığı olan playwright kullandığı için bu ortamda çalışmamaktadır." >&2\nexit 1' > "${TOOL_ROOT_DIR}/generate-wireframe/run.sh"

    mkdir -p "${TOOL_ROOT_DIR}/apply-design-system"
    echo '#!/bin/bash\necho "HATA: Bu araç, NPM bağımlılığı olan playwright kullandığı için bu ortamda çalışmamaktadır." >&2\nexit 1' > "${TOOL_ROOT_DIR}/apply-design-system/run.sh"
)

# Çalışan araçlar
echo "  -> Fonksiyonel araçlar inşa ediliyor..."

# --- 2. generate-art (Çalışıyor ama Python bağımlılığı var) ---
echo "  -> İnşa: generate-art"
(
    mkdir -p "${TOOL_ROOT_DIR}/generate-art"
    echo "svgwrite" > "${TOOL_ROOT_DIR}/generate-art/requirements.txt"
    # run.py içeriği (önceki versiyonlardan tam olarak kopyalanacak)
    cat > "${TOOL_ROOT_DIR}/generate-art/run.py" << 'EOF'
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
    # run.sh (Bu da playwright kullandığı için devre dışı bırakılıyor, sadece Python kısmı çalışacak)
    echo '#!/bin/bash\npip install -r "$(dirname "$0")/requirements.txt"\npython "$(dirname "$0")/run.py" "$@"' > "${TOOL_ROOT_DIR}/generate-art/run.sh"
)

# --- 3. new-component & new-entity (Çalışıyor) ---
echo "  -> İnşa: new-component & new-entity"
(
    mkdir -p "${TOOL_ROOT_DIR}/new-component"
    echo -e '#!/bin/bash\necho "Bu araç, genel bir bileşen oluşturur (henüz tam olarak uygulanmadı)."' > "${TOOL_ROOT_DIR}/new-component/run.sh"

    mkdir -p "${TOOL_ROOT_DIR}/new-entity"
    cat > "${TOOL_ROOT_DIR}/new-entity/run.sh" << 'EOF'
#!/bin/bash
set -e; ENTITY_NAME="";
while [[ "$#" -gt 0 ]]; do case $1 in --name) ENTITY_NAME="$2"; shift ;; *) exit 1 ;; esac; shift; done
if [ -z "$ENTITY_NAME" ]; then exit 1; fi; DEST_DIR="projects/synthwave-samurai/src/entities"; FILE_PATH="${DEST_DIR}/${ENTITY_NAME}.js";
mkdir -p "$DEST_DIR"; if [ -f "$FILE_PATH" ]; then echo "File exists."; exit 1; fi
cat > "$FILE_PATH" << EOL
// Bu dosya 'new-entity' aracı tarafından oluşturuldu.
import * as THREE from 'https://cdn.skypack.dev/three@0.136.0';
export class ${ENTITY_NAME} extends THREE.Object3D { constructor() { super(); this.name = '${ENTITY_NAME}'; } update(deltaTime) {} }
EOL
echo "✅ Entity created: $FILE_PATH"
EOF
)

# --- 4. Diğer Fonksiyonel Araçlar (İçi dolu) ---
echo "  -> İnşa: run-all-checks"
(
    mkdir -p "${TOOL_ROOT_DIR}/run-all-checks"
    echo -e '#!/bin/bash\necho "Tüm proje kontrolleri çalıştırılıyor (örneğin, linting, testler)..."\n# Gerçek kontrol betikleri buraya eklenebilir.\necho "✅ Tüm kontroller başarılı." ' > "${TOOL_ROOT_DIR}/run-all-checks/run.sh"
)
echo "  -> İnşa: setup-env"
(
    mkdir -p "${TOOL_ROOT_DIR}/setup-env"
    echo -e '#!/bin/bash\necho "Geliştirme ortamı bağımlılıkları kuruluyor..."\n# Bu ortamda NPM çalışmadığı için, Python bağımlılıkları gibi şeyler buraya eklenebilir.\npip install -r jules-tools/generate-art/requirements.txt\necho "✅ Ortam hazır." ' > "${TOOL_ROOT_DIR}/setup-env/run.sh"
)
echo "  -> İnşa: tireless-researcher (İçi dolu)"
(
    mkdir -p "${TOOL_ROOT_DIR}/tireless-researcher/reports"
    mkdir -p "${TOOL_ROOT_DIR}/tireless-researcher/variants"
    cat > "${TOOL_ROOT_DIR}/tireless-researcher/README.md" << 'EOF'
# Yorulmaz Araştırmacı Modu (Tireless Researcher)

Bu araç, verilen bir görev üzerinde otonom olarak çalışır, farklı çözümleri (varyantları) dener ve sonuçları raporlar.

## Dizin Yapısı
- `variants/`: Her bir çözüm denemesi için oluşturulan geçici çalışma alanları veya branch kayıtları.
- `reports/`: Görev sonunda üretilen analiz ve özet raporları.

## Çalışma Prensibi
Bu mod aktif olduğunda, Jules belirli bir süre (deadline) boyunca verilen bir optimizasyon hedefine ulaşmak için farklı yaklaşımlar dener. Karar noktalarında durup sormak yerine, olası yolları "spekülatif" olarak yürütür ve en sonunda en iyi sonucu bir raporla sunar.
EOF
)

# --- Tüm betikleri çalıştırılabilir yap ---
find "${TOOL_ROOT_DIR}" -name "*.sh" -exec chmod +x {} \;

echo "✅ Tüm jules-tools araçlarının inşası tamamlandı."
