-- plugin personalization layer: for every plugin registered via vim.pack,
-- run its setup file lua/plugins/<repo-basename>.lua when present.
-- the registry in core/plugins.lua is the single source of truth; this
-- file never lists plugins itself - adding a plugin is registry entry +
-- same-named file. resolved through the runtimepath (we got here via
-- require(), so lua/ is on it by definition) - never splice paths.
for _, plugin in ipairs(vim.pack.get()) do
    local pattern = ('lua/plugins/%s.lua'):format(plugin.spec.name)
    for _, file in ipairs(vim.api.nvim_get_runtime_file(pattern, true)) do
        local chunk, err = loadfile(file)
        if not chunk then
            vim.notify(('failed to load %s: %s'):format(file, err), vim.log.levels.ERROR)
        else
            local setup = chunk()
            -- setup files may personalize at top level or return a setup fn
            if type(setup) == 'function' then
                pcall(setup)
            end
        end
    end
end
