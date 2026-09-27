-- keymaps via vim.keymap.set with function rhs (no <cmd>...<cr> strings)
-- leader is <space>; prefixed groups: f = find, b = buffer, l = lsp, e = explorer

local keymap = {}

keymap.setup = function()
    vim.g.mapleader = ' '

    local map = vim.keymap.set

    -- window navigation
    map('n', '<C-h>', '<C-w>h', { desc = 'switch to left window' })
    map('n', '<C-j>', '<C-w>j', { desc = 'switch to down window' })
    map('n', '<C-k>', '<C-w>k', { desc = 'switch to up window' })
    map('n', '<C-l>', '<C-w>l', { desc = 'switch to right window' })
    map('n', '<F10>', function()
        vim.cmd.cclose()
    end, { desc = 'close the quickfix window' })
    map('n', 'D', 'd$', { desc = 'delete to the EOL' })
    map('n', 'Y', 'y$', { desc = 'yank to the EOL' })

    -- buffers (shown by mini.tabline)
    map('n', ']b', function()
        vim.cmd.bnext()
    end, { desc = 'next buffer' })
    map('n', '[b', function()
        vim.cmd.bprevious()
    end, { desc = 'previous buffer' })
    map('n', '<leader>bd', function()
        vim.cmd.bdelete()
    end, { desc = 'close current buffer' })

    -- file explorer (mini.files)
    map('n', '<leader>e', function()
        local mf = require('mini.files')
        if not mf.close() then
            mf.open(vim.api.nvim_buf_get_name(0))
            mf.reveal_cwd()
        end
    end, { desc = 'toggle file explorer' })

    -- search (fzf-lua)
    map('n', '<leader>ff', function()
        require('fzf-lua').files()
    end, { desc = 'find files' })
    map('n', '<leader>fg', function()
        require('fzf-lua').live_grep()
    end, { desc = 'live grep' })
    map('n', '<leader>fb', function()
        require('fzf-lua').buffers()
    end, { desc = 'buffer list' })
    map('n', '<leader>fs', function()
        require('fzf-lua').lsp_document_symbols()
    end, { desc = 'document symbols' })
    map('n', '<leader>fd', function()
        require('fzf-lua').diagnostics_document()
    end, { desc = 'document diagnostics' })

    -- lsp (0.11+ builtin defaults: grn rename, grr references, gri implementation,
    -- gra code action, K hover; only non-defaults live here)
    map('n', 'gd', vim.lsp.buf.definition, { desc = 'goto definition' })
    map('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'show line diagnostics' })

    -- terminal mode
    map('t', '<Esc>', '<C-\\><C-n>', { desc = 'escape from terminal mode' })
    map('t', '<C-h>', '<C-\\><C-w>h', { desc = 'switch to left window' })
    map('t', '<C-j>', '<C-\\><C-w>j', { desc = 'switch to down window' })
    map('t', '<C-k>', '<C-\\><C-w>k', { desc = 'switch to up window' })
    map('t', '<C-l>', '<C-\\><C-w>l', { desc = 'switch to right window' })
end

return keymap
