-- panel-style terminal manager: vscode-style bottom dock
-- two kinds of terminals:
-- - shell: interactive; `exit` wipes it right away (no corpse, vscode-like)
-- - task:  delegated via :TermRun/:T; keeps its scrollback after finishing,
--          winbar label shows the exit code, closed manually (<leader>tx or q)
local term = {}

local HEIGHT_RATIO = 0.3

local state = { terms = {}, active = 0, seq = 0, last_cmd = nil }

-- terminal program: prefer pwsh on windows. msix (store) pwsh hangs when
-- spawned by libuv directly, so relay through cmd - no hardcoded paths,
-- no vim.o.shell pollution (:!/system() keep the system default)
local shell_argv = nil -- nil means use vim.o.shell verbatim
if vim.fn.has('win32') == 1 and vim.fn.executable('pwsh') == 1 then
    shell_argv = { 'cmd.exe', '/c', 'pwsh' }
end

-- argv for a delegated task command, piggybacking on the chosen shell
local function task_argv(cmd)
    if shell_argv then
        return vim.list_extend(vim.deepcopy(shell_argv), { '-c', cmd })
    end
    local flag = vim.o.shell:lower():match('cmd%.exe$') and '/c' or '-c'
    return { vim.o.shell, flag, cmd }
end

----------------------------------------------------------------------
-- helpers
----------------------------------------------------------------------

local function panel_height()
    return math.max(3, math.floor(vim.o.lines * HEIGHT_RATIO))
end

local function find_rec_idx(buf)
    for i, rec in ipairs(state.terms) do
        if rec.buf == buf then
            return i
        end
    end
    return nil
end

local function is_valid(idx)
    local rec = state.terms[idx]
    return rec and vim.api.nvim_buf_is_valid(rec.buf)
end

local term_win -- forward declaration, defined below

-- the window currently showing any managed terminal, if visible
term_win = function()
    local set = {}
    for _, rec in ipairs(state.terms) do
        set[rec.buf] = true
    end
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if set[vim.api.nvim_win_get_buf(win)] then
            return win
        end
    end
    return nil
end

-- winbar label from the record (not the buffer name, which cannot
-- express a task's exit state)
local function rec_label(rec)
    if rec.kind == 'task' then
        -- triangle play glyph (U+25B6, written as bytes) marks task terminals
        local label = ('\xe2\x96\xb6 %d:%s'):format(rec.seq, rec.cmd)
        if rec.done then
            -- bare exit code: 0 is universally understood as success
            label = label .. (' (%d)'):format(rec.code)
        end
        return label
    end
    -- '$ ' marks interactive shells
    return ('$ %d:%s'):format(rec.seq, vim.fn.fnamemodify(rec.cwd, ':t'))
end

-- panel winbar: clickable tabs, active one highlighted, key hints right
local function render_winbar()
    local parts = {}
    for i, rec in ipairs(state.terms) do
        local hl = (i == state.active) and '%#TabLineSel#' or '%#TabLine#'
        -- %<i>@...@...%X makes the label clickable, minwid = terminal index
        table.insert(parts, ("%%%d@v:lua.require'utils.term'.click@%s %s %%X"):format(i, hl, rec_label(rec)))
    end
    -- trailing fill must not inherit the active tab's highlight
    return table.concat(parts, ' ')
        .. '%#TabLineFill# %= q:close <C-\\>:hide <Esc>:normal '
end

local function update_winbar()
    local win = term_win()
    if win then
        vim.wo[win].winbar = #state.terms > 0 and render_winbar() or ''
    end
end

local function open_panel()
    vim.cmd('botright ' .. panel_height() .. 'split')
    local win = vim.api.nvim_get_current_win()
    vim.wo[win].winfixheight = true
    return win
end

-- q in normal mode: "close what is in front of me" - a finished task gets
-- wiped, anything else just hides the panel (the process survives)
local function setup_buffer_keys(buf)
    vim.keymap.set('n', 'q', function()
        local idx = find_rec_idx(vim.api.nvim_get_current_buf())
        local rec = idx and state.terms[idx]
        if rec and rec.kind == 'task' and rec.done then
            state.active = idx
            term.kill()
            return
        end
        local win = term_win()
        if win then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf, desc = 'close finished task / hide panel' })
end

-- shared creation path; kind is 'shell' or 'task' (cmd required for tasks)
local function create(kind, cmd)
    -- reuse the existing panel window: multiple terminals live as records
    -- inside the single panel (vscode terminal tabs), never stacked splits
    local win = term_win() or open_panel()
    -- unlisted (kept out of the global tabline) but not a scratch buffer
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_win_set_buf(win, buf)

    state.seq = state.seq + 1
    local rec = {
        buf = buf,
        kind = kind,
        seq = state.seq,
        cwd = vim.fn.getcwd(),
        cmd = cmd,
        done = false,
        code = nil,
    }

    if kind == 'task' then
        -- shell -c so aliases/env match an interactive session
        vim.fn.termopen(task_argv(cmd), {
            cwd = rec.cwd,
            on_exit = function(_, code)
                vim.schedule(function()
                    rec.done = true
                    rec.code = code
                    pcall(vim.api.nvim_buf_set_name, buf, ('task://%d:%s(%d)'):format(rec.seq, cmd, code))
                    update_winbar()
                    vim.notify(('task finished (%d): %s'):format(code, cmd), vim.log.levels.INFO)
                end)
            end,
        })
        state.last_cmd = cmd
        pcall(vim.api.nvim_buf_set_name, buf, ('task://%d:%s'):format(rec.seq, cmd))
    else
        vim.fn.termopen(shell_argv or vim.o.shell, { cwd = rec.cwd })
        pcall(
            vim.api.nvim_buf_set_name,
            buf,
            ('term://%d:%s'):format(rec.seq, vim.fn.fnamemodify(rec.cwd, ':t'))
        )
    end

    table.insert(state.terms, rec)
    state.active = #state.terms
    setup_buffer_keys(buf)
    update_winbar()
    vim.cmd.startinsert()
end

-- drop wiped terminal buffers from the state list
vim.api.nvim_create_autocmd('BufWipeout', {
    callback = function(ev)
        local idx = find_rec_idx(ev.buf)
        if not idx then
            return
        end
        table.remove(state.terms, idx)
        if state.active > #state.terms then
            state.active = #state.terms
        end
        update_winbar()
    end,
})

-- interactive shells: `exit` wipes the buffer right away (no corpse).
-- task buffers are kept on purpose and handled by on_exit instead
vim.api.nvim_create_autocmd('TermClose', {
    callback = function(ev)
        local idx = find_rec_idx(ev.buf)
        local rec = idx and state.terms[idx]
        if not (rec and rec.kind == 'shell') then
            return
        end
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
                pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
            end
        end)
    end,
})

----------------------------------------------------------------------
-- public api
----------------------------------------------------------------------

term.toggle = function()
    local win = term_win()
    if win then
        vim.api.nvim_win_close(win, true)
        return
    end
    if is_valid(state.active) then
        local w = open_panel()
        vim.api.nvim_win_set_buf(w, state.terms[state.active].buf)
        update_winbar()
        vim.cmd.startinsert()
    else
        create('shell')
    end
end

term.new = function()
    create('shell')
end

term.run = function(cmd)
    create('task', cmd)
end

term.rerun = function()
    if state.last_cmd then
        create('task', state.last_cmd)
    else
        vim.notify('no task to rerun yet', vim.log.levels.WARN)
    end
end

term.cycle = function(delta)
    if #state.terms == 0 then
        return
    end
    state.active = ((state.active - 1 + delta) % #state.terms) + 1
    local win = term_win()
    if win then
        vim.api.nvim_win_set_buf(win, state.terms[state.active].buf)
        vim.api.nvim_set_current_win(win)
        update_winbar()
        vim.cmd.startinsert()
    end
end

term.kill = function()
    local rec = state.terms[state.active]
    if not rec then
        return
    end
    -- wiping a terminal buffer that is displayed in a window takes the
    -- window down with it (observed behavior), so don't rely on the window
    -- surviving: close the leftovers or reopen the panel as needed
    local win = term_win()
    pcall(vim.api.nvim_buf_delete, rec.buf, { force = true })
    local win_alive = win and vim.api.nvim_win_is_valid(win)
    if #state.terms == 0 then
        if win_alive then
            vim.api.nvim_win_close(win, true)
        end
        return
    end
    if win_alive then
        vim.api.nvim_win_set_buf(win, state.terms[state.active].buf)
    else
        local w = open_panel()
        vim.api.nvim_win_set_buf(w, state.terms[state.active].buf)
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
        vim.api.nvim_win_set_buf(win, state.terms[minwid].buf)
        update_winbar()
    end
end

-- statusline section: ' 2/3' (icon + active/total), empty when no terminals
term.status = function()
    if #state.terms == 0 then
        return ''
    end
    -- leading nf-oct-terminal icon (U+F489, written as bytes on purpose)
    return ('\xef\x92\x89 %d/%d'):format(state.active, #state.terms)
end

-- :TermRun {cmd} and its short alias :T
vim.api.nvim_create_user_command('TermRun', function(ev)
    term.run(ev.args)
end, { nargs = '+', desc = 'run a command in a task terminal' })
vim.api.nvim_create_user_command('T', function(ev)
    term.run(ev.args)
end, { nargs = '+', desc = 'alias of :TermRun' })

return term
