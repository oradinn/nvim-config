-- Rendu markdown directement dans le buffer (titres, gras, blocs de code,
-- tableaux stylés) sans quitter Neovim ni dépendre de node.js — contrairement
-- à markdown-preview.nvim qui ouvre un aperçu dans le navigateur. Pas de rendu
-- d'images réelles sauf terminal compatible (protocole Kitty/iTerm2). Voir
-- docs/lsp.md.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {},
}
