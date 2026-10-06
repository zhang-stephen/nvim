-- nvim-treesitter (main branch): syntax highlighting
-- parsers compile locally, so gcc is required on each host

return function()
    -- availability guard: warn + skip while the plugin is not installed yet (first run)
    local ok, ts = pcall(require, 'nvim-treesitter')
    if not ok then
        vim.notify(('nvim-treesitter unavailable, setup skipped: %s'):format(ts), vim.log.levels.WARN)
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
