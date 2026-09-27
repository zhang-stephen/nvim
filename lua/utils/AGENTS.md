# AGENTS.md — lua/utils/

Hand-written utility modules (no plugin equivalent, or plugin not worth it).
Root `AGENTS.md` rules apply; this file adds module-level conventions.

## Module conventions

- Same module pattern as everywhere: `local M = {}` → public functions as fields → `return M`.
- State lives in a module-local table (see `term.lua`'s `state`); never in globals.
- Side effects at load time are allowed only for autocmds/user commands the module owns.
- Lua forward references: declare `local fn` first, assign later (`fn = function() ... end`).
  A `local function` used before its definition line silently resolves to a global nil.

## term.lua — terminal panel

Design decisions, in order of importance:

1. **Re-evaluate toggleterm.nvim before adding ANY new terminal feature.** Self-hosting
   was chosen because winbar tabs / task corpses / click-switching are not toggleterm's
   model; do not let this drift without re-checking.
2. **Two kinds**: `shell` (interactive, `exit` wipes immediately, no corpse) and
   `task` (`:TermRun`/`:T`, keeps scrollback, exit code in the winbar label, manual close).
3. **Wiping a displayed terminal buffer takes its window down.** Never assume the panel
   window survives a `buf_delete` — grab the window first, reopen if it died.
4. **Never map `<leader>` in terminal mode** — leader is space; every typed space would
   be intercepted. Terminal-mode keys are singletons only (`<C-\>`, `<Esc>`, `<C-hjkl>`);
   discoverability goes in the winbar's right-aligned hints, not mini.clue.
5. Terminal buffers are **unlisted** (kept out of the global tabline) but **not scratch**
   (avoid `bufhidden=wipe` semantics).
6. Names use a monotonic `seq` (`term://3:cwd`, `task://4:cmd`), never list indices —
   indices shift on kill.
7. Nerd-font glyphs in source are written as byte escapes (`\xef\x92\x89`), never as
   literal characters — literals have been silently dropped before.

## Platform detection

Use builtin `vim.fn.has()` (`'win32'` / `'macunix'` / `'unix'`) — never
`os_uname().sysname`, which msys2/mingw neovim builds report as MSYS-style
strings. (The former `platform.lua` wrapper was retired: the builtin API made
it a one-line shell.)
