local Packer = {}
local uv = vim.loop

local nvim_data_path = vim.fn.stdpath('data') .. '/site'
local default_compiled = nvim_data_path .. '/lua/_compiled.lua'
local packer = nil

local use_ssh = vim.env['USE_SSH_TO_GITHUB'] ~= nil
local url_scheme = use_ssh and 'git@github.com:%s' or 'https://github.com/%s'

local disable_distribution_plugins = function()
    vim.g.loaded_fzf = 1
    vim.g.loaded_gtags = 1
    vim.g.loaded_gzip = 1
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_getscript = 1
    vim.g.loaded_getscriptPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_matchit = 1
    vim.g.loaded_matchparen = 1
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        if not packer then
            packer = require(Packer.manager.name)
        end
        return packer[key]
    end,
})

Packer.manager = {
    name = 'packer',
    path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim',
    status = false,
    repo = 'wbthomason/packer.nvim',
}

Packer.bootstrap = function()
    if uv.fs_stat(Packer.manager.path) == nil then
        local ret = vim.fn.system({
            'git',
            'clone',
            '--depth',
            '1',
            string.format(url_scheme, Packer.manager.repo),
            Packer.manager.path,
        })

        Packer.manager.status = (ret ~= nil)
    else
        vim.notify('plugin manager has been initliazed...', vim.log.levels.DEBUG)
        Packer.manager.status = true
    end
end

Packer.setup = function()
    Packer.bootstrap()

    if not Packer.manager.status then
        vim.notify(
            string.format('[%s] load failed, neovim initialized failed!', Packer.manager.name),
            vim.log.levels.ERROR
        )
        require('os').exit(-1)
    end

    -- CORE function to load all plugins
    local loading = function(use)
        use({
            'wbthomason/packer.nvim',
            opt = true,
        })

        for _, modules in ipairs(require('modules')) do
            for repo, spec in pairs(modules) do
                use(vim.tbl_extend('force', { repo }, spec))
            end
        end
    end

    vim.api.nvim_command('packadd packer.nvim')

    packer = require(Packer.manager.name)
    packer.init({
        compile_path = default_compiled,
        max_jobs = 24,
        display = {
            open_fn = function()
                return require('packer.util').float({
                    border = 'single',
                })
            end,
        },
        git = {
            clone_timeout = 60,
            default_url_format = url_scheme,
        },
    })

    packer.reset()

    loading(packer.use)
end

plugins.setup = function()
    disable_distribution_plugins()
    Packer.setup()
    if vim.fn.filereadable(default_compiled) == 1 then
        require('_compiled')
    end
end

return plugins
