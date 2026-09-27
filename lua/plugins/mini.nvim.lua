-- mini.nvim monorepo: 12 modules
-- icons first so the others pick it up; icons only need a nerd font on the
-- *local* terminal (maple mono nf cn), remote hosts over ssh need nothing

return function()
    -- availability guard: skip quietly while plugins are not installed yet (first run)
    local ok = pcall(require, 'mini.icons')
    if not ok then
        return
    end

    -- beyond this point no pcall: a failing setup call is a config bug
    -- and should surface loudly, not be swallowed
    local icons = require('mini.icons')
    icons.setup({})
    icons.mock_nvim_web_devicons() -- serve fzf-lua/blink anything expecting devicons

    require('mini.tabline').setup({})
    require('mini.files').setup({
        windows = { preview = true, width_preview = 60 },
    })
    require('mini.pairs').setup({})
    require('mini.surround').setup({})
    require('mini.ai').setup({})
    require('mini.statusline').setup({})
    require('mini.notify').setup({})
    require('mini.indentscope').setup({})
    require('mini.bufremove').setup({})

    -- git: branch data for statusline, blame-at-cursor, :Git wrapper.
    -- diff signs/hunks/current-line blame are handled by gitsigns (see lua/plugins/)
    require('mini.git').setup({})

    -- key hints for <leader>/g/[/] prefixes (discoverability while the config is new)
    local clue = require('mini.clue')
    clue.setup({
        triggers = {
            { mode = 'n', keys = '<Leader>' },
            { mode = 'n', keys = 'g' },
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },
        },
        clues = {
            clue.gen_clues.g(),
            clue.gen_clues.square_brackets(),
        },
        window = { delay = 300 },
    })
end
