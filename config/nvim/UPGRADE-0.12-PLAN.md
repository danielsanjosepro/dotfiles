# Neovim 0.12 migration plan for this config

## Quick facts

- You are already running **Neovim 0.12.1**.
- Your config is still structurally **Kickstart-based**, but it has grown into a mixed setup:
  - Kickstart core in `init.lua`
  - Kickstart extras in `lua/kickstart/plugins/*`
  - custom plugins in `lua/custom/plugins/*`
- Current plugin graph is about **44 plugins**.

## What changed in Neovim 0.12 that matters here

### 1. Built-in plugin manager: `vim.pack`

Neovim 0.12 adds a built-in plugin manager via `vim.pack`.

What it gives you:
- install / update / delete plugins
- lockfile support
- native workflow

What it does **not** replace:
- Mason for LSP/formatter/debugger binaries
- the richer lazy-loading/dependency ergonomics you currently get from `lazy.nvim`

### 2. Native LSP config flow is much better

Neovim now has a cleaner built-in LSP flow:
- `vim.lsp.config()`
- `vim.lsp.enable()`
- better default LSP integration

This means you can move away from the older pattern:
- `require('lspconfig')[server].setup(...)`
- `mason-lspconfig` handler boilerplate

A good middle ground is:
- keep `nvim-lspconfig` for server definitions
- stop using its old `setup()` style
- use `vim.lsp.config()` + `vim.lsp.enable()` in your own config

### 3. Native popup completion exists

Neovim 0.12 ships `vim.lsp.completion`.

This can replace **part** of what `blink.cmp` does if your goal is minimalism.

What it is good for:
- LSP completion menu
- built-in completion UI
- accepting LSP completion items with edits/snippets/imports

What you lose compared to `blink.cmp`:
- richer menu UI
- extra completion sources integration
- polished UX/features around snippets/path/source decoration

### 4. Native inline completion exists

Neovim 0.12 also has `vim.lsp.inline_completion`.

This is the most interesting change for your Copilot question.

Instead of using `zbirenbaum/copilot.lua`, you can use:
- Copilot language server
- `vim.lsp.inline_completion.enable()`
- `vim.lsp.inline_completion.get()`

This is a much better fit if your goal is:
- minimal config
- ghost-text style AI completion
- fewer plugin-specific layers

## Current config: what stands out

## Good candidates to keep

These still make sense even in a minimal setup:
- `nvim-treesitter`
- `nvim-lspconfig`
- `conform.nvim` (if you want formatter routing)
- `telescope.nvim` or `oil.nvim` depending on taste
- `gitsigns.nvim`
- your colorscheme
- `lazydev.nvim` if you edit your Neovim config in Lua

## Good candidates to remove or defer

These are not minimal-core items:
- `kickstart.plugins.debug`
- `noice.nvim`
- `trouble.nvim`
- `snacks.nvim`
- `marks.nvim`
- `hop.nvim`
- `iron.nvim`
- `render-markdown.nvim`
- `typst-preview.nvim` (keep only if you really use Typst often)
- `lspkind.nvim`

## Current issues worth fixing before any bigger migration

These should be cleaned up first.

### 1. Treesitter custom plugin spec is using stale patterns

File:
- `lua/custom/plugins/treesitter.lua`

Problems:
- uses `after` and `requires` style fields
- calls `require('nvim-treesitter.configs').setup(...)` in `init`
- this is a bad fit for `lazy.nvim` ordering

Observed symptom during headless startup:
- `module 'nvim-treesitter.configs' not found`

Meaning:
- your Treesitter extension layer is already fragile
- this should be rewritten with proper `dependencies`, `opts`, or `config`

### 2. `render-markdown.nvim` is configured too early

File:
- `lua/custom/plugins/markdown.lua`

Problem:
- it calls `require('render-markdown').setup()` from `init`

Observed symptom:
- it fails during startup in headless mode

Meaning:
- this should be `opts = {}` or `config = function() ... end`
- not `init`

### 3. `vim.textwidth = 79` is not the right option API

Files:
- `init.lua`
- `lua/custom/config/set.lua`

Problem:
- this should be `vim.o.textwidth = 79` or `vim.opt.textwidth = 79`
- current assignment likely does nothing useful

### 4. duplicated / dead settings layer

File:
- `lua/custom/config/set.lua`

Problem:
- it duplicates settings already present in `init.lua`
- I could not find it being required anywhere

Meaning:
- dead file
- good deletion target

### 5. stale `noice` override

File:
- `lua/custom/plugins/noice.lua`

Problem:
- it overrides `cmp.entry.get_documentation`
- but your config uses `blink.cmp`, not `nvim-cmp`

Meaning:
- likely leftover config
- probably removable

### 6. `lspkind.nvim` may now be dead weight

File:
- `lua/custom/plugins/lspkind.lua`

Problem:
- I do not see it wired into `blink.cmp`
- if you move to built-in completion, it is definitely unnecessary

## Recommended strategy

## Recommendation summary

Do **not** switch everything at once.

Best path:
1. clean current config
2. split it out of Kickstart shape
3. simplify LSP stack
4. replace completion stack
5. only then decide whether `lazy.nvim` should become `vim.pack`

## Phase 0 — create a safe migration sandbox

Use a parallel app name instead of rewriting your daily config first.

Recommended:
- keep current config as-is
- create a new config target like `nvim-next` or `nvim-min`
- test with `NVIM_APPNAME=nvim-next nvim`

Why:
- safest way to migrate slowly
- lets you compare behavior side-by-side
- avoids breaking your current editor during the transition

## Phase 1 — strip Kickstart structure, but keep behavior

Goal:
- remove Kickstart shape without changing editor behavior much

Suggested target structure:

```text
config/nvim/
  init.lua
  lua/config/options.lua
  lua/config/keymaps.lua
  lua/config/autocmds.lua
  lua/config/lsp.lua
  lua/config/diagnostics.lua
  lua/plugins/init.lua
  lua/plugins/editor.lua
  lua/plugins/lsp.lua
  lua/plugins/ui.lua
```

Tasks:
- move raw options out of `init.lua`
- move your custom commands/autocmds into `lua/config/*`
- move plugin specs into your own `lua/plugins/*`
- stop importing Kickstart extras unless you still truly want them
- remove `kickstart.plugins.debug` if DAP is not core for you
- delete dead file `lua/custom/config/set.lua`

Outcome:
- still uses `lazy.nvim`
- still feels familiar
- no longer mentally tied to Kickstart

## Phase 2 — simplify the LSP stack

Current stack:
- `nvim-lspconfig`
- `mason.nvim`
- `mason-lspconfig.nvim`
- `mason-tool-installer.nvim`
- `blink.cmp`
- `LuaSnip`
- `lazydev.nvim`

This is where most of the config complexity lives.

### Recommended target

Use:
- `nvim-lspconfig`
- `vim.lsp.config()`
- `vim.lsp.enable()`
- optionally `mason.nvim` only for installing binaries
- optionally `conform.nvim` for formatting

Drop:
- `mason-lspconfig.nvim`
- `mason-tool-installer.nvim`
- old `handlers = { function(server_name) ... }` setup pattern

Why this is a good middle ground:
- much less glue code
- still benefits from server definitions from `nvim-lspconfig`
- native Neovim API becomes the top-level interface

### Practical direction

Keep a file like `lua/config/lsp.lua` that does this kind of work:
- global diagnostics config
- `LspAttach` keymaps
- shared capabilities if needed
- `vim.lsp.config('pyright', { ... })`
- `vim.lsp.config('ruff', { ... })`
- `vim.lsp.config('lua_ls', { ... })`
- `vim.lsp.enable({ 'pyright', 'ruff', 'lua_ls' })`

### Mason decision

Important:
- `vim.pack` is for plugins
- Mason is for external tools

So the real decision is:

#### Option A — keep Mason, but only Mason
Use Mason only to install binaries.
Drop its extra integration layers.

This is the easiest transition.

#### Option B — remove Mason entirely
Install tools with system package managers:
- `uv` / `pipx`
- `npm`
- distro packages
- `mise` / `asdf`

This is the cleanest long-term minimal setup, but more manual.

My recommendation:
- **keep Mason for now only if you want convenience**
- otherwise remove it once your tool install workflow is stable outside Neovim

## Phase 3 — replace `blink.cmp` with native completion

This is the biggest UX decision.

### What makes sense for your goal

If your target is **super minimal**, native completion is worth trying.

Use:
- `vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })`
- builtin insert completion menu

Then remove:
- `blink.cmp`
- `LuaSnip` unless you explicitly still want snippets
- blink-specific LSP capability wiring
- `lspkind.nvim`

### When not to do this

Do **not** do this yet if you strongly depend on:
- rich popup menu behavior
- snippet workflow
- non-LSP completion sources in one menu
- polished path/source decoration

### My recommendation

Try native completion in the parallel config first.
If it feels good enough, remove `blink.cmp`.
If it feels too bare, keep `blink.cmp` and simplify elsewhere first.

## Phase 4 — replace `copilot.lua` with native inline completion

This is the cleanest “new 0.12” win for your setup.

### Recommended target

Replace:
- `zbirenbaum/copilot.lua`

With:
- Copilot language server
- `vim.lsp.config('copilot', { ... })`
- `vim.lsp.enable('copilot')`
- `vim.lsp.inline_completion.enable()`
- a keymap to accept inline suggestions

### Why this makes sense

Your current Copilot setup is plugin-specific and fairly large.
Neovim 0.12 now has a native model for this kind of UX.

This aligns with your goals:
- less plugin glue
- simpler mental model
- closer to native Neovim

### Caveat

This is best for **inline suggestion** workflow.
If you rely on Copilot panel-specific UX, native inline completion will feel more minimal and less feature-rich.

## Phase 5 — decide on `lazy.nvim` vs `vim.pack`

This should be the **last** step, not the first.

### My recommendation

For your config, I would **not** switch to `vim.pack` immediately.

Reason:
- you are still reducing plugins
- you still have some broken specs to clean up
- `lazy.nvim` is currently the lowest-risk layer in the config

### When `vim.pack` becomes attractive

It makes more sense once:
- plugin list is much smaller
- plugin loading is simple
- you no longer need much lazy-loading logic
- you are okay with a more native/manual plugin workflow

### Suggested rule

If you get down to roughly a small, stable core plugin set, then try `vim.pack`.
Until then, keep `lazy.nvim` and simplify the rest first.

## My concrete recommendation for your target state

## Best near-term target

A minimal-but-practical config probably looks like this:

Core:
- `lazy.nvim` for now
- `nvim-lspconfig`
- `nvim-treesitter`
- `conform.nvim` (optional but useful)
- `gitsigns.nvim`
- one finder/file browser choice: `telescope.nvim` **or** `oil.nvim`
- one colorscheme

Optional but reasonable:
- `lazydev.nvim` for Lua config editing
- Copilot via native LSP inline completion

Likely removable:
- `blink.cmp`
- `LuaSnip`
- `copilot.lua`
- `mason-lspconfig.nvim`
- `mason-tool-installer.nvim`
- `lspkind.nvim`
- most Kickstart extras

## Validation plan

Any migration should prove two things:
1. startup is clean
2. your daily workflows still work

## Validation level 1 — startup smoke tests

Run these on the migration config, not your live one.

### Must pass

- headless startup exits cleanly
- no Lua errors during startup
- no plugin ordering errors
- no missing module errors

Suggested checks:
- `NVIM_APPNAME=nvim-next nvim --headless '+qa'`
- `NVIM_APPNAME=nvim-next nvim --headless '+checkhealth vim.lsp' '+qa'`
- `NVIM_APPNAME=nvim-next nvim --headless '+checkhealth provider' '+qa'`

## Validation level 2 — LSP checks

For each important language you use, open a real file and verify:
- LSP attaches
- diagnostics appear
- go to definition works
- rename works
- formatting works
- completion works

Suggested manual checks:
- `:lua =vim.lsp.get_clients({ bufnr = 0 })`
- `:checkhealth vim.lsp`
- `gd`, rename, code action, hover

Languages to test first from your current config:
- Lua
- Python
- Typst (if it is important in your workflow)

## Validation level 3 — completion checks

If moving to native completion:
- confirm menu appears on trigger characters
- confirm manual trigger works
- confirm accept applies edits/imports
- confirm snippet/text edit behavior is acceptable

If moving Copilot to native inline completion:
- confirm Copilot LSP attaches
- confirm inline suggestion appears in insert mode
- confirm accept key works
- confirm fallback behavior is sane when no suggestion exists

## Validation level 4 — workflow checks

Verify the things you actually use every day:
- file finding
- grep/search
- git hunk signs
- formatting on save
- markdown rendering if you keep it
- Typst preview if you keep it
- REPL workflow if you keep `iron.nvim`

## Validation level 5 — regression script idea

Once changes start landing, add a tiny smoke-test script for the config.

Example goals for a future script:
- start Neovim headless with the migration app name
- open a Lua file and a Python file
- wait briefly for plugins/LSP
- fail if `v:errors` is non-empty
- optionally print attached LSP clients

This gives you a repeatable way to validate future cleanup.

## Order I would do the work in

1. create parallel config (`NVIM_APPNAME=nvim-next`)
2. remove dead/fragile pieces first
   - fix `treesitter.lua`
   - fix `markdown.lua`
   - remove dead `custom/config/set.lua`
   - fix `vim.textwidth`
3. split config out of Kickstart-shaped `init.lua`
4. move LSP setup to native `vim.lsp.config()` + `vim.lsp.enable()`
5. remove `mason-lspconfig` and `mason-tool-installer`
6. trial native `vim.lsp.completion`
7. if good enough, remove `blink.cmp` + `LuaSnip`
8. move Copilot to native inline completion
9. only then decide whether to keep `lazy.nvim` or try `vim.pack`

## Bottom line

What makes the most sense here:

- **Yes** to moving away from Kickstart structure now.
- **Yes** to moving toward native `vim.lsp.config()` / `vim.lsp.enable()`.
- **Yes** to seriously testing native inline completion for Copilot.
- **Maybe** to replacing `blink.cmp` with built-in completion — test first.
- **Not yet** to replacing `lazy.nvim` with `vim.pack`.

If you want, next step I can turn this plan into a concrete `nvim-next` file layout and start with Phase 1 cleanup.