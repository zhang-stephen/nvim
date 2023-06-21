local keymap = {}

local mappings = {
    n = {
        { '<C-h>', '<C-w>h', { desc = 'switch to left window' }, },
        { '<C-j>', '<C-w>j', { desc = 'switch to down window' }, },
        { '<C-k>', '<C-w>k', { desc = 'switch to up window' }, },
        { '<C-l>', '<C-w>l', { desc = 'switch to right window' }, },
        { '<F10>', '<cmd>ccl<CR>', { desc = 'close the quickfix window' }, },
        { 'D', 'd$', { desc = 'delete to the EOL', }, },
        { 'Y', 'y$', { desc = 'yank to the EOL', }, },
    },
    t = {
        { '<Esc>', '<C-\\><C-n>', { desc = 'escape from terminal mode' }, },
        { '<C-h>', '<C-\\><C-w>h', { desc = 'switch to left window' }, },
        { '<C-j>', '<C-\\><C-w>j', { desc = 'switch to down window' }, },
        { '<C-k>', '<C-\\><C-w>k', { desc = 'switch to up window' }, },
        { '<C-l>', '<C-\\><C-w>l', { desc = 'switch to right window' }, },
    },
            -- ['<leader>'] = {
            --     b = {
            --         name = 'bufferline.nvim',
            --         ['1'] = { '<cmd>BufferLineGotoBuffer 1<CR>', 'Jump to buffer 1' },
            --         ['2'] = { '<cmd>BufferLineGotoBuffer 2<CR>', 'Jump to buffer 2' },
            --         ['3'] = { '<cmd>BufferLineGotoBuffer 3<CR>', 'Jump to buffer 3' },
            --         ['4'] = { '<cmd>BufferLineGotoBuffer 4<CR>', 'Jump to buffer 4' },
            --         ['5'] = { '<cmd>BufferLineGotoBuffer 5<CR>', 'Jump to buffer 5' },
            --         ['6'] = { '<cmd>BufferLineGotoBuffer 6<CR>', 'Jump to buffer 6' },
            --         ['7'] = { '<cmd>BufferLineGotoBuffer 7<CR>', 'Jump to buffer 7' },
            --         ['8'] = { '<cmd>BufferLineGotoBuffer 8<CR>', 'Jump to buffer 8' },
            --         ['9'] = { '<cmd>BufferLineGotoBuffer 9<CR>', 'Jump to buffer 9' },
            --         d = { '<cmd>BufferLineSortByDirectory<CR>', 'Sort all buffers by directory' },
            --         e = { '<cmd>BufferLineSortByExtension<CR>', 'Sort all buffers by extension' },
            --         j = { '<cmd>BufferLineCycleNext<CR>', 'Jump to next buffer' },
            --         k = { '<cmd>BufferLineCyclePrev<CR>', 'Jump to previous buffer' },
            --     },
            --     c = {
            --         name = 'Code Actions',
            --         a = { '<cmd>Lspsaga code_action<CR>', 'Code action' },
            --         d = {
            --             '<cmd>TroubleToggle lsp_document_diagnostics<CR>',
            --             'Show all diagnostics in current buffer',
            --         },
            --         l = { '<cmd>TroubleToggle loclist<CR>', 'unknown' },
            --         q = { '<cmd>TroubleToggle quickfix<CR>', 'Show quickfix' },
            --         r = { '<cmd>Lspsaga rename<CR>', 'Rename symbol under cursor' },
            --         w = { '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>', 'Show all diagnostics in workspace' },
            --     },
            --     e = { '<cmd>NvimTreeToggle<CR>', 'Toggle File Explorer' },
            --     h = { name = 'gitsigns' },
            --     q = {
            --         name = 'hop.nvim',
            --         a = { '<cmd>HopLineStartMW<CR>', 'Hop to head of any line in visible buffers' },
            --         c = { '<cmd>HopChar1<CR>', 'Hop to any character' },
            --         l = { '<cmd>HopLineStart<CR>', 'Hop to head of any line' },
            --         v = { '<cmd>HopChar2<CR>', 'Hop to any bigram' },
            --         w = { '<cmd>HopWord<CR>', 'Hop to start of any word' },
            --     },
            --     t = {
            --         name = 'Telescope',
            --         k = { '<cmd>Telescope keymaps<CR>', 'Find all keymaps' },
            --         o = { '<cmd>Telescope oldfiles<CR>', 'Find recent files' },
            --         t = { '<cmd>TodoTelescope<CR>', 'Find all TODOs' },
            --     },
            -- },
}

keymap.setup = function()
    vim.g.mapleader = ' ' -- use <space> as default leader

    for mode, specs in pairs(mappings) do
        for _, spec in ipairs(specs) do
            vim.keymap.set(mode, spec[1], spec[2], spec[3])
        end
    end
end

return keymap
