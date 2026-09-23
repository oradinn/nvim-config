return {
  "echasnovski/mini.bufremove",
  version = false,
  opts = {},
  keys = {
    {
      "<leader>bd",
      function()
        require("mini.bufremove").delete(0, false)
      end,
      desc = "Fermer le buffer sans fermer le split",
    },
  },
}
