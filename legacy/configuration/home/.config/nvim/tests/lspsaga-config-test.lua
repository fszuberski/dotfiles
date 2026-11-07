package.path = vim.fn.getcwd() .. "/lua/?.lua;" .. package.path
local options
package.preload.lspsaga = function()
    return { setup = function(config) options = config end }
end
require("plugins.configs.lspsaga")
assert(options.lightbulb.enable and options.lightbulb.sign, "code-action gutter sign must remain enabled")
assert(options.lightbulb.virtual_text == false, "inline code-action lightbulb must be disabled")
assert(vim.tbl_contains(options.lightbulb.ignore and options.lightbulb.ignore.ft or {}, "markdown"), "Markdown must not display the code-action lightbulb")
print("Lspsaga lightbulb configuration test passed")
