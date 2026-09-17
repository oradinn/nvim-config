-- Navigation dans les fichiers markdown : suivre un lien (y compris vers une
-- ancre `fichier.md#titre`), sauter au titre suivant/précédent, naviguer
-- avant/arrière dans l'historique des liens suivis. Complète render-markdown.nvim
-- (qui ne fait que le rendu visuel, pas la navigation). Voir docs/lsp.md.
return {
  "jakewvincent/mkdnflow.nvim",
  ft = "markdown",
  opts = {
    -- On ne garde que la navigation (liens, titres, historique) : tableaux,
    -- listes, todo et pliage ne sont pas demandés et leurs raccourcis par
    -- défaut (`o`/`O`, `<leader>f`/`<leader>F`) entreraient en conflit avec
    -- des raccourcis existants (cf. core/keymaps.lua, lsp/lspconfig.lua).
    modules = {
      tables = false,
      lists = false,
      to_do = false,
      folds = false,
      foldtext = false,
      bib = false,
      templates = false,
    },
    mappings = {
      -- Entre en conflit avec <leader>p (coller sur la sélection, cf.
      -- core/keymaps.lua) ; fonctionnalité non demandée, désactivée plutôt
      -- que déplacée.
      MkdnCreateLinkFromClipboard = false,
    },
  },
}
