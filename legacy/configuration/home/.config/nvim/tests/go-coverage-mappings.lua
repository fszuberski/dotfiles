local neotest = require("neotest")
local received
neotest.run.run = function(args) received = args end
neotest.run.run_last = function(args) received = args end

for _, key in ipairs({ " nT", " nF", " nL" }) do
    received = nil
    local mapping = vim.fn.maparg(key, "n", false, true)
    assert(type(mapping.callback) == "function", "coverage mapping missing: " .. key)
    mapping.callback()
    local args = received and received.extra_args and received.extra_args.go_test_args
    assert(args and vim.tbl_contains(args, "-covermode=atomic"), "coverage mode missing: " .. key)
    assert(vim.tbl_contains(args, "-coverprofile=coverage.out"), "coverage profile missing: " .. key)
end
