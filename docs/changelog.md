# Changelog

## Claude Code integration

Added [`coder/claudecode.nvim`](https://github.com/coder/claudecode.nvim)
(`lua/plugins/ai/claudecode.lua`, new `plugins.ai` category imported from
`lua/config/lazy.lua`) for in-editor Claude Code. The plugin only launches the
`claude` CLI and has no model/provider logic of its own; the config forwards
`ANTHROPIC_BASE_URL` / `ANTHROPIC_AUTH_TOKEN` / `ANTHROPIC_MODEL` from the
shell into the Claude terminal when set, so it can be pointed at a
non-Anthropic backend without editing this repo. See [Claude Code](ai.md) for
the full explanation, including why an OpenAI-compatible in-house gateway
needs a translating proxy in front of it (Claude Code speaks Anthropic's
Messages API, not OpenAI's Chat Completions API).

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
