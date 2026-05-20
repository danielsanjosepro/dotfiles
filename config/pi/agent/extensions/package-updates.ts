/**
 * Package Updates Extension
 *
 * Shows a minimal blinking dot indicator when package updates are available,
 * with a /show-available-updates command to see details.
 *
 * Requires PI_OFFLINE=1 to suppress the built-in verbose notification.
 */
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { exec } from "child_process";
import { promisify } from "util";

const execAsync = promisify(exec);

interface PackageUpdate {
  name: string;
  current?: string;
  latest?: string;
  type: "npm" | "git";
}

let cachedUpdates: PackageUpdate[] = [];
let checkInProgress = false;
let blinkState = true;
let blinkInterval: ReturnType<typeof setInterval> | undefined;
let lastCtx: ExtensionContext | undefined;

export default function (pi: ExtensionAPI) {
  // Check for updates on session start
  pi.on("session_start", async (_event, ctx) => {
    lastCtx = ctx;

    // Run check in background (don't block startup)
    checkForUpdates(ctx.cwd).then((updates) => {
      cachedUpdates = updates;
      if (updates.length > 0) {
        startBlinkingIndicator(ctx);
      }
    });
  });

  // Command to show available updates
  pi.registerCommand("show-available-updates", {
    description: "Check and show available package updates",
    handler: async (_args, ctx) => {
      lastCtx = ctx;

      if (checkInProgress) {
        ctx.ui.notify("Update check in progress...", "info");
        return;
      }

      // Refresh the check
      ctx.ui.notify("Checking for package updates...", "info");
      const updates = await checkForUpdates(ctx.cwd);
      cachedUpdates = updates;

      if (updates.length === 0) {
        stopBlinkingIndicator(ctx);
        ctx.ui.notify("All packages are up to date!", "success");
        return;
      }

      // Start blinking if not already
      startBlinkingIndicator(ctx);

      // Show the updates
      const lines = updates.map((u) => {
        if (u.current && u.latest) {
          return `  ${u.name}: ${u.current} → ${u.latest}`;
        }
        return `  ${u.name}`;
      });

      const message = [
        "📦 Package Updates Available",
        "",
        ...lines,
        "",
        `Run: pi update`,
      ].join("\n");

      ctx.ui.notify(message, "warning");
    },
  });

  // Cleanup on shutdown
  pi.on("session_shutdown", async (_event, ctx) => {
    stopBlinkingIndicator(ctx);
  });
}

function startBlinkingIndicator(ctx: ExtensionContext) {
  if (blinkInterval) return;

  const updateStatus = () => {
    const dot = blinkState ? "🟡" : "⚫";
    const c = lastCtx || ctx;
    c.ui.setStatus("pkg-updates", `${dot} updates`);
    blinkState = !blinkState;
  };

  updateStatus();
  blinkInterval = setInterval(updateStatus, 800);
}

function stopBlinkingIndicator(ctx: ExtensionContext) {
  if (blinkInterval) {
    clearInterval(blinkInterval);
    blinkInterval = undefined;
  }
  ctx.ui.setStatus("pkg-updates", "");
}

async function checkForUpdates(cwd: string): Promise<PackageUpdate[]> {
  if (checkInProgress) return cachedUpdates;
  checkInProgress = true;

  try {
    const updates: PackageUpdate[] = [];

    // Check pi itself
    try {
      const { stdout: currentVersion } = await execAsync("pi --version", { cwd });
      const { stdout: latestInfo } = await execAsync(
        "npm view @earendil-works/pi-coding-agent version 2>/dev/null || npm view @mariozechner/pi-coding-agent version 2>/dev/null",
        { cwd, timeout: 10000 }
      );
      const current = currentVersion.trim();
      const latest = latestInfo.trim();
      if (current && latest && current !== latest) {
        updates.push({ name: "pi", current, latest, type: "npm" });
      }
    } catch {
      // Ignore errors checking pi version
    }

    // Check installed packages using pi list --json (if available)
    try {
      const { stdout } = await execAsync("pi list --json 2>/dev/null", {
        cwd,
        timeout: 15000,
      });
      const packages = JSON.parse(stdout);

      for (const pkg of packages) {
        if (pkg.hasUpdate) {
          updates.push({
            name: pkg.displayName || pkg.source,
            current: pkg.installedVersion,
            latest: pkg.latestVersion,
            type: pkg.type || "npm",
          });
        }
      }
    } catch {
      // pi list --json might not be available or might fail
      // Fall back to just checking pi version above
    }

    return updates;
  } finally {
    checkInProgress = false;
  }
}
