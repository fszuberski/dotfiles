local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.fn.mkdir(path, "p")

local captured
package.preload.lazy = function()
    return {
        setup = function(spec, opts)
            captured = { spec = spec, opts = opts }
        end,
    }
end

local specs = { { "example/plugin" } }
require("plugins.lazy-bootstrap").setup(specs)
assert(captured and captured.spec == specs, "lazy.nvim did not receive the plugin specs")
assert(vim.opt.runtimepath:get()[1] == path, "lazy.nvim was not added to the runtime path")
print("lazy.nvim bootstrap test passed")
