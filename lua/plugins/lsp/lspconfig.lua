return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Va permettre de remplir le plugin de complétion automatique nvim-cmp
    -- avec les résultats des LSP
    "hrsh7th/cmp-nvim-lsp",
    -- Ajoute les « code actions » de type renommage de fichiers intelligent, etc
    { "antosha417/nvim-lsp-file-operations", config = true },
    -- Utile pour éditer les fichiers lua spécifiques à la config neovim
    -- Notamment pour éviter le "Undefined global `vim`"
    { "folke/lazydev.nvim", opts = {} },
  },
  keys = {
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
    { "gR", "<cmd>Telescope lsp_references<CR>", desc = "Show LSP references", mode = "n" },
    { "gD", vim.lsp.buf.declaration, desc = "Go to declaration", mode = "n" },
    { "gd", "<cmd>Telescope lsp_definitions<CR>", desc = "Show LSP definitions", mode = "n" },
    { "gi", "<cmd>Telescope lsp_implementations<CR>", desc = "Show LSP implementations", mode = "n" },
    { "gt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Show LSP type definitions", mode = "n" },
    { "gs", vim.lsp.buf.signature_help, desc = "Show LSP signature help", mode = "n" },
    { "<leader>rn", vim.lsp.buf.rename, desc = "Smart rename", mode = "n" },
    { "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Show buffer diagnostics", mode = "n" },
    { "<leader>cd", vim.diagnostic.open_float, desc = "Show line diagnostics", mode = "n" },
    {
      "[d",
      function()
        vim.diagnostic.jump({ count = -1, float = true })
      end,
      desc = "Go to previous diagnostic",
      mode = "n",
    },
    {
      "]d",
      function()
        vim.diagnostic.jump({ count = 1, float = true })
      end,
      desc = "Go to next diagnostic",
      mode = "n",
    },
    { "K", vim.lsp.buf.hover, desc = "Show documentation for what is under cursor", mode = "n" },
    { "<leader>F", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", desc = "Format buffer", mode = { "n", "x" } },
    { "<leader>rs", ":LspRestart<CR>", desc = "Restart LSP", mode = "n" },
  },
  config = function()
    -- Customize error signs
    vim.diagnostic.config({
      signs = {
        text = {
          -- Glyphs écrits en \u{...} plutôt qu'en caractère littéral pour
          -- qu'ils ne puissent pas être silencieusement effacés par un
          -- outil non compatible UTF-8 (voir docs/changelog.md).
          [vim.diagnostic.severity.ERROR] = "\u{f057} ",
          [vim.diagnostic.severity.WARN] = "\u{f071} ",
          [vim.diagnostic.severity.INFO] = "\u{f05a} ",
          [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
        },
      },
    })

    -- Python : basedpyright (types, complétion, hover) + ruff (lint/format,
    -- très rapide). On désactive le hover de ruff pour éviter un doublon
    -- avec celui, plus complet (types inclus), de basedpyright. Les deux
    -- sont installés via mason, cf. lua/plugins/lsp/mason.lua. Détails et
    -- justification du choix dans docs/lsp.md.
    vim.lsp.config("basedpyright", {
      settings = {
        basedpyright = {
          analysis = {
            -- Analyse tout le workspace, pas seulement les fichiers ouverts
            diagnosticMode = "workspace",
          },
        },
      },
    })

    vim.lsp.config("ruff", {
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
      end,
    })

    -- C++ (clangd, installé via mason). Nécessite un compile_commands.json
    -- (projets CMake) ou un compile_flags.txt pour résoudre correctement
    -- les #include relatifs — voir docs/lsp.md pour la configuration côté
    -- projet (CMAKE_EXPORT_COMPILE_COMMANDS + fichier .clangd).
    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
      },
    })
  end,
}
