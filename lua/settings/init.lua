-- settings

local settings = {}

---@return table settings valid user settings
settings.get = function()
    -- TODO: support settings merged from different locations
    return require('settings.default')
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

return settings
