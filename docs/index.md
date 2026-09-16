# nvim-config

A personal, from-scratch Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim).

It favors a small set of well-known plugins — Telescope, Treesitter, nvim-cmp, the
native LSP client via `nvim-lspconfig`/`mason.nvim`, Tokyonight — wired together with
plain Lua and no framework (no LazyVim, no NvChad).

## Highlights

- **Fast startup** — everything is lazy-loaded by `lazy.nvim` on an event, command,
  or keymap, except the colorscheme and a couple of foundational plugins.
- **LSP out of the box** — `mason.nvim` installs the configured language servers,
  `mason-lspconfig.nvim` wires them into `vim.lsp`, and per-server settings (e.g.
  `basedpyright`/`ruff` for Python, `clangd` for C/C++) live in
  [`lua/plugins/lsp/lspconfig.lua`](https://github.com/oradinn/nvim-config/blob/main/lua/plugins/lsp/lspconfig.lua) —
  see [LSP](lsp.md) for language-specific setup, especially the C++ project
  configuration `clangd` needs to resolve `#include`s correctly.
- **Fuzzy everything** — Telescope (backed by the native `fzf` extension) for files,
  live grep, buffers, and LSP pickers.
- **Snippet-aware completion** — `nvim-cmp` + `LuaSnip` + `friendly-snippets`.

## Where to go next

- [Installation](installation.md) — requirements and how to get running.
- [Structure](structure.md) — how the repository is laid out and why.
- [Keymaps](keymaps.md) — every custom keybinding, grouped by area.
- [Plugins](plugins.md) — what each plugin does and where it's configured.
- [LSP](lsp.md) — Python, C++, and markdown rendering setup.
- [AI in Neovim](ai.md) — the CodeCompanion assistant and its in-house LLM setup.
- [Changelog](changelog.md) — notable fixes and changes.
