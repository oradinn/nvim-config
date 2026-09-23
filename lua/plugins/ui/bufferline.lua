return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      separator_style = "slant",
      offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
      -- Ferme l'onglet sans fermer le split (voir mini-bufremove.lua) :
      -- un simple `bdelete` viderait la fenêtre et la fermerait s'il n'y a
      -- pas de buffer de repli.
      close_command = function(bufnum)
        require("mini.bufremove").delete(bufnum, false)
      end,
      right_mouse_command = function(bufnum)
        require("mini.bufremove").delete(bufnum, false)
      end,
    },
  },
}
