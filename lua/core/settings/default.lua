-- the default user settings with dynamic application

local DEFAULT_USER_SETTING = {
    ---@type table builtin options/settings of neovim
    builtins = {},

    ---@type table options for plugins
    plugins = {
        -- example ENV: NVIM_PLUGINS_USE_SSH
        -- use SSH to download plugins and treesitter parsers from github instead of HTTPS
        use_ssh = true,

        lsp = {
            -- C/C++
            cpp = {
                ---@type string C/C++ language server: clangd/ccls
                c_cxx_server = 'clangd',
                ---@type table<string> default arguments, passed to c_cxx_server directly
                default_args = {
                    '-j=6',
                    '--background-index',
                    '--pch-storage=memory',
                    -- '--clang-tidy',
                    '--all-scopes-completion',
                    '--cross-file-rename',
                    '--completion-style=detailed',
                    '--header-insertion-decorators',
                    '--header-insertion=iwyu',
                },
            },
            lua = {
                ---@type string the default version of sumneko_lua
                version = 'Lua5.1', -- for nvim lua
                ---@type table<string> registed global vars
                globals = {
                    'vim',
                    'packer_plugins',
                },
                ---@type table<string, boolean> libraries enabled
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
        editor = {
            -- Telescope
            telescope = {
                ---@type string | nil the path to find libsqlite3.so
                sqlite_clib_path = nil,
            },
        },
    },
}

return DEFAULT_USER_SETTING
