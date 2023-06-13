local config = {}

config.aerial = function()
    require('aerial').setup({
        backups = { 'lsp', 'treesitter' },
        filter_kind = {
            'Class',
            'Constant',
            'Constructor',
            'Enum',
            'EnumMember',
            'Field',
            'Function',
            'Interface',
            'Key',
            'Module',
            'Method',
            'Namespace',
            'Object',
            'Operator',
            'Package',
            'Property',
            'Struct',
            'TypeParameter',
            'Variable',
        },
        max_width = { 60, 0.35 },
        close_behavior = 'close',
    })
end

config.treesitter = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'c',
            'cpp',
            'json',
            'python',
            'rust',
            'yaml',
            'toml',
            'lua',
            'cmake',
            'make',
            'vim',
            'bash',
        },
        highlight = {
            enable = true,
            disable = { 'vim' },
        },
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']['] = '@function.outer',
                [']m'] = '@class.outer',
            },
            goto_next_end = {
                [']]'] = '@function.outer',
                [']M'] = '@class.outer',
            },
            goto_previous_start = {
                ['[['] = '@function.outer',
                ['[m'] = '@class.outer',
            },
            goto_previous_end = {
                ['[]'] = '@function.outer',
                ['[M'] = '@class.outer',
            },
        },
        rainbow = {
            enable = true,
            extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
            max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        },
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
        matchup = {
            enable = true,
        },
        context = {
            enable = true,
            throttle = true,
        },
    })

    require('nvim-treesitter.install').prefer_git = true
end

config.matchup = function()
    vim.api.nvim_command([[let g:matchup_matchparen_offscreen = {'method': 'popup'}]])
end

return config
