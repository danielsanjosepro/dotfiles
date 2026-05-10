import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import type { AutocompleteItem } from "@earendil-works/pi-tui";
import type { ExtensionAPI, ExtensionContext, Theme } from "@earendil-works/pi-coding-agent";

const DEFAULT_MASCOT = "invader";
const GLOBAL_MASCOT_STATE_PATH = path.join(os.homedir(), ".pi", "agent", "mascot.json");
const LEGACY_LOCAL_MASCOT_STATE_PATH = path.join(process.cwd(), ".pi", "agent", "mascot.json");

type MascotName = "invader" | "charmander" | "umbreon";
type StoredMascotName = MascotName | "phoenix";

interface MascotState {
  selectedMascot: StoredMascotName;
}

function getInvader(theme: Theme): string[] {
  const a = (s: string) => theme.fg("accent", s);
  const m = (s: string) => theme.fg("muted", s);
  const d = (s: string) => theme.fg("dim", s);

  return [
    "",
    `   ${a("▗▄▖")}`,
    `  ${a("▐██▌")}`,
    ` ${a("▟████▙")}`,
    ` ${a("██▟▙██")}`,
    `   ${m("pi")} ${d("/menu open · /mascot <name>")}`,
    "",
  ];
}

function parseSprite(rows: string[], palette: Record<string, string>): string[][] {
  return rows.map((row) => [...row].map((cell) => palette[cell] ?? "empty"));
}

function renderCompressedSprite(
  sprite: string[][],
  colors: Record<string, string>,
  label: string,
): string[] {
  const width = sprite.reduce((max, row) => Math.max(max, row.length), 0);

  const toRgb = (hex: string): [number, number, number] => {
    const normalized = hex.replace("#", "");
    return [
      Number.parseInt(normalized.slice(0, 2), 16),
      Number.parseInt(normalized.slice(2, 4), 16),
      Number.parseInt(normalized.slice(4, 6), 16),
    ];
  };

  const paint = (glyph: string, fg?: string, bg?: string): string => {
    let prefix = "";
    if (fg) {
      const [r, g, b] = toRgb(fg);
      prefix += `\u001b[38;2;${r};${g};${b}m`;
    }
    if (bg) {
      const [r, g, b] = toRgb(bg);
      prefix += `\u001b[48;2;${r};${g};${b}m`;
    }
    return `${prefix}${glyph}\u001b[39m\u001b[49m`;
  };

  const lines: string[] = [];
  for (let y = 0; y < sprite.length; y += 2) {
    let line = "";
    for (let x = 0; x < width; x += 1) {
      const top = sprite[y]?.[x] ?? "empty";
      const bottom = sprite[y + 1]?.[x] ?? "empty";

      if (top === "empty" && bottom === "empty") {
        line += " ";
        continue;
      }

      if (top !== "empty" && bottom !== "empty") {
        if (top === bottom) {
          line += paint("█", colors[top]);
        } else {
          line += paint("▀", colors[top], colors[bottom]);
        }
        continue;
      }

      if (top !== "empty") {
        line += paint("▀", colors[top]);
        continue;
      }

      line += paint("▄", colors[bottom]);
    }
    lines.push(line);
  }

  return ["", ...lines, "", `${label}  /menu open · /mascot <name>`, ""];
}

function getCharmander(_theme: Theme): string[] {
  const sprite = [
    ["empty","empty","empty","outline","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty"],
    ["empty","empty","outline","red","outline","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty"],
    ["empty","outline","red","red","outline","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty"],
    ["empty","outline","red","red","outline","empty","empty","empty","empty","empty","empty","empty","empty","empty","outline","outline","outline","outline","empty","empty","empty","empty"],
    ["outline","red","white","white","red","outline","empty","empty","empty","empty","empty","empty","empty","outline","orange","orange","orange","orange","outline","empty","empty","empty"],
    ["outline","red","white","white","red","outline","empty","empty","empty","empty","empty","empty","outline","orange","orange","orange","orange","orange","orange","outline","empty","empty"],
    ["outline","red","yellow","yellow","red","outline","empty","empty","empty","empty","empty","empty","outline","orange","orange","orange","orange","orange","orange","outline","empty","empty"],
    ["empty","outline","red","red","outline","empty","empty","empty","empty","empty","empty","outline","orange","orange","orange","orange","orange","orange","orange","orange","outline","empty"],
    ["empty","empty","outline","orange","outline","empty","empty","empty","empty","empty","empty","outline","orange","orange","orange","orange","outline","empty","orange","orange","orange","outline"],
    ["empty","empty","outline","orange","orange","outline","empty","empty","empty","empty","outline","orange","orange","orange","orange","orange","outline","outline","orange","orange","orange","outline"],
    ["empty","empty","outline","orange","orange","outline","empty","empty","empty","empty","outline","orange","orange","orange","orange","orange","outline","outline","orange","orange","orange","outline"],
    ["empty","empty","empty","outline","orange","orange","outline","empty","empty","outline","orange","orange","orange","orange","orange","orange","orange","orange","orange","orange","outline","empty"],
    ["empty","empty","empty","outline","orange","orange","orange","outline","outline","orange","orange","orange","orange","orange","orange","orange","orange","orange","outline","outline","empty","empty"],
    ["empty","empty","empty","empty","outline","orange","orange","outline","outline","orange","orange","orange","outline","orange","orange","outline","outline","outline","empty","empty","empty","empty"],
    ["empty","empty","empty","empty","empty","outline","orange","outline","orange","orange","orange","orange","orange","outline","orange","yellow","outline","empty","empty","empty","empty","empty"],
    ["empty","empty","empty","empty","empty","empty","outline","outline","orange","orange","orange","outline","outline","yellow","yellow","yellow","outline","empty","empty","empty","empty","empty"],
    ["empty","empty","empty","empty","empty","empty","empty","outline","orange","orange","orange","orange","yellow","yellow","yellow","outline","empty","outline","empty","empty","empty","empty"],
    ["empty","empty","empty","empty","empty","empty","empty","outline","outline","orange","orange","orange","orange","orange","outline","outline","outline","empty","empty","empty","empty","empty"],
    ["empty","empty","empty","empty","empty","empty","empty","empty","outline","outline","orange","outline","outline","outline","empty","empty","empty","empty","empty","empty","empty","empty"],
    ["empty","empty","empty","empty","empty","empty","empty","empty","outline","empty","orange","empty","outline","empty","empty","empty","empty","empty","empty","empty","empty","empty"],
    ["empty","empty","empty","empty","empty","empty","empty","empty","empty","outline","outline","outline","empty","empty","empty","empty","empty","empty","empty","empty","empty","empty"],
  ];

  const colors = {
    outline: "#5a3d2b",
    orange: "#f59e0b",
    yellow: "#fde047",
    red: "#ef4444",
    blue: "#60a5fa",
    white: "#f8fafc",
  };

  return renderCompressedSprite(sprite, colors, "charmander");
}

function getUmbreon(_theme: Theme): string[] {
  const sprite = parseSprite(
    [
      "##...................",
      "#m#........###.......",
      "#yy#.....##mm#....###",
      "#ymm#...#yymd#...#dd#",
      "#gmm####mmyy#...#ygd#",
      ".#mdygm#mmg#...#gyyg#",
      "..#mmymmmd#....#ddy#.",
      ".#mmymmm##..###ddd#..",
      ".#yymmw#m###dd#d##...",
      ".#mmmwr#m##dddd#.....",
      ".#mmmr#mmdddddgd#....",
      "..#mmmm#ddddddgd#....",
      "...####mmdddd#dgd#...",
      ".....#mmmmddd#d#d#...",
      ".....#dm#md#d##dd#...",
      "....#d###mg##..#d#...",
      "...#dd#..#g#...#d#...",
      "...###...#d#...##....",
      ".........#d#.........",
      ".........##...........",
    ],
    {
      ".": "empty",
      "#": "outline",
      "d": "dark",
      "m": "mid",
      "l": "light",
      "y": "yellow",
      "g": "gold",
      "r": "red",
      "w": "white",
    },
  );

  const colors = {
    outline: "#2c2b2c",
    dark: "#545357",
    mid: "#808080",
    light: "#fefcfc",
    yellow: "#feff20",
    gold: "#bf9843",
    red: "#fe6a65",
    white: "#fefcfc",
  };

  return renderCompressedSprite(sprite, colors, "umbreon");
}

const MASCOTS: Record<MascotName, (theme: Theme) => string[]> = {
  invader: getInvader,
  charmander: getCharmander,
  umbreon: getUmbreon,
};

const MASCOT_DESCRIPTIONS: Record<MascotName, string> = {
  invader: "Original space invader",
  charmander: "Charmander pixel mascot",
  umbreon: "Umbreon pixel mascot",
};

const MASCOT_ALIASES: Record<string, MascotName> = {
  default: DEFAULT_MASCOT,
  original: "invader",
  "space-invader": "invader",
  phoenix: "charmander",
  bird: "charmander",
  pokemon: "charmander",
  lizard: "charmander",
  eevee: "umbreon",
  moon: "umbreon",
};

function normalizeMascotName(value: string): MascotName | null {
  const normalized = value.trim().toLowerCase();
  if (normalized in MASCOT_ALIASES) return MASCOT_ALIASES[normalized];
  return normalized in MASCOTS ? (normalized as MascotName) : null;
}

function readMascotStateFile(statePath: string): MascotName | null {
  try {
    if (!fs.existsSync(statePath)) return null;
    const raw = fs.readFileSync(statePath, "utf8");
    const parsed = JSON.parse(raw) as Partial<MascotState>;
    if (!parsed.selectedMascot) return DEFAULT_MASCOT;
    return normalizeMascotName(parsed.selectedMascot) ?? DEFAULT_MASCOT;
  } catch {
    return null;
  }
}

function readSelectedMascot(): MascotName {
  return readMascotStateFile(GLOBAL_MASCOT_STATE_PATH)
    ?? readMascotStateFile(LEGACY_LOCAL_MASCOT_STATE_PATH)
    ?? DEFAULT_MASCOT;
}

function writeSelectedMascot(selectedMascot: MascotName): void {
  fs.mkdirSync(path.dirname(GLOBAL_MASCOT_STATE_PATH), { recursive: true });
  fs.writeFileSync(GLOBAL_MASCOT_STATE_PATH, JSON.stringify({ selectedMascot }, null, 2) + "\n", "utf8");
}

function renderMascot(theme: Theme, mascot: MascotName): string[] {
  return MASCOTS[mascot](theme);
}

function closeMenu(ctx: ExtensionContext, mascot: MascotName): void {
  ctx.ui.setHeader((_tui, theme) => ({
    render(): string[] {
      return renderMascot(theme, mascot);
    },
    invalidate() {},
  }));
}

export default function (pi: ExtensionAPI) {
  let menuOpen = false;
  let currentMascot: MascotName = readSelectedMascot();

  pi.on("session_start", async (_event, ctx) => {
    if (!ctx.hasUI) return;

    menuOpen = false;
    currentMascot = readSelectedMascot();
    closeMenu(ctx, currentMascot);
  });

  pi.registerCommand("menu", {
    description: "Open, close, or toggle the startup menu/header",
    getArgumentCompletions: (prefix: string): AutocompleteItem[] | null => {
      const items: AutocompleteItem[] = [
        { value: "open", label: "open", description: "Show built-in startup header" },
        { value: "close", label: "close", description: "Hide startup header details" },
        { value: "toggle", label: "toggle", description: "Toggle current state" },
        { value: "status", label: "status", description: "Show current menu state" },
      ];
      const filtered = items.filter((item) => item.value.startsWith(prefix.trim().toLowerCase()));
      return filtered.length > 0 ? filtered : null;
    },
    handler: async (args, ctx) => {
      if (!ctx.hasUI) return;

      const action = (args || "toggle").trim().toLowerCase();

      if (action === "status") {
        ctx.ui.notify(`Menu ${menuOpen ? "open" : "closed"} · mascot ${currentMascot}`, "info");
        return;
      }

      const shouldOpen = action === "open" ? true : action === "close" ? false : !menuOpen;

      if (shouldOpen) {
        ctx.ui.setHeader(undefined);
        menuOpen = true;
        ctx.ui.notify("Menu open", "info");
        return;
      }

      closeMenu(ctx, currentMascot);
      menuOpen = false;
      ctx.ui.notify(`Menu closed · mascot ${currentMascot}`, "info");
    },
  });

  pi.registerCommand("mascot", {
    description: "Set header mascot: /mascot invader | charmander | umbreon | default",
    getArgumentCompletions: (prefix: string): AutocompleteItem[] | null => {
      const trimmed = prefix.trim().toLowerCase();
      const items: AutocompleteItem[] = [
        ...Object.keys(MASCOTS).map((name) => ({
          value: name,
          label: name,
          description: MASCOT_DESCRIPTIONS[name as MascotName],
        })),
        { value: "default", label: "default", description: `Alias for ${DEFAULT_MASCOT}` },
        { value: "space-invader", label: "space-invader", description: "Alias for invader" },
        { value: "phoenix", label: "phoenix", description: "Alias for charmander" },
        { value: "bird", label: "bird", description: "Alias for charmander" },
        { value: "pokemon", label: "pokemon", description: "Alias for charmander" },
        { value: "eevee", label: "eevee", description: "Alias for umbreon" },
        { value: "moon", label: "moon", description: "Alias for umbreon" },
        { value: "list", label: "list", description: "Show mascot names" },
        { value: "status", label: "status", description: "Show current mascot" },
      ];
      const filtered = items.filter((item) => item.value.startsWith(trimmed));
      return filtered.length > 0 ? filtered : null;
    },
    handler: async (args, ctx) => {
      if (!ctx.hasUI) return;

      const input = (args || "status").trim();
      const action = input.toLowerCase();
      const available = Object.keys(MASCOTS).join(", ");

      if (!input || action === "status") {
        ctx.ui.notify(`Mascot ${currentMascot} · available: ${available}`, "info");
        return;
      }

      if (action === "list") {
        ctx.ui.notify(`Mascots: ${available} · default=${DEFAULT_MASCOT}`, "info");
        return;
      }

      const nextMascot = normalizeMascotName(input);
      if (!nextMascot) {
        ctx.ui.notify(`Unknown mascot: ${input}. Available: ${available}, default`, "warning");
        return;
      }

      currentMascot = nextMascot;
      writeSelectedMascot(currentMascot);

      if (!menuOpen) {
        closeMenu(ctx, currentMascot);
      }

      ctx.ui.notify(`Mascot set to ${currentMascot}`, "success");
    },
  });
}
