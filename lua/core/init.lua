local core = {
    config = {
        require('core.options'),
        require('core.keymap'),
        require('core.event'),
        require('core.plugins'),
    },
}

local is_nvim_compatible = function()
    return vim.fn.has('nvim-0.9')
end

core.setup = function()
    if not is_nvim_compatible() then
        return
    end

    for _, conf in ipairs(core.config) do
        conf.setup()
    end
end

return core
