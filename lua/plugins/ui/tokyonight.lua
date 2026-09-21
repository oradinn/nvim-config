return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "moon",
    transparent = true,
    on_highlights = function(hl, c)
      hl.LineNrAbove = { fg = "#545c7e" }
      hl.LineNrBelow = { fg = "#828bb8" }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
