# Neovim Configurations for High Flexibility

This is my neovim configurations, for working, studying and other scenarios. And it's expected with high flexiblity for different working.

### Features

- [ ] core configurations of neovim
- [ ] support different languages with nvim-lspconfig
    - [ ] Lua
    - [ ] C/C++
    - [ ] Python
    - [ ] CMake
    - [ ] Rust
    - [ ] SystemVerilog(also Verilog)
    - [ ] Json
    - [ ] Yaml
    - [ ] Toml(for rustc/cargo)
- [ ] code formatting
- [ ] health check in nvim style
    - requested softwares, e.g. git
    - dynamic dependencies, requested by LSP servers
- [ ] more flexible settings with setting.json
    - `$XDG_CONFIG_HOME/nvim/settings.json` for global settings
    - `<project>/.nvim/settings.json` for project-specified settings
- [ ] nvim auto command
- [ ] lazy-loading modules, powered by [lazy.nvim](https://github.com/folke/lazy.nvim)
- [ ] auto completions
- [ ] better nvim terminals
- [ ] debugger adapter protocol

Well, I want to make neovim be a complex IDE...

### Configurations

#### Core Configuration of Neovim

For nvim built-in options, keymaps and others, no dependency except nvim itself.

If the modules(plugins) are enabled, there should be a git to download/update modules.

#### Language Support

Ok, it's more complex than core configurations.

Most of LSP servers are npm package, and that means a node.js environment is required, and some LSP servers are delivered by [crates.io](https://crates.io), so Rust itself is required too.

#### Code Formatting

In the planning, [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) is the base of code formatting, but I am not sure what the dependencies are.

#### Health Check

Planning... But a dynamic checking is required.

#### Settings

To be done.
