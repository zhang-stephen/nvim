-- **Experimental** --
-- user settings, which is following projects
-- would be referred in the plugin configurations, to adapt requirements of different projects
-- nvim +PackerSync is still required if settings were updated...

-- the default user settings could be obtained from following methods(priority high to low):
--     + <project_root>/.nvim/settings.json(or yaml), a folder with .git/, .nvim/ or .proj would be treated as a project
--     + envrionment variables, name pattern: NVIM_<FIELDS>(capitalized)(not implemented)
--     + $XDG_CONFIG_HOME/.nvim.json

local settings = {
    root_dir_patterns = { 'git/', '.nvim/', '.proj' },
}

local DEFAULT_USER_SETTING = {
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
                    '-j=12',
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
            ts = {
                ---@type string | nil the path to find libsqlite3.so
                sqlite_clib_path = nil,
            },
        },
    },
}

settings.get = function()
    return DEFAULT_USER_SETTING
end

settings.setup = function() end

return settings

-- EOF
