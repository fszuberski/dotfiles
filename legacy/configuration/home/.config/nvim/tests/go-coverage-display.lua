local config = vim.fn.stdpath("config")
dofile(config .. "/tests/go-coverage.lua")
vim.cmd.edit("sample.go")

local mapping = vim.fn.maparg(" ko", "n", false, true)
assert(type(mapping.callback) == "function", "coverage display mapping missing")
mapping.callback()

local ok = vim.wait(5000, function()
    local placed = vim.fn.sign_getplaced(vim.api.nvim_get_current_buf(), { group = "coverage" })
    return placed[1] and #placed[1].signs > 0
end, 50)
assert(ok, "coverage signs were not displayed for the Go fixture")
