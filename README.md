# nvim-config

A personal, from-scratch Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim) —
Telescope, Treesitter, native LSP (`nvim-lspconfig` + `mason.nvim`), `nvim-cmp`,
Claude Code, and Tokyonight, wired together with plain Lua.

## Quick start

```bash
git clone https://github.com/oradinn/nvim-config.git ~/.config/nvim
nvim
```

Plugins install automatically on first launch. See
[**Installation**](docs/installation.md) for requirements (Nerd Font, ripgrep, a
C compiler) and details.

## Documentation

The full docs — installation, repository structure, every keymap, and what
each plugin does — are written with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)
under [`docs/`](docs/):

- [Home](docs/index.md)
- [Installation](docs/installation.md)
- [Structure](docs/structure.md)
- [Keymaps](docs/keymaps.md)
- [Plugins](docs/plugins.md)
- [Claude Code](docs/ai.md)
- [Changelog](docs/changelog.md)

To browse them as a rendered site locally:

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r docs/requirements.txt
mkdocs serve   # http://127.0.0.1:8000
```

`mkdocs build` produces a static `site/` directory you can host anywhere
(GitHub Pages, Netlify, a plain file server, ...).

## Repository layout

```text
init.lua                 -- entry point
lua/core/                -- options & keymaps that don't depend on any plugin
lua/config/lazy.lua       -- bootstraps lazy.nvim
lua/plugins/
  ai/                     -- Claude Code IDE integration
  completion/             -- nvim-cmp, LuaSnip
  editor/                 -- telescope, nvim-tree, treesitter, which-key
  lsp/                    -- mason.nvim, nvim-lspconfig
  ui/                      -- statusline, bufferline, icons, colorscheme
docs/                     -- this documentation site
```

See [`docs/structure.md`](docs/structure.md) for the reasoning behind this
layout and the conventions to follow when adding a plugin.

## License

Personal configuration, shared as-is — use whatever is useful to you.
