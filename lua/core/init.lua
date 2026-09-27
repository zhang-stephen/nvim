-- core modules loader
local core = {}

core.setup = function()
    require('core.options').setup()
    require('core.plugins').setup()
    require('core.lsp').setup()
    -- keymaps load last: they may reference plugin functions, and must work
    -- whether the rhs is a closure or a direct function reference
    require('core.keymap').setup()
end

return core
