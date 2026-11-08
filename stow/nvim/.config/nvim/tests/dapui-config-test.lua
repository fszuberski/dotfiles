local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local options
package.preload.dap = function()
    return { listeners = { after = { event_initialized = {} }, before = { event_terminated = {}, event_exited = {} } } }
end
package.preload.dapui = function()
    return { setup = function(opts) options = opts end, open = function() end, close = function() end }
end
require("plugins.configs.dapui")
assert(options and options.expand_lines == true, "DAP UI expand_lines must be a boolean")
print("DAP UI configuration test passed")
