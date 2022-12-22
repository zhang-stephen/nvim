local keymap = {}

local mappings = {
    normal = {
        specs = {
            ['<C-h>'] = { '<C-w>h', 'switch to left window' },
            ['<C-j>'] = { '<C-w>j', 'switch to down window' },
            ['<C-k>'] = { '<C-w>k', 'switch to up window' },
            ['<C-l>'] = { '<C-w>l', 'switch to right window' },
            ['<leader>'] = {
                c = {
                    name = '+Code Actions',
                    a = { '<cmd>Lspsaga code_action<CR>', 'Code action' },
                    d = {
                        '<cmd>TroubleToggle lsp_document_diagnostics<CR>',
                        'Show all diagnostics in current buffer',
                    },
                    l = { '<cmd>TroubleToggle loclist<CR>', 'unknown' },
                    q = { '<cmd>TroubleToggle quickfix<CR>', 'Show quickfix' },
                    r = { '<cmd>Lspsaga rename<CR>', 'Rename symbol under cursor' },
                    w = { '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>', 'Show all diagnostics in workspace' },
                },
                e = { '<cmd>NvimTreeToggle<CR>', 'Toggle File Explorer' },
                h = { name = '+gitsigns' },
                o = { '<cmd>Lspsaga outline<CR>', 'Toggle lspsaga outline' },
                p = {
                    name = '+Packer.nvim',
                    c = { '<cmd>PackerClean<CR>', 'Remove all plugins' },
                    i = { '<cmd>PackerInstall<CR>', 'Install new plugins' },
                    s = { '<cmd>PackerSync<CR>', 'Upgrade & re-configure all plugins' },
                    u = { '<cmd>PackerUpdate<CR>', 'Update packer.nvim itself' },
                },
                t = {
                    name = '+Telescope',
                },
            },
            ['<F10>'] = { '<cmd>ccl<CR>', 'Close QuickFix window' },
            g = {
                name = '+goto',
                ['['] = { '<cmd>Lspsaga diagnostic_jump_prev<CR>', 'Goto previous diagnostic' },
                [']'] = { '<cmd>Lspsaga diagnostic_jump_next<CR>', 'Goto next diagnostic' },
                b = { '<cmd>BufferLinePick<CR>', 'unknown' },
                d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Goto definition under cursor' },
                p = { '<cmd>Lspsaga peek_definition<CR>', 'Preview defintion under cursor' },
                r = { '<cmd>TroubleToggle lsp_references<CR>', 'Show reference list of symbol under cursor' },
                s = { '<cmd>Lspsaga signature_help<CR>', 'Show help of function under cursor' },
                t = { '<cmd>TroubleToggle<CR>', 'Show all diagnostics of current buffer' },
            },
            D = { 'd$', 'Delete to EOL' },
            K = { '<cmd>Lspsaga hover_doc<CR>', 'Show hover information of symbol' },
            Y = { 'y$', 'Yank to EOL' },
        },
        opt = { mode = 'n' },
    },
    command = { specs = {}, opt = { mode = 'c' } },
    visual = { specs = {}, opt = { mode = 'v' } },
}

local check_whichkey = function()
    local ok, _ = pcall(require, 'which-key')
    return ok
end

keymap.setup = function()
    if not check_whichkey() then
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
