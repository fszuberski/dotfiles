local file = vim.fn.stdpath("cache") .. "/dap-fixture.txt"
vim.fn.writefile({ "breakpoint" }, file)
vim.cmd.edit(vim.fn.fnameescape(file))
local buf = vim.api.nvim_get_current_buf()
local callback = vim.fn.maparg(" db", "n", false, true).callback
assert(type(callback) == "function", "breakpoint mapping missing")

callback()
local breakpoints = require("dap.breakpoints").get()
assert(breakpoints[buf] and #breakpoints[buf] == 1, "breakpoint was not set")
callback()
breakpoints = require("dap.breakpoints").get()
assert(not breakpoints[buf] or #breakpoints[buf] == 0, "breakpoint was not removed")
