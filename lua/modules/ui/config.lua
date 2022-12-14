local config = {}

config.catppuccin = function()
    require('catppuccin').setup({
        flavour = 'mocha', -- Can be one of: latte, frappe, macchiato, mocha
        background = { light = 'latte', dark = 'mocha' },
        dim_inactive = {
            enabled = false,
            -- Dim inactive splits/windows/buffers.
            -- NOT recommended if you use old palette (a.k.a., mocha).
            shade = 'dark',
            percentage = 0.15,
        },
        transparent_background = true,
        term_colors = true,
        compile_path = vim.fn.stdpath('cache') .. '/catppuccin',
        styles = {
            comments = { 'italic' },
            properties = { 'italic' },
            functions = { 'italic', 'bold' },
            keywords = { 'italic' },
            operators = { 'bold' },
            conditionals = { 'bold' },
            loops = { 'bold' },
            booleans = { 'bold', 'italic' },
            numbers = {},
            types = {},
            strings = {},
            variables = {},
        },
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { 'italic' },
                    hints = { 'italic' },
                    warnings = { 'italic' },
                    information = { 'italic' },
                },
                underlines = {
                    errors = { 'underline' },
                    hints = { 'underline' },
                    warnings = { 'underline' },
                    information = { 'underline' },
                },
            },
            lsp_trouble = true,
            lsp_saga = true,
            gitgutter = false,
            gitsigns = true,
            telescope = true,
            nvimtree = true,
            which_key = true,
            indent_blankline = { enabled = true, colored_indent_levels = true },
            dashboard = true,
            neogit = false,
            vim_sneak = false,
            fern = false,
            barbar = false,
            markdown = true,
            lightspeed = false,
            ts_rainbow = true,
            mason = true,
            neotest = false,
            noice = false,
            hop = true,
            illuminate = true,
            cmp = true,
            dap = { enabled = true, enable_ui = true },
            notify = true,
            symbols_outline = false,
            coc_nvim = false,
            leap = false,
            neotree = { enabled = false, show_root = true, transparent_panel = false },
            telekasten = false,
            mini = false,
            aerial = false,
            vimwiki = true,
            beacon = false,
            navic = { enabled = false },
            overseer = false,
            fidget = true,
        },
        color_overrides = {
            mocha = {
                rosewater = '#F5E0DC',
                flamingo = '#F2CDCD',
                mauve = '#DDB6F2',
                pink = '#F5C2E7',
                red = '#F28FAD',
                maroon = '#E8A2AF',
                peach = '#F8BD96',
                yellow = '#FAE3B0',
                green = '#ABE9B3',
                blue = '#96CDFB',
                sky = '#89DCEB',
                teal = '#B5E8E0',
                lavender = '#C9CBFF',

                text = '#D9E0EE',
                subtext1 = '#BAC2DE',
                subtext0 = '#A6ADC8',
                overlay2 = '#C3BAC6',
                overlay1 = '#988BA2',
                overlay0 = '#6E6C7E',
                surface2 = '#6E6C7E',
                surface1 = '#575268',
                surface0 = '#302D41',

                base = '#1E1E2E',
                mantle = '#1A1826',
                crust = '#161320',
            },
        },
        highlight_overrides = {
            mocha = function(cp)
                return {
                    -- For base configs.
                    CursorLineNr = { fg = cp.green },
                    Search = { bg = cp.surface1, fg = cp.pink, style = { 'bold' } },
                    IncSearch = { bg = cp.pink, fg = cp.surface1 },

                    -- For native lsp configs.
                    DiagnosticVirtualTextError = { bg = cp.none },
                    DiagnosticVirtualTextWarn = { bg = cp.none },
                    DiagnosticVirtualTextInfo = { bg = cp.none },
                    DiagnosticVirtualTextHint = { fg = cp.rosewater, bg = cp.none },

                    DiagnosticHint = { fg = cp.rosewater },
                    LspDiagnosticsDefaultHint = { fg = cp.rosewater },
                    LspDiagnosticsHint = { fg = cp.rosewater },
                    LspDiagnosticsVirtualTextHint = { fg = cp.rosewater },
                    LspDiagnosticsUnderlineHint = { sp = cp.rosewater },

                    -- For fidget.
                    FidgetTask = { bg = cp.none, fg = cp.surface2 },
                    FidgetTitle = { fg = cp.blue, style = { 'bold' } },

                    -- For treesitter.
                    ['@field'] = { fg = cp.rosewater },
                    ['@property'] = { fg = cp.yellow },

                    ['@include'] = { fg = cp.teal },
                    ['@operator'] = { fg = cp.sky },
                    ['@keyword.operator'] = { fg = cp.sky },
                    ['@punctuation.special'] = { fg = cp.maroon },

                    -- ["@float"] = { fg = cp.peach },
                    -- ["@number"] = { fg = cp.peach },
                    -- ["@boolean"] = { fg = cp.peach },

                    ['@constructor'] = { fg = cp.lavender },
                    -- ["@constant"] = { fg = cp.peach },
                    -- ["@conditional"] = { fg = cp.mauve },
                    -- ["@repeat"] = { fg = cp.mauve },
                    ['@exception'] = { fg = cp.peach },

                    ['@constant.builtin'] = { fg = cp.lavender },
                    -- ["@function.builtin"] = { fg = cp.peach, style = { "italic" } },
                    -- ["@type.builtin"] = { fg = cp.yellow, style = { "italic" } },
                    ['@variable.builtin'] = { fg = cp.red, style = { 'italic' } },

                    -- ["@function"] = { fg = cp.blue },
                    ['@function.macro'] = { fg = cp.red, style = {} },
                    ['@parameter'] = { fg = cp.rosewater },
                    ['@keyword.function'] = { fg = cp.maroon },
                    ['@keyword'] = { fg = cp.red },
                    ['@keyword.return'] = { fg = cp.pink, style = {} },

                    -- ["@text.note"] = { fg = cp.base, bg = cp.blue },
                    -- ["@text.warning"] = { fg = cp.base, bg = cp.yellow },
                    -- ["@text.danger"] = { fg = cp.base, bg = cp.red },
                    -- ["@constant.macro"] = { fg = cp.mauve },

                    -- ["@label"] = { fg = cp.blue },
                    ['@method'] = { style = { 'italic' } },
                    ['@namespace'] = { fg = cp.rosewater, style = {} },

                    ['@punctuation.delimiter'] = { fg = cp.teal },
                    ['@punctuation.bracket'] = { fg = cp.overlay2 },
                    -- ["@string"] = { fg = cp.green },
                    -- ["@string.regex"] = { fg = cp.peach },
                    -- ["@type"] = { fg = cp.yellow },
                    ['@variable'] = { fg = cp.text },
                    ['@tag.attribute'] = { fg = cp.mauve, style = { 'italic' } },
                    ['@tag'] = { fg = cp.peach },
                    ['@tag.delimiter'] = { fg = cp.maroon },
                    ['@text'] = { fg = cp.text },

                    -- ["@text.uri"] = { fg = cp.rosewater, style = { "italic", "underline" } },
                    -- ["@text.literal"] = { fg = cp.teal, style = { "italic" } },
                    -- ["@text.reference"] = { fg = cp.lavender, style = { "bold" } },
                    -- ["@text.title"] = { fg = cp.blue, style = { "bold" } },
                    -- ["@text.emphasis"] = { fg = cp.maroon, style = { "italic" } },
                    -- ["@text.strong"] = { fg = cp.maroon, style = { "bold" } },
                    -- ["@string.escape"] = { fg = cp.pink },

                    -- ["@property.toml"] = { fg = cp.blue },
                    -- ["@field.yaml"] = { fg = cp.blue },

                    -- ["@label.json"] = { fg = cp.blue },

                    ['@function.builtin.bash'] = { fg = cp.red, style = { 'italic' } },
                    ['@parameter.bash'] = { fg = cp.yellow, style = { 'italic' } },

                    ['@field.lua'] = { fg = cp.lavender },
                    ['@constructor.lua'] = { fg = cp.flamingo },

                    ['@constant.java'] = { fg = cp.teal },

                    ['@property.typescript'] = { fg = cp.lavender, style = { 'italic' } },
                    -- ["@constructor.typescript"] = { fg = cp.lavender },

                    -- ["@constructor.tsx"] = { fg = cp.lavender },
                    -- ["@tag.attribute.tsx"] = { fg = cp.mauve },

                    ['@type.css'] = { fg = cp.lavender },
                    ['@property.css'] = { fg = cp.yellow, style = { 'italic' } },

                    ['@property.cpp'] = { fg = cp.text },

                    -- ["@symbol"] = { fg = cp.flamingo },
                }
            end,
        },
    })

    vim.api.nvim_command('colorscheme catppuccin')
end

config.alpha = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    local button = function(sc, txt, keybind, keybind_opts)
        local opts = {
            position = 'center',
            shortcut = sc,
            cursor = 5,
            width = 50,
            align_shortcut = 'right',
            hl_shortcut = 'Keyword',
        }

        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { 'n', sc, keybind, keybind_opts }

        local function on_press()
            -- local key = vim.api.nvim_replace_termcodes(keybind .. '<Ignore>', true, false, true)
            local key = vim.api.nvim_replace_termcodes(sc .. '<Ignore>', true, false, true)
            vim.api.nvim_feedkeys(key, 't', false)
        end

        return {
            type = 'button',
            val = txt,
            on_press = on_press,
            opts = opts,
        }
    end

    local footer = function()
        local total_plugins = #vim.tbl_keys(packer_plugins)
        return ' ???  Have Fun with neovim'
            .. '  ??? v'
            .. vim.version().major
            .. '.'
            .. vim.version().minor
            .. '.'
            .. vim.version().patch
            .. '  ??? '
            .. total_plugins
            .. ' plugins'
    end

    -- Set header
    dashboard.section.header.val = {
        '                                                     ',
        '  ????????????   ????????????????????????????????? ????????????????????? ?????????   ??????????????????????????????   ???????????? ',
        '  ???????????????  ?????????????????????????????????????????????????????????????????????   ????????????????????????????????? ??????????????? ',
        '  ?????????????????? ???????????????????????????  ?????????   ??????????????????   ??????????????????????????????????????????????????? ',
        '  ????????????????????????????????????????????????  ?????????   ????????????????????? ?????????????????????????????????????????????????????? ',
        '  ????????? ????????????????????????????????????????????????????????????????????? ????????????????????? ?????????????????? ????????? ????????? ',
        '  ?????????  ??????????????????????????????????????? ?????????????????????   ???????????????  ??????????????????     ????????? ',
        '                                                     ',
    }

    -- Set menu, telescope.nvim required
    dashboard.section.buttons.val = {
        button('f', '???  > Find file', 'Telescope find_files<CR>'),
        button('r', '???  > Recent', ':Telescope oldfiles<CR>'),
        button('n', '???  > Notifations', ':Telescope notify<CR>'),
        button('x', '???  > Git Status', ':Telescope git_status<CR>'),
        button('c', '???  > Git Commits', ':Telescope git_commits<CR>'),
        button('b', '???  > Git Branches', ':Telescope git_branches<CR>'),
        button('s', '???  > Git Stashes', ':Telescope git_stash<CR>'),
        button('t', '???  > Themes', ':Telescope colorscheme<CR>'),
        button('q', '???  > Quit neovim', ':qa<CR>'),
    }

    dashboard.section.buttons.opts.hl = 'String'
    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = 'Function'

    local head_butt_padding = 2
    local occu_height = #dashboard.section.header.val + 2 * #dashboard.section.buttons.val + head_butt_padding
    local header_padding = math.max(0, math.ceil((vim.fn.winheight('$') - occu_height) * 0.25))
    local foot_butt_padding = 1

    dashboard.config.layout = {
        { type = 'padding', val = header_padding },
        dashboard.section.header,
        { type = 'padding', val = head_butt_padding },
        dashboard.section.buttons,
        { type = 'padding', val = foot_butt_padding },
        dashboard.section.footer,
    }
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.api.nvim_command([[
        autocmd FileType alpha setlocal nofoldenable
    ]])
end

config.notify = function()
    local notify = require('notify')
    local notify_renderers = require('notify.render')
    local icons = {
        diagnostics = require('modules.ui.icons').get('diagnostics'),
        ui = require('modules.ui.icons').get('ui'),
    }

    notify.setup({
        ---@usage Animation style one of { "fade", "slide", "fade_in_slide_out", "static" }
        stages = 'slide',
        ---@usage Function called when a new window is opened, use for changing win settings/config
        on_open = nil,
        ---@usage Function called when a window is closed
        on_close = nil,
        ---@usage timeout for notifications in ms, default 5000
        timeout = 2000,
        ---@usage highlight behind the window for stages that change opacity
        background_colour = 'Normal',
        ---@usage minimum width for notification windows
        minimum_width = 50,
        ---@usage notifications with level lower than this would be ignored. [ERROR > WARN > INFO > DEBUG > TRACE]
        level = 'TRACE',
        ---@usage Icons for the different levels
        icons = {
            ERROR = icons.diagnostics.Error,
            WARN = icons.diagnostics.Warning,
            INFO = icons.diagnostics.Information,
            DEBUG = icons.ui.Bug,
            TRACE = icons.ui.Pencil,
        },
        -- Render function for notifications. See notify-render()
        render = function(bufnr, notif, ...)
            if notif.title[1] == '' then
                return notify_renderers.minimal(bufnr, notif, ...)
            else
                return notify_renderers.default(bufnr, notif, ...)
            end
        end,
    })

    vim.notify = notify
end

config.lualine = function()
    local icons = {
        diagnostics = require('modules.ui.icons').get('diagnostics', true),
        misc = require('modules.ui.icons').get('misc', true),
    }

    local function escape_status()
        local ok, m = pcall(require, 'better_escape')
        return ok and m.waiting and icons.misc.EscapeST or ''
    end

    local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
            return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
            }
        end
    end

    local mini_sections = {
        lualine_a = { 'filetype' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    }
    local outline = {
        sections = mini_sections,
        filetypes = { 'lspsagaoutline' },
    }

    local function python_venv()
        local function env_cleanup(venv)
            if string.find(venv, '/') then
                local final_venv = venv
                for w in venv:gmatch('([^/]+)') do
                    final_venv = w
                end
                venv = final_venv
            end
            return venv
        end

        if vim.bo.filetype == 'python' then
            local venv = os.getenv('CONDA_DEFAULT_ENV')
            if venv then
                return string.format('%s', env_cleanup(venv))
            end
            venv = os.getenv('VIRTUAL_ENV')
            if venv then
                return string.format('%s', env_cleanup(venv))
            end
        end
        return ''
    end

    require('lualine').setup({
        options = {
            icons_enabled = true,
            theme = 'catppuccin',
            disabled_filetypes = {},
            component_separators = '|',
            section_separators = { left = '???', right = '???' },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { { 'branch' }, { 'diff', source = diff_source } },
            lualine_c = {},
            lualine_x = {
                { escape_status },
                {
                    'diagnostics',
                    sources = { 'nvim_diagnostic' },
                    symbols = {
                        error = icons.diagnostics.Error,
                        warn = icons.diagnostics.Warning,
                        info = icons.diagnostics.Information,
                    },
                },
            },
            lualine_y = {
                { 'filetype', colored = true, icon_only = true },
                { python_venv },
                { 'encoding' },
                {
                    'fileformat',
                    icons_enabled = true,
                    symbols = {
                        unix = 'LF',
                        dos = 'CRLF',
                        mac = 'CR',
                    },
                },
            },
            lualine_z = { 'progress', 'location' },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {
            'quickfix',
            'nvim-tree',
            'nvim-dap-ui',
            'toggleterm',
            'fugitive',
            outline,
        },
    })
end

config.nvim_tree = function()
    local icons = {
        diagnostics = require('modules.ui.icons').get('diagnostics'),
        documents = require('modules.ui.icons').get('documents'),
        git = require('modules.ui.icons').get('git'),
        ui = require('modules.ui.icons').get('ui'),
    }

    require('nvim-tree').setup({
        create_in_closed_folder = false,
        respect_buf_cwd = false,
        auto_reload_on_write = true,
        disable_netrw = false,
        hijack_cursor = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        ignore_buffer_on_setup = false,
        open_on_setup = false,
        open_on_setup_file = false,
        open_on_tab = false,
        sort_by = 'name',
        sync_root_with_cwd = true,
        view = {
            adaptive_size = false,
            centralize_selection = false,
            width = 30,
            side = 'left',
            preserve_window_proportions = false,
            number = false,
            relativenumber = false,
            signcolumn = 'yes',
            hide_root_folder = false,
            float = {
                enable = false,
                open_win_config = {
                    relative = 'editor',
                    border = 'rounded',
                    width = 30,
                    height = 30,
                    row = 1,
                    col = 1,
                },
            },
        },
        renderer = {
            add_trailing = false,
            group_empty = true,
            highlight_git = false,
            full_name = false,
            highlight_opened_files = 'none',
            special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md', 'CMakeLists.txt' },
            symlink_destination = true,
            indent_markers = {
                enable = true,
                icons = {
                    corner = '??? ',
                    edge = '??? ',
                    item = '??? ',
                    none = '  ',
                },
            },
            root_folder_modifier = ':e',
            icons = {
                webdev_colors = true,
                git_placement = 'before',
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = false,
                    git = true,
                },
                padding = ' ',
                symlink_arrow = ' ??? ',
                glyphs = {
                    default = icons.documents.Default, --???
                    symlink = icons.documents.Symlink, --???
                    bookmark = icons.ui.Bookmark,
                    git = {
                        unstaged = icons.git.Mod_alt,
                        staged = icons.git.Add, --???
                        unmerged = icons.git.Unmerged,
                        renamed = icons.git.Rename, --???
                        untracked = icons.git.Untracked, -- "???"
                        deleted = icons.git.Remove, --???
                        ignored = icons.git.Ignore, --???
                    },
                    folder = {
                        -- arrow_open = "???",
                        -- arrow_closed = "???",
                        arrow_open = '',
                        arrow_closed = '',
                        default = icons.ui.Folder,
                        open = icons.ui.FolderOpen,
                        empty = icons.ui.EmptyFolder,
                        empty_open = icons.ui.EmptyFolderOpen,
                        symlink = icons.ui.SymlinkFolder,
                        symlink_open = icons.ui.FolderOpen,
                    },
                },
            },
        },
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = true,
            update_root = false,
            ignore_list = {},
        },
        ignore_ft_on_setup = {},
        filters = {
            dotfiles = false,
            custom = { '.DS_Store' },
            exclude = {},
        },
        actions = {
            use_system_clipboard = true,
            change_dir = {
                enable = true,
                global = false,
            },
            open_file = {
                quit_on_open = false,
                resize_window = false,
                window_picker = {
                    enable = true,
                    chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
                    exclude = {
                        filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
                        buftype = { 'nofile', 'terminal', 'help' },
                    },
                },
            },
            remove_file = {
                close_window = true,
            },
        },
        diagnostics = {
            enable = false,
            show_on_dirs = false,
            debounce_delay = 50,
            icons = {
                hint = icons.diagnostics.Hint_alt,
                info = icons.diagnostics.Information_alt,
                warning = icons.diagnostics.Warning_alt,
                error = icons.diagnostics.Error_alt,
            },
        },
        filesystem_watchers = {
            enable = true,
            debounce_delay = 50,
        },
        git = {
            enable = true,
            ignore = true,
            show_on_dirs = true,
            timeout = 400,
        },
        trash = {
            cmd = 'gio trash',
            require_confirm = true,
        },
        live_filter = {
            prefix = '[FILTER]: ',
            always_show_folders = true,
        },
        log = {
            enable = false,
            truncate = false,
            types = {
                all = false,
                config = false,
                copy_paste = false,
                dev = false,
                diagnostics = false,
                git = false,
                profile = false,
                watcher = false,
            },
        },
    })
end

config.bufferline = function()
    local icons = { ui = require('modules.ui.icons').get('ui') }

    local opts = {
        options = {
            number = nil,
            modified_icon = icons.ui.Modified,
            buffer_close_icon = icons.ui.Close,
            left_trunc_marker = icons.ui.Left,
            right_trunc_marker = icons.ui.Right,
            max_name_length = 14,
            max_prefix_length = 13,
            tab_size = 20,
            show_buffer_close_icons = true,
            show_buffer_icons = true,
            show_tab_indicators = true,
            diagnostics = 'nvim_lsp',
            always_show_bufferline = true,
            separator_style = 'thin',
            offsets = {
                {
                    filetype = 'NvimTree',
                    text = 'File Explorer',
                    text_align = 'center',
                    padding = 1,
                },
                {
                    filetype = 'undotree',
                    text = 'Undo Tree',
                    text_align = 'center',
                    highlight = 'Directory',
                    separator = true,
                },
            },
            diagnostics_indicator = function(count)
                return '(' .. count .. ')'
            end,
        },
        -- Change bufferline's highlights here! See `:h bufferline-highlights` for detailed explanation.
        -- Note: If you use catppuccin then modify the colors below!
        highlights = {},
    }

    if vim.g.colors_name == 'catppuccin' then
        local cp = require('catppuccin.palettes').get_palette() -- Get the palette.
        cp.none = 'NONE' -- Special setting for complete transparent fg/bg.

        local catppuccin_hl_overwrite = {
            highlights = require('catppuccin.groups.integrations.bufferline').get({
                styles = { 'italic', 'bold' },
                custom = {
                    mocha = {
                        -- Hint
                        hint = { fg = cp.rosewater },
                        hint_visible = { fg = cp.rosewater },
                        hint_selected = { fg = cp.rosewater },
                        hint_diagnostic = { fg = cp.rosewater },
                        hint_diagnostic_visible = { fg = cp.rosewater },
                        hint_diagnostic_selected = { fg = cp.rosewater },
                    },
                },
            }),
        }

        opts = vim.tbl_deep_extend('force', opts, catppuccin_hl_overwrite)
    end

    require('bufferline').setup(opts)
end

config.gitsigns = function()
    require('gitsigns').setup({
        signs = {
            add = {
                hl = 'GitSignsAdd',
                text = '???',
                numhl = 'GitSignsAddNr',
                linehl = 'GitSignsAddLn',
            },
            change = {
                hl = 'GitSignsChange',
                text = '???',
                numhl = 'GitSignsChangeNr',
                linehl = 'GitSignsChangeLn',
            },
            delete = {
                hl = 'GitSignsDelete',
                text = '_',
                numhl = 'GitSignsDeleteNr',
                linehl = 'GitSignsDeleteLn',
            },
            topdelete = {
                hl = 'GitSignsDelete',
                text = '???',
                numhl = 'GitSignsDeleteNr',
                linehl = 'GitSignsDeleteLn',
            },
            changedelete = {
                hl = 'GitSignsChange',
                text = '~',
                numhl = 'GitSignsChangeNr',
                linehl = 'GitSignsChangeLn',
            },
        },
        keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true,
            ['n ]g'] = {
                expr = true,
                [[&diff ? ']g' : '<cmd>lua require("gitsigns").next_hunk()<CR>']],
            },
            ['n [g'] = {
                expr = true,
                [[&diff ? '[g' : '<cmd>lua require("gitsigns").prev_hunk()<CR>']],
            },
            ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
            ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
            ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
            ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
            ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line({full=true})<CR>',
            -- Text objects
            ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
            ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
        },
        watch_gitdir = { interval = 1000, follow_files = true },
        current_line_blame = true,
        current_line_blame_opts = { delay = 1000, virtual_text_pos = 'eol' },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        diff_opts = { internal = true },
    })
end

config.indent_blankline = function()
    require('indent_blankline').setup({
        char = '???',
        show_first_indent_level = true,
        filetype_exclude = {
            'startify',
            'dashboard',
            'dotooagenda',
            'log',
            'fugitive',
            'gitcommit',
            'packer',
            'vimwiki',
            'markdown',
            'json',
            'txt',
            'vista',
            'help',
            'todoist',
            'NvimTree',
            'peekaboo',
            'git',
            'TelescopePrompt',
            'undotree',
            'flutterToolsOutline',
            '', -- for all buffers without a file type
        },
        buftype_exclude = { 'terminal', 'nofile' },
        show_trailing_blankline_indent = false,
        show_current_context = true,
        context_patterns = {
            'class',
            'function',
            'method',
            'block',
            'list_literal',
            'selector',
            '^if',
            '^table',
            'if_statement',
            'while',
            'for',
            'type',
            'var',
            'import',
        },
        space_char_blankline = ' ',
    })
end

config.scrollview = function()
    require('scrollview').setup({})
end

config.fidget = function()
    require('fidget').setup({
        window = { blend = 0 },
    })
end

return config
