local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local options
package.preload.gitsigns = function()
    return { setup = function(opts) options = opts end }
end

require("plugins.configs.gitsigns")
assert(options, "gitsigns was not configured")
assert(options.yadm == nil, "obsolete yadm option is still configured")
assert(options.numhl and not options.signcolumn, "existing sign preferences changed")
assert(type(options.on_attach) == "function", "existing buffer mappings are missing")
print("gitsigns configuration test passed")
