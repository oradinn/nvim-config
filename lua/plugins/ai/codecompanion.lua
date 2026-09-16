-- CodeCompanion : assistant IA générique (façon Cline) pour Neovim, capable
-- de parler directement à un endpoint compatible OpenAI via l'adaptateur
-- communautaire "openai_compatible" — sans passerelle de traduction. Voir
-- docs/ai.md.
--
-- Rien de sensible ici : `env.url`/`env.api_key` sont de simples NOMS de
-- variables d'environnement que CodeCompanion résout lui-même via
-- os.getenv() à chaque requête (voir lua/codecompanion/adapters/utils dans
-- le plugin) — jamais une valeur littérale, jamais commité.
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
              -- Noms de variables d'environnement, pas des valeurs : voir
              -- docs/ai.md pour où et comment les définir (jamais dans ce dépôt).
              url = "CODECOMPANION_BASE_URL",
              api_key = "CODECOMPANION_API_KEY",
              -- Ajusté sur le chemin réel de la passerelle (baseURL + "/chat/completions",
              -- sans préfixe /v1) — à adapter si la vôtre diffère.
              chat_url = "/chat/completions",
            },
            schema = {
              model = {
                default = function()
                  return os.getenv("CODECOMPANION_MODEL") or "model-name-small"
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
