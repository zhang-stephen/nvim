-- core layer: plugin-independent editor infrastructure.
-- plugins (vim.pack add) before lsp: capabilities() requires blink.cmp,
-- which only exists on the rtp once plugins are installed
require('core.options').setup()
require('core.keymap').setup()
require('core.plugins')
require('core.lsp').setup()
