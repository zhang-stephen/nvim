return function()
    local lsp_settings = require('core.settings').get().plugins.lsp
    local lspconfig = require('lspconfig')

    -- FIXME: vim.lsp.client should be updated together, or re-setup with new configuration
    lspconfig.clangd.cmd = vim.list_extend({ 'clangd' }, lsp_settings.cpp.default_args)
    -- FIXME: the lsp client should be restarted after configuration upgraded
end
