local plugins = {}
local uv = vim.fn.has('nvim-0.10') and vim.uv or vim.loop
local git_url_template = require('settings').git_url_template()

plugins.setup = function()
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

    if not uv.fs_stat(lazypath) then
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable', -- latest stable release
            lazypath,
        })
    end

    vim.opt.rtp:prepend(lazypath)

    local plugins_ = {}
    local lazy = require('lazy')
    local lazy_options = {
        git = {},
    }

    for _, specs in ipairs(require('plugins')) do
        vim.list_extend(plugins_, specs)
    end

    lazy.setup(plugins_, lazy_options)
end

return plugins
