-- mini.nvim monorepo: 12 modules
-- icons first so the others pick it up; icons only need a nerd font on the
-- *local* terminal (maple mono nf cn), remote hosts over ssh need nothing

return function()
    -- availability guard: warn + skip while the plugin is not installed yet (first run)
    local ok = pcall(require, 'mini.icons')
    if not ok then
        vim.notify('mini.nvim unavailable, setup skipped', vim.log.levels.WARN)
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
    -- default layout plus a terminal section (' 2/3') from utils/term
    local statusline = require('mini.statusline')
    -- dedicated section color: tokyonight's devinfo/fileinfo backgrounds are
    -- nearly identical, so borrow a mode color for real contrast.
    -- re-apply on colorscheme changes (themes reset highlight groups)
    local function set_term_hl()
        vim.api.nvim_set_hl(0, 'MiniStatuslineTerm', { link = 'MiniStatuslineModeVisual' })
    end
    set_term_hl()
    vim.api.nvim_create_autocmd('ColorScheme', { callback = set_term_hl })
    statusline.setup({
        content = {
            active = function()
                local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
                local git = statusline.section_git({ trunc_width = 40 })
                -- diff counts come from gitsigns (mini.diff was replaced)
                local gsdiff = ''
                local dict = vim.b.gitsigns_status_dict
                if dict then
                    gsdiff = ('+%d ~%d -%d'):format(dict.added or 0, dict.changed or 0, dict.removed or 0)
                end
                local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
                local terminals = require('utils.term').status()
                local filename = statusline.section_filename({ trunc_width = 140 })
                local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
                local location = statusline.section_location({ trunc_width = 75 })
                return statusline.combine_groups({
                    { hl = mode_hl, strings = { mode } },
                    { hl = 'MiniStatuslineDevinfo', strings = { git, gsdiff, diagnostics } },
                    '%<',
                    { hl = 'MiniStatuslineFilename', strings = { filename } },
                    '%=',
                    { hl = 'MiniStatuslineTerm', strings = { terminals } },
                    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                    { hl = mode_hl, strings = { location } },
                })
            end,
        },
    })
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
