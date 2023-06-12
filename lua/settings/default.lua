-- default settings, used in plugins configuration

return {
    plugins = {
        use_git_ssh = false,

        -- all registries found here: https://mason-registry.dev/registry/list
        registries = {
            lsp = {
                -- language servers, should be compatible with nvim-lspconfig
                ['lua-language-server'] = {
                    -- enabled or not, if not enabled, it won't be installed or configured
                    enabled = true,
                    -- installer by mason.nvim, or 'system' for installer by package manager,
                    installer = 'mason',
                    -- registry types, it would be ignored if installer is 'system'
                    -- npm, binary, crates, pypi, git, for health checking
                    type = 'git',
                    -- lspconfig name
                    -- it could be nil if it's same as registry name
                    name = 'lua_ls',
                    options = {
                        -- configurations passed to lspconfig
                        -- FIXME: not support field root_dir(it's a lua class, not a list)
                        settings = {
                            Lua = {
                                runtime = {
                                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                    version = 'LuaJIT',
                                },
                                diagnostics = {
                                    -- Get the language server to recognize the `vim` global
                                    globals = { 'vim' },
                                },
                                workspace = {
                                    -- Make the server aware of Neovim runtime files
                                    library = vim.api.nvim_get_runtime_file('', true),
                                },
                                -- Do not send telemetry data containing a randomized but unique identifier
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    },
                },
                clangd = {
                    enabled = true,
                    installer = 'system',
                    type = 'binary',
                    options = {
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
                        single_file_support = true,
                    },
                },
                pyright = {
                    enabled = true,
                    installer = 'mason',
                    type = 'npm',
                    options = {},
                },
                ['cmake-language-server'] = {
                    enabled = true,
                    installer = 'mason',
                    type = 'pypi',
                    name = 'cmake',
                    options = {},
                },
                ['rust-analyzer'] = {
                    enabled = false,
                    installer = 'mason',
                    type = 'git',
                    options = {},
                },

                svls = {
                    enabled = false,
                    installer = 'mason',
                    type = 'crates',
                    options = {},
                },

                ['json-lsp'] = {
                    enabled = true,
                    installer = 'mason',
                    type = 'npm',
                    name = 'jsonls',
                    options = {},
                },

                taplo = {
                    enabled = false,
                    installer = 'mason',
                    type = 'crates',
                    options = {},
                },
            },

            null = {
                -- hooks to nvim builtin lsp, should be compatible with null-ls.nvim
                -- linters

                -- formatters

                -- DAP clients
            },
        },
    },
}
