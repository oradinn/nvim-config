# Claude Code in Neovim

[`coder/claudecode.nvim`](https://github.com/coder/claudecode.nvim) (`lua/plugins/ai/claudecode.lua`)
brings [Claude Code](https://docs.anthropic.com/en/docs/claude-code) into Neovim
using the same WebSocket/MCP protocol as the official VS Code and JetBrains
extensions: Claude can see the current buffer and selection, open files, and
propose changes as native diffs you review before accepting.

## What the plugin does — and doesn't do

The plugin's only job is to launch the `claude` CLI binary in a terminal split
and run a local WebSocket server it connects to. **It has no concept of model
or provider** — which backend `claude` actually talks to is entirely decided
by the CLI itself, the same way it would be from a regular shell.

## Using an in-house LLM instead of Claude AI

Claude Code's CLI speaks Anthropic's **Messages API** wire format. If your
in-house model has been set up to speak that same format natively (as opposed
to an OpenAI Chat Completions-style API, the shape Cline and most VS Code
extensions use), no bridge or proxy is needed — point the CLI straight at it
via three environment variables:

| Variable | Purpose |
|---|---|
| `ANTHROPIC_BASE_URL` | URL of the Anthropic-Messages-API-compatible endpoint |
| `ANTHROPIC_AUTH_TOKEN` | Auth token/API key for that endpoint |
| `ANTHROPIC_MODEL` | Model ID to request |

If instead your gateway only speaks an OpenAI-compatible API, `ANTHROPIC_BASE_URL`
alone won't work — you'd need a translating proxy in front of it (e.g.
[claude-code-router](https://github.com/musistudio/claude-code-router)) and
would point these same three variables at that proxy instead.

### Keep the credential out of this repo

**Never put the token in any file inside `~/.config/nvim`** (this repo) — not
in `lua/plugins/ai/claudecode.lua`, not in a checked-in `.env`, nowhere. Two
ways to configure it that live entirely outside this repo:

**Option A — `~/.claude/settings.json` (recommended).** Claude Code's own
per-user config file. The `claude` CLI reads it automatically on every
launch — from a plain shell or from this Neovim plugin's terminal — and it
lives in your home directory, so it can never be swept up by a `git add -A`
run inside `~/.config/nvim`:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://your-gateway:port/api",
    "ANTHROPIC_AUTH_TOKEN": "sk-...",
    "ANTHROPIC_MODEL": "your-model-id"
  }
}
```

Lock it down after writing it: `chmod 600 ~/.claude/settings.json`.

**Option B — shell profile env vars.** Export the same three variables from
`~/.bashrc`/`~/.zshrc` instead. Works identically, but applies to every
process in your shell, not just `claude`. If your dotfiles are themselves a
git repo, put the `export` lines in a file that repo gitignores (e.g.
`~/.zshrc.local`, sourced from the end of the tracked `~/.zshrc`) rather than
in the tracked file directly.

Either option needs **zero changes to this repo** — `claude` resolves its own
connection regardless of what launched it. The `terminal.env` block already in
`lua/plugins/ai/claudecode.lua` (`os.getenv("ANTHROPIC_...")`) only matters if
you want the Neovim-launched session to see *different* values than a plain
shell would; it never contains the key itself, so there's nothing to leak
from the repo either way.

### Verify before you trust it

1. Confirm the values live outside git: `cat ~/.claude/settings.json` (Option
   A) or `echo $ANTHROPIC_BASE_URL` (Option B) — then `git -C ~/.config/nvim
   status` should show nothing related to either.
2. `claude doctor` from a plain shell — confirms the CLI can reach the
   endpoint before involving Neovim at all.
3. In Neovim: `<leader>ac` to open Claude, then `:ClaudeCodeStatus` to confirm
   it's connected.

If your organization instead gives you a custom `claude`-compatible binary or
wrapper script rather than env vars, point `opts.terminal_cmd` at it in
`lua/plugins/ai/claudecode.lua` (see the [claudecode.nvim README](https://github.com/coder/claudecode.nvim#local-installation-configuration)
for the exact option) — that path is a binary location, not a secret, so it's
fine to commit.

## Keymaps

See [Keymaps → Claude Code](keymaps.md#claude-code-luapluginsaiclaudecodelua).

## Troubleshooting

- Run `:checkhealth claudecode` first — it checks the CLI is installed, the
  WebSocket server is running, and whether Claude is connected.
- `:ClaudeCodeStatus` shows connection state.
- Set `log_level = "debug"` in the plugin's `opts` for verbose logs.
