import svgwrite
import argparse
import re

# --- Sanatçı Ayarları ve Palet ---
# Renkler, daha yumuşak ve anime tarzına uygun olacak şekilde güncellendi.
PALETTE = {
    "cilt": "#f2d3b3",
    "saç": "#8c5b98",  # Varsayılan mor saç
    "göz": "#4a7a9d",    # Varsayılan mavi göz
    "kıyafet": "#e0a5c3",
    "kontur": "black",
}

# --- Gelişmiş Prompt Analizi ---

def parse_anime_prompt(prompt):
    """
    "mor saçlı mavi gözlü bir anime kızı" gibi bir prompt'u analiz eder
    ve çizim için bir özellikler sözlüğü döndürür.
    """
    prompt = prompt.lower()
    attributes = {
        "saç_rengi": PALETTE["saç"],
        "göz_rengi": PALETTE["göz"]
    }

    # Renk ve özellik eşleştirmesi
    renk_map = {
        "kırmızı": "red", "mavi": "#4a7a9d", "yeşil": "#6a9a69", "sarı": "yellow",
        "siyah": "black", "beyaz": "white", "mor": "#8c5b98", "pembe": "#e0a5c3",
        "kahverengi": "#8b4513"
    }

    # "mavi gözlü", "mor saçlı" gibi kalıpları bul
    göz_match = re.search(r'(\w+)\s+göz', prompt)
    if göz_match and göz_match.group(1) in renk_map:
        attributes["göz_rengi"] = renk_map[göz_match.group(1)]

    saç_match = re.search(r'(\w+)\s+saç', prompt)
    if saç_match and saç_match.group(1) in renk_map:
        attributes["saç_rengi"] = renk_map[saç_match.group(1)]

    return attributes

# --- Programatik Çizim Fonksiyonları ---

def ciz_kafa(dwg, x, y):
    """Kafa şeklini ve boynunu çizer."""
    # Kafa
    dwg.add(dwg.circle(center=(x, y), r=150, fill=PALETTE["cilt"], stroke=PALETTE["kontur"], stroke_width=4))
    # Boyun
    dwg.add(dwg.rect(insert=(x - 40, y + 140), size=(80, 100), fill=PALETTE["cilt"], stroke=PALETTE["kontur"], stroke_width=4))

def ciz_gözler(dwg, x, y, renk):
    """Bir çift anime gözü çizer."""
    # Sol Göz
    sol_göz_x = x - 60
    dwg.add(dwg.ellipse(center=(sol_göz_x, y), r=(35, 50), fill='white', stroke=PALETTE["kontur"], stroke_width=3))
    dwg.add(dwg.circle(center=(sol_göz_x, y + 5), r=25, fill=renk))
    dwg.add(dwg.circle(center=(sol_göz_x - 8, y - 5), r=8, fill='white')) # Işık yansıması

    # Sağ Göz
    sağ_göz_x = x + 60
    dwg.add(dwg.ellipse(center=(sağ_göz_x, y), r=(35, 50), fill='white', stroke=PALETTE["kontur"], stroke_width=3))
    dwg.add(dwg.circle(center=(sağ_göz_x, y + 5), r=25, fill=renk))
    dwg.add(dwg.circle(center=(sağ_göz_x + 8, y - 5), r=8, fill='white')) # Işık yansıması

def ciz_ağız(dwg, x, y):
    """Basit bir gülümseyen ağız çizer."""
    path = svgwrite.path.Path(d=f"M {x-40},{y+80} Q {x},{y+100} {x+40},{y+80}", stroke=PALETTE["kontur"], fill='none', stroke_width=3)
    dwg.add(path)

def ciz_saç(dwg, x, y, renk):
    """Anime tarzı saç çizer."""
    # Katman 1: Arka Saç
    dwg.add(dwg.circle(center=(x, y), r=160, fill=renk, stroke=PALETTE["kontur"], stroke_width=4))
    # Katman 2: Kahküller
    dwg.add(dwg.path(d=f"M {x-160},{y-20} C {x-80},{y-150} {x+80},{y-150} {x+160},{y-20} Z", fill=renk, stroke=PALETTE["kontur"], stroke_width=4))
    # Katman 3: Yan Saçlar
    dwg.add(dwg.polygon(points=[(x-120, y-100), (x-220, y+150), (x-100, y+100)], fill=renk, stroke=PALETTE["kontur"], stroke_width=4))
    dwg.add(dwg.polygon(points=[(x+120, y-100), (x+220, y+150), (x+100, y+100)], fill=renk, stroke=PALETTE["kontur"], stroke_width=4))

def ciz_kıyafet(dwg, x, y):
    """Basit bir kıyafet üstü çizer."""
    dwg.add(dwg.rect(insert=(x - 120, y + 240), size=(240, 150), fill=PALETTE["kıyafet"], stroke=PALETTE["kontur"], stroke_width=4))

def parse_arguments():
    """Komut satırı argümanlarını ayrıştırır."""
    parser = argparse.ArgumentParser(description="Jules'un Üretken Tuvali")
    parser.add_argument("--prompt", type=str, required=True, help="Oluşturulacak sanatı tanımlayan metin prompt'u.")
    parser.add_argument("--output", type=str, required=True, help="Çıktı dosyaları için temel ad (uzantısız).")
    return parser.parse_args()

def main():
    """SVG sanatını oluşturmak için ana fonksiyon."""
    args = parse_arguments()

    print(f"🎨 '{args.prompt}' prompt'u için sanat oluşturuluyor...")

    # --- Prompt'u Analiz Et ---
    attributes = parse_anime_prompt(args.prompt)
    if not attributes:
        print("⚠️ Prompt anlaşılamadı. Lütfen 'mor saçlı mavi gözlü bir anime kızı' gibi bir tanım girin.")
        return

    # --- SVG Tuval Kurulumu ---
    output_svg_path = f"{args.output}.svg"
    dwg = svgwrite.Drawing(output_svg_path, profile='full', size=('800px', '800px'))
    dwg.add(dwg.rect(insert=(0, 0), size=('100%', '100%'), fill='#f0f0f0')) # Arka plan

    # --- Katmanlı Çizim ---
    # Çizim sırası önemlidir (arkadan öne).
    merkez_x, merkez_y = 400, 300
    ciz_saç(dwg, merkez_x, merkez_y, attributes["saç_rengi"])
    ciz_kıyafet(dwg, merkez_x, merkez_y)
    ciz_kafa(dwg, merkez_x, merkez_y)
    ciz_gözler(dwg, merkez_x, merkez_y, attributes["göz_rengi"])
    ciz_ağız(dwg, merkez_x, merkez_y)

    # --- SVG Dosyasını Kaydet ---
    dwg.save()

    print(f"✅ SVG dosyası başarıyla kaydedildi: {output_svg_path}")

if __name__ == "__main__":
    main()
