return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- fzf implémentation en C pour plus de rapidité
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- live_grep avec arguments rg bruts (glob/type/dossier) dans le même prompt
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {

        -- Parce que c'est joli
        -- selection_caret en \u{...} pour éviter qu'un outil non compatible
        -- UTF-8 ne l'efface silencieusement (voir docs/changelog.md).
        prompt_prefix = "🔍 ",
        selection_caret = "\u{f054} ",
        path_display = { "smart" },
        file_ignore_patterns = { ".git/", "node_modules" },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            -- note : telescope-live-grep-args.nvim définit son propre <C-k>
            -- (guillemeter le mot sous le curseur) sous
            -- extensions.live_grep_args.mappings.i, un espace de config
            -- distinct de celui-ci — pas de conflit réel avec la ligne
            -- suivante, même si on ne le configure pas ici.
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- guillemets automatiques autour du motif tapé
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set(
      "n",
      "<leader>ff",
      "<cmd>Telescope find_files<cr>",
      { desc = "Recherche de chaînes de caractères dans les noms de fichiers" }
    )
    keymap.set(
      "n",
      "<leader>fg",
      "<cmd>Telescope live_grep_args<cr>",
      { desc = "Recherche de chaînes de caractères (regex/glob/dossier) dans le contenu des fichiers" }
    )
    keymap.set(
      "n",
      "<leader>fb",
      "<cmd>Telescope buffers<cr>",
      { desc = "Recherche de chaînes de caractères dans les noms de buffers" }
    )
    keymap.set(
      "n",
      "<leader>fx",
      "<cmd>Telescope grep_string<cr>",
      { desc = "Recherche de la chaîne de caractères sous le curseur" }
    )
  end,
}
