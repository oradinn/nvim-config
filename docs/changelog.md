# Changelog

## Regenerate the lock file

`lazy-lock.json` hadn't been updated since the initial commit, so
`codecompanion.nvim` and `undotree` (added since) were never pinned — a
fresh install would grab whatever their latest commit happened to be at
install time instead of a known-good one. Ran
`nvim --headless "+Lazy! install" +qa` and committed the result.

Diffed against the pre-existing lock file to confirm nothing unexpected
moved: `codecompanion.nvim` and `undotree` are newly added (as expected,
they had no prior entry), `nvim-treesitter` stayed on `master` at the same
commit it was already pinned to (confirming the branch pin above works),
and every other plugin's commit is unchanged — except `lazy.nvim` itself,
which isn't installed through the lock-file-restore mechanism at all: it
bootstraps itself via a fresh `git clone --branch=stable` in
`lua/config/lazy.lua`, so its own lock entry naturally drifts on any fresh
install regardless of anything in this repo's plugin specs.

## Pin nvim-treesitter to the `master` branch

Upstream's default branch has moved to `main`, which restructures the
plugin's API in a way that's incompatible with this config's
`require("nvim-treesitter.configs").setup(...)`-based setup. Without an
explicit branch, a future install/update would silently switch to `main`
and break treesitter entirely (confirmed while testing this change: a
plain `:Lazy install` run without a pinned branch rewrote
`lazy-lock.json`'s `nvim-treesitter` entry from `master` to `main`, same
commit — an upstream branch rename, not a fork). Added `branch = "master"`
to `lua/plugins/editor/treesitter.lua` with a comment explaining why.

## Remove the nvim_lua completion source (plugin not installed)

`nvim-cmp.lua` listed `{ name = "nvim_lua" }` as a completion source, but
`hrsh7th/cmp-nvim-lua` — the plugin that actually provides it — was never
declared as a dependency. Removed the source and its now-orphaned
`[Lua]` menu label. Updated `docs/plugins.md`.

## Add the missing undotree plugin

`<leader>u` (`lua/core/keymaps.lua`) has always called `:UndotreeShow`, and
`docs/keymaps.md` documented it, but [`mbbill/undotree`](https://github.com/mbbill/undotree)
was never actually declared as a plugin — the command didn't exist. Added
`lua/plugins/editor/undotree.lua`, lazy-loaded on `:UndotreeShow`/`:UndotreeToggle`.
Updated `docs/plugins.md`.

## Fix invalid filename modifier and wrong `J` description

`lua/core/keymaps.lua`'s "copy relative path" keymap used
`expand("%:f")` — `:f` is not a valid Vim filename modifier (the
documented set is `:p`, `:8`, `:~`, `:.`, `:h`, `:t`, `:r`, `:e`,
`:s`/`:gs`); the cwd-relative path modifier is `:.`. Fixed to
`expand("%:.")`.

Also fixed the normal-mode `J` keymap's description — it joins the line
below into the current one and keeps the cursor in place, not "move down".

## Fix lost diagnostic/telescope/lualine icons (again)

A previous edit that replaced corrupted `?` icon glyphs (see "Restructure
and fixes" below) itself lost most of those glyphs somewhere along the way:
`lspconfig.lua`'s ERROR/WARN/INFO diagnostic sign texts had become plain
spaces (only HINT still had a glyph), `telescope.lua`'s `selection_caret`
was just a space, and `lualine.lua`'s `section_separators` were empty
strings — confirmed by printing each string's codepoints rather than by
looking at the glyphs in an editor.

This time each glyph is written as a `\u{...}` Lua escape instead of a
literal character, so a tool that mangles non-ASCII bytes can't silently
strip it again:

- `lspconfig.lua` diagnostic signs: ERROR `\u{f057}`, WARN `\u{f071}`,
  INFO `\u{f05a}`, HINT `\u{f0eb}`.
- `telescope.lua` `selection_caret`: `\u{f054} `.
- `lualine.lua` `section_separators`: left `\u{e0b0}`, right `\u{e0b2}`.

Verified by loading each plugin file directly (not lazy.nvim) and printing
the resulting strings' codepoints via `vim.fn.str2list` — confirmed to
match exactly, from the actual committed files rather than re-typed
strings.

## Fix tokyonight transparency being ignored

`lua/plugins/ui/tokyonight.lua`'s custom `config` function called
`vim.cmd.colorscheme("tokyonight")` directly without ever passing `opts` to
`require("tokyonight").setup(...)` — lazy.nvim only auto-applies `opts` when
there's no custom `config` function, so `style = "moon"` and
`transparent = true` were silently ignored. Fixed by taking `opts` as the
function's second argument and passing it through to `setup()` explicitly,
before applying the colorscheme.

## Fix `<leader>d` keymap conflict

`lua/core/keymaps.lua` maps `<leader>d` (normal and visual) to delete-to-void,
but `lua/plugins/lsp/lspconfig.lua` also mapped `<leader>d` (normal only) to
`vim.diagnostic.open_float`, silently overriding the delete-to-void mapping
in normal mode. Moved line diagnostics to `<leader>cd` (grouped with the
other LSP `<leader>c*` code-related keymaps) so both mappings work as
intended. Updated `docs/keymaps.md`.

## Removed Claude Code, settled on CodeCompanion

Removed `coder/claudecode.nvim` (`lua/plugins/ai/claudecode.lua`) entirely.
It was added first, but Claude Code only speaks Anthropic's Messages API,
and the in-house LLM gateway this config targets turned out to be
OpenAI-compatible — confirmed by an existing working `opencode.json` config
using `@ai-sdk/openai-compatible` against the same gateway, and by Claude
Code itself returning `400: System message must be at the beginning` (an
OpenAI Chat Completions validation message, not an Anthropic one) against it.
[`olimorris/codecompanion.nvim`](https://github.com/olimorris/codecompanion.nvim)
(`lua/plugins/ai/codecompanion.lua`, added in the same change that removed
Claude Code) talks that same OpenAI-compatible shape directly via its
`openai_compatible` adapter, with no translation layer needed. See
[AI in Neovim](ai.md).

## Claude Code integration (removed, see above)

Added `coder/claudecode.nvim` (`lua/plugins/ai/claudecode.lua`, new
`plugins.ai` category imported from `lua/config/lazy.lua`) for in-editor
Claude Code. The plugin only launched the `claude` CLI and had no
model/provider logic of its own; the config forwarded `ANTHROPIC_BASE_URL` /
`ANTHROPIC_AUTH_TOKEN` / `ANTHROPIC_MODEL` from the shell into the Claude
terminal when set, so it could be pointed at a non-Anthropic backend without
editing this repo.

## Restructure and fixes

Reorganized `lua/plugins/` into `ui/`, `editor/`, `lsp/`, and `completion/`
subfolders (see [Structure](structure.md)), added this documentation site, and
fixed the following issues found while going through the configuration:

- **`init.lua`**: removed a leftover `vim.lsp.set_log_level("debug")` call that
  forced verbose LSP logging on every startup, writing heavily to `lsp.log` in
  normal use.
- **`lua/config/lazy.lua`**: `lazy.nvim`'s `import` only goes one directory
  level deep per call (a subfolder is picked up automatically only if it has
  its own `init.lua`). A first pass at this restructure assumed a single
  `{ import = "plugins" }` would recurse into every category subfolder,
  removed the explicit `{ import = "plugins.lsp" }` on that assumption, and
  broke startup (`No specs found for module "plugins"`) once every plugin
  file lived one level deeper than `lua/plugins/`. Fixed by importing each
  category explicitly: `{ import = "plugins.completion" }`,
  `{ import = "plugins.editor" }`, `{ import = "plugins.lsp" }`,
  `{ import = "plugins.ui" }`.
- **`lua/plugins/completion/nvim-cmp.lua`**: the completion `sources` list had
  `nvim_lua`, `luasnip`, `buffer`, `path`, and `emoji` each duplicated, and
  `nvim_lsp` wasn't prioritized — completion menus showed duplicate entries.
  Sources are now deduplicated and split into a priority group (`nvim_lsp`,
  `nvim_lua`, `luasnip`) and a fallback group (`buffer`, `path`, `emoji`).
- **`lua/plugins/lsp/lspconfig.lua`**: the `pylsp` settings block (formatter,
  linter, type checker, import sorting options) was commented out behind
  `--DEBUG--` markers, so `pylsp` — despite being installed via Mason — ran
  with defaults only. Restored it as live configuration.
- **Corrupted icon glyphs**: several Unicode icons had been mangled into a
  literal `?` (confirmed by inspecting the raw bytes — plain `0x3f`, not a
  multi-byte codepoint), in:
  - `lua/core/options.lua` (`listchars.nbsp`/`.trail`)
  - `lua/plugins/editor/telescope.lua` (`prompt_prefix`, `selection_caret`)
  - `lua/plugins/ui/lualine.lua` (`component_separators`, `section_separators`)
  - `lua/plugins/lsp/lspconfig.lua` (diagnostic sign text for error/warn/info/hint)

  Replaced with proper glyphs; a [Nerd Font](https://www.nerdfonts.com/) is
  required for these (and for `nvim-web-devicons`, already a dependency of
  several plugins here) to render correctly.
- **`lua/plugins/ui/tokyonight.lua`**: `transparent = "true"` was a string, not
  a boolean; changed to `transparent = true`. Also fixed inconsistent
  indentation in the plugin spec.
- **`lua/core/keymaps.lua`**:
  - Fixed typos in keymap descriptions ("realtive" → "relative", "middke" →
    "middle").
  - The visual-mode `J`/`K` "move block of text" keymaps had their
    descriptions swapped (`J`, which moves the selection down, was labeled
    "up" and vice versa).
  - The `<leader>p` (paste-over-selection) keymap was labeled `"Cut"`, which
    doesn't describe what it does; relabeled to "Paste over selection without
    overwriting register".
