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

Export three environment variables from your shell profile
(`~/.bashrc`/`~/.zshrc`) — **never put them in this repo**:

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

## Keymaps

See [Keymaps → CodeCompanion](keymaps.md#codecompanion-luapluginsaicodecompanionlua).

## Verify

1. `git -C ~/.config/nvim status` should show nothing related to the values
   above after exporting them — confirms they're not in this repo.
2. `:checkhealth codecompanion` in Neovim — checks the plugin's own setup.
3. `<leader>ai` to open the chat, ask something simple, confirm you get a
   real response back from your in-house model.
