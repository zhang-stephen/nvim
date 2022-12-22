local event = {}

local defs = {
    {
        event = 'TextYankPost',
        opts = {
            group = nil,
            pattern = '*',
            callback = function ()
                vim.highlight.on_yank({higroup = 'IncSearch', timeout = 300})
            end
        }
    },
}

event.setup = function ()
    vim.api.nvim_create_augroup('UserDefined', { clear = true })

    for _, def in ipairs(defs) do
        def.opts.group = "UserDefined"
        vim.api.nvim_create_autocmd(def.event, def.opts)
    end
end

return event

-- EOF
