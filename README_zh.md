# nvim 配置（v2 重写版）

个人 neovim 配置。**本分支（`v2`）是最低兼容 neovim 0.12 的重写**，
面向 SSH 实验机自包含设计。旧配置在 `dev`/`master` 分支。

## 目录结构

```
init.lua                  -- 版本守卫，然后平级调用三层
stylua.toml               -- 4 空格缩进、单引号、调用带括号、Unix 换行
lua/
├── settings.lua          -- 用户可调设置（use_git_ssh）
├── core/
│   ├── init.lua          -- options → keymap → plugins → lsp
│   ├── options.lua       -- 编辑器选项（含 OSC52 剪贴板、winborder）
│   ├── keymap.lua        -- 声明式键位（<leader> 分组：f/b/l/e）
│   ├── plugins.lua       -- vim.pack 插件声明 + 安装（基础设施）
│   └── lsp.lua           -- 内置 vim.lsp.config（clangd / lua_ls / pyright）
├── plugins/              -- 插件个性化设置，每个 repo 名一个文件
│   ├── init.lua          -- setup 调度（目录扫描）
│   ├── tokyonight.nvim.lua
│   ├── nvim-treesitter.lua
│   ├── fzf-lua.lua
│   ├── mini.nvim.lua
│   ├── blink.cmp.lua
│   └── gitsigns.nvim.lua
└── utils/                -- 手写工具模块（见其 AGENTS.md）
    ├── init.lua          -- require 有副作用的模块
    └── term.lua          -- panel 式双模终端管理器
```

## 设计决策

- **最低兼容版本：neovim 0.12**（`init.lua` 硬守卫；以后按需提升下限）。
- **插件管理器：内置 `vim.pack`**（0.12+）。零 bootstrap，克隆本仓库即可上岗。
  声明就是 `{ src, version }` 表；将来迁 lazy.nvim 只需改 `plugins.lua` 一个文件。
- **插件 clone 默认走 SSH**（`git@github.com:...`），失败自动回退 HTTPS——
  见 `lua/settings/init.lua` 的 `use_git_ssh`。
- **不用 nvim-lspconfig**：服务器用内置 `vim.lsp.config()` + `vim.lsp.enable()` 声明，
  每个约 10 行显式配置，0.11–0.12+ 行为一致。
- **不用 mason**：LSP 服务器和命令行依赖全部走发行版包（SSH 机器上可预期，
  避免从 GitHub 下二进制）。
- **treesitter 用 `main` 分支**（活跃开发线，要求 0.11+）。
- **图标开启**——nerd font（如 Maple Mono NF CN）只需装在*本地*终端，远端机器无需任何处理。

## 部署

```bash
git clone -b v2 git@github.com:zhang-stephen/nvim.git ~/.config/nvim
nvim   # 首次启动自动安装插件（有一次确认提示）
```

## 系统依赖（每台机器执行一次）

```bash
# debian 13
sudo apt install git gcc fzf ripgrep clangd lua-language-server
# fedora 44
sudo dnf install git gcc fzf ripgrep clang-tools-extra lua-language-server
# python lsp（任选其一；会带入 nodejs）
sudo apt install pyright 2>/dev/null || pip install pyright
```

发行版源没有 `lua-language-server` 时（如 fedora），装官方 release 二进制
（版本号去 releases 页看最新；arm 机器用 `linux-arm64.tar.gz`）：

```bash
mkdir -p ~/.local/share/lua-language-server
curl -L https://github.com/LuaLS/lua-language-server/releases/download/3.15.0/lua-language-server-3.15.0-linux-x64.tar.gz \
  | tar xz -C ~/.local/share/lua-language-server
ln -sf ~/.local/share/lua-language-server/bin/lua-language-server ~/.local/bin/
```

发行版源里的 neovim 版本过旧时，用官方 tarball 装到 `~/.local`：

```bash
# arm64（RPi5）
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
# x86_64
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-*.tar.gz -C ~/.local --strip-components=1   # 确保 ~/.local/bin 在 PATH
```

（这个一次性步骤需要 `curl` 和 `tar`。）

## Git 集成

- **gitsigns**：diff 标记、hunk 操作、GitLens 风格当前行 blame（虚拟文本）
- **mini.git**：statusline 分支名、光标处 blame、`:Git` 命令包装
- **fzf-lua git pickers**：`git_status` / `git_commits` / `git_branches` / `git_stash`
- 重度交互操作（rebase、批量 staging）：用 **lazygit**（单二进制，SSH 友好）

## eBPF 项目的 clangd 配置

eBPF C 就是 C，clangd 全权负责。项目根放 `compile_flags.txt`：

```
-target
bpf
-D__TARGET_ARCH_x86
-I.
```

并从本机 BTF 生成内核类型定义（CO-RE 的核心）：

```bash
bpftool btf dump file /sys/kernel/btf/vmlinux format c > vmlinux.h
```

（需要内核有 BTF；Fedora VM 有，RPi5 无。）

bpftrace 脚本没有 LSP，当普通文本处理。

## 键位分组

| 分组 | 键位 |
|---|---|
| find | `<leader>ff` 文件 · `<leader>fg` 全文 · `<leader>fb` buffer · `<leader>fs` 符号 · `<leader>fd` 诊断 |
| buffer | `]b` / `[b` 切换 · `<leader>bd` 关闭 |
| lsp | `gd` 定义 · `grr` 引用 · `grn` 重命名 · `gra` code action · `K` 文档 · `<leader>ld` 行诊断 |
| explorer | `<leader>e` 文件管理器 |
| terminal | `<C->` 面板开关 · `<leader>tn` 新建 shell · `<leader>t]`/`<leader>t[` 切换 · `<leader>tx` 关闭 · `<leader>tr` 重跑任务 · `:TermRun`/`:T` 委托命令 |

## 验证清单

- [ ] `nvim --version` ≥ 0.12
- [ ] 打开 `.c` 文件有高亮；`gd` 跳定义、`K` 浮窗文档、`grr` 找引用
- [ ] 输入触发补全弹窗，文档自动展开
- [ ] `<leader>ff` / `<leader>fg` / `<leader>fb` 正常
- [ ] `<leader>e` 打开文件管理器；`]b` `[b` 切换 buffer 标签
- [ ] SSH 会话里 `y` 复制能进本地剪贴板（OSC52）
- [ ] `:checkhealth vim.lsp` 全绿

## 常见问题

- **blink.cmp 模糊匹配器下载失败**（网络受限）：`plugins.lua` 里 `fuzzy.implementation` 改 `'lua'`
- **treesitter parser 编译失败**：缺 `gcc`，装上面的系统依赖
- **图标显示为方块**：在终端里跑 `printf '\ue0b0 \uf07b \uf15b\n'`。
  这里也是方块 → *本地*终端字体不是 nerd font（本地装 Maple Mono NF CN 并在终端 profile 里选中）；
  字形正常 → 是配置问题，报回来。
