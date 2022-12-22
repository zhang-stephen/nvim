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
                    a = { '<cmd>Lspsaga code_action', 'Code action' },
                },
                h = { name = '+gitsigns' },
                o = { '<cmd>Lspsaga outline<cr>', 'Toggle outline window powered by lspsaga' },
                p = {
                    name = '+Packer.nvim',
                    s = { '<cmd>PackerSync<cr>', 'Upgrade & re-configure all plugins' },
                    i = { '<cmd>PackerInstall<cr>', 'Install new plugins' },
                    u = { '<cmd>PackerUpdate<cr>', 'Update packer.nvim itself' },
                    c = { '<cmd>PackerClean<cr>', 'Remove all plugins' },
                },
                r = {
                    n = { '<cmd>Lspsaga rename', 'Rename symbol under cursor' },
                },
                t = {
                    name = '+Telescope',
                },
            },
            g = {
                name = '+goto',
                ['['] = { '<cmd>Lspsaga diagnostic_jump_prev<cr>', 'Goto previous diagnostic' },
                [']'] = { '<cmd>Lspsaga diagnostic_jump_next<cr>', 'Goto next diagnostic' },
                d = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'Goto definition under cursor' },
                s = { '<cmd>Lspsaga signature_help<cr>', 'Show help of function under cursor' },
                p = { '<cmd>Lspsaga peek_definition<cr>', 'Preview defintion under cursor' },
                t = { '<cmd>TroubleToggle<cr>', 'Show all diagnostics of current buffer' },
                r = { '<cmd>TroubleToggle lsp_references<cr>', 'Show reference list of symbol under cursor' },
                b = { '<cmd>BufferLinePick<cr>', 'unknown' },
            },
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

    local wk = require('which-key')

    for _, mapping in pairs(mappings) do
        wk.register(mapping.specs, mapping.opt)
    end
end

return keymap
