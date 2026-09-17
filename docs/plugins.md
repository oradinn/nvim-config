# Plugins

Each plugin is declared in its own file under `lua/plugins/`, grouped by purpose
into subfolders that are each imported explicitly from `lua/config/lazy.lua` —
see [Structure](structure.md) for why.

## AI

| Plugin | File | Notes |
|---|---|---|
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | `ai/codecompanion.lua` | General-purpose AI assistant (Cline equivalent) wired to a custom OpenAI-compatible endpoint via the community `openai_compatible` adapter. See [AI in Neovim](ai.md) for setup. |

## Completion

| Plugin | File | Notes |
|---|---|---|
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | `completion/nvim-cmp.lua` | Completion engine. Sources are ordered by priority: `nvim_lsp` / `luasnip` first, `buffer` / `path` / `emoji` as fallback. |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) + [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | same file | Snippet engine and a ready-made snippet collection, loaded lazily on `InsertEnter`. |
| [lspkind.nvim](https://github.com/onsails/lspkind.nvim) | same file | Adds VS Code-style icons and a `[LSP]`/`[Buffer]`/... suffix to completion entries. |

## Editor

| Plugin | File | Notes |
|---|---|---|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | `editor/telescope.lua` | Fuzzy finder for files, grep, buffers, and LSP pickers, backed by `telescope-fzf-native.nvim` for speed. |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | `editor/nvim-tree.lua` | File explorer sidebar, toggled with `<leader>e`. |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | `editor/treesitter.lua` | Syntax highlighting, indentation, and incremental selection for the languages listed in `ensure_installed`. |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | `editor/whichkey.lua` | Popup that shows available keybindings as you type a prefix. |
| [undotree](https://github.com/mbbill/undotree) | `editor/undotree.lua` | Visual undo history, toggled with `<leader>u`. |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | `editor/plenary.lua` | Lua utility library other plugins (Telescope in particular) depend on. |

## LSP

| Plugin | File | Notes |
|---|---|---|
| [mason.nvim](https://github.com/mason-org/mason.nvim) + [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | `lsp/mason.lua` | Installs and manages the language servers listed in `ensure_installed` (`lua_ls`, `pylsp`, `clangd`) and enables them automatically (`automatic_enable = true`). |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | `lsp/lspconfig.lua` | LSP keymaps, diagnostic sign customization, and per-server settings (e.g. `pylsp`'s formatter/linter plugins). |
| [nvim-lsp-file-operations](https://github.com/antosha417/nvim-lsp-file-operations) | same file | Keeps imports in sync when files are renamed/moved via nvim-tree. |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | same file | Configures the Lua LSP for editing this very Neovim config (adds `vim` globals, etc). |

## UI

| Plugin | File | Notes |
|---|---|---|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | `ui/tokyonight.lua` | Colorscheme, `moon` variant, transparent background. Loaded eagerly (`lazy = false`) since it's needed at startup. |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | `ui/lualine.lua` | Statusline: mode, git branch/diff, diagnostics, filename, pending `lazy.nvim` update count, encoding/format/filetype, progress, location. |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | `ui/bufferline.lua` | Tab-like buffer line at the top, with an offset reserved for the nvim-tree sidebar. |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | `ui/devicons.lua` | Shared file-type icon set used by nvim-tree, Telescope, bufferline, and lualine. Requires a [Nerd Font](https://www.nerdfonts.com/). |

## Adding a plugin

1. Create a new file under the subfolder that matches the plugin's purpose
   (`ui/`, `editor/`, `lsp/`, or `completion/`).
2. Return a single [lazy.nvim plugin spec](https://lazy.folke.io/spec) table from
   that file.
3. Restart Neovim, or run `:Lazy sync`, to install it.

If the plugin doesn't fit any existing subfolder, create a new one **and** add
a matching `{ import = "plugins.<name>" }` line in `lua/config/lazy.lua` — see
[Structure](structure.md) for why that explicit import is required.
