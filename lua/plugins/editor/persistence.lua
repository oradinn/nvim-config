return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    -- nvim-tree gère lui-même le contenu de son buffer : si sa fenêtre est
    -- incluse dans la session, :mksession n'enregistre qu'un buffer vide,
    -- et la restauration affiche un panneau vide. On ferme donc l'arbre
    -- avant la sauvegarde ; l'autocmd SessionLoadPost ci-dessous le rouvre
    -- correctement après restauration.
    pre_save = function()
      local ok, api = pcall(require, "nvim-tree.api")
      if ok then
        api.tree.close()
      end
    end,
  },
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

    -- Rouvre l'explorateur après restauration (voir pre_save ci-dessus).
    vim.api.nvim_create_autocmd("SessionLoadPost", {
      callback = function()
        local ok, api = pcall(require, "nvim-tree.api")
        if ok then
          api.tree.open()
        end
      end,
    })
  end,
}
