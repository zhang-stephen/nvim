-- blink.cmp: completion UI (lsp only provides data; popup/fuzzy/docs live here)

return function()
    -- availability guard: warn + skip while the plugin is not installed yet (first run)
    local ok, blink = pcall(require, 'blink.cmp')
    if not ok then
        vim.notify(('blink.cmp unavailable, setup skipped: %s'):format(blink), vim.log.levels.WARN)
        return
    end
    -- v2 (main) downloads the prebuilt rust fuzzy library on demand. the
    -- checkout is an untagged commit, so match='*' resolves the nearest
    -- ancestor tag's release asset (per UPGRADE.md; no cargo needed).
    -- pwait() swallows task errors, so verify via library_available();
    -- 'prefer_rust' below falls back to the lua matcher silently
    if not blink.library_available() then
        blink.download({ match = '*' }):pwait()
        if not blink.library_available() then
            vim.notify('blink.cmp rust library unavailable, using lua fuzzy matcher', vim.log.levels.WARN)
        end
    end
    blink.setup({
        keymap = { preset = 'default' }, -- enter to confirm, tab/s-tab to select, c-space to trigger
        completion = { documentation = { auto_show = true } },
        sources = { default = { 'lsp', 'path', 'buffer' } },
        -- prebuilt rust fuzzy matcher, downloaded on demand from github
        -- releases (no toolchain); silently falls back to the lua matcher
        fuzzy = { implementation = 'prefer_rust' },
        -- modern popup completion for the : cmdline (native tab wildmenu still works)
        cmdline = { enabled = true },
    })
end
