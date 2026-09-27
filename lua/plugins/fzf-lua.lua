-- fzf-lua: files / grep / buffers / lsp symbols
-- requires system fzf + ripgrep (see README)

return function()
    -- availability guard: skip quietly while plugins are not installed yet (first run)
    local ok, fzf = pcall(require, 'fzf-lua')
    if not ok then
        return
    end
    fzf.setup({ 'default' })
end
