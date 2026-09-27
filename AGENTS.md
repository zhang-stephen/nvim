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
- Plugin declaration lives in `lua/core/plugins.lua`, split into two tables:
  `repos` (pure specs: repo + version) and `configs` (per-plugin setup keyed by repo basename).
- Clone URLs: SSH first (`git@github.com:...`), HTTPS fallback; controlled by
  `use_git_ssh` in `lua/settings/init.lua`.
- Keep the plugin list small. Every new plugin needs a stated reason.

## LSP

- Builtin `vim.lsp.config()` + `vim.lsp.enable()` only. **No nvim-lspconfig, no mason.**
- Server binaries come from distro packages; each server is ~10 explicit lines
  (cmd / filetypes / root_markers / settings).

## Git workflow

- **Never commit or push without the user's explicit approval.** Present changes and wait.
- Commit titles follow Conventional Commits: `feat:` / `fix:` / `docs:` / `refactor:` / `chore:` ...
- Work happens on the `v2` orphan branch; `dev`/`master` keep the legacy config untouched.
