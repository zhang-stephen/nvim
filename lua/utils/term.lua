-- panel-style terminal manager: vscode-style bottom dock
-- - toggle hides the panel but keeps the process alive
-- - cwd of new terminals follows neovim's working directory
-- - multiple terminals: new / cycle / kill
local term = {}

local HEIGHT_RATIO = 0.3

local state = { terms = {}, active = 0, seq = 0 }

local function panel_height()
    return math.max(3, math.floor(vim.o.lines * HEIGHT_RATIO))
end

local function is_valid(idx)
    local buf = state.terms[idx]
    return buf and vim.api.nvim_buf_is_valid(buf)
end

-- label for the winbar: 'term://3:nvim' -> '3:nvim' (stable creation seq,
-- identical to what the statusline shows)
local term_win -- forward declaration, defined below

local function buf_label(buf)
    return vim.api.nvim_buf_get_name(buf):match('[^/\\]+$') or ''
end

-- panel winbar: clickable tabs ' 1:nvim  2:nvim ', active one highlighted
local function render_winbar()
    local parts = {}
    for i, buf in ipairs(state.terms) do
        local hl = (i == state.active) and '%#TabLineSel#' or '%#TabLine#'
        -- %<i>@...@...%X makes the label clickable, minwid = terminal index
        table.insert(parts, ("%%%d@v:lua.require'utils.term'.click@%s %s %%X"):format(i, hl, buf_label(buf)))
    end
    -- trailing fill must not inherit the active tab's highlight;
    -- right-aligned key hints since mini.clue cannot cover terminal mode
    -- (mapping <leader>=space in terminal mode would eat every typed space)
    return table.concat(parts, ' ')
        .. '%#TabLineFill# %= <C-\\>:hide <Esc>:normal <C-hjkl>:leave '
end

local function update_winbar()
    local win = term_win()
    if win then
        vim.wo[win].winbar = #state.terms > 0 and render_winbar() or ''
    end
end

-- the window currently showing any managed terminal, if visible
term_win = function()
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
    -- unlisted (kept out of the global tabline, the panel has its own winbar)
    -- but not a scratch buffer (avoid bufhidden=wipe etc.)
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_win_set_buf(win, buf)
    vim.fn.termopen(vim.o.shell, { cwd = vim.fn.getcwd() })
    table.insert(state.terms, buf)
    state.active = #state.terms
    -- stable creation-seq name for the winbar/statusline (monotonic, never
    -- reused; list indices shift on kill, so don't use them as names)
    state.seq = state.seq + 1
    pcall(
        vim.api.nvim_buf_set_name,
        buf,
        ('term://%d:%s'):format(state.seq, vim.fn.fnamemodify(vim.fn.getcwd(), ':t'))
    )
    update_winbar()
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
                update_winbar()
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
        update_winbar()
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
        update_winbar()
        vim.cmd.startinsert()
    end
end

term.kill = function()
    local buf = state.terms[state.active]
    if not buf then
        return
    end
    -- wiping a terminal buffer that is displayed in a window takes the
    -- window down with it (observed behavior), so don't rely on the window
    -- surviving: close the leftovers or reopen the panel as needed
    local win = term_win()
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
    local win_alive = win and vim.api.nvim_win_is_valid(win)
    if #state.terms == 0 then
        if win_alive then
            vim.api.nvim_win_close(win, true)
        end
        return
    end
    if win_alive then
        vim.api.nvim_win_set_buf(win, state.terms[state.active])
    else
        local w = open_panel()
        vim.api.nvim_win_set_buf(w, state.terms[state.active])
        vim.cmd.startinsert()
    end
    update_winbar()
end

-- winbar click handler: switch the panel to the clicked terminal
term.click = function(minwid)
    if not is_valid(minwid) then
        return
    end
    state.active = minwid
    local win = term_win()
    if win then
        vim.api.nvim_win_set_buf(win, state.terms[minwid])
        update_winbar()
    end
end

-- statusline section: '2/3' (active/total), empty when no terminals exist
term.status = function()
    if #state.terms == 0 then
        return ''
    end
    return ('%d/%d'):format(state.active, #state.terms)
end

return term
