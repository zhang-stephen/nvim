local plugins = {}
local git_url_template = require('settings').git_url_template()

plugins.setup = function()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
      })
    end

    vim.opt.rtp:prepend(lazypath)

    local lazy = require('lazy')
    local lazy_options = {
        git = {
        }
    }

    lazy.setup(require('plugins.lsp'), lazy_options)

end

return plugins
