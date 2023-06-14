# Neovim Configurations for High Flexibility

This is my neovim configurations, for working, studying and other scenarios. And it's expected with high flexiblity for different working.

### Features

- [x] core configurations of neovim
- [x] support different languages with nvim-lspconfig
    - [x] Lua
    - [x] C/C++
    - [x] Python
    - [x] CMake
    - [ ] Rust
    - [ ] SystemVerilog(also Verilog)
    - [x] Json
    - [ ] Yaml
    - [ ] Toml(for rustc/cargo)
- [ ] code formatting
- [ ] health check in nvim style
    - requested softwares, e.g. git
    - dynamic dependencies, requested by LSP servers
- [x] more flexible settings with setting.json
    - `$XDG_CONFIG_HOME/nvim/settings.json` for global settings
    - `<project>/.nvim/settings.json` for project-specified settings
- [ ] nvim auto command
- [x] lazy-loading modules, powered by [lazy.nvim](https://github.com/folke/lazy.nvim)
- [x] auto completions, powered by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) and its extensions
- [ ] better nvim terminals
- [ ] debugger adapter protocol

Well, I want to make neovim be a complex IDE...

### Dependencies

There are some pre-requesties for basic functions:

- a v3.0+ patched font from [Nerd Fonts](https://nerdfonts.com) for unicode icons
- git for plugins installation

For language servers, there are some pre-requesties for different languages

- no check for language servers, which are not installed by [mason.nvim](https://github.com/williamboman/mason.nvim),
- if a server should be installed by mason.nvim:
    - git for language servers, which have type `git`,
    - nodejs for language servers, which have type `npm`,
    - python3 & pip3 for language servers, which have type `pypi`,
    - cargo for language servers, which have type `crates`,
- only `enabled = true` servers would be checked by health check.

### Configurations

#### `lua/core`

All of built-in options and keymaps could be found here, and some user-defined auto commands & auto command groups.

And bootstraped lazy.nvim configuration could be found in [lua/core/plugins.lua](lua/core/plugins.lua), other plugins should be loaded here.

#### `lua/settings`

Declarative key-valued settings, for customed plugin configuration and environment variables could be found here.

The default settings could be found [lua/settings/default.lua](lua/settings/default.lua). User could create `vim.fn.stdpath('data')/settings.json` or `<proj_root>/.nvim/settings.json` to have more settings custom-made. Settings in `<proj_root>/.nvim` has the highest priority and the `default.lua` has the lowest.

New language server configuration could be declared in any of `settings.json`, instead of changing the `default.lua`, which is basic configuration for language servers.

#### `lua/plugins`

Specifications and configurations for plugins.

#### `lua/utils`

Utility functions for all neovim configurations.

### Others

#### Code Formatting

In the planning, [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) is the base of code formatting, but I am not sure what the dependencies are.

#### Health Check

Planning... But a dynamic checking is required.

#### Settings

To be done.
