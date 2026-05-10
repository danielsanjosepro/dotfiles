# pokemon-header

Prototype Pi extension that renders Pokémon terminal headers from pixel-art PNGs.

## What it does

- adds a `/pokemon <name>` command
- replaces the older mascot/menu prototype for now
- shows the selected Pokémon in the Pi header using full block pixels
- blinks every ~3 seconds by switching to the closed-eyes frame briefly
- remembers the last selected Pokémon in `~/.pi/agent/pokemon-header.json`

## Source assets

The editable source sprites live in `assets/<dex>_<slug>/`:

- `open.png`
- `closed.png`

These are the 1x pixel-art versions used to generate the terminal data.

## Regenerating the terminal sprite data

From this directory:

```bash
uv run --with pillow python scripts/generate_pokemon_data.py
```

That rewrites `pokemon-data.ts` from the PNG assets.

## Installing through these dotfiles

This repo already symlinks `.pi/agent/extensions/` and `.pi/agent/settings.json` into `~/.pi/agent/` via `install.sh`.

After installing the dotfiles, reload Pi:

```text
/reload
```

## Usage

```text
/pokemon pikachu
/pokemon bulbasaur
/pokemon mr mime
/pokemon status
```

Use Tab completion after `/pokemon ` to browse names.
