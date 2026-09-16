# Keymaps

Leader key is `<Space>`. Press `<leader>?` at any time to open
[which-key](https://github.com/folke/which-key.nvim) and browse everything
available from the current mode/buffer.

## CodeCompanion (`lua/plugins/ai/codecompanion.lua`)

See [AI in Neovim](ai.md) for setup and how it connects to an OpenAI-compatible
in-house LLM.

| Mode | Keys | Action |
|---|---|---|
| n, v | `<leader>ai` | Toggle the CodeCompanion chat |
| n, v | `<leader>ap` | Open the CodeCompanion action palette |
| v | `<leader>av` | Add selection to the CodeCompanion chat |

## General (`lua/core/keymaps.lua`)

| Mode | Keys | Action |
|---|---|---|
| n | `<leader><F1>` | Copy absolute path of current file to the clipboard |
| n | `<leader><F2>` | Copy relative path of current file to the clipboard |
| n | `<leader><F3>` | Copy filename of current file to the clipboard |
| n | `<leader>pv` | Open netrw (file explorer) |
| n | `<leader>u` | Show the undo tree (`:UndotreeShow`) |
| v | `J` | Move the selected block down one line |
| v | `K` | Move the selected block up one line |
| n | `J` | Join line below, keep cursor position |
| n | `<C-d>` | Half-page down, keep cursor centered |
| n | `<C-u>` | Half-page up, keep cursor centered |
| n | `n` | Next search match, centered |
| n | `N` | Previous search match, centered |
| x | `<leader>p` | Paste over selection without overwriting the unnamed register |
| n, v | `<leader>y` | Yank to the system clipboard |
| n | `<leader>Y` | Yank line to the system clipboard |
| n, v | `<leader>d` | Delete to the void register |
| t | `<Esc>` | Exit terminal mode |

## LSP (`lua/plugins/lsp/lspconfig.lua`)

Active once `nvim-lspconfig` attaches to a buffer.

| Mode | Keys | Action |
|---|---|---|
| n, v | `<leader>ca` | Code action |
| n | `gR` | LSP references (Telescope) |
| n | `gD` | Go to declaration |
| n | `gd` | LSP definitions (Telescope) |
| n | `gi` | LSP implementations (Telescope) |
| n | `gt` | LSP type definitions (Telescope) |
| n | `gs` | Signature help |
| n | `<leader>rn` | Smart rename |
| n | `<leader>D` | Buffer diagnostics (Telescope) |
| n | `<leader>d` | Line diagnostics (floating window) |
| n | `[d` / `]d` | Previous / next diagnostic |
| n | `K` | Hover documentation |
| n, x | `<leader>F` | Format buffer |
| n | `<leader>rs` | Restart the LSP client (`:LspRestart`) |

## Telescope (`lua/plugins/editor/telescope.lua`)

| Mode | Keys | Action |
|---|---|---|
| n | `<leader>ff` | Find files |
| n | `<leader>fg` | Live grep |
| n | `<leader>fb` | List buffers |
| n | `<leader>fx` | Grep the word under the cursor |
| i | `<C-j>` / `<C-k>` | Next / previous item in the picker |

## File explorer (`lua/plugins/editor/nvim-tree.lua`)

| Mode | Keys | Action |
|---|---|---|
| n | `<leader>e` | Toggle nvim-tree, focused on the current file |

## Completion (`lua/plugins/completion/nvim-cmp.lua`)

Active while the completion menu is open (insert / command-line mode).

| Keys | Action |
|---|---|
| `<C-j>` / `<C-k>` | Next / previous suggestion |
| `<C-b>` / `<C-f>` | Scroll documentation |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort completion |
| `<CR>` | Confirm selection |

## Treesitter (`lua/plugins/editor/treesitter.lua`)

| Mode | Keys | Action |
|---|---|---|
| n, v | `<C-Space>` | Init/grow incremental selection to the enclosing node |
| n, v | `<BS>` | Shrink incremental selection |

## Which-key (`lua/plugins/editor/whichkey.lua`)

| Mode | Keys | Action |
|---|---|---|
| n | `<leader>?` | Show all keymaps available from the current buffer |
