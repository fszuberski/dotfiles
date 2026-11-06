local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path
local lock = vim.json.decode(table.concat(vim.fn.readfile(root .. "/lazy-lock.json"), "\n"))
for _, spec in ipairs(require("plugins.lazy-spec")) do
    local name = spec.name or spec[1]:match("/([^/]+)$")
    assert(lock[name] and lock[name].commit:match("^%x+$") and #lock[name].commit == 40, "missing locked revision for " .. name)
end
assert(lock["lazy.nvim"] and lock["nvim-nio"], "plugin manager or DAP dependency is not locked")
assert(not lock.playground, "removed playground plugin remains in lockfile")
print("lazy.nvim lockfile test passed")
