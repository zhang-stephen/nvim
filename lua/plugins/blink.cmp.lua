-- blink.cmp: completion UI (lsp only provides data; popup/fuzzy/docs live here)

return function()
    -- availability guard: skip quietly while plugins are not installed yet (first run)
    local ok, blink = pcall(require, 'blink.cmp')
    if not ok then
        return
    end
    blink.setup({
        keymap = { preset = 'default' }, -- enter to confirm, tab/s-tab to select, c-space to trigger
        completion = { documentation = { auto_show = true } },
        sources = { default = { 'lsp', 'path', 'buffer' } },
        -- prebuilt rust fuzzy matcher; set to 'lua' if the download is blocked
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        -- modern popup completion for the : cmdline (native tab wildmenu still works)
        cmdline = { enabled = true },
    })
end
