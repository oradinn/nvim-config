# Installation

## Requirements

| Tool | Why |
|---|---|
| [Neovim](https://neovim.io/) ≥ 0.10 (0.11+ recommended) | `vim.lsp.config`/`vim.lsp.enable` used in [`lspconfig.lua`](https://github.com/oradinn/nvim-config/blob/main/lua/plugins/lsp/lspconfig.lua) need a recent LSP client. |
| `git` | Used by `lazy.nvim` to bootstrap itself and to clone plugins. |
| A C compiler (`make`, `gcc`/`clang`) | Builds `telescope-fzf-native.nvim` and `LuaSnip`'s optional `jsregexp`. |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) | Powers `<leader>fg` / `<leader>fx` (Telescope live grep). |
| A [Nerd Font](https://www.nerdfonts.com/) | Required for file icons (`nvim-web-devicons`), the statusline, bufferline, and diagnostic signs to render correctly instead of as `?`/boxes. |
| `node`, `python3`, etc. (optional) | Only needed if you `:Mason`-install language servers that require them. |

## Setup

1. Back up any existing configuration:

   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   ```

2. Clone this repository into `~/.config/nvim`:

   ```bash
   git clone https://github.com/oradinn/nvim-config.git ~/.config/nvim
   ```

3. Start Neovim. `lazy.nvim` bootstraps itself on first launch and installs every
   plugin declared under `lua/plugins/`:

   ```bash
   nvim
   ```

4. Once plugins are installed, open `:Mason` and confirm `lua_ls`, `basedpyright`,
   `ruff`, and `clangd` (the servers listed in [`mason.lua`](https://github.com/oradinn/nvim-config/blob/main/lua/plugins/lsp/mason.lua)) installed successfully.

## Keeping it up to date

`lazy.nvim`'s update checker runs automatically (see `lua/config/lazy.lua`) and
surfaces available plugin updates as an icon in the statusline (via
`lualine.nvim`'s `lazy.status` component). Run `:Lazy update` to apply them, and
`:Lazy` any time to open the plugin manager UI.

`:Lazy update` rewrites `lazy-lock.json` with the new commit for every updated
plugin — **commit that diff right after verifying the update works**, in the
same change. `lazy-lock.json` is what makes an install reproducible (same role
as `package-lock.json`/`Cargo.lock`): a plugin added or updated without its
lock entry committed means a fresh install elsewhere silently grabs whatever
that plugin's latest commit happens to be at install time, instead of the
version you actually tested. This has bitten this repo before — see
[Changelog → Regenerate the lock file](changelog.md#regenerate-the-lock-file).
