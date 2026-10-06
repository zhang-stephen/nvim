-- plugin personalization layer: one setup file per plugin, called in the
-- order listed below. independent of the registry in core/plugins.lua -
-- the registry installs, this layer personalizes. adding a plugin is
-- registry entry + setup file + one entry in the list.
--
-- each setup file returns a setup function and guards itself against the
-- plugin being absent (warn + skip), so this layer just calls them.
-- no pcall around the calls: a failing setup is a config bug and must
-- surface loudly, not be swallowed.
--
-- files are reached through the runtimepath (lua/ is on it by definition)
-- and loaded with loadfile, because repo names with dots (blink.cmp,
-- mini.nvim) cannot be require()'d - dots become path separators.
local setups = {
    'tokyonight.nvim',
    'nvim-treesitter',
    'fzf-lua',
    'mini.nvim',
    'blink.cmp',
    'gitsigns.nvim',
}

for _, name in ipairs(setups) do
    local file = vim.api.nvim_get_runtime_file(('lua/plugins/%s.lua'):format(name), false)[1]
    if not file then
        vim.notify(('no setup file for plugin %s'):format(name), vim.log.levels.WARN)
    else
        local setup = loadfile(file)()
        if type(setup) == 'function' then
            setup()
        end
    end
end
