-- default settings, used in plugins configuration

return {
    plugins = {
        use_git_ssh = false,

        -- all registries found here: https://mason-registry.dev/registry/list
        registries = {
            lsp = {
                -- language servers, should be compatible with nvim-lspconfig
                ['lua-language-server']   = {
                    enabled = false,
                    installer = 'mason', -- installer by mason.nvim, or 'system' for installer by package manager,
                    type = 'git',        -- npm, binary, crates, pypi, git, for health checking
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
                                    library = vim.api.nvim_get_runtime_file("", true),
                                },
                                -- Do not send telemetry data containing a randomized but unique identifier
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    },
                },

                clangd                    = {
                    enabled = true,
                    installer = 'system',
                    type = 'binary',
                    options = {
                        cmd = {
                            'clangd',
                            "-j=8",
                            "--log=info",
                            "--pch-storage=memory",
                            "--enable-config",
                            "--header-insertion=iwyu",
                            "--clang-tidy",
                            "--completion-style=detailed",
                            "--background-index",
                            "--all-scopes-completion",
                            "--pretty"
                        },
                        single_file_support = true,
                    },
                }
                ,
                pyright                   = {
                    enabled = false,
                    installer = 'mason',
                    type = 'npm',
                    options = {},
                }
                ,
                ['cmake-language-server'] = {
                    enabled = false,
                    installer = 'mason',
                    type = 'pypi',
                    options = {},
                }
                ,
                ['rust-analyzer']         = {
                    enabled = false,
                    installer = 'mason',
                    type = 'git',
                    options = {},
                }
                ,

                svls                      = {
                    enabled = false,
                    installer = 'mason',
                    type = 'crates',
                    options = {}
                },

                ['json-lsp']              = {
                    enabled = false,
                    installer = 'mason',
                    type = 'npm',
                    options = {},
                },

                taplo                     = {
                    enabled = false,
                    installer = 'mason',
                    type = 'crates',
                    options = {},
                }
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
