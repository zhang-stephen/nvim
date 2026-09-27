-- tokyonight: colorscheme
-- pcall is canonical here: colorschemes are not require()-able, so this is
-- the availability check for the not-installed-yet case

return function()
    pcall(vim.cmd.colorscheme, 'tokyonight')
end
