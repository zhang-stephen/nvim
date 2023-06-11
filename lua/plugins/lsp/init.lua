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
    },

    -- LSP servers
    {
        'neovim/nvim-lspconfig',
        event = 'BufReadPre',
        module = true,
        config = conf.lspconfig,
    },
    {
        'glepnir/lspsaga.nvim',
        event = 'LspAttach',
        config = conf.lspsaga,
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
        build = "make install_jsregexp",
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
