-- editor options, assigned directly via vim.o

local options = {}

options.setup = function()
    -- global
    vim.o.termguicolors = true
    vim.o.mouse = 'a'
    vim.o.fileformat = 'unix'
    vim.o.magic = true
    vim.o.encoding = 'utf-8'
    vim.o.virtualedit = 'block'
    vim.o.history = 2000
    vim.o.updatetime = 100
    vim.o.redrawtime = 1500
    vim.o.background = 'dark'
    vim.o.backspace = 'indent,eol,start'
    vim.o.foldlevelstart = 99
    vim.o.splitbelow = true
    vim.o.splitright = true
    vim.o.grepformat = '%f:%l:%c:%m'
    vim.o.grepprg = 'rg --hidden --vimgrep --smart-case --'
    vim.o.winborder = 'rounded' -- unified border for all floats since 0.11

    -- window/buffer defaults
    vim.o.undofile = true
    vim.o.synmaxcol = 2500
    vim.o.formatoptions = '1jcroql'
    vim.o.expandtab = true
    vim.o.autoindent = true
    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
    vim.o.softtabstop = -1
    vim.o.breakindentopt = 'shift:2,min:20'
    vim.o.wrap = false
    vim.o.linebreak = true
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.foldenable = true
    vim.o.foldmethod = 'indent'
    vim.o.foldlevel = 99
    vim.o.signcolumn = 'yes:3'
    vim.o.conceallevel = 0
    vim.o.concealcursor = 'niv'
    vim.o.scrolloff = 15
    vim.o.smartcase = true
    vim.o.hlsearch = true
    vim.o.incsearch = true
    vim.o.cursorline = false
    vim.o.cursorcolumn = false
    vim.o.showcmd = true
    vim.o.cmdwinheight = 5
    vim.o.equalalways = false
    vim.o.laststatus = 3 -- one global statusline at the very bottom (vscode style)
    vim.o.display = 'lastline'
    vim.o.pumblend = 10
    vim.o.winblend = 10

    vim.cmd('filetype indent on')
    vim.api.nvim_set_hl(0, 'Pmenu', { ctermbg = 'black', bg = 'black' })

    -- OSC52 clipboard: the terminal emulator (local or over ssh) writes yanks
    -- to the system clipboard; works anywhere the terminal supports it
    vim.g.clipboard = 'osc52'

    -- diagnostics appearance: nerd font signs instead of the default E/W/I/H letters
    vim.diagnostic.config({
        virtual_text = true,
        signs = {
            text = {
                -- nerd font glyphs as byte escapes (literals get mangled)
                [vim.diagnostic.severity.ERROR] = '\xef\x81\x97',
                [vim.diagnostic.severity.WARN] = '\xef\x81\xb1',
                [vim.diagnostic.severity.INFO] = '\xef\x81\x9a',
                [vim.diagnostic.severity.HINT] = '\xef\x83\xab',
            },
        },
        underline = true,
        severity_sort = true,
    })
end

return options
