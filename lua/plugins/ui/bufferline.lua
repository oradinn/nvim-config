return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      separator_style = "slant",
      offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
      middle_mouse_command = "bdelete! %d", -- clic molette sur un onglet : ferme le buffer
    },
  },
}
