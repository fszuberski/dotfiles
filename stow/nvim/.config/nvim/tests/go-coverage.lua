local dir = vim.fn.stdpath("config") .. "/tests/fixtures/go"
vim.env.GOCACHE = vim.fn.stdpath("cache") .. "/go-build"
vim.env.GOWORK = "off"
vim.env.GOPROXY = "off"
vim.env.GOTELEMETRY = "off"
vim.lsp.enable("gopls", false)
vim.cmd.cd(vim.fn.fnameescape(dir))
vim.cmd.edit("sample_test.go")

local mapping = vim.fn.maparg(" nF", "n", false, true)
assert(type(mapping.callback) == "function", "Go coverage mapping missing")
mapping.callback()

local neotest = require("neotest")
local ok = vim.wait(120000, function()
    for _, id in ipairs(neotest.state.adapter_ids()) do
        local counts = neotest.state.status_counts(id)
        if counts and counts.passed > 0 and vim.fn.filereadable(dir .. "/coverage.out") == 1 then
            return true
        end
    end
    return false
end, 100)
assert(ok, "neotest did not report a passing covered Go test")
local lines = vim.fn.readfile(dir .. "/coverage.out")
assert(lines[1] == "mode: atomic" and #lines > 1, "coverage profile is missing instrumented statements")
