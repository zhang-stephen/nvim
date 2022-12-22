local keymap = {}

local mappings = {
    normal = {
        specs = {
            ['<Ctrl>'] = {
                w = {
                    name = '+windows',
                    h = { '<C-w>h', 'switch to left window' },
                    j = { '<C-w>j', 'switch to down window' },
                    k = { '<C-w>k', 'switch to up window' },
                    l = { '<C-w>l', 'switch to right window' },
                },
            },
            ['<leader>'] = {
                c = {
                    name = '+Code Actions',
                    a = { '<cmd>Lspsaga code_action<cr>', 'Code action' },
                    d = {'<cmd>TroubleToggle lsp_document_diagnostics<cr>', 'Show all diagnostics in current buffer'},
                    l = {'<cmd>TroubleToggle loclist<cr>', 'unknown'},
                    q = {'<cmd>TroubleToggle quickfix<cr>', 'Show quickfix'},
                    r = { '<cmd>Lspsaga rename<cr>', 'Rename symbol under cursor' },
                    w = {'<cmd>TroubleToggle lsp_workspace_diagnostics<cr>', 'Show all diagnostics in workspace'},
                },
                h = { name = '+gitsigns' },
                o = { '<cmd>Lspsaga outline<cr>', 'Toggle outline window powered by lspsaga' },
                p = {
                    name = '+Packer.nvim',
                    c = { '<cmd>PackerClean<cr>', 'Remove all plugins' },
                    i = { '<cmd>PackerInstall<cr>', 'Install new plugins' },
                    s = { '<cmd>PackerSync<cr>', 'Upgrade & re-configure all plugins' },
                    u = { '<cmd>PackerUpdate<cr>', 'Update packer.nvim itself' },
                },
                t = {
                    name = '+Telescope',
                },
            },
            ['<F10>'] = {'<cmd>ccl<cr>', 'Close QuickFix window'},
            g = {
                name = '+goto',
                ['['] = { '<cmd>Lspsaga diagnostic_jump_prev<cr>', 'Goto previous diagnostic' },
                [']'] = { '<cmd>Lspsaga diagnostic_jump_next<cr>', 'Goto next diagnostic' },
                b = { '<cmd>BufferLinePick<cr>', 'unknown' },
                d = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'Goto definition under cursor' },
                p = { '<cmd>Lspsaga peek_definition<cr>', 'Preview defintion under cursor' },
                r = { '<cmd>TroubleToggle lsp_references<cr>', 'Show reference list of symbol under cursor' },
                s = { '<cmd>Lspsaga signature_help<cr>', 'Show help of function under cursor' },
                t = { '<cmd>TroubleToggle<cr>', 'Show all diagnostics of current buffer' },
            },
            D = {'d$', 'Delete to EOL'},
            Y = {'y$', 'Yank to EOL'},

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

    -- use the default mapleader
    -- vim.g.mapleader = ' ' -- use <space> as default leader

    local wk = require('which-key')

    for _, mapping in pairs(mappings) do
        wk.register(mapping.specs, mapping.opt)
    end
end

return keymap
