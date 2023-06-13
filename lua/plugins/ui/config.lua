local config = {}

config.catppuccin = function()
    require('catppuccin').setup({
        transparent_background = true,
        term_colors = true,
        integrations = {
            treesitter = true,
            native_lsp = { enabled = true },
            cmp = true,
            lsp_saga = true,
            gitsigns = true,
            telescope = true,
            nvimtree = {
                enabled = true,
                show_root = false,
                transparent_panel = true,
            },
            which_key = true,
            bufferline = true,
            ts_rainbow = false,
            hop = false,
            notify = true,
        },
    })

    vim.api.nvim_command('color catppuccin')
end

config.lualine = function()
    local extend_sections = {
        lualine_a = { 'filetype' },
    }

    local aerial = {
        sections = extend_sections,
        filetypes = { 'aerial' },
    }

    -- TODO: add DAP UI
    -- local dapui = {
    --     sections = extend_sections,
    --     filetypes = {
    --         ['dapui_scopes'] = 'DAP Scopes',
    --         ['dapui_stacks'] = 'DAP Stacks',
    --         ['dapui_breakpoints'] = 'DAP Breakpoints',
    --         ['dapui_watches'] = 'DAP Watches',
    --     },
    -- }

    require('lualine').setup({
        options = {
            icons_enabled = true,
            theme = 'auto',
            disabled_filetypes = {},
            component_separators = '|',
            section_separators = nil,
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { { 'branch' }, { 'diff' } },
            lualine_c = {},
            lualine_x = {
                {
                    'diagnostics',
                    sources = { 'nvim_diagnostic' },
                    symbols = { error = ' ', warn = ' ', info = ' ' },
                },
            },
            lualine_y = { 'filetype', 'encoding', 'fileformat' },
            lualine_z = { 'progress', 'location' },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {
            'quickfix',
            'nvim-tree',
            'toggleterm',
            'fugitive',
            aerial,
            -- dapui,
        },
    })
end

config.barbecue = function()
    require('barbecue').setup({
        create_autocmd = false, -- prevent barbecue from updating itself automatically
        symbols = {
            separator = '>',
        },
        -- FIXME: find out if the icons could be displayed on other environments
        kinds = {
            File = '',
            Module = '',
            Namespace = '',
            Package = '',
            Class = '',
            Method = '',
            Property = '',
            Field = '',
            Constructor = '',
            Enum = '',
            Interface = '',
            Function = '',
            Variable = '',
            Constant = '',
            String = '',
            Number = '',
            Boolean = '',
            Array = '',
            Object = '',
            Key = '',
            Null = '',
            EnumMember = '',
            Struct = '',
            Event = '',
            Operator = '',
            TypeParameter = '',
        },
    })

    vim.api.nvim_create_autocmd({
        'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
        'BufWinEnter',
        'CursorHold',
        'InsertLeave',

        -- include this if you have set `show_modified` to `true`
        'BufModifiedSet',
    }, {
        group = vim.api.nvim_create_augroup('barbecue.updater', {}),
        callback = function()
            require('barbecue.ui').update()
        end,
    })
end

config.bufferline = function()
    require('bufferline').setup({
        options = {
            numbers = function(opts)
                return string.format('%s/%s', opts.raise(opts.id), opts.lower(opts.ordinal))
            end,
            modified_icon = '*',
            buffer_close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            max_name_length = 14,
            max_prefix_length = 13,
            tab_size = 20,
            show_buffer_close_icons = true,
            show_buffer_icons = true,
            show_tab_indicators = true,
            diagnostics = 'nvim_lsp',
            always_show_bufferline = true,
            separator_style = 'thin',
            offsets = {
                {
                    filetype = 'NvimTree',
                    text = 'File Explorer',
                    text_align = 'center',
                    padding = 1,
                },
            },
        },
        highlights = {},
    })
end

config.nvim_tree = function()
    require('nvim-tree').setup({
        disable_netrw = true,
        hijack_netrw = true,
        open_on_tab = false,
        hijack_cursor = true,
        update_cwd = false,
        diagnostics = {
            enable = false,
            icons = { hint = '', info = '', warning = '', error = '' },
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {},
        },
        system_open = { cmd = nil, args = {} },
        filters = { dotfiles = false, custom = {} },
        git = { enable = true, ignore = true, timeout = 500 },
        view = {
            width = 30,
            hide_root_folder = false,
            side = 'left',
            adaptive_size = true,
            mappings = { custom_only = false, list = {} },
            number = false,
            relativenumber = false,
            signcolumn = 'yes',
        },
        trash = { cmd = 'trash', require_confirm = true },
    })
end

return config
