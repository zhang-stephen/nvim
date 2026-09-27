# AGENTS.md — constraints for AI agents

Rules for AI agents (and humans) working on this repository. Read this file first.

## Language

- All code, comments, commit messages, and docs in **English**.
- Sole exception: `README_zh.md` (Chinese mirror of `README.md`).
- `README.md` and `README_zh.md` must be updated **together** — never let them drift.

## Code style

- `stylua.toml` is authoritative: 4-space indent, single quotes, always call parentheses, Unix line endings.
- Module pattern: `local M = {}` → `M.setup = function() ... end` → `return M`.
- Prefer direct, greppable code over table-driven indirection. A kv table + apply loop is
  **not** welcome where plain assignments read better (see `core/options.lua`).

## Error handling

- `pcall` is for **uncontrollable environments only**: availability guards on first run
  (plugin not installed yet), non-require-able probes (`colorscheme`), or callbacks firing
  on unknown inputs (`vim.treesitter.start` on parser-less filetypes). One per site, with a comment.
- **Never** wrap setup calls in `pcall` defensively: a failing setup call is a config bug
  and must surface loudly, not be swallowed.

## API conventions (modern API only)

- Options: `vim.o.xx = yy` direct assignment. **Never** build `:set ...` command strings —
  that style existed only when there was no proper API.
- Keymaps: `vim.keymap.set` with **function rhs** (`vim.cmd.bnext()`, `require(...)` calls).
  String rhs is allowed only for pure key sequences (e.g. `'d$'`, `'<C-\\><C-n>'`).
- Highlights: `vim.api.nvim_set_hl`, not `:highlight` commands.

## Versioning

- Minimum supported version: **neovim 0.12** (hard guard in `init.lua`).
- This is a floor, not a pin: raise it deliberately when a needed feature requires it,
  and update `init.lua` + both READMEs in the same change.
- No version-compat shim layer. If it's not in 0.12, we don't use it yet.

## Plugins

- Plugin manager: builtin `vim.pack` only. No lazy.nvim/packer/plug unless the user asks for a migration.
- Plugin declarations live in `lua/core/plugins.lua` (`repos`: pure specs, repo + version only).
- Per-plugin setup lives in `lua/plugins/<repo-basename>.lua`; each file returns a setup
  function. `loadfile` (not `require`) is used so repo names with dots map 1:1 to file names.
- Adding a plugin = one entry in `repos` + one file in `lua/plugins/`. State the reason first.
- Clone URLs: SSH first (`git@github.com:...`), HTTPS fallback; controlled by
  `use_git_ssh` in `lua/settings/init.lua`.
- Lazy loading: only via `vim.pack.add(..., { load = false })` + manual `packadd()`.
  Do not add it for startup-essential plugins; reserve for genuinely heavy optional ones.

## LSP

- Builtin `vim.lsp.config()` + `vim.lsp.enable()` only. **No nvim-lspconfig, no mason.**
- Server binaries come from distro packages; each server is ~10 explicit lines
  (cmd / filetypes / root_markers / settings).

## Git workflow

- **Never commit or push without the user's explicit approval.** Present changes and wait.
- Commit titles follow Conventional Commits: `feat:` / `fix:` / `docs:` / `refactor:` / `chore:` ...
- Work happens on the `v2` orphan branch; `dev`/`master` keep the legacy config untouched.
