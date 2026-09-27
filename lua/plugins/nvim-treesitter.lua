-- nvim-treesitter (main branch): syntax highlighting
-- parsers compile locally, so gcc is required on each host

return function()
    -- availability guard: skip quietly while plugins are not installed yet (first run)
    local ok, ts = pcall(require, 'nvim-treesitter')
    if not ok then
        return
    end
    ts.setup({})
    ts.install({ 'c', 'cpp', 'lua', 'python', 'bash', 'vim', 'vimdoc', 'query', 'markdown' })
    -- the main branch does not auto-start highlighting.
    -- pcall is required here: this fires on every filetype, including ones
    -- without a parser (text, etc.), where treesitter.start() errors
    vim.api.nvim_create_autocmd('FileType', {
        callback = function()
            pcall(vim.treesitter.start)
        end,
    })
    -- recompile parsers after plugin updates
    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(ev)
            if ev.data.spec.name == 'nvim-treesitter' then
                vim.cmd('TSUpdate')
            end
        end,
    })
end
