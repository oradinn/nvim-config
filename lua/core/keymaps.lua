-- On définit notre touche leader sur espace
vim.g.mapleader = " "


-- absolute path to clipboard
vim.keymap.set("n", "<leader><F1>", ":let @+ = expand(\"%:p\")<CR>", {desc = "Copy absolute path to clipboard", noremap = true})
-- relative path to clipboard
vim.keymap.set("n", "<leader><F2>", ":let @+ = expand(\"%:.\")<CR>", {desc = "Copy relative path to clipboard", noremap = true})
-- filename to clipboard
vim.keymap.set("n", "<leader><F3>", ":let @+ = expand(\"%:t\")<CR>", {desc = "Copy filename to clipboard", noremap = true})
-- current buffer's directory to clipboard
vim.keymap.set("n", "<leader><F4>", ":let @+ = expand(\"%:p:h\")<CR>", {desc = "Copy buffer's directory to clipboard", noremap = true})

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

-- Ouvre un terminal dans un split, avec le répertoire de travail réglé sur
-- `dir` (local à la fenêtre du terminal via :lcd, donc sans effet sur les
-- autres fenêtres/buffers). :lcd ne fixe que le répertoire de départ du
-- process : si le shell est interactif, son rc (~/.bashrc, etc.) peut lancer
-- son propre `cd` après coup et l'écraser. On envoie donc explicitement un
-- `cd` dans le terminal une fois le shell démarré, pour avoir le dernier mot.
local function open_terminal_in(dir)
  vim.cmd("botright split")
  vim.cmd.lcd(dir)
  vim.cmd.terminal()
  vim.fn.chansend(vim.bo.channel, "cd " .. vim.fn.shellescape(dir) .. "\n")
  vim.cmd.startinsert()
end

vim.keymap.set("n", "<leader>tt", function()
  open_terminal_in(vim.fn.expand("%:p:h"))
end, {desc = "Open terminal in current buffer's directory"})

vim.keymap.set("n", "<leader>tp", function()
  -- Racine du projet : celle affichée par nvim-tree si l'explorateur a déjà
  -- été ouvert (cohérente avec la sidebar, y compris après un
  -- change_root_to_node/change_root_to_parent manuel) ; à défaut, le premier
  -- dossier parent contenant .git ; à défaut, le dossier du buffer courant.
  local nvim_tree_root_node = require("nvim-tree.api").tree.get_nodes()
  local root = (nvim_tree_root_node and nvim_tree_root_node.absolute_path)
    or vim.fs.root(0, ".git")
    or vim.fn.expand("%:p:h")
  open_terminal_in(root)
end, {desc = "Open terminal in project root"})
