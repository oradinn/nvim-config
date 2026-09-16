# AI in Neovim

Two AI assistant plugins live under `lua/plugins/ai/`, for two different
connection shapes:

- **[CodeCompanion](#codecompanion-a-cline-equivalent)** talks to an
  OpenAI-compatible endpoint directly — no bridge needed. Use this if your
  in-house LLM gateway is OpenAI-compatible (the common case; the same shape
  Cline/most VS Code extensions use).
- **[Claude Code](#claude-code)** is Anthropic's own CLI agent, wired into
  Neovim via `coder/claudecode.nvim`. It only speaks Anthropic's Messages API,
  so it needs your endpoint (or a proxy in front of it) to speak that format.

If you're not sure which applies, check what your organization's LLM gateway
docs say, or ask whoever configured it — the two are not interchangeable
without a translation layer in between.

## Keep credentials out of this repo

**Never put an API key/token in any file inside `~/.config/nvim`** (this
repo) — not in a plugin file, not in a checked-in `.env`, nowhere. Both
integrations below are written so the repo never contains a literal secret —
only the *names* of environment variables, resolved at runtime from wherever
you configure them (your shell profile, or, for Claude Code, its own
per-user settings file). Where exactly to put each one is covered in that
tool's own section.

## CodeCompanion (a Cline equivalent)

[`olimorris/codecompanion.nvim`](https://github.com/olimorris/codecompanion.nvim)
(`lua/plugins/ai/codecompanion.lua`) is a general-purpose AI coding assistant
for Neovim — chat buffer, inline edits, an action palette — comparable to
Cline in VS Code. It's wired here to a custom in-house endpoint via
CodeCompanion's community-contributed [`openai_compatible` adapter](https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/http/openai_compatible.lua),
which sends plain OpenAI Chat Completions requests (`POST {url}{chat_url}`,
`Authorization: Bearer {api_key}`) — the same shape Cline uses, and the same
shape your in-house gateway is confirmed to speak if you've already got it
working through Cline or a tool like [OpenCode](https://opencode.ai). No
bridge/proxy needed.

> That adapter is explicitly marked "not supported by CodeCompanion.nvim...
> provided as an example" in its own source — it's community-maintained
> rather than a first-class adapter. It works, and is the standard way people
> connect CodeCompanion to a custom/local OpenAI-compatible server, but keep
> that in mind if something behaves oddly — check the adapter's own issues/
> discussions rather than assuming it's this repo's config.

### Configure it

Export three environment variables from your shell profile
(`~/.bashrc`/`~/.zshrc`) — CodeCompanion has no equivalent of Claude Code's
own settings file, so this is the only option:

| Variable | Purpose |
|---|---|
| `CODECOMPANION_BASE_URL` | Base URL of your OpenAI-compatible gateway (e.g. `https://your-gateway:port/api` — CodeCompanion appends `chat_url` to this) |
| `CODECOMPANION_API_KEY` | API key for that endpoint |
| `CODECOMPANION_MODEL` | Model ID to request (optional — falls back to a placeholder default in the plugin file if unset) |

If your dotfiles are themselves a git repo, put the `export` lines in a file
that repo gitignores (e.g. `~/.zshrc.local`, sourced from the tracked
`~/.zshrc`) rather than the tracked file directly.

`lua/plugins/ai/codecompanion.lua` never contains a literal value for any of
these — `env.url`/`env.api_key` are the *names* of environment variables,
resolved by CodeCompanion itself via `os.getenv()` on every request (verified
in `codecompanion.nvim`'s own `adapters/utils/init.lua`), and
`CODECOMPANION_MODEL` is read the same way in the plugin file. If your
gateway's chat endpoint isn't at `{base_url}/chat/completions`, adjust the
`chat_url` field in that file (not a secret, fine to edit/commit).

### Keymaps

See [Keymaps → CodeCompanion](keymaps.md#codecompanion-luapluginsaicodecompanionlua).

### Verify

1. `git -C ~/.config/nvim status` should show nothing related to the values
   above after exporting them — confirms they're not in this repo.
2. `:checkhealth codecompanion` in Neovim — checks the plugin's own setup.
3. `<leader>ai` to open the chat, ask something simple, confirm you get a
   real response back from your in-house model.

## Claude Code

[`coder/claudecode.nvim`](https://github.com/coder/claudecode.nvim) (`lua/plugins/ai/claudecode.lua`)
brings [Claude Code](https://docs.anthropic.com/en/docs/claude-code) into Neovim
using the same WebSocket/MCP protocol as the official VS Code and JetBrains
extensions: Claude can see the current buffer and selection, open files, and
propose changes as native diffs you review before accepting.

### What the plugin does — and doesn't do

The plugin's only job is to launch the `claude` CLI binary in a terminal split
and run a local WebSocket server it connects to. **It has no concept of model
or provider** — which backend `claude` actually talks to is entirely decided
by the CLI itself, the same way it would be from a regular shell.

### Using an in-house LLM instead of Claude AI

Claude Code's CLI speaks Anthropic's **Messages API** wire format. If your
in-house model has been set up to speak that same format natively, no bridge
or proxy is needed — point the CLI straight at it via three environment
variables:

| Variable | Purpose |
|---|---|
| `ANTHROPIC_BASE_URL` | URL of the Anthropic-Messages-API-compatible endpoint |
| `ANTHROPIC_AUTH_TOKEN` | Auth token/API key for that endpoint |
| `ANTHROPIC_MODEL` | Model ID to request |

**If your gateway is actually OpenAI-compatible** (confirm by checking how
any working client — e.g. Cline, or an `opencode.json` config — connects to
it: `baseURL` + API key + model ID, no separate `system` parameter, is the
tell), `ANTHROPIC_BASE_URL` alone will not work — Claude Code sends
Anthropic-format requests, and an OpenAI-only backend will reject them (a
`400: System message must be at the beginning` error is a symptom of exactly
this mismatch — that's an OpenAI Chat Completions validation message, not an
Anthropic Messages API one). In that case, either use
[CodeCompanion](#codecompanion-a-cline-equivalent) instead — it speaks
OpenAI-compatible directly — or put a translating proxy in front of the
gateway (e.g. [claude-code-router](https://github.com/musistudio/claude-code-router))
and point these same three variables at that proxy.

### Keep the credential out of this repo

Two ways to configure it that live entirely outside this repo:

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

Prefer keeping dotfiles under `~/.config` (XDG-style, matching where this
config itself lives)? Claude Code honors `CLAUDE_CONFIG_DIR` to relocate its
entire config directory — set it in your shell profile:

```bash
export CLAUDE_CONFIG_DIR="$HOME/.config/claude"
```

then create `~/.config/claude/settings.json` (same `700`/`600` permissions,
same content) instead of `~/.claude/settings.json`. `CLAUDE_CONFIG_DIR` is a
plain environment variable, so Neovim inherits it from your shell and the
Claude terminal inherits it from Neovim automatically — no plugin change
needed either.

**Option B — shell profile env vars.** Export the same three variables from
`~/.bashrc`/`~/.zshrc` instead. Works identically, but applies to every
process in your shell, not just `claude`. Same gitignored-local-file advice
as CodeCompanion above if your dotfiles are version-controlled.

Either option needs **zero changes to this repo** — `claude` resolves its own
connection regardless of what launched it. The `terminal.env` block already in
`lua/plugins/ai/claudecode.lua` (`os.getenv("ANTHROPIC_...")`) only matters if
you want the Neovim-launched session to see *different* values than a plain
shell would; it never contains the key itself, so there's nothing to leak
from the repo either way.

### Verify before you trust it

1. Confirm the values live outside git: `cat ~/.claude/settings.json` (or
   `~/.config/claude/settings.json` if using `CLAUDE_CONFIG_DIR`) or
   `echo $ANTHROPIC_BASE_URL` (Option B) — then `git -C ~/.config/nvim status`
   should show nothing related to either.
2. `claude doctor` from a plain shell — confirms the CLI can reach the
   endpoint before involving Neovim at all.
3. A real prompt from a plain shell (`claude`, then ask it something) — if
   this fails with a 400 about system message ordering, it's a backend/gateway
   issue (see above), not something fixable from Neovim.
4. In Neovim: `<leader>ac` to open Claude, then `:ClaudeCodeStatus` to confirm
   it's connected.

If your organization instead gives you a custom `claude`-compatible binary or
wrapper script rather than env vars, point `opts.terminal_cmd` at it in
`lua/plugins/ai/claudecode.lua` (see the [claudecode.nvim README](https://github.com/coder/claudecode.nvim#local-installation-configuration)
for the exact option) — that path is a binary location, not a secret, so it's
fine to commit.

### Keymaps

See [Keymaps → Claude Code](keymaps.md#claude-code-luapluginsaiclaudecodelua).

### Troubleshooting

- Run `:checkhealth claudecode` first — it checks the CLI is installed, the
  WebSocket server is running, and whether Claude is connected.
- `:ClaudeCodeStatus` shows connection state.
- Set `log_level = "debug"` in the plugin's `opts` for verbose logs.
- A "trust this folder" prompt (or other TUI output) rendering as `[?]`
  boxes in a plain terminal is a local font/terminal-emulator issue, not a
  config or connectivity problem — try a different terminal emulator or font
  with full Unicode box-drawing coverage.
