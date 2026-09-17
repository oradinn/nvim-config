-- On définit notre touche leader sur espace
vim.g.mapleader = " "


-- absolute path to clipboard
vim.keymap.set("n", "<leader><F1>", ":let @+ = expand(\"%:p\")<CR>", {desc = "Copy absolute path to clipboard", noremap = true})
-- relative path to clipboard
vim.keymap.set("n", "<leader><F2>", ":let @+ = expand(\"%:.\")<CR>", {desc = "Copy relative path to clipboard", noremap = true})
-- filename to clipboard
vim.keymap.set("n", "<leader><F3>", ":let @+ = expand(\"%:t\")<CR>", {desc = "Copy filename to clipboard", noremap = true})

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {desc = "Go back to Explorer"})
vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>", {desc = "Show undotree window"})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move block of text down"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move block of text up"})


vim.keymap.set("n", "J", "mzJ`z", {desc = "Join line below, keep cursor position"})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc = "Page down but keep cursor in the middle" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc = "Page up but keep cursor in the middle" })
vim.keymap.set("n", "n", "nzzzv", {desc = "Go to next occurrence but keep cursor in the middle"})
vim.keymap.set("n", "N", "Nzzzv", {desc = "Go to prev occurrence but keep cursor in the middle"})

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], {desc = "Paste over selection without overwriting register"})

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {desc = "Copy selection to system clipboard"})
vim.keymap.set("n", "<leader>Y", [["+Y]], {desc = "Copy line to system clipboard"})

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", {desc = "Delete to void register"})

-- terminal mode
vim.keymap.set( "t", "<Esc>", "<C-\\><C-n>", {noremap = true, silent = true, desc = "Back to normal mode from terminal"})
