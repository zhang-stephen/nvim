local conf = require('plugins.editor.config')

return {
    -- advanced comments
    {
        'numToStr/Comment.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = true,
    },
    {
        'folke/todo-comments.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = true,
        keys = {
            {
                '<leader>t[',
                '<cmd>lua require("todo-comments").jump_prev()<CR>',
                mode = 'n',
                desc = 'previous todo comment',
            },
            {
                '<leader>t]',
                '<cmd>lua require("todo-comments").jump_next()<CR>',
                mode = 'n',
                desc = 'next todo comment',
            },
        },
    },

    -- marks & bookmarks
    {
        'chentoast/marks.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = true,
    },

    -- outline
    {
        'stevearc/aerial.nvim',
        event = 'LspAttach',
        cmd = { 'AerialToggle' },
        module = true,
        config = conf.aerial,
        keys = {
            { '<leader>o', '<cmd>AerialToggle<CR>', mode = 'n', desc = 'toggle outline view' },
        },
    },

    -- highlighter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate all',
        event = { 'BufReadPre', 'BufNewFile', 'LspAttach' },
        config = conf.treesitter,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'romgrk/nvim-treesitter-context',
            'p00f/nvim-ts-rainbow',
            'mfussenegger/nvim-ts-hint-textobject',
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
    },
}
