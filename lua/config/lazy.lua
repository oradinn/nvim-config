-- Mise en place et installation de lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configuration de lazy.nvim et importation du répertoire `plugins`
-- lazy.nvim ne descend qu'un seul niveau par `import` (voir Spec:import /
-- Util.lsmod dans lazy.nvim) : un sous-dossier n'est parcouru que s'il a son
-- propre `init.lua`. On importe donc explicitement chaque sous-dossier de
-- catégorie plutôt que de compter sur une récursion qui n'existe pas.
require("lazy").setup({
  { import = "plugins.ai" },
  { import = "plugins.completion" },
  { import = "plugins.editor" },
  { import = "plugins.lsp" },
  { import = "plugins.ui" },
}, {
  -- vérifie automatiquement les mises à jour des plugins mais sans notifier
  -- lualine va se charger de nous afficher un icône
  checker = {
    enabled = true,
    notify = false,
  },
  -- thème utilisé lors de l'installation de plugins
  install = { colorscheme = { "tokyonight" } },
  -- désactive la pénible notification au démarrage
  change_detection = {
    notify = false,
  },
})
