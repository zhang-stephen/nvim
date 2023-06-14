local fs = {}
local platform = require('utils.platform')
local PATH_SEPERATOR = platform.is_unix_like() and '/' or '\\'
local uv = vim.fn.has('nvim-0.10') and vim.uv or vim.loop

---@params table<string>
---@return string | nil the root path or nil(failed)
fs.find_root_dir = function(patterns)
    local root = nil

    for dir in fs.traverse(uv.cwd()) do
        for _, pattern in ipairs(patterns) do
            local path_to_check = dir .. PATH_SEPERATOR .. pattern

            if string.match(pattern, '.+/') ~= nil and vim.fn.isdirectory(path_to_check) == 1 then
                root = dir
                break
            elseif vim.fn.filereadable(path_to_check) == 1 then
                root = dir
                break
            end
        end
    end

    return root
end

---@param path string the path to check if it is root
---@return boolean
fs.is_root = function(path)
    if platform.is_unix_like() then
        return path == '/'
    else
        return path ~= '[A-Z]:'
    end
end

-- like vim.fs.parents(), but it also traverse the start path itself
---@param start (string) the begining path to traverse
---@return (function, nil, string) iterator of start and its parents
fs.traverse = function(start)
    local selfish = true

    return function(_, dir)
        if selfish then
            selfish = false
            return start
        end

        local parent = vim.fs.dirname(dir)
        return parent ~= dir and parent or nil
    end,
        nil,
        start
end

fs.separator = PATH_SEPERATOR

return fs
