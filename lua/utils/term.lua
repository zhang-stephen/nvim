-- panel-style terminal manager: vscode-style bottom dock
-- - toggle hides the panel but keeps the process alive
-- - cwd of new terminals follows neovim's working directory
-- - multiple terminals: new / cycle / kill
local term = {}

local HEIGHT_RATIO = 0.3

local state = { terms = {}, active = 0 }

local function panel_height()
    return math.max(3, math.floor(vim.o.lines * HEIGHT_RATIO))
end

local function is_valid(idx)
    local buf = state.terms[idx]
    return buf and vim.api.nvim_buf_is_valid(buf)
end

-- the window currently showing any managed terminal, if visible
local function term_win()
    local set = {}
    for _, buf in ipairs(state.terms) do
        set[buf] = true
    end
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if set[vim.api.nvim_win_get_buf(win)] then
            return win
        end
    end
    return nil
end

local function open_panel()
    vim.cmd('botright ' .. panel_height() .. 'split')
    local win = vim.api.nvim_get_current_win()
    vim.wo[win].winfixheight = true
    return win
end

local function create()
    -- reuse the existing panel window: multiple terminals live as buffers
    -- inside the single panel (vscode terminal tabs), never stacked splits
    local win = term_win() or open_panel()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, buf)
    vim.fn.termopen(vim.o.shell, { cwd = vim.fn.getcwd() })
    table.insert(state.terms, buf)
    state.active = #state.terms
    -- readable name for the tabline/buffer list instead of '[No Name]'
    pcall(
        vim.api.nvim_buf_set_name,
        buf,
        ('term://%d:%s'):format(buf, vim.fn.fnamemodify(vim.fn.getcwd(), ':t'))
    )
    vim.cmd.startinsert()
end

-- drop wiped terminal buffers from the state list
vim.api.nvim_create_autocmd('BufWipeout', {
    callback = function(ev)
        for i, buf in ipairs(state.terms) do
            if buf == ev.buf then
                table.remove(state.terms, i)
                if state.active > #state.terms then
                    state.active = #state.terms
                end
                return
            end
        end
    end,
})

term.toggle = function()
    local win = term_win()
    if win then
        vim.api.nvim_win_close(win, true)
        return
    end
    if is_valid(state.active) then
        local w = open_panel()
        vim.api.nvim_win_set_buf(w, state.terms[state.active])
        vim.cmd.startinsert()
    else
        create()
    end
end

term.new = create

term.cycle = function(delta)
    if #state.terms == 0 then
        return
    end
    state.active = ((state.active - 1 + delta) % #state.terms) + 1
    local win = term_win()
    if win then
        vim.api.nvim_win_set_buf(win, state.terms[state.active])
        vim.api.nvim_set_current_win(win)
        vim.cmd.startinsert()
    end
end

term.kill = function()
    local buf = state.terms[state.active]
    if buf then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
end

return term
