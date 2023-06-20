-- settings

local settings = { merged = {} }
local platform = require('utils.platform')
local fs = require('utils.fs')

---@return table settings valid user settings
settings.get = function()
    return settings.merged
end

settings.init = function()
    -- read settings.json from these paths:
    --   * vim.fn.stdpath('data'), e.g. ~/.local/share/nvim/ mostly
    --   * <proj_root/.nvim>, which there is .git/ subfolder
    local system_settings_path = vim.fn.stdpath('data')
    local project_settings_path = string.format('%s%s%s', fs.find_root_dir({ '.git/' }), fs.separator, '.nvim')

    -- priority: highest to lowest
    local project_settings = settings.read(project_settings_path) or {}
    local system_settings = settings.read(system_settings_path) or {}
    local default_settings = require('settings.default')

    -- settings merged
    settings.merged = vim.tbl_deep_extend('keep', project_settings, system_settings, default_settings)

    settings.apply_environs()
end

settings.apply_environs = function()
    local envrions = settings.get().envs
    local env_seperator = platform.is_unix_like() and ':' or ';'

    for _, envrion in ipairs(envrions) do
        local name = envrion.name
        local method = envrion.method
        local value = envrion.value

        if method == 'prepend' then
            vim.env[name] = value .. env_seperator .. vim.env[name]
        elseif method == 'append' then
            vim.env[name] = vim.env[name] .. env_seperator .. value
        elseif method == 'overwrite' then
            vim.env[name] = value
        end
    end
end

---@param registry string mason registry name
---@return boolean lsp_enabeld_or_not
settings.is_registry_enabled = function(registry)
    local conf = settings.get()
    local lsp_registries = conf.plugins.registries.lsp
    local null_registries = conf.plugins.registries.null

    if lsp_registries[registry] then
        return lsp_registries[registry].enabled
    elseif null_registries[registry] then
        return null_registries[registry].enabled
    else
        return false
    end
end

settings.git_url_template = function()
    local use_git_ssh = settings.get().plugins.use_git_ssh

    if use_git_ssh then
        return 'git@github.com:%s'
    else
        return 'https://github.com/%s'
    end
end

-- read settings.json from specified path
---@param path string the parent path of settings.json
---@return table|nil
settings.read = function(path)
    local json = string.format('%s%s%s', path, fs.separator, 'settings.json')

    if not vim.fn.isdirectory(path) or vim.fn.filereadable(json) ~= 1 then
        return nil
    end

    local ok, conf = pcall(vim.fn.json_decode, io.open(json, 'r'):read('*a'))
    return ok and conf or nil
end

return settings
