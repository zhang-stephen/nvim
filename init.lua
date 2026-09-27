-- the entry point for neovim configuration in luaJIT

-- minimum supported version: neovim 0.12 (vim.pack); raise deliberately as needs grow
if vim.fn.has('nvim-0.12') == 0 then
    vim.notify('this config requires neovim 0.12+, see README for upgrade guide', vim.log.levels.ERROR)
    return
end

require('core').setup()
