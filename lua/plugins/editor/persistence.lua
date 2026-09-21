return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  keys = {
    {
      "<leader>qs",
      function()
        require("persistence").load()
      end,
      desc = "Restaurer la session du répertoire courant",
    },
    {
      "<leader>ql",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "Restaurer la dernière session",
    },
    {
      "<leader>qd",
      function()
        require("persistence").stop()
      end,
      desc = "Ne pas sauvegarder la session en quittant",
    },
  },
  init = function()
    -- Permet de restaurer une session en ligne de commande, sans passer par
    -- un keymap : `nvim -c SessionRestore .` (équivalent d'un `nvim -r .`,
    -- que Neovim ne propose pas nativement pour les sessions).
    vim.api.nvim_create_user_command("SessionRestore", function()
      require("persistence").load()
    end, { desc = "Restaurer la session du répertoire courant" })
  end,
}
