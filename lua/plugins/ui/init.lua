local conf = require('plugins.ui.config')

return {
    {
        'dstein64/nvim-scrollview',
        event = 'BufReadPre',
        config = true,
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        config = conf.catppuccin,
    },
    {
        'hoob3rt/lualine.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = conf.lualine,
    },
    {
        'akinsho/nvim-bufferline.lua',
        event = { 'BufReadPre', 'BufNewFile' },
        branch = 'main',
        config = conf.bufferline,
    },
    {
        'nvim-tree/nvim-tree.lua',
        cmd = { 'NvimTreeToggle', 'NvimTreeOpen' },
        config = conf.nvim_tree,
    },
}
