import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import type { AutocompleteItem } from "@earendil-works/pi-tui";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { POKEMON_SPRITES, type PokemonFrame, type PokemonSprite } from "./pokemon-data";

const DEFAULT_POKEMON = "bulbasaur";
const STATE_PATH = path.join(os.homedir(), ".pi", "agent", "pokemon-header.json");
const BLINK_INTERVAL_MS = 3000;
const BLINK_DURATION_MS = 140;
const ANIMATION_TICK_MS = 70;
const PIXEL_X_SCALE = 2;
const COMPACT_X_SCALE = 1;
const LEFT_PADDING = "      ";

type RenderMode = "full" | "compact";

type PokemonState = {
  selectedPokemon?: string;
  renderMode?: RenderMode;
};

const POKEMON_BY_SLUG = new Map(POKEMON_SPRITES.map((pokemon) => [pokemon.slug, pokemon]));
const RENDER_CACHE = new Map<string, string[]>();
const ALIASES = buildAliases();

function buildAliases(): Map<string, string> {
  const aliases = new Map<string, string>();

  const add = (key: string, slug: string) => {
    const normalized = normalizeKey(key);
    if (normalized) aliases.set(normalized, slug);
  };

  for (const pokemon of POKEMON_SPRITES) {
    add(pokemon.slug, pokemon.slug);
    add(pokemon.displayName, pokemon.slug);
    add(pokemon.id, pokemon.slug);
    add(String(Number.parseInt(pokemon.id, 10)), pokemon.slug);
    add(pokemon.slug.replaceAll("_", " "), pokemon.slug);
  }

  add("default", DEFAULT_POKEMON);
  add("missingno.", "missingno");
  add("mr mime", "mr_mime");
  add("mr. mime", "mr_mime");
  add("nidoran female", "nidoran_female");
  add("nidoran male", "nidoran_male");
  add("farfetch'd", "farfetchd");

  return aliases;
}

function normalizeKey(value: string): string {
  return value
    .trim()
    .toLowerCase()
    .replace(/♀/g, " female ")
    .replace(/♂/g, " male ")
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "")
    .replace(/_+/g, "_");
}

function normalizePokemonName(value: string): string | null {
  const normalized = normalizeKey(value);
  if (!normalized) return null;
  return ALIASES.get(normalized) ?? null;
}

function readState(): { selectedPokemon: string; renderMode: RenderMode } {
  try {
    if (!fs.existsSync(STATE_PATH)) return { selectedPokemon: DEFAULT_POKEMON, renderMode: "full" };
    const parsed = JSON.parse(fs.readFileSync(STATE_PATH, "utf8")) as PokemonState;
    const normalized = parsed.selectedPokemon ? normalizePokemonName(parsed.selectedPokemon) : null;
    return {
      selectedPokemon: normalized ?? DEFAULT_POKEMON,
      renderMode: parsed.renderMode === "compact" ? "compact" : "full",
    };
  } catch {
    return { selectedPokemon: DEFAULT_POKEMON, renderMode: "full" };
  }
}

function writeState(slug: string, renderMode: RenderMode): void {
  fs.mkdirSync(path.dirname(STATE_PATH), { recursive: true });
  fs.writeFileSync(STATE_PATH, JSON.stringify({ selectedPokemon: slug, renderMode }, null, 2) + "\n", "utf8");
}

function toRgb(hex: string): [number, number, number] {
  const normalized = hex.replace("#", "");
  return [
    Number.parseInt(normalized.slice(0, 2), 16),
    Number.parseInt(normalized.slice(2, 4), 16),
    Number.parseInt(normalized.slice(4, 6), 16),
  ];
}

function paintBlock(hex: string): string {
  const [r, g, b] = toRgb(hex);
  return `\u001b[38;2;${r};${g};${b}m${"█".repeat(PIXEL_X_SCALE)}\u001b[39m`;
}

function renderFullFrame(frame: PokemonFrame): string[] {
  const cacheKey = `full:${JSON.stringify(frame)}`;
  const cached = RENDER_CACHE.get(cacheKey);
  if (cached) return cached;

  const lines = frame.rows.map((row) => {
    let line = LEFT_PADDING;
    for (const cell of row) {
      if (cell === ".") {
        line += " ".repeat(PIXEL_X_SCALE);
        continue;
      }
      line += paintBlock(frame.palette[cell]);
    }
    return line;
  });

  RENDER_CACHE.set(cacheKey, lines);
  return lines;
}

function paintGlyph(glyph: string, hex: string): string {
  const [r, g, b] = toRgb(hex);
  return `\u001b[38;2;${r};${g};${b}m${glyph}\u001b[39m`;
}

function renderCompactFrame(frame: PokemonFrame): string[] {
  const cacheKey = `compact:${JSON.stringify(frame)}`;
  const cached = RENDER_CACHE.get(cacheKey);
  if (cached) return cached;

  const lines: string[] = [];

  for (let y = 0; y < frame.rows.length; y += 2) {
    let line = LEFT_PADDING;
    for (let x = 0; x < frame.width; x++) {
      const topCell = frame.rows[y]?.[x] ?? ".";
      const bottomCell = frame.rows[y + 1]?.[x] ?? ".";
      const topColor = topCell !== "." ? frame.palette[topCell] : null;
      const bottomColor = bottomCell !== "." ? frame.palette[bottomCell] : null;

      let char = " ".repeat(COMPACT_X_SCALE);

      if (topColor && bottomColor) {
        if (topColor === bottomColor) {
          char = paintGlyph("█".repeat(COMPACT_X_SCALE), topColor);
        } else {
          const [tr, tg, tb] = toRgb(topColor);
          const [br, bg, bb] = toRgb(bottomColor);
          char = `\u001b[38;2;${tr};${tg};${tb}m\u001b[48;2;${br};${bg};${bb}m${"▀".repeat(COMPACT_X_SCALE)}\u001b[39m\u001b[49m`;
        }
      } else if (topColor) {
        char = paintGlyph("▀".repeat(COMPACT_X_SCALE), topColor);
      } else if (bottomColor) {
        char = paintGlyph("▄".repeat(COMPACT_X_SCALE), bottomColor);
      }

      line += char;
    }
    lines.push(line);
  }

  RENDER_CACHE.set(cacheKey, lines);
  return lines;
}

function renderFrame(frame: PokemonFrame, renderMode: RenderMode): string[] {
  return renderMode === "compact" ? renderCompactFrame(frame) : renderFullFrame(frame);
}

function shouldBlink(): boolean {
  const phase = Date.now() % BLINK_INTERVAL_MS;
  return phase >= BLINK_INTERVAL_MS - BLINK_DURATION_MS;
}

function getCurrentPokemon(slug: string): PokemonSprite {
  return POKEMON_BY_SLUG.get(slug) ?? POKEMON_BY_SLUG.get(DEFAULT_POKEMON)!;
}

function installHeader(
  ctx: ExtensionContext,
  selectedSlug: string,
  renderMode: RenderMode,
  animation: { timer?: NodeJS.Timeout | undefined },
): void {
  if (!ctx.hasUI) return;

  if (animation.timer) {
    clearInterval(animation.timer);
    animation.timer = undefined;
  }

  const pokemon = getCurrentPokemon(selectedSlug);

  ctx.ui.setHeader((tui, theme) => {
    if (animation.timer) clearInterval(animation.timer);
    animation.timer = setInterval(() => tui.requestRender(), ANIMATION_TICK_MS);

    return {
      render(): string[] {
        const frame = shouldBlink() ? pokemon.closed : pokemon.open;
        return [
          "",
          ...renderFrame(frame, renderMode),
          "",
          `${theme.fg("accent", pokemon.displayName)} ${theme.fg("dim", `· ${renderMode} · /pokemon <name> · /pokemon mode <full|compact>` )}`,
          "",
        ];
      },
      invalidate() {},
    };
  });
}

export default function (pi: ExtensionAPI) {
  const initialState = readState();
  let currentPokemon = initialState.selectedPokemon;
  let renderMode = initialState.renderMode;
  const animation: { timer?: NodeJS.Timeout } = {};

  pi.on("session_start", async (_event, ctx) => {
    const state = readState();
    currentPokemon = state.selectedPokemon;
    renderMode = state.renderMode;
    installHeader(ctx, currentPokemon, renderMode, animation);
  });

  pi.on("session_shutdown", async () => {
    if (animation.timer) {
      clearInterval(animation.timer);
      animation.timer = undefined;
    }
  });

  pi.registerCommand("pokemon", {
    description: "Set the header pokemon: /pokemon pikachu",
    getArgumentCompletions: (prefix: string): AutocompleteItem[] | null => {
      const normalizedPrefix = normalizeKey(prefix);
      const items: AutocompleteItem[] = [
        { value: "status", label: "status", description: "Show the current default Pokémon" },
        { value: "mode full", label: "mode full", description: "Use wider full-block rendering" },
        { value: "mode compact", label: "mode compact", description: "Use smaller compact block rendering" },
        ...POKEMON_SPRITES.map((pokemon) => ({
          value: pokemon.slug,
          label: pokemon.slug,
          description: pokemon.displayName,
        })),
      ];
      const filtered = !normalizedPrefix
        ? items
        : items.filter((item) => normalizeKey(item.value).includes(normalizedPrefix) || normalizeKey(item.description ?? "").includes(normalizedPrefix));
      return filtered.length > 0 ? filtered : null;
    },
    handler: async (args, ctx) => {
      if (!ctx.hasUI) return;

      const input = (args ?? "status").trim();
      if (!input || input.toLowerCase() === "status") {
        const pokemon = getCurrentPokemon(currentPokemon);
        ctx.ui.notify(`Pokemon header: ${pokemon.displayName} (${pokemon.slug}) · mode=${renderMode}`, "info");
        return;
      }

      const modeMatch = input.match(/^mode\s+(full|compact)$/i);
      if (modeMatch) {
        renderMode = modeMatch[1].toLowerCase() as RenderMode;
        writeState(currentPokemon, renderMode);
        installHeader(ctx, currentPokemon, renderMode, animation);
        ctx.ui.notify(`Pokemon render mode set to ${renderMode}`, "success");
        return;
      }

      const nextSlug = normalizePokemonName(input);
      if (!nextSlug) {
        ctx.ui.notify(`Unknown pokemon: ${input}. Use Tab completion after /pokemon .`, "warning");
        return;
      }

      currentPokemon = nextSlug;
      writeState(currentPokemon, renderMode);
      installHeader(ctx, currentPokemon, renderMode, animation);
      ctx.ui.notify(`Pokemon header set to ${getCurrentPokemon(currentPokemon).displayName}`, "success");
    },
  });
}
