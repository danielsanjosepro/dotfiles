---
name: sprite-conversion
description: Convert one or more pixel-art sprite images into compact terminal sprite definitions for the pi mascot/header extension. Use when the user gives image files, clipboard screenshots, or sprite URLs and wants them turned into parseSprite rows plus colors, or integrated into the mascot extension.
---

# Sprite Conversion

Use this skill when the user provides one or more sprite images and wants them converted into compact pi mascot sprites.

This project already contains a mascot extension at:

- `.pi/agent/extensions/space-invader-header.ts`

The preferred rendering style is:

- keep full horizontal resolution
- compress vertically with `▀`, `▄`, and `█`
- color glyphs with ANSI truecolor
- define sprites as row strings and convert them with `parseSprite(...)`
- render them with `renderCompressedSprite(...)`

## When to use this skill

Use this skill when the user asks to:

- convert a sprite image into the mascot format
- add a new mascot from a PNG or clipboard image
- process a batch/list of sprite images
- extract palette rows from pixel art
- turn sprite sheets or screenshots into `parseSprite(...)` rows

## Workflow

For each requested sprite:

1. Read the image with `read` so you can visually inspect it.
2. Use the helper script `scripts/extract_sprite.py` with `uv run --with pillow`.
3. Review the generated rows and palette.
4. If needed, manually clean up the rows:
   - trim empty borders only if it improves centering
   - keep distinctive features like eyes, rings, flames, ears, tails
   - preserve full horizontal resolution
5. Integrate the sprite into `.pi/agent/extensions/space-invader-header.ts`:
   - add/update `MascotName`
   - add a `get<Name>()` function
   - add entries to `MASCOTS`, `MASCOT_DESCRIPTIONS`, and `MASCOT_ALIASES`
   - keep backward-compatible aliases when renaming an old mascot
6. If multiple images were provided, process them one by one and report which were completed.

## Helper script

Run:

```bash
uv run --with pillow .pi/skills/sprite-conversion/scripts/extract_sprite.py /path/to/image.png
```

If the user gives a remote image URL, download it first, for example:

```bash
curl -L "https://example.com/sprite.png" -o /tmp/sprite.png
uv run --with pillow .pi/skills/sprite-conversion/scripts/extract_sprite.py /tmp/sprite.png
```

## Expected script output

The script prints:

- inferred scale
- cropped sprite size in cells
- token rows suitable for `parseSprite(...)`
- a token-to-color mapping in hex

Default token legend:

- `.` = empty
- `#` = darkest color / outline
- remaining colors use short tokens like `a`, `b`, `c`, ... ordered from dark to light

After extraction, rename tokens semantically when it helps readability, for example:

- `d` → `dark`
- `m` → `mid`
- `l` → `light`
- `y` → `yellow`
- `g` → `gold`
- `r` → `red`
- `w` → `white`
- `o` → `orange`

## Editing guidance

Prefer this structure inside the mascot extension:

```ts
function getExample(_theme: Theme): string[] {
  const sprite = parseSprite(
    [
      "..##..",
      ".#yy#.",
      ".#mm#.",
      "..##..",
    ],
    {
      ".": "empty",
      "#": "outline",
      "y": "yellow",
      "m": "mid",
    },
  );

  const colors = {
    outline: "#232328",
    yellow: "#fff62e",
    mid: "#808080",
  };

  return renderCompressedSprite(sprite, colors, "example");
}
```

## Batch processing rules

When the user gives multiple sprites:

- make a short checklist of the sprite names/files
- extract each sprite separately
- do not overwrite previous sprites accidentally
- keep descriptions and aliases tidy
- summarize which mascots were added or updated

## Validation checklist

Before finishing:

- the new mascot name is included in `MascotName`
- `MASCOTS`, `MASCOT_DESCRIPTIONS`, and aliases are updated
- `/mascot list` will expose the new sprite
- the sprite label line matches the mascot name
- old saved mascot names still resolve if a rename happened
- if installer/global setup matters, update `install.sh` and docs accordingly

## Notes

- Use `uv` for Python execution.
- Prefer exact image extraction over hand-transcribing pixels.
- After extraction, it is normal to do a small manual cleanup pass for eyes, highlights, rings, or symmetry.
