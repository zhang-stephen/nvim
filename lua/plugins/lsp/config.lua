-- lsp configs

local config = {}
local settings = require('settings')
local user_conf = settings.get()

config.mason = function()
    require('mason').setup({
        ui = {
            icons = {
                package_installed = '✓',
                package_pending = '➜',
                package_uninstalled = '✗',
            },
        },

        max_concurrent_installers = 6,
    })
end

config.mason_installer = function()
    local lsp_registris = user_conf.plugins.registries.lsp
    local ensure_installed = {}

    for k, v in pairs(lsp_registris) do
        if v.enabled and v.installer == 'mason' then
            table.insert(ensure_installed, k)
        end
    end

    -- TODO: sources null-ls.nvim...

    local mason_tool_installer = require('mason-tool-installer')

    mason_tool_installer.setup({
        ensure_installed = ensure_installed,
        auto_update = true,
        run_on_start = false,
    })
end

config.lspconfig = function()
    local servers = user_conf.plugins.registries.lsp
    local lsp = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- TODO: for other function extension
    ---@diagnostic disable-next-line:unused-local
    local on_attach = function(client, bufnr) end

    for registry, conf in pairs(servers) do
        if conf.enabled then
            local options = conf.options
            local name = registry

            options['on_attach'] = on_attach
            options['capabilities'] = capabilities

            if conf.name then
                name = conf.name
            end

            lsp[name].setup(options)
        end
    end
end

config.lspsaga = function()
    local icons = {
        diagnostics = require('plugins.ui.icons').get('diagnostics', true),
        kind = require('plugins.ui.icons').get('kind', true),
        type = require('plugins.ui.icons').get('type', true),
        ui = require('plugins.ui.icons').get('ui', true),
    }

    local function set_sidebar_icons()
        -- Set icons for sidebar.
        local diagnostic_icons = {
            Error = icons.diagnostics.Error_alt,
            Warn = icons.diagnostics.Warning_alt,
            Info = icons.diagnostics.Information_alt,
            Hint = icons.diagnostics.Hint_alt,
        }
        for type, icon in pairs(diagnostic_icons) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl })
        end
    end

    set_sidebar_icons()

    require('lspsaga').setup({
        diagnostic_header = {
            icons.diagnostics.Error_alt,
            icons.diagnostics.Warning_alt,
            icons.diagnostics.Information_alt,
            icons.diagnostics.Hint_alt,
        },
        ui = {
            kind = {
                Class = { icons.kind.Class, '@lsp.type.class' },
                Constant = { icons.kind.Constant, '@lsp.type.macro' },
                Constructor = { icons.kind.Constructor, '@constructor' },
                Enum = { icons.kind.Enum, '@lsp.type.enum' },
                EnumMember = { icons.kind.EnumMember, '@lsp.type.enumMember' },
                -- Event = { icons.kind.Event, colors.yellow },
                Field = { icons.kind.Field, '@lsp.type.property' },
                File = { icons.kind.File, '@comment' },
                Function = { icons.kind.Function, '@lsp.type.function' },
                Interface = { icons.kind.Interface, '@lsp.type.interface' },
                Key = { icons.kind.Keyword, '@comment' },
                Method = { icons.kind.Method, '@lsp.type.method' },
                Module = { icons.kind.Module, '@lsp.type.module' },
                Namespace = { icons.kind.Namespace, '@lsp.type.namespace' },
                Number = { icons.kind.Number, '@number' },
                Operator = { icons.kind.Operator, '@lsp.type.operator' },
                Package = { icons.kind.Package, '@lsp.type.module' },
                Property = { icons.kind.Property, '@lsp.type.property' },
                Struct = { icons.kind.Struct, '@lsp.type.struct' },
                TypeParameter = { icons.kind.TypeParameter, '@lsp.type.typeParameter' },
                Variable = { icons.kind.Variable, '@lsp.type.vairable' },
                Array = { icons.type.Array, '@lsp.type.vairable' },
                Boolean = { icons.type.Boolean, '@boolean' },
                Null = { icons.type.Null, '@lsp.type.vairable' },
                Object = { icons.type.Object, '@lsp.type.vairable' },
                String = { icons.type.String, '@string' },
            },
        },
        symbol_in_winbar = {
            enable = true,
            in_custom = false,
            separator = ' ' .. icons.ui.Separator,
            show_file = true,
            -- define how to customize filename, eg: %:., %
            -- if not set, use default value `%:t`
            -- more information see `vim.fn.expand` or `expand`
            -- ## only valid after set `show_file = true`
            file_formatter = '',
            click_support = function(node, clicks, button, modifiers)
                -- To see all avaiable details: vim.pretty_print(node)
                local st = node.range.start
                local en = node.range['end']
                if button == 'l' then
                    if clicks == 2 then
                        -- double left click to do nothing
                    else -- jump to node's starting line+char
                        vim.fn.cursor(st.line + 1, st.character + 1)
                    end
                elseif button == 'r' then
                    if modifiers == 's' then
                        print('lspsaga') -- shift right click to print "lspsaga"
                    end -- jump to node's ending line+char
                    vim.fn.cursor(en.line + 1, en.character + 1)
                elseif button == 'm' then
                    -- middle click to visual select node
                    vim.fn.cursor(st.line + 1, st.character + 1)
                    vim.api.nvim_command([[normal v]])
                    vim.fn.cursor(en.line + 1, en.character + 1)
                end
            end,
        },
    })
end

config.luasnip = function()
    local snippet_path = vim.fn.stdpath('data') .. '/my-snippets/'
    if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
        vim.opt.rtp:append(snippet_path)
    end

    require('luasnip.config').set_config({
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        delete_check_events = 'TextChanged,InsertLeave',
    })
    require('luasnip.loaders.from_lua').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_snipmate').lazy_load()
end

config.nvim_cmp = function()
    local icons = {
        kind = require('plugins.ui.icons').get('kind', false),
        type = require('plugins.ui.icons').get('type', false),
        cmp = require('plugins.ui.icons').get('cmp', false),
    }

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    local border = function(hl)
        return {
            { '┌', hl },
            { '─', hl },
            { '┐', hl },
            { '│', hl },
            { '┘', hl },
            { '─', hl },
            { '└', hl },
            { '│', hl },
        }
    end

    local cmp_window = require('cmp.utils.window')

    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
        local info = self:info_()
        info.scrollable = false
        return info
    end

    local compare = require('cmp.config.compare')
    local lspkind = require('lspkind')
    local cmp = require('cmp')

    cmp.setup({
        window = {
            completion = {
                winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
                col_offset = -3,
                side_padding = 0,
            },
            documentation = {
                border = border('CmpDocBorder'),
            },
        },
        sorting = {
            priority_weight = 2,
            comparators = {
                compare.offset,
                compare.exact,
                compare.score,
                require('cmp-under-comparator').under,
                compare.kind,
                compare.sort_text,
                compare.length,
                compare.order,
            },
        },
        formatting = {
            fields = { 'kind', 'abbr', 'menu' },
            format = function(entry, vim_item)
                local kind = lspkind.cmp_format({
                    mode = 'symbol_text',
                    maxwidth = 50,
                    symbol_map = vim.tbl_deep_extend('force', icons.kind, icons.type, icons.cmp),
                })(entry, vim_item)
                local strings = vim.split(kind.kind, '%s', { trimempty = true })
                kind.kind = ' ' .. strings[1] .. ' '
                kind.menu = '    (' .. strings[2] .. ')'
                return kind
            end,
        },
        -- You can set mappings if you want
        mapping = cmp.mapping.preset.insert({
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.close(),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif require('luasnip').expand_or_jumpable() then
                    vim.fn.feedkeys(t('<Plug>luasnip-expand-or-jump'), '')
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif require('luasnip').jumpable(-1) then
                    vim.fn.feedkeys(t('<Plug>luasnip-jump-prev'), '')
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        -- You should specify your *installed* sources.
        sources = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'spell' },
            { name = 'tmux' },
            { name = 'orgmode' },
            { name = 'buffer' },
            { name = 'latex_symbols' },
        },
    })

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local handlers = require('nvim-autopairs.completion.handlers')

    cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done({
            filetypes = {
                -- "*" is an alias to all filetypes
                ['*'] = {
                    ['('] = {
                        kind = {
                            cmp.lsp.CompletionItemKind.Function,
                            cmp.lsp.CompletionItemKind.Method,
                        },
                        handler = handlers['*'],
                    },
                },
                -- Disable for tex
                tex = false,
            },
        })
    )
end

config.autopairs = function()
    require('nvim-autopairs').setup({})
end

return config
