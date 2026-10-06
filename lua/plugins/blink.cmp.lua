-- blink.cmp: completion UI (lsp only provides data; popup/fuzzy/docs live here)

-- vscode-style completion keys (blink.cmp dsl, not vim keymaps): enter/tab
-- accept, esc dismisses the menu (falls back to leaving insert mode when no
-- menu is open)
local keymap = {
    preset = 'none',
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<Esc>'] = { 'cancel', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev' },
    ['<C-n>'] = { 'select_next' },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
}

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
        keymap = keymap,
        completion = { documentation = { auto_show = true } },
        sources = { default = { 'lsp', 'path', 'buffer' } },
        -- prebuilt rust fuzzy matcher, downloaded on demand from github
        -- releases (no toolchain); silently falls back to the lua matcher
        fuzzy = { implementation = 'prefer_rust' },
        -- modern popup completion for the : cmdline (native tab wildmenu still works)
        cmdline = { enabled = true },
    })
end
