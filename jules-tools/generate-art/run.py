import svgwrite
import argparse
import re

# --- Constants ---
VALID_COLORS = {
    "kırmızı": "red", "mavi": "blue", "yeşil": "green", "sarı": "yellow",
    "siyah": "black", "beyaz": "white", "mor": "purple", "turuncu": "orange"
}
VALID_SHAPES = ["daire", "kare", "üçgen", "dikdörtgen"]

# --- Core Functions ---

def parse_simple_prompt(prompt):
    """
    Parses a simple prompt like "bir kırmızı daire ve mavi bir kare çiz"
    into a list of drawing instructions.
    """
    instructions = []
    # Use regex to find patterns like "[color] [shape]"
    # This is a very basic parser and can be improved significantly.

    # Normalize prompt
    prompt = prompt.lower()

    # Split the prompt by "ve", "ile" etc. to handle multiple objects
    parts = re.split(r'\s+ve\s+|\s+ile\s+', prompt)

    x, y = 150, 150 # Starting coordinates for drawing

    for part in parts:
        color = None
        shape = None

        for word in part.split():
            if word in VALID_COLORS:
                color = VALID_COLORS[word]
            if word in VALID_SHAPES:
                shape = word

        if color and shape:
            instructions.append({
                "shape": shape,
                "color": color,
                "x": x,
                "y": y
            })
            x += 250 # Move to the next position for the next shape
            if x > 600:
                x = 150
                y += 250

    return instructions

def render_elements(dwg, instructions):
    """
    Renders a list of drawing instructions onto the SVG canvas.
    """
    for inst in instructions:
        shape = inst["shape"]
        color = inst["color"]
        x = inst["x"]
        y = inst["y"]

        if shape == "daire":
            dwg.add(dwg.circle(center=(x, y), r=100, fill=color, stroke='black', stroke_width=3))
        elif shape == "kare":
            dwg.add(dwg.rect(insert=(x - 100, y - 100), size=('200px', '200px'), fill=color, stroke='black', stroke_width=3))
        elif shape == "dikdörtgen":
            dwg.add(dwg.rect(insert=(x - 150, y - 100), size=('300px', '200px'), fill=color, stroke='black', stroke_width=3))
        elif shape == "üçgen":
            # Simple equilateral triangle
            points = [(x, y - 100), (x - 86.6, y + 50), (x + 86.6, y + 50)]
            dwg.add(dwg.polygon(points, fill=color, stroke='black', stroke_width=3))

def parse_arguments():
    """Parses command-line arguments."""
    parser = argparse.ArgumentParser(description="Jules's Generative Canvas")
    parser.add_argument("--prompt", type=str, required=True, help="Text prompt describing the art to be generated.")
    parser.add_argument("--output", type=str, required=True, help="Base name for the output files (without extension).")
    return parser.parse_args()

def main():
    """Main function to generate the SVG art."""
    args = parse_arguments()

    print(f"🎨 Generating art for prompt: '{args.prompt}'")

    # --- Parse the prompt ---
    instructions = parse_simple_prompt(args.prompt)
    if not instructions:
        print("⚠️ Prompt anlaşılamadı. Lütfen 'bir [renk] [şekil]' formatında bir komut girin.")
        return

    # --- SVG Canvas Setup ---
    output_svg_path = f"{args.output}.svg"
    dwg = svgwrite.Drawing(output_svg_path, profile='tiny', size=('800px', '800px'))
    dwg.add(dwg.rect(insert=(0, 0), size=('100%', '100%'), fill='white')) # White background

    # --- Render the elements from instructions ---
    render_elements(dwg, instructions)

    # --- Save the SVG file ---
    dwg.save()

    print(f"✅ SVG file successfully saved to: {output_svg_path}")

if __name__ == "__main__":
    main()
