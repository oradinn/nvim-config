-- Intégration de Claude Code (agent en CLI) dans Neovim via le même
-- protocole (WebSocket/MCP) que les extensions officielles VS Code/JetBrains.
-- Le plugin ne fait que lancer le binaire `claude` dans un terminal : il n'a
-- aucune notion de fournisseur/modèle. C'est la CLI elle-même (via les
-- variables d'environnement ci-dessous, ou ~/.claude/settings.json) qui
-- décide à quel backend elle parle. Voir docs/ai.md.
local function claude_env()
  local env = {}
  for _, key in ipairs({ "ANTHROPIC_BASE_URL", "ANTHROPIC_AUTH_TOKEN", "ANTHROPIC_MODEL" }) do
    local value = os.getenv(key)
    if value then
      env[key] = value
    end
  end
  return env
end

return {
  "coder/claudecode.nvim",
  -- `cmd` fait créer par lazy.nvim des commandes-stub pour que :ClaudeCode et
  -- consorts existent dès le démarrage, sans attendre qu'un des raccourcis
  -- <leader>a* soit pressé.
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  opts = {
    terminal = {
      -- "auto" utilise folke/snacks.nvim s'il est installé (terminal flottant),
      -- sinon retombe silencieusement sur le terminal natif de Neovim. Pas de
      -- dépendance à ajouter pour l'instant.
      provider = "auto",
      env = claude_env(),
    },
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree" },
    },
    -- Gestion des diffs proposés par Claude
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
