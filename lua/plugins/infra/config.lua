local config = {}

config.devicons = function()
    require('nvim-web-devicons').set_default_icon('', '#6d8086')
    require('nvim-web-devicons').setup({
        default = true,
    })
end

return config
