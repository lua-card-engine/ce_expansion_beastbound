"""
Removes the light halo left around cut-out (transparent background) images.

AI generated assets that is cut from a white background keeps a 1-2px ring of
white-ish, anti-aliased pixels just outside the dark outline. This script:

  1. peels off outermost opaque pixels that are much lighter than the outline
     right behind them,
  2. recolors the remaining edge pixels with the outline color (so nothing
     white bleeds back in when the game filters/mipmaps the texture),
  3. gives the edge a slight alpha feather so it stays smooth, not jagged.

Usage:
  python tools/defringe.py <file-or-dir> [...]           # edits in place
  python tools/defringe.py <file-or-dir> --out <dir>     # writes copies
  python tools/defringe.py design/monsters --preview     # also writes *.preview.png on dark bg

Requires: pip install pillow numpy scipy
"""
import argparse
import sys
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as ndi

CROSS = ndi.generate_binary_structure(2, 1)
SQUARE = ndi.generate_binary_structure(2, 2)


def luminance(rgb):
    return rgb[..., 0] * 0.299 + rgb[..., 1] * 0.587 + rgb[..., 2] * 0.114


def defringe(img, passes=3, min_lum=95.0, contrast=45.0, feather=0.6, radius=2):
    rgba = np.asarray(img.convert("RGBA")).astype(np.float32)
    rgb, alpha = rgba[..., :3], rgba[..., 3]
    opaque = alpha >= 128
    lum = luminance(rgb)

    # 1. peel light pixels off the outside, one layer at a time.
    for _ in range(passes):
        edge = opaque & ~ndi.binary_erosion(opaque, CROSS, border_value=0)
        # darkest opaque pixel within `radius`: what the outline looks like here
        masked = np.where(opaque, lum, 255.0)
        local_dark = ndi.minimum_filter(masked, size=2 * radius + 1)
        strip = edge & (lum >= min_lum) & (lum - local_dark >= contrast)
        if not strip.any():
            break
        opaque &= ~strip

    # drop specks that the peeling detached from the main shape
    labels, n = ndi.label(opaque, SQUARE)
    if n > 1:
        sizes = ndi.sum(opaque, labels, range(1, n + 1))
        keep = np.isin(labels, [i + 1 for i, s in enumerate(sizes) if s >= 4])
        opaque &= keep

    # 2. recolor the outer ring with the darkest nearby interior color
    inner = ndi.binary_erosion(opaque, SQUARE, iterations=2, border_value=1)
    ring = opaque & ~inner
    out_rgb = rgb.copy()
    ys, xs = np.nonzero(ring)
    h, w = lum.shape
    for y, x in zip(ys, xs):
        y0, y1, x0, x1 = max(0, y - radius), min(h, y + radius + 1), max(0, x - radius), min(w, x + radius + 1)
        win_op = opaque[y0:y1, x0:x1]
        win_l = np.where(win_op, lum[y0:y1, x0:x1], 255.0)
        j = np.unravel_index(np.argmin(win_l), win_l.shape)
        if win_l[j] < lum[y, x] - 8:
            out_rgb[y, x] = rgb[y0 + j[0], x0 + j[1]]

    # 3. feather the edge (only shrinks alpha of existing pixels, never grows)
    new_alpha = np.where(opaque, 255.0, 0.0)
    if feather > 0:
        soft = ndi.gaussian_filter(opaque.astype(np.float32), feather)
        soft = np.clip(soft * 1.6, 0, 1)
        new_alpha = np.where(opaque, np.maximum(soft, 0.35) * 255.0, 0.0)
        # keep pixels that were already partly transparent from getting more opaque
        new_alpha = np.minimum(new_alpha, np.where(opaque, np.maximum(alpha, 1.0), 0.0))

    out = np.dstack([np.where(opaque[..., None], out_rgb, 0), new_alpha])
    return Image.fromarray(np.clip(out + 0.5, 0, 255).astype(np.uint8), "RGBA")


def preview(img, scale=3, bg=(24, 24, 24)):
    base = Image.new("RGBA", img.size, bg + (255,))
    base.alpha_composite(img)
    return base.resize((img.width * scale, img.height * scale), Image.NEAREST)


def collect(paths):
    for p in map(Path, paths):
        if p.is_dir():
            yield from sorted(p.rglob("*.png"))
        elif p.suffix.lower() == ".png":
            yield p


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("paths", nargs="+")
    ap.add_argument("--out", help="write results here (keeps relative layout) instead of editing in place")
    ap.add_argument("--preview", action="store_true", help="also write a zoomed *.preview.png on a dark background")
    ap.add_argument("--passes", type=int, default=3)
    ap.add_argument("--min-lum", type=float, default=95.0)
    ap.add_argument("--contrast", type=float, default=45.0)
    ap.add_argument("--feather", type=float, default=0.6)
    a = ap.parse_args()

    files = list(collect(a.paths))
    if not files:
        sys.exit("no png files found")
    root = Path(a.paths[0]) if Path(a.paths[0]).is_dir() else Path(a.paths[0]).parent
    for f in files:
        src = Image.open(f)
        if "A" not in src.convert("RGBA").getbands() or src.mode not in ("RGBA", "LA", "P"):
            print(f"skip (no alpha): {f}")
            continue
        res = defringe(src, a.passes, a.min_lum, a.contrast, a.feather)
        dst = f
        if a.out:
            dst = Path(a.out) / f.relative_to(root)
            dst.parent.mkdir(parents=True, exist_ok=True)
        res.save(dst)
        if a.preview:
            preview(res).save(dst.with_suffix(".preview.png"))
        print(f"ok: {f}")


if __name__ == "__main__":
    main()
