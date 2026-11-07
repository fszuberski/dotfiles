local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path
local lock = vim.json.decode(table.concat(vim.fn.readfile(root .. "/lazy-lock.json"), "\n"))
for _, spec in ipairs(require("plugins.lazy-spec")) do
    local name = spec.name or spec[1]:match("/([^/]+)$")
    assert(lock[name] and lock[name].commit:match("^%x+$") and #lock[name].commit == 40, "missing locked revision for " .. name)
end
assert(lock["lazy.nvim"] and lock["nvim-nio"], "plugin manager or DAP dependency is not locked")
assert(not lock.playground, "removed playground plugin remains in lockfile")
assert(lock["lspsaga.nvim"].commit == "cf6fc9473bba1d332eda9887855ea29ed9b37701", "Lspsaga lock must retain the tested modern revision")
assert(lock["nvim-scrollbar"].branch == "refactor/v2" and lock["nvim-scrollbar"].commit == "b39443d8fcae3e326ff965dea3fe7df266c8ccac", "scrollbar lock must retain the tested v2 revision")
print("lazy.nvim lockfile test passed")
