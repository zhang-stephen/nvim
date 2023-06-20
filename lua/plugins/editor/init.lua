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
            {
                'andymass/vim-matchup',
                config = conf.matchup,
            },
        },
    },

    -- enhaced git
    {
        'tpope/vim-fugitive',
        cmd = { 'Git', 'G' },
    },

    -- movements
    {
        'phaazon/hop.nvim',
        config = conf.hop,
        cmd = {
            'HopLine',
            'HopLineStart',
            'HopWord',
            'HopPattern',
            'HopChar1',
            'HopChar2',
        },
        opts = {
            keys = 'etovxqpdygfblzhckisuran',
        },
        keys = {
            { '<leader>hl', '<cmd>HopLine<CR>', mode = 'n', desc = 'hop to any line' },
            { '<leader>hw', '<cmd>HopWord<CR>', mode = 'n', desc = 'hop to any word' },
            { '<leader>hc', '<cmd>HopChar1<CR>', mode = 'n', desc = 'hop to any char' },
        },
    },

    -- better scroll
    {
        'karb94/neoscroll.nvim',
        event = 'WinScrolled',
        config = true,
    },

    -- advanced terminals
    -- others
    {
        'romainl/vim-cool',
        event = { 'CursorMoved', 'InsertEnter' },
        config = function()
            vim.g.CoolTotalMathes = 1
        end,
    },
}
