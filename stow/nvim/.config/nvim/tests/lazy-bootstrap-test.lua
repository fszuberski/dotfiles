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

vim.fn.delete(path, "d")
local config = vim.fn.stdpath("config")
vim.fn.mkdir(config, "p")
local revision = string.rep("a", 40)
vim.fn.writefile({ vim.json.encode({ ["lazy.nvim"] = { commit = revision } }) }, config .. "/lazy-lock.json")
local commands = {}
vim.fn.system = function(command)
    table.insert(commands, command)
    if command[2] == "clone" then vim.fn.mkdir(path, "p") end
    return ""
end
require("plugins.lazy-bootstrap").setup(specs)
assert(#commands == 2 and commands[2][2] == "-C" and commands[2][3] == path
    and commands[2][4] == "checkout" and commands[2][5] == "--detach" and commands[2][6] == revision,
    "fresh bootstrap must check out the locked lazy.nvim revision")
print("lazy.nvim bootstrap test passed")
