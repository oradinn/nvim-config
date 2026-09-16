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

Claude Code's CLI speaks Anthropic's **Messages API** wire format. It can be
pointed at any endpoint that speaks that same format via three environment
variables:

| Variable | Purpose |
|---|---|
| `ANTHROPIC_BASE_URL` | URL of the Anthropic-Messages-API-compatible endpoint |
| `ANTHROPIC_AUTH_TOKEN` | Auth token/API key for that endpoint |
| `ANTHROPIC_MODEL` | Model ID to request |

`lua/plugins/ai/claudecode.lua` forwards whichever of these three are set in
your shell into the Claude terminal automatically (`opts.terminal.env`) — set
them in your shell profile and this config picks them up with zero changes.

**Important — most in-house gateways are OpenAI-compatible, not
Anthropic-compatible.** If yours exposes an OpenAI Chat Completions-style API
(base URL + API key + model ID, the shape Cline and most VS Code extensions
use), pointing `ANTHROPIC_BASE_URL` straight at it will **not** work — the
request/response shapes are different APIs, not just different auth. You need
something in between that accepts Anthropic-format requests and forwards them
to your OpenAI-compatible gateway. That's infrastructure your organization
provides (or a tool like [claude-code-router](https://github.com/musistudio/claude-code-router),
which exists specifically to bridge Claude Code to OpenAI-compatible and other
non-Anthropic providers) — this repo intentionally doesn't pin a specific one,
since that's an org-wide decision, not a per-editor one.

Once that bridge exists, either:

- export `ANTHROPIC_BASE_URL` / `ANTHROPIC_AUTH_TOKEN` / `ANTHROPIC_MODEL` in
  your shell profile (works for Neovim *and* `claude` run directly from a
  terminal), or
- set them only for Neovim by editing the `env` table passed to
  `opts.terminal` in `lua/plugins/ai/claudecode.lua`.

If your organization instead gives you a custom `claude`-compatible binary or
wrapper script rather than env vars, point `opts.terminal_cmd` at it in the
same file (see the [claudecode.nvim README](https://github.com/coder/claudecode.nvim#local-installation-configuration)
for the exact option).

## Keymaps

See [Keymaps → Claude Code](keymaps.md#claude-code-luapluginsaiclaudecodelua).

## Troubleshooting

- Run `:checkhealth claudecode` first — it checks the CLI is installed, the
  WebSocket server is running, and whether Claude is connected.
- `:ClaudeCodeStatus` shows connection state.
- Set `log_level = "debug"` in the plugin's `opts` for verbose logs.
