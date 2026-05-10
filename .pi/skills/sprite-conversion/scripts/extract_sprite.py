#!/usr/bin/env python3
from __future__ import annotations

import argparse
import math
from collections import Counter
from pathlib import Path
from typing import Iterable

from PIL import Image


DEFAULT_EMPTY_TOKEN = "."
DARKEST_TOKEN = "#"
OTHER_TOKENS = list("abcdefghijklmnopqrstuvwxyz0123456789")


def rgba_key(pixel: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    return tuple(pixel)


def detect_background(img: Image.Image) -> tuple[int, int, int, int]:
    w, h = img.size
    points = [
        (0, 0),
        (w - 1, 0),
        (0, h - 1),
        (w - 1, h - 1),
        (w // 2, 0),
        (w // 2, h - 1),
        (0, h // 2),
        (w - 1, h // 2),
    ]
    samples = [rgba_key(img.getpixel(p)) for p in points]
    return Counter(samples).most_common(1)[0][0]


def content_bbox(img: Image.Image, bg: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    w, h = img.size
    xs: list[int] = []
    ys: list[int] = []
    for y in range(h):
        for x in range(w):
            px = rgba_key(img.getpixel((x, y)))
            if px != bg and px[3] != 0:
                xs.append(x)
                ys.append(y)
    if not xs or not ys:
        raise SystemExit("No non-background pixels found")
    return min(xs), min(ys), max(xs), max(ys)


def run_lengths(values: Iterable[tuple[int, int, int, int]]) -> list[int]:
    iterator = iter(values)
    try:
        prev = next(iterator)
    except StopIteration:
        return []
    count = 1
    runs: list[int] = []
    for value in iterator:
        if value == prev:
            count += 1
        else:
            runs.append(count)
            prev = value
            count = 1
    runs.append(count)
    return runs


def infer_scale(img: Image.Image) -> int:
    w, h = img.size
    lengths: list[int] = []

    for y in range(h):
        row = [rgba_key(img.getpixel((x, y))) for x in range(w)]
        lengths.extend(run_lengths(row))

    for x in range(w):
        col = [rgba_key(img.getpixel((x, y))) for y in range(h)]
        lengths.extend(run_lengths(col))

    lengths = [n for n in lengths if n > 0]
    if not lengths:
        return 1
    return math.gcd(*lengths)


def luminance(rgba: tuple[int, int, int, int]) -> float:
    r, g, b, _a = rgba
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def assign_tokens(colors: list[tuple[int, int, int, int]], bg: tuple[int, int, int, int]) -> dict[tuple[int, int, int, int], str]:
    non_bg = [c for c in colors if c != bg and c[3] != 0]
    ordered = sorted(non_bg, key=luminance)
    tokens: dict[tuple[int, int, int, int], str] = {bg: DEFAULT_EMPTY_TOKEN}
    if not ordered:
        return tokens

    tokens[ordered[0]] = DARKEST_TOKEN
    token_iter = iter(OTHER_TOKENS)
    for color in ordered[1:]:
        token = next(token_iter)
        if token in {DEFAULT_EMPTY_TOKEN, DARKEST_TOKEN}:
            token = next(token_iter)
        tokens[color] = token
    return tokens


def sample_cells(
    img: Image.Image,
    bbox: tuple[int, int, int, int],
    scale: int,
    bg: tuple[int, int, int, int],
) -> list[list[tuple[int, int, int, int]]]:
    left, top, right, bottom = bbox
    width = right - left + 1
    height = bottom - top + 1
    cells_x = width // scale
    cells_y = height // scale
    rows: list[list[tuple[int, int, int, int]]] = []
    for cy in range(cells_y):
        row: list[tuple[int, int, int, int]] = []
        sy = top + cy * scale + scale // 2
        for cx in range(cells_x):
            sx = left + cx * scale + scale // 2
            px = rgba_key(img.getpixel((sx, sy)))
            row.append(bg if px[3] == 0 else px)
        rows.append(row)
    return rows


def trim_empty(rows: list[str], empty_token: str = DEFAULT_EMPTY_TOKEN) -> list[str]:
    if not rows:
        return rows

    top = 0
    bottom = len(rows) - 1
    while top <= bottom and set(rows[top]) == {empty_token}:
        top += 1
    while bottom >= top and set(rows[bottom]) == {empty_token}:
        bottom -= 1

    cropped = rows[top : bottom + 1]
    if not cropped:
        return []

    left = 0
    right = len(cropped[0]) - 1
    while left <= right and all(row[left] == empty_token for row in cropped):
        left += 1
    while right >= left and all(row[right] == empty_token for row in cropped):
        right -= 1

    return [row[left : right + 1] for row in cropped]


def hex_rgb(rgba: tuple[int, int, int, int]) -> str:
    r, g, b, _a = rgba
    return f"#{r:02x}{g:02x}{b:02x}"


def main() -> None:
    parser = argparse.ArgumentParser(description="Extract nearest-neighbor sprite rows and palette from an image")
    parser.add_argument("image", type=Path)
    parser.add_argument("--no-trim", action="store_true", help="Keep empty border rows/columns")
    args = parser.parse_args()

    img = Image.open(args.image).convert("RGBA")
    bg = detect_background(img)
    bbox = content_bbox(img, bg)
    cropped = img.crop((bbox[0], bbox[1], bbox[2] + 1, bbox[3] + 1))
    scale = infer_scale(cropped)
    rows_rgba = sample_cells(cropped, (0, 0, cropped.size[0] - 1, cropped.size[1] - 1), scale, bg)

    colors = sorted({px for row in rows_rgba for px in row}, key=luminance)
    token_map = assign_tokens(colors, bg)
    rows = ["".join(token_map[px] for px in row) for row in rows_rgba]
    if not args.no_trim:
        rows = trim_empty(rows)

    used_tokens = []
    for row in rows:
        for token in row:
            if token not in used_tokens:
                used_tokens.append(token)

    reverse = {token: color for color, token in token_map.items() if token in used_tokens}

    print(f"image: {args.image}")
    print(f"detected background: {hex_rgb(bg)}")
    print(f"cropped px size: {cropped.size[0]}x{cropped.size[1]}")
    print(f"inferred scale: {scale}")
    print(f"cell size: {len(rows[0]) if rows else 0}x{len(rows)}")
    print()
    print("rows:")
    for row in rows:
        print(f'  "{row}",')
    print()
    print("palette:")
    for token in used_tokens:
        if token == DEFAULT_EMPTY_TOKEN:
            print(f'  "{token}": "empty",')
        else:
            print(f'  "{token}": "{hex_rgb(reverse[token])}",')


if __name__ == "__main__":
    main()
