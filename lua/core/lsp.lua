-- lsp via builtin vim.lsp.config/enable (neovim 0.11+), no nvim-lspconfig
-- servers come from distro packages (see README), avoiding mason's github downloads
local lsp = {}

lsp.setup = function()
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

return lsp
