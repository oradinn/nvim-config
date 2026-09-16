# AI in Neovim

[`olimorris/codecompanion.nvim`](https://github.com/olimorris/codecompanion.nvim)
(`lua/plugins/ai/codecompanion.lua`) is a general-purpose AI coding assistant
for Neovim — chat buffer, inline edits, an action palette — comparable to
Cline in VS Code. It's wired here to a custom in-house LLM gateway via
CodeCompanion's community-contributed [`openai_compatible` adapter](https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/http/openai_compatible.lua),
which sends plain OpenAI Chat Completions requests (`POST {url}{chat_url}`,
`Authorization: Bearer {api_key}`) — the same shape most in-house LLM
gateways and tools like Cline/OpenCode use. No bridge or translation proxy
needed.

> That adapter is explicitly marked "not supported by CodeCompanion.nvim...
> provided as an example" in its own source — it's community-maintained
> rather than a first-class adapter. It works, and is the standard way people
> connect CodeCompanion to a custom/local OpenAI-compatible server, but keep
> that in mind if something behaves oddly — check the adapter's own issues/
> discussions rather than assuming it's this repo's config.

## Configure it

Credentials live in `~/.config/codecompanion/` — a plain directory of small
text files, entirely outside `~/.config/nvim` (this repo), never committed:

```bash
mkdir -p -m 700 ~/.config/codecompanion
printf '%s' "https://your-gateway:port/api" > ~/.config/codecompanion/base_url
printf '%s' "sk-..."                        > ~/.config/codecompanion/api_key
printf '%s' "your-model-id"                 > ~/.config/codecompanion/model
chmod 600 ~/.config/codecompanion/*
```

| File | Purpose |
|---|---|
| `base_url` | Base URL of your OpenAI-compatible gateway (CodeCompanion appends `chat_url` from the plugin file to this) |
| `api_key` | API key for that endpoint |
| `model` | Model ID to request — optional, falls back to a placeholder default in the plugin file if the file doesn't exist |

`lua/plugins/ai/codecompanion.lua` never contains a literal value for any of
these — `env.url`/`env.api_key` use CodeCompanion's built-in `file:` prefix
(read fresh from disk on every request; confirmed in `codecompanion.nvim`'s
own `adapters/utils/init.lua`), and `model` is read the same way via a small
helper in the plugin file. Since it's a file rather than a shell-exported
environment variable, it's only ever read when explicitly opened — no risk of
leaking through `/proc/<pid>/environ` or a child process inheriting it
unintentionally.

If your gateway's chat endpoint isn't at `{base_url}/chat/completions`,
adjust the `chat_url` field in the plugin file (not a secret, fine to
edit/commit).

**Prefer environment variables instead?** They still work — CodeCompanion's
`env` fields also resolve a plain string as an environment variable *name* if
one by that name is set (falling through to the file check otherwise). Export
`CODECOMPANION_BASE_URL`/`CODECOMPANION_API_KEY` from your shell profile and
change `env.url`/`env.api_key` in the plugin file to those names instead of
the `file:` paths. If your dotfiles are themselves a git repo, put the
`export` lines in a file that repo gitignores (e.g. `~/.zshrc.local`, sourced
from the tracked `~/.zshrc`) rather than the tracked file directly.

## Keymaps

See [Keymaps → CodeCompanion](keymaps.md#codecompanion-luapluginsaicodecompanionlua).

## Verify

1. `git -C ~/.config/nvim status` should show nothing related to the values
   above — confirms they're not in this repo.
2. `:checkhealth codecompanion` in Neovim — checks the plugin's own setup.
3. `<leader>ai` to open the chat, ask something simple, confirm you get a
   real response back from your in-house model.

## Troubleshooting

**Chat hangs forever with no response and no error** (the `## CodeCompanion`
header appears but nothing ever streams in): first isolate whether it's the
gateway or the plugin — replicate the exact request with `curl`, using your
real config file contents:

```bash
curl -sS -X POST "$(cat ~/.config/codecompanion/base_url)/chat/completions" \
  -H "Authorization: Bearer $(cat ~/.config/codecompanion/api_key)" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"$(cat ~/.config/codecompanion/model)\",\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}]}"
```

If that returns a fast, complete response but CodeCompanion still hangs, the
likely cause is **streaming**: the `openai_compatible` adapter requests
Server-Sent Events (`"stream": true`) by default, and the curl test above
doesn't. If your gateway doesn't fully support SSE streaming (or emits a
shape CodeCompanion's parser doesn't recognize), the client sits waiting for
chunks that never resolve — a hung connection, not an HTTP error, so nothing
surfaces in the chat buffer or `:messages`. This repo already disables
streaming for that reason (`opts.stream = false` in
`lua/plugins/ai/codecompanion.lua`, confirmed against the adapter's own
source to be a real, respected toggle — not a guess). If your gateway *does*
support streaming properly and you'd rather have it, flip that back to
`true`.

Other things to check if it's still not working:

- `:messages` in Neovim — errors go through `vim.notify` and may have
  scrolled past unnoticed.
- `~/.cache/nvim/codecompanion.log` — the plugin's own log file.
- The config files themselves aren't empty/malformed:
  `cat ~/.config/codecompanion/base_url`, `cat ~/.config/codecompanion/model`,
  `wc -c ~/.config/codecompanion/api_key` (byte count only, to avoid printing
  the key).
