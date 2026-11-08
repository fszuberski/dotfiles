local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path
local options
package.preload["treesitter-context"] = function()
    return { setup = function(opts) options = opts end }
end
require("plugins.configs.treesitter-context")
assert(options and options.enable and options.mode == "cursor", "context settings missing")
assert(options.trim_scope == "outer" and options.max_lines == 0, "context layout changed")
assert(options.patterns == nil and options.exact_patterns == nil, "obsolete pattern options remain")
print("Tree-sitter context configuration test passed")
