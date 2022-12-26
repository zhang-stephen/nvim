-- **Experimental** --
-- user settings, which is following projects
-- would be referred in the plugin configurations, to adapt requirements of different projects
-- nvim +PackerSync might be still required if settings were updated...

-- the default user settings could be obtained from following methods(priority high to low):
--     + <project_root>/.nvim/settings.json(or yaml), a folder with .git/, .nvim/ or .proj would be treated as a project
--     + envrionment variables, name pattern: NVIM_<FIELDS>(capitalized)(not implemented)
--     + $XDG_CONFIG_HOME/.nvim.json

local settings = {
    root_dir_patterns = { 'git/', '.nvim/', '.proj' },
    ---@type table<string, function | nil>
    items = {
        ['nvim-lspconfig'] = require('core.settings.items.lspconfig'),
        -- ['telescope.nvim'] = nil,
    },
}

---@param plugin string plugin to check if it is loaded
---@return boolean
local is_plugin_loaded = function(plugin)
    return _G.packer_plugins[plugin].loaded
end

settings.get = function()
    local defaults = require('core.settings.default')

    return defaults
end

settings.setup = function()
    for plugin, action in pairs(settings.items) do
        local timer = vim.loop.new_timer()
        timer:start(150, 150, function()
            if is_plugin_loaded(plugin) then
                timer:stop()
                timer:close()
                action()
            end
        end)
    end
end

return settings
