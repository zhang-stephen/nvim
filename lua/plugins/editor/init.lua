local conf = require('plugins.editor.config')

return {
    -- advanced comments
    {
        'numToStr/Comment.nvim',
        event = {'BufReadPre', "BufNewFile"},
        config = true
    },
    {
        'folke/todo-comments.nvim',
        event = {'BufReadPre', "BufNewFile"},
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
        keys = {
            {'<leader>t[', '<cmd>lua require("todo-comments").jump_prev()<CR>', mode = 'n', desc = 'previous todo comment'},
            {'<leader>t]', '<cmd>lua require("todo-comments").jump_next()<CR>', mode = 'n', desc = 'next todo comment'}
        }
    },

    -- outline
}
