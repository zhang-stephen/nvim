local keymap = {}

local mappings = {
    normal = {
        specs = {
            ['<C-h>'] = { '<C-w>h', 'switch to left window' },
            ['<C-j>'] = { '<C-w>j', 'switch to down window' },
            ['<C-k>'] = { '<C-w>k', 'switch to up window' },
            ['<C-l>'] = { '<C-w>l', 'switch to right window' },
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
            --     o = { '<cmd>Lspsaga outline<CR>', 'Toggle lspsaga outline' },
            --     p = {
            --         name = 'packer.nvim',
            --         c = { '<cmd>PackerClean<CR>', 'Remove all plugins' },
            --         i = { '<cmd>PackerInstall<CR>', 'Install new plugins' },
            --         s = { '<cmd>PackerSync<CR>', 'Upgrade & re-configure all plugins' },
            --         u = { '<cmd>PackerUpdate<CR>', 'Update packer.nvim itself' },
            --     },
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
            ['<F10>'] = { '<cmd>ccl<CR>', 'Close QuickFix window' },
            -- g = {
            --     name = 'goto',
            --     ['['] = { '<cmd>Lspsaga diagnostic_jump_prev<CR>', 'Goto previous diagnostic' },
            --     [']'] = { '<cmd>Lspsaga diagnostic_jump_next<CR>', 'Goto next diagnostic' },
            --     b = { '<cmd>BufferLinePick<CR>', 'unknown' },
            --     d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Goto definition under cursor' },
            --     p = { '<cmd>Lspsaga peek_definition<CR>', 'Preview defintion under cursor' },
            --     r = { '<cmd>TroubleToggle lsp_references<CR>', 'Show reference list of symbol under cursor' },
            --     s = { '<cmd>Lspsaga signature_help<CR>', 'Show help of function under cursor' },
            --     t = { '<cmd>TroubleToggle<CR>', 'Show all diagnostics of current buffer' },
            -- },
            D = { 'd$', 'Delete to EOL' },
            -- K = { '<cmd>Lspsaga hover_doc<CR>', 'Show hover information of symbol' },
            Y = { 'y$', 'Yank to EOL' },
        },
        opt = { mode = 'n' },
    },
    terminal = {
        specs = {
            ['<Esc>'] = { '<C-\\><C-n>', 'Escape Terminal Mode' },
            ['<C-h>'] = { '<C-\\><C-w>h', 'Switch to left window' },
            ['<C-j>'] = { '<C-\\><C-w>j', 'Switch to down window' },
            ['<C-k>'] = { '<C-\\><C-w>k', 'Switch to up window' },
            ['<C-l>'] = { '<C-\\><C-w>l', 'Switch to right window' },
        },
        opt = { mode = 't' },
    },
    command = { specs = {}, opt = { mode = 'c' } },
    visual = { specs = {}, opt = { mode = 'v' } },
}

local check_which_key = function()
    local ok, _ = pcall(require, 'which-key')
    return ok
end

keymap.setup = function()
    if not check_which_key() then
        vim.notify('WRN: which-key.nvim not found, keymap initialize failed!')
        return
    end

    vim.g.mapleader = ' ' -- use <space> as default leader

    local wk = require('which-key')

    for _, mapping in pairs(mappings) do
        wk.register(mapping.specs, mapping.opt)
    end
end

return keymap
