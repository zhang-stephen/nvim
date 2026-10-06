-- fzf-lua: files / grep / buffers / lsp symbols
-- requires system fzf + ripgrep (see README)

return function()
    -- availability guard: warn + skip while the plugin is not installed yet (first run)
    local ok, fzf = pcall(require, 'fzf-lua')
    if not ok then
        vim.notify(('fzf-lua unavailable, setup skipped: %s'):format(fzf), vim.log.levels.WARN)
        return
    end
    fzf.setup({ 'default' })
end
