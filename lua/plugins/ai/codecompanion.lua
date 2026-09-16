-- CodeCompanion : assistant IA générique (façon Cline) pour Neovim, capable
-- de parler directement à un endpoint compatible OpenAI via l'adaptateur
-- communautaire "openai_compatible" — sans passerelle de traduction. Voir
-- docs/ai.md.
--
-- Rien de sensible ici : `env.url`/`env.api_key` utilisent le préfixe
-- `file:` de CodeCompanion (voir adapters/utils/init.lua dans le plugin) —
-- le contenu est lu depuis ~/.config/codecompanion/ à chaque requête,
-- jamais une valeur littérale, jamais commité. Voir docs/ai.md pour la mise
-- en place de ce dossier.
local function read_config_file(name, default)
  local path = vim.fs.normalize("~/.config/codecompanion/" .. name)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or not lines[1] then
    return default
  end
  return vim.trim(lines[1])
end

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  keys = {
    { "<leader>a", nil, desc = "AI" },
    { "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion chat", mode = { "n", "v" } },
    { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion action palette", mode = { "n", "v" } },
    { "<leader>av", "<cmd>CodeCompanionChat Add<cr>", desc = "Add selection to CodeCompanion chat", mode = "v" },
  },
  opts = {
    adapters = {
      http = {
        in_house = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              -- Lus depuis des fichiers, jamais des valeurs littérales.
              url = "file:~/.config/codecompanion/base_url",
              api_key = "file:~/.config/codecompanion/api_key",
              -- Ajusté sur le chemin réel de la passerelle (baseURL + "/chat/completions",
              -- sans préfixe /v1) — à adapter si la vôtre diffère.
              chat_url = "/chat/completions",
            },
            schema = {
              model = {
                default = function()
                  return read_config_file("model", "model-name-small")
                end,
              },
            },
          })
        end,
      },
    },
    strategies = {
      chat = { adapter = "in_house" },
      inline = { adapter = "in_house" },
    },
  },
}
