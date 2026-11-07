local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local options, direction
package.preload.gitsigns = function()
    return {
        setup = function(opts) options = opts end,
        nav_hunk = function(value) direction = value end,
        stage_buffer = function() end,
        undo_stage_hunk = function() end,
        reset_buffer = function() end,
        preview_hunk = function() end,
        toggle_current_line_blame = function() end,
        diffthis = function() end,
    }
end

require("plugins.configs.gitsigns")
assert(options, "gitsigns was not configured")
assert(options.yadm == nil, "obsolete yadm option is still configured")
assert(options.numhl and not options.signcolumn, "existing sign preferences changed")
assert(type(options.on_attach) == "function", "existing buffer mappings are missing")
local mappings = {}
vim.keymap.set = function(_, lhs, rhs) mappings[lhs] = rhs end
vim.schedule = function(callback) callback() end
options.on_attach(vim.api.nvim_get_current_buf())
mappings["]c"]()
assert(direction == "next", "]c should navigate to the next hunk")
mappings["[c"]()
assert(direction == "prev", "[c should navigate to the previous hunk")
print("gitsigns configuration test passed")
