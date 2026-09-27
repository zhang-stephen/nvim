-- plugin management via builtin vim.pack (requires neovim 0.12+)
-- first startup clones automatically (one confirmation prompt)
-- update all with :lua vim.pack.update()
-- migration path to lazy.nvim: repos/configs below map 1:1, only this file changes
--
-- note: vim.pack specs have no auto-invoked config callback like lazy.nvim;
-- setup functions live in `configs` (keyed by plugin name) and run after add()
local settings = require('settings')

local plugins = {}

-- github repos; { repo, version = ... } or plain string
local repos = {
    { 'folke/tokyonight.nvim' }, -- colorscheme
    { 'nvim-treesitter/nvim-treesitter', version = 'main' }, -- highlighting (active branch, 0.11+)
    { 'ibhagwan/fzf-lua' }, -- search (needs system fzf + ripgrep)
    { 'nvim-mini/mini.tabline' }, -- buffer tabline
    { 'nvim-mini/mini.files' }, -- file explorer
    -- completion UI: lsp only provides data, this layer owns popup/fuzzy/docs
    { 'saghen/blink.cmp', version = vim.version.range('1.*') },
}

-- per-plugin setup, keyed by repo basename
local configs = {}

configs['tokyonight.nvim'] = function()
    pcall(vim.cmd.colorscheme, 'tokyonight')
end

configs['nvim-treesitter'] = function()
    local ok, ts = pcall(require, 'nvim-treesitter')
    if not ok then
        return
    end
    ts.setup({})
    ts.install({ 'c', 'cpp', 'lua', 'python', 'bash', 'vim', 'vimdoc', 'query', 'markdown' })
    -- the main branch does not auto-start highlighting
    vim.api.nvim_create_autocmd('FileType', {
        callback = function()
            pcall(vim.treesitter.start)
        end,
    })
    -- recompile parsers after plugin updates
    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(ev)
            if ev.data.spec.name == 'nvim-treesitter' then
                vim.cmd('TSUpdate')
            end
        end,
    })
end

configs['fzf-lua'] = function()
    local ok, fzf = pcall(require, 'fzf-lua')
    if ok then
        fzf.setup({ 'default' })
    end
end

-- icons require a nerd font on the *local* terminal only (maple mono nf cn);
-- remote hosts over ssh need nothing
configs['mini.tabline'] = function()
    pcall(function()
        require('mini.tabline').setup({})
    end)
end

configs['mini.files'] = function()
    pcall(function()
        require('mini.files').setup({
            windows = { preview = true, width_preview = 60 },
        })
    end)
end

configs['blink.cmp'] = function()
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
    })
end

local function build_specs(use_ssh)
    local specs = {}
    for _, entry in ipairs(repos) do
        local spec = {
            src = use_ssh and ('git@github.com:' .. entry[1]) or ('https://github.com/' .. entry[1]),
        }
        if entry.version then
            spec.version = entry.version
        end
        table.insert(specs, spec)
    end
    return specs
end

plugins.setup = function()
    -- ssh clone by default; fall back to https if ssh fails
    -- (e.g. no github key on this host)
    local ok = pcall(vim.pack.add, build_specs(settings.use_git_ssh))
    if not ok and settings.use_git_ssh then
        vim.notify('ssh clone failed, falling back to https', vim.log.levels.WARN)
        vim.pack.add(build_specs(false))
    end

    for _, entry in ipairs(repos) do
        local name = entry[1]:match('[^/]+$')
        if configs[name] then
            configs[name]()
        end
    end
end

return plugins
