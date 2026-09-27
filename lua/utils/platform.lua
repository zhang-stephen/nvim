local platform = {}
local uv = vim.loop

platform.is_win32 = function()
    return uv.os_uname().sysname == 'Windows_NT'
end

platform.is_linux = function()
    return uv.os_uname().sysname == 'Linux'
end

platform.is_macos = function()
    return uv.os_uname().sysname == 'Darwin'
end

platform.is_unix_like = function()
    return not platform.is_win32()
end

platform.is_ssh = function()
    return vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil
end

return platform
