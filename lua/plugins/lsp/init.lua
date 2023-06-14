-- Language Server Protocol plugins

local conf = require('plugins.lsp.config')

local lsp = {
    {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
        config = conf.mason,
    },

    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        config = conf.mason_installer,
        build = ':MasonToolInstall',
    },

    -- LSP servers
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        module = true,
        config = conf.lspconfig,
    },
    {
        'glepnir/lspsaga.nvim',
        event = 'LspAttach',
        config = conf.lspsaga,
        keys = {
            { 'K', '<cmd>Lspsaga hover_doc<CR>', mode = 'n', desc = 'hover document view' },
            { 'g[', '<cmd>Lspsaga diagnostic_jump_prev<CR>', mode = 'n', desc = 'goto previous dianostic' },
            { 'g]', '<cmd>Lspsaga diagnostic_jump_next<CR>', mode = 'n', desc = 'goto next dianostic' },
            { 'gs', '<cmd>Lspsaga signature_help<CR>', mode = 'n', desc = 'signature help' },
            { 'gd', '<cmd>Lspsaga peek_definition<CR>', mode = 'n', desc = 'goto definition' },
            { '<leader>ca', '<cmd>Lspsaga code_action<CR>', mode = 'n', desc = 'do some code actions' },
            { '<leader>ca', '<cmd>Lspsaga code_action<CR>', mode = 'v', desc = 'do some code actions in the range' },
            { '<leader>rn', '<cmd>Lspsaga rename<CR>', mode = 'n', desc = 'symbol rename' },
            { '<leader>o', '<cmd>Lspsaga outline<CR>', mode = 'n', desc = 'outline view'},
        },
    },
    {
        'ray-x/lsp_signature.nvim',
        event = 'LspAttach',
    },

    -- autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'onsails/lspkind.nvim',
            'lukas-reineke/cmp-under-comparator',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'andersevenrud/cmp-tmux',
            'hrsh7th/cmp-path',
            'f3fora/cmp-spell',
            'hrsh7th/cmp-buffer',
            'kdheepak/cmp-latex-symbols',
        },
        config = conf.nvim_cmp,
    },

    {
        'L3MON4D3/LuaSnip',
        module = true,
        event = 'InsertEnter',
        build = 'make install_jsregexp',
        config = conf.luasnip,
    },
    {
        'windwp/nvim-autopairs',
        module = true,
        event = 'InsertEnter',
        config = conf.autopairs,
    },

    -- Linters & Formatters
    {
        'jose-elias-alvarez/null-ls.nvim',
        event = 'BufReadPre',
        module = true,
    },

    -- DAPs
    -- TODO: not completed now
}

return lsp
