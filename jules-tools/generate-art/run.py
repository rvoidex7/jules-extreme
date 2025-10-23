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
