#!/usr/bin/env python3
"""Generate a macOS-style squircle icon from assets/alfred-logo.png."""
from __future__ import annotations

import math
import sys
from pathlib import Path

try:
    from PIL import Image, ImageChops, ImageDraw, ImageFilter
except ImportError:
    print("Pillow is required: python3 -m pip install pillow", file=sys.stderr)
    sys.exit(1)

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets" / "alfred-logo.png"
OUTPUT = ROOT / "assets" / "alfred-logo-macos.png"
SIZE = 512
PADDING = 44

# Dark squircle to pair with the Cursor logo in the README header.
BACKGROUND_TOP = (36, 36, 38)
BACKGROUND_BOTTOM = (12, 12, 14)
HIGHLIGHT_ALPHA = 22
BORDER_ALPHA = 36


def squircle_points(size: int, n: float = 4.5, steps: int = 360) -> list[tuple[float, float]]:
    points: list[tuple[float, float]] = []
    for i in range(steps):
        t = 2 * math.pi * i / steps
        cos_t, sin_t = math.cos(t), math.sin(t)
        x = math.copysign(abs(cos_t) ** (2 / n), cos_t)
        y = math.copysign(abs(sin_t) ** (2 / n), sin_t)
        points.append(((x + 1) / 2 * size, (y + 1) / 2 * size))
    return points


def make_squircle_mask(size: int) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).polygon(squircle_points(size), fill=255)
    return mask


def vertical_gradient(
    size: int,
    top: tuple[int, int, int] = BACKGROUND_TOP,
    bottom: tuple[int, int, int] = BACKGROUND_BOTTOM,
) -> Image.Image:
    img = Image.new("RGB", (size, size))
    px = img.load()
    for y in range(size):
        t = y / (size - 1)
        color = tuple(int(top[i] * (1 - t) + bottom[i] * t) for i in range(3))
        for x in range(size):
            px[x, y] = color
    return img


def add_inner_highlight(base: Image.Image, mask: Image.Image) -> Image.Image:
    highlight = Image.new("RGBA", base.size, (255, 255, 255, 0))
    draw = ImageDraw.Draw(highlight)
    width, height = base.size
    draw.ellipse(
        (width * 0.08, height * 0.02, width * 0.92, height * 0.55),
        fill=(255, 255, 255, HIGHLIGHT_ALPHA),
    )
    red, green, blue, alpha = highlight.split()
    highlight.putalpha(ImageChops.multiply(alpha, mask))
    return Image.alpha_composite(base.convert("RGBA"), highlight)


def remove_near_white_background(image: Image.Image, threshold: int = 245) -> Image.Image:
    image = image.convert("RGBA")
    pixels = image.load()
    width, height = image.size

    for y in range(height):
        for x in range(width):
            red, green, blue, alpha = pixels[x, y]
            if red >= threshold and green >= threshold and blue >= threshold:
                pixels[x, y] = (red, green, blue, 0)

    return image


def build_icon(source: Path, output: Path) -> None:
    if not source.exists():
        raise FileNotFoundError(f"Missing source logo: {source}")

    mask = make_squircle_mask(SIZE)
    background = vertical_gradient(SIZE)
    icon = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    icon.paste(background, (0, 0))
    icon.putalpha(mask)
    icon = add_inner_highlight(icon, mask)

    logo = remove_near_white_background(Image.open(source).convert("RGBA"))
    logo = logo.crop(logo.getbbox())
    content = SIZE - PADDING * 2
    logo.thumbnail((content, content), Image.Resampling.LANCZOS)
    offset = ((SIZE - logo.width) // 2, (SIZE - logo.height) // 2)
    icon.alpha_composite(logo, offset)

    border = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    ImageDraw.Draw(border).polygon(
        squircle_points(SIZE),
        outline=(255, 255, 255, BORDER_ALPHA),
        width=2,
    )
    icon = Image.alpha_composite(icon, border)

    output.parent.mkdir(parents=True, exist_ok=True)
    icon.save(output, "PNG")
    print(f"Wrote {output}")


if __name__ == "__main__":
    build_icon(SOURCE, OUTPUT)
