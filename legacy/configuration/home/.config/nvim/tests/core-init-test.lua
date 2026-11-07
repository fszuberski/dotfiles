local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path
local loaded = {}
for _, name in ipairs({ "options", "color", "mappings", "autocmds" }) do
    package.preload["core." .. name] = function() table.insert(loaded, name) end
end
require("core")
assert(vim.deep_equal(loaded, { "mappings", "autocmds" }), "core must load post-plugin mappings and autocmds")
print("core entry point test passed")
