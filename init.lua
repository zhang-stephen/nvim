-- zhang-stephen's neovim config
-- init.lua calls the three layers flat, in dependency order

-- 0.12 hard floor (see AGENTS.md); all machines can self-upgrade
-- (official tarball into ~/.local), so no compatibility shims
if vim.fn.has('nvim-0.12') ~= 1 then
    vim.notify('this config requires neovim 0.12+', vim.log.levels.ERROR)
    return
end

require('core') -- options -> keymap -> vim.pack registry/add -> lsp
require('plugins') -- per-plugin personalization setups
require('utils') -- util modules with load-time side effects
