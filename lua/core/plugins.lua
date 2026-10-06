-- plugin registry: declaration + installation only (infrastructure).
-- personalization setups live in lua/plugins/<repo-basename>.lua and are
-- dispatched by lua/plugins/init.lua after the core layer is up.
--
-- update all with :lua vim.pack.update()
-- lazy loading: vim.pack supports { load = false } + manual packadd(), but the
-- current set is all startup-essential; defer that until a heavy plugin shows up.
local settings = require('settings')

-- github repos; { repo, version = ... }
local repos = {
    { 'folke/tokyonight.nvim' }, -- colorscheme
    { 'nvim-treesitter/nvim-treesitter', version = 'main' }, -- highlighting (active branch, 0.11+)
    { 'ibhagwan/fzf-lua' }, -- search (needs system fzf + ripgrep)
    -- mini.nvim monorepo: tabline, files, icons, pairs, surround, ai,
    -- statusline, clue, notify, indentscope, bufremove
    { 'nvim-mini/mini.nvim' },
    -- completion UI: lsp only provides data, this layer owns popup/fuzzy/docs.
    -- tracks main, which requires the companion library blink.lib
    { 'saghen/blink.cmp' },
    { 'saghen/blink.lib' },
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

-- ssh clone by default; fall back to https if ssh fails
-- (e.g. no github key on this host)
local ok = pcall(vim.pack.add, build_specs(settings.use_git_ssh))
if not ok and settings.use_git_ssh then
    vim.notify('ssh clone failed, falling back to https', vim.log.levels.WARN)
    vim.pack.add(build_specs(false))
end
