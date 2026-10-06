-- tokyonight: colorscheme
-- pcall is canonical here: colorschemes are not require()-able, so this is
-- the availability check for the not-installed-yet case

return function()
    local ok = pcall(vim.cmd.colorscheme, 'tokyonight')
    if not ok then
        vim.notify('tokyonight unavailable, colorscheme unchanged', vim.log.levels.WARN)
    end
end
