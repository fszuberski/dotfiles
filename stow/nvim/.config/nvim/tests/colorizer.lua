vim.api.nvim_buf_set_lines(0, 0, -1, false, { "#ff0000" })
vim.cmd("setfiletype text")
vim.cmd.redraw()
local namespace = vim.api.nvim_get_namespaces().colorizer
assert(namespace, "colorizer namespace is missing")
local ok = vim.wait(5000, function()
    return #vim.api.nvim_buf_get_extmarks(0, namespace, 0, -1, {}) > 0
end, 50)
assert(ok, "hex color was not highlighted")
