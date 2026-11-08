local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local options
package.preload.scrollbar = function()
    return { setup = function(opts) options = opts end }
end
package.preload["core.color"] = function()
    return { orange = "#ffaa00", error = "#ff0000", warn = "#ffff00", info = "#00ffff", hint = "#00ff00", purple = "#ff00ff" }
end
require("plugins.configs.scrollbar")
assert(options and options.providers.gitsigns and options.providers.diagnostic, "Git and diagnostic providers must be enabled")
assert(options.providers.search == false and options.providers.marks == false, "new providers must not change existing behavior")
assert(options.scrollbar.visibility == "all" and options.scrollbar.thumb.highlight == "CursorColumn", "scrollbar appearance changed")
assert(options.marks.Error.highlight.fg == "#ff0000" and options.marks.GitChange.highlight == "GitSignsChange", "marker highlights changed")
assert(options.exclude.filetypes.harpoon and options.exclude.buftypes.terminal, "buffer exclusions changed")
print("scrollbar v2 configuration test passed")
