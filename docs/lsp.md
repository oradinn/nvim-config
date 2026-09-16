# LSP

Language servers are installed by `mason.nvim` (`ensure_installed` in
[`lua/plugins/lsp/mason.lua`](https://github.com/oradinn/nvim-config/blob/main/lua/plugins/lsp/mason.lua))
and configured via `vim.lsp.config(...)` in
[`lua/plugins/lsp/lspconfig.lua`](https://github.com/oradinn/nvim-config/blob/main/lua/plugins/lsp/lspconfig.lua).
See [Keymaps → LSP](keymaps.md#lsp-luapluginslsplspconfiglua) for the
keybindings — they're the same regardless of language.

## Python

Two servers, each doing a different job:

| Server | Role |
|---|---|
| [`basedpyright`](https://detachhead.github.io/basedpyright) | Types, completion, hover, go-to-definition. A community fork of `pyright` that works well standalone (`pyright` itself is tuned for VS Code/Pylance). |
| [`ruff`](https://docs.astral.sh/ruff/editors/) | Linting and formatting — extremely fast (written in Rust), replaces the old `black`/`pyflakes`/`isort` combo in one tool. Uses `ruff`'s built-in `server` subcommand, not the older, now-deprecated `ruff-lsp`. |

Running both means overlapping capabilities in a couple of places; `ruff`'s
hover is explicitly disabled in `lspconfig.lua` (`client.server_capabilities.hoverProvider = false`
in its `on_attach`) so you get `basedpyright`'s richer, type-aware hover
instead of a plain one — this is the standard way people run this combo.

`basedpyright` is set to `diagnosticMode = "workspace"` (analyzes the whole
project, not just open files) rather than its own default of
`"openFilesOnly"` — catches issues in files you haven't opened yet, at the
cost of a bit more CPU on large projects. Drop that setting back to
`"openFilesOnly"` in `lspconfig.lua` if that trade-off doesn't suit a
particular project.

Formatting (`<leader>F`) uses whichever attached server responds — `ruff`
handles it.

This replaced `pylsp` (`python-lsp-server`), which is still a perfectly
valid choice but slower and less actively developed than this combo.

## C++

`clangd` is configured with:

```lua
cmd = {
  "clangd",
  "--background-index",     -- index the whole project, not just open files
  "--clang-tidy",            -- extra diagnostics from clang-tidy, when available
  "--completion-style=detailed",
  "--header-insertion=iwyu", -- auto-insert the right #include when completing a symbol
}
```

(Flag names verified against `clangd --help-hidden` directly, not assumed —
`--cross-file-rename` from some older guides is now an obsolete no-op flag
and deliberately left out.)

### Why `#include`s sometimes don't resolve

`clangd` doesn't parse your build system — it needs a
[JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html)
(`compile_commands.json`) telling it the exact compiler flags and include
paths **each individual file** was actually compiled with. Without one, it
falls back to guessing, which is exactly when relative/cross-directory
`#include "foo.hpp"` starts failing to resolve even though the file compiles
fine.

Two different situations, two different fixes:

### CMake projects (e.g. using `onera/project_utils`)

This is genuine CMake underneath (`add_subdirectory`/`find_package`/
`target_install`), so the standard, robust fix applies directly:

1. Configure with compile commands export turned on:
   ```bash
   cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
   ```
2. Tell `clangd` where to find it. `compile_commands.json` lands in the build
   directory (out-of-source), not the source root, so either:
   - Symlink it to the project root (works with `clangd`'s default
     upward-search, needs no extra config):
     ```bash
     ln -s build/compile_commands.json .
     ```
   - Or add a `.clangd` file at the project root, pointing at the build
     directory explicitly (no symlink to remember to recreate):
     ```yaml
     CompileFlags:
       CompilationDatabase: build
     ```

Either is a **per-project** setup step (the build directory name/location is
a project decision, `project_utils` doesn't fix one), so it's not something
to bake into this Neovim config — do it once per repo, commit the `.clangd`
file (or a `.gitignore`'d symlink) so every contributor's `clangd` picks it
up automatically.

`project_utils`'s own header-install convention (`target_install` copies the
whole `${PROJECT_SOURCE_DIR}/${PROJECT_NAME}/` folder — i.e. each module has
its own name-matching subfolder, referenced elsewhere as
`#include "modulename/header.hpp"`) resolves correctly once
`compile_commands.json` is in place, since CMake already knows the right
include search path per target — no manual `-I` flags needed.

### Course exercises (no build system)

For a plain `g++ exo.cpp` with no CMake, `#include "point.hpp"` already
resolves correctly with **zero configuration** when `point.hpp` sits in the
same directory as `exo.cpp` — that's standard C/C++ preprocessor behavior for
quoted includes (search the current file's directory first), not something
`clangd` needs to be told about.

If an exercise reaches into a shared/parent directory instead
(`#include "../common/utils.hpp"`), or `clangd` still can't resolve
something, drop a `compile_flags.txt` next to the exercise (or in a shared
ancestor folder — `clangd` walks upward looking for one) with the extra
flags it needs, one per line:

```text
-std=c++20
-I../common
```

## Markdown

[`render-markdown.nvim`](https://github.com/MeanderingProgrammer/render-markdown.nvim)
(`lua/plugins/editor/markdown.lua`) renders markdown **in the buffer itself**
— headers, bold/italic, code blocks, and tables get styled directly as you
read/edit, using the `markdown`/`markdown_inline` Treesitter parsers already
in `ensure_installed` (`lua/plugins/editor/treesitter.lua`). No browser, no
external dependency — it just needs a [Nerd Font](https://www.nerdfonts.com/)
(already required elsewhere in this config) for its icons.

Commands: `:RenderMarkdown toggle` / `enable` / `disable`.

This was chosen specifically over
[`markdown-preview.nvim`](https://github.com/iamcco/markdown-preview.nvim)
(which opens a live, browser-rendered preview with real images/math/diagrams,
synced to your cursor) because that one needs **Node.js** installed to build
its bundled preview server — not available on every machine. If Node.js ever
becomes available and genuinely rich rendering (real image sizes, complex
tables, Mermaid diagrams) is worth the extra dependency, `markdown-preview.nvim`
is the one to add — nothing in the current setup conflicts with adding it
alongside `render-markdown.nvim` later.
