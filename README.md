# nvim

Personal neovim configuration. **This branch (`v2`) is a rewrite** requiring neovim 0.12+ (minimum supported version),
self-contained for SSH lab machines. The legacy config lives on `dev`/`master`.

[中文说明](README_zh.md)

## Layout

```
init.lua
stylua.toml               -- 4 spaces, single quotes, always parens, unix endings
lua/
├── settings/init.lua     -- user-tweakable settings (use_git_ssh)
├── core/
│   ├── init.lua          -- module loader
│   ├── options.lua       -- editor options (incl. OSC52 clipboard, winborder)
│   ├── keymap.lua        -- declarative keymaps (<leader> groups: f/b/l/e)
│   ├── plugins.lua       -- vim.pack specs + setup dispatch
│   └── lsp.lua           -- builtin vim.lsp.config (clangd / lua_ls / pyright)
├── plugins/              -- one setup file per plugin, named by repo basename
│   ├── tokyonight.nvim.lua
│   ├── nvim-treesitter.lua
│   ├── fzf-lua.lua
│   ├── mini.nvim.lua
│   └── blink.cmp.lua
└── utils/
    └── platform.lua      -- os / ssh detection
```

## Design decisions

- **Minimum supported version: neovim 0.12** (hard guard in `init.lua`; raise deliberately as needs grow).
- **Plugin manager: builtin `vim.pack`** (0.12+). Zero bootstrap; `git clone` this repo and go.
  Specs are plain `{ src, version }` tables; migrating to lazy.nvim later only touches `plugins.lua`.
- **Plugin clones default to SSH** (`git@github.com:...`) with automatic fallback to HTTPS —
  see `use_git_ssh` in `lua/settings/init.lua`.
- **No nvim-lspconfig.** Servers are declared with builtin `vim.lsp.config()` + `vim.lsp.enable()`;
  each server is ~10 explicit lines, identical behavior across 0.11–0.12+.
- **No mason.** LSP servers and CLI deps come from distro packages (predictable on SSH hosts,
  no GitHub binary downloads).
- **treesitter `main` branch** (active development line, requires 0.11+).
- **Icons enabled** — a nerd font (e.g. Maple Mono NF CN) is only needed on the *local* terminal;
  remote hosts need nothing.

## Install

```bash
git clone -b v2 git@github.com:zhang-stephen/nvim.git ~/.config/nvim
nvim   # first startup installs plugins (one confirmation prompt)
```

## System dependencies (once per host)

```bash
# debian 13
sudo apt install git gcc fzf ripgrep clangd lua-language-server
# fedora 44
sudo dnf install git gcc fzf ripgrep clang-tools-extra lua-language-server
# python lsp (either; pulls in nodejs)
sudo apt install pyright 2>/dev/null || pip install pyright
```

If the distro has no `lua-language-server` package (e.g. fedora), install the
official release binary (check the releases page for the latest version;
use `linux-arm64.tar.gz` on arm hosts):

```bash
mkdir -p ~/.local/share/lua-language-server
curl -L https://github.com/LuaLS/lua-language-server/releases/download/3.15.0/lua-language-server-3.15.0-linux-x64.tar.gz \
  | tar xz -C ~/.local/share/lua-language-server
ln -sf ~/.local/share/lua-language-server/bin/lua-language-server ~/.local/bin/
```

If the distro neovim is too old, install the official tarball into `~/.local`:

```bash
# arm64 (rpi5)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
# x86_64
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-*.tar.gz -C ~/.local --strip-components=1   # ensure ~/.local/bin is in PATH
```

(`curl` and `tar` are needed for this one-time step.)

## Git integration

- **gitsigns**: diff signs, hunk actions, and gitlens-style current-line blame (virtual text)
- **mini.git**: branch in statusline, blame at cursor, `:Git` command wrapper
- **fzf-lua git pickers**: `git_status` / `git_commits` / `git_branches` / `git_stash`
- heavy interactive work (rebase, bulk staging): use **lazygit** (single binary, ssh-friendly)

## eBPF projects and clangd

eBPF C is just C — clangd handles it. Put a `compile_flags.txt` in the project root:

```
-target
bpf
-D__TARGET_ARCH_x86
-I.
```

and generate kernel type definitions from the host BTF (the core of CO-RE):

```bash
bpftool btf dump file /sys/kernel/btf/vmlinux format c > vmlinux.h
```

(requires kernel BTF; fedora VM has it, rpi5 does not.)

bpftrace scripts have no LSP — treat as plain text.

## Keymap groups

| group | keys |
|---|---|
| find | `<leader>ff` files · `<leader>fg` grep · `<leader>fb` buffers · `<leader>fs` symbols · `<leader>fd` diagnostics |
| buffer | `]b` / `[b` cycle · `<leader>bd` close |
| lsp | `gd` definition · `grr` references · `grn` rename · `gra` action · `K` hover · `<leader>ld` line diagnostics |
| explorer | `<leader>e` mini.files |
| terminal | `<C->` toggle panel · `<leader>tn` new shell · `<leader>t]`/`<leader>t[` cycle · `<leader>tx` kill · `<leader>tr` rerun task · `:TermRun`/`:T` run command |

## Verification checklist

- [ ] `nvim --version` ≥ 0.12
- [ ] `.c` file: highlighting works; `gd`, `K`, `grr` work
- [ ] completion popup appears while typing, docs auto-expand
- [ ] `<leader>ff` / `<leader>fg` / `<leader>fb` work
- [ ] `<leader>e` opens file explorer; `]b` `[b` cycle buffer tabs
- [ ] over SSH: yank reaches the local clipboard (OSC52)
- [ ] `:checkhealth vim.lsp` is green

## FAQ

- **blink.cmp fuzzy matcher download fails** (restricted network): set
  `fuzzy.implementation = 'lua'` in `plugins.lua`.
- **treesitter parser build fails**: missing `gcc` — install the system dependencies above.
- **icons show as boxes**: run `printf '\ue0b0 \uf07b \uf15b\n'` in the terminal.
  Boxes there too → the *local* terminal font is not a nerd font (install Maple Mono NF CN
  locally and select it in the terminal profile). Glyphs fine → report a config issue.
