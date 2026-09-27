-- core modules loader
local core = {}

core.setup = function()
    require('core.options').setup()
    require('core.keymap').setup()
    require('core.plugins').setup()
    require('core.lsp').setup()
end

return core
