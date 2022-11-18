local core = {
    config = {
        require('core.options'),
        require('core.plugins'),
        -- require('core.keymap'),
        -- require('core.event'),
    },
}

local is_nvim_compatible = function()
    return vim.fn.has('nvim-0.8')
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

-- EOF
