return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    -- import de mason
    local mason = require("mason")

    -- import de mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    -- Active mason et personnalise les icônes
    mason.setup({
      ui = {
        icons = {
          package_installed = "I",
          package_pending = "?",
          package_uninstalled = "N",
        },
      },
    })

    mason_lspconfig.setup({
      automatic_enable = true,
      -- Liste des serveurs à installer par défaut
      -- List des serveurs possibles : https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      -- Vous pouvez ne pas en mettre ici et tout installer en utilisant :Mason
      -- Mais au lieu de passer par :Mason pour installer, je vous recommande d'ajouter une entrée à cette liste
      -- Ça permettra à votre configuration d'être plus portable
      ensure_installed = {
        "lua_ls",
        -- Python : basedpyright pour les types/la complétion, ruff pour le
        -- lint/format (rapide, écrit en Rust) — cf. lua/plugins/lsp/lspconfig.lua
        -- et docs/lsp.md pour le détail de la répartition des rôles.
        "basedpyright",
        "ruff",
        "clangd",
      },
    })
  end,
}
