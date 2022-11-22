local lsp = {}
local conf = require('modules.lsp.config')

lsp['neovim/nvim-lspconfig'] = {
    opt = true,
    event = 'BufReadPre',
    config = conf.nvim_lsp,
}
lsp['creativenull/efmls-configs-nvim'] = {
    opt = false,
    requires = 'neovim/nvim-lspconfig',
}
lsp['williamboman/mason.nvim'] = {
    opt = false,
    requires = {
        { 'williamboman/mason-lspconfig.nvim' },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim', config = conf.mason_install },
    },
}
lsp['glepnir/lspsaga.nvim'] = {
    opt = true,
    event = 'LspAttach',
    config = conf.lspsaga,
}
lsp['ray-x/lsp_signature.nvim'] = { opt = true, after = 'nvim-lspconfig' }
lsp['hrsh7th/nvim-cmp'] = {
    config = conf.cmp,
    event = 'InsertEnter',
    requires = {
        { 'onsails/lspkind.nvim' },
        { 'lukas-reineke/cmp-under-comparator' },
        { 'saadparwaiz1/cmp_luasnip', after = 'LuaSnip' },
        { 'hrsh7th/cmp-nvim-lsp', after = 'cmp_luasnip' },
        { 'hrsh7th/cmp-nvim-lua', after = 'cmp-nvim-lsp' },
        { 'andersevenrud/cmp-tmux', after = 'cmp-nvim-lua' },
        { 'hrsh7th/cmp-path', after = 'cmp-tmux' },
        { 'f3fora/cmp-spell', after = 'cmp-path' },
        { 'hrsh7th/cmp-buffer', after = 'cmp-spell' },
        { 'kdheepak/cmp-latex-symbols', after = 'cmp-buffer' },
    },
}
lsp['L3MON4D3/LuaSnip'] = {
    after = 'nvim-cmp',
    config = conf.luasnip,
    requires = 'rafamadriz/friendly-snippets',
}
lsp['windwp/nvim-autopairs'] = {
    after = 'nvim-cmp',
    config = conf.autopairs,
}

return lsp
