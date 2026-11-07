local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path
local remap = require("core.remap")

remap.nmap("<F21>", "j")
remap.nnoremap("<F22>", "k", { silent = true })
remap.inoremap("<F23>", "x")

assert(vim.fn.maparg("<F21>", "n", false, true).noremap == 0, "nmap must be recursive")
local normal = vim.fn.maparg("<F22>", "n", false, true)
assert(normal.noremap == 1 and normal.silent == 1, "nnoremap must preserve nonrecursive and custom options")
assert(vim.fn.maparg("<F23>", "i", false, true).noremap == 1, "insert mapping must be nonrecursive")
print("mapping helper test passed")
