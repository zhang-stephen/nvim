-- gitsigns: diff signs, hunk actions, and gitlens-style current-line blame.
-- supersedes mini.diff (avoid duplicate signs); mini.git stays for
-- statusline branch data and the :Git wrapper

return function()
    -- availability guard: warn + skip while the plugin is not installed yet (first run)
    local ok, gitsigns = pcall(require, 'gitsigns')
    if not ok then
        vim.notify(('gitsigns unavailable, setup skipped: %s'):format(gitsigns), vim.log.levels.WARN)
        return
    end
    gitsigns.setup({
        -- blame virtual text at the end of the current line
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 500,
            virt_text_pos = 'eol',
        },
    })
end
