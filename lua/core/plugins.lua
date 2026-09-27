-- plugin management via builtin vim.pack (requires neovim 0.12+)
-- first startup clones automatically (one confirmation prompt)
-- update all with :lua vim.pack.update()
--
-- per-plugin setup lives in lua/plugins/<repo-basename>.lua; each file returns
-- a setup function. loadfile (not require) is used so repo names containing
-- dots (mini.nvim, blink.cmp) map 1:1 to file names.
--
-- lazy loading: vim.pack supports { load = false } + manual packadd(), but the
-- current set is all startup-essential; defer that until a heavy plugin shows up.
local settings = require('settings')

local plugins = {}

-- github repos; { repo, version = ... }
local repos = {
    { 'folke/tokyonight.nvim' }, -- colorscheme
    { 'nvim-treesitter/nvim-treesitter', version = 'main' }, -- highlighting (active branch, 0.11+)
    { 'ibhagwan/fzf-lua' }, -- search (needs system fzf + ripgrep)
    -- mini.nvim monorepo: tabline, files, icons, pairs, surround, ai,
    -- statusline, clue, notify, indentscope, bufremove
    { 'nvim-mini/mini.nvim' },
    -- completion UI: lsp only provides data, this layer owns popup/fuzzy/docs
    { 'saghen/blink.cmp', version = vim.version.range('1.*') },
    -- current-line blame virtual text (gitlens style); also covers diff signs
    -- and hunk actions, replacing mini.diff
    { 'lewis6991/gitsigns.nvim' },
}

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

-- run lua/plugins/<name>.lua for every repo that ships one.
-- resolve relative to this script (not stdpath) so the config also works
-- when loaded from an arbitrary location via `nvim -u`
local function run_setups()
    local this = debug.getinfo(1, 'S').source:sub(2) -- .../lua/core/plugins.lua
    local dir = vim.fn.fnamemodify(this, ':p:h:h') .. '/plugins/'
    for _, entry in ipairs(repos) do
        local name = entry[1]:match('[^/]+$')
        local chunk = loadfile(dir .. name .. '.lua')
        if chunk then
            local setup = chunk()
            if type(setup) == 'function' then
                pcall(setup)
            end
        end
    end
end

plugins.setup = function()
    -- ssh clone by default; fall back to https if ssh fails
    -- (e.g. no github key on this host)
    local ok = pcall(vim.pack.add, build_specs(settings.use_git_ssh))
    if not ok and settings.use_git_ssh then
        vim.notify('ssh clone failed, falling back to https', vim.log.levels.WARN)
        vim.pack.add(build_specs(false))
    end

    run_setups()
end

return plugins
