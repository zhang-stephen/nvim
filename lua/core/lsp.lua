-- lsp via builtin vim.lsp.config/enable (neovim 0.11+), no nvim-lspconfig
-- servers come from distro packages (see README), avoiding mason's github downloads
local lsp = {}

lsp.setup = function()
    -- client capabilities, advertised to every server via the '*' config:
    -- - workspace/didChangeWatchedFiles: let clangd register file watchers
    --   (compile_commands.json / header changes without :LspRestart)
    -- - blink.cmp: snippet completion and rich completion items
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
    local blink_ok, blink = pcall(require, 'blink.cmp')
    if blink_ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
    end
    vim.lsp.config('*', { capabilities = capabilities })

    -- c/c++/ebpf
    -- project root is located by compile_commands.json (cmake: -DCMAKE_EXPORT_COMPILE_COMMANDS=ON)
    -- or compile_flags.txt (ebpf template in README)
    vim.lsp.config('clangd', {
        cmd = {
            'clangd',
            '-j=8',
            '--log=info',
            '--pch-storage=memory',
            '--enable-config',
            '--header-insertion=iwyu',
            '--clang-tidy',
            '--completion-style=detailed',
            '--background-index',
            '--all-scopes-completion',
            '--pretty',
        },
        filetypes = { 'c', 'cpp' },
        root_markers = { 'compile_commands.json', 'compile_flags.txt', '.clangd', '.git' },
    })

    -- lua (for maintaining this config)
    vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.stylua.toml', 'stylua.toml', '.git' },
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = { library = vim.api.nvim_get_runtime_file('', true) },
                telemetry = { enable = false },
            },
        },
    })

    -- python (bcc scripts, tooling)
    vim.lsp.config('pyright', {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', '.git' },
    })

    vim.lsp.enable({ 'clangd', 'lua_ls', 'pyright' })
end

-- capabilities() requires blink.cmp from the rtp, so core/init.lua loads
-- this after core/plugins (vim.pack add)
return lsp
