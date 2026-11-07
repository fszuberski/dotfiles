local path = vim.fn.stdpath("config") .. "/tests/fixtures/go/sample_test.go"
vim.env.GOCACHE = vim.fn.stdpath("cache") .. "/go-build"
vim.env.GOWORK = "off"
vim.env.GOPROXY = "off"
vim.env.GOTELEMETRY = "off"
vim.lsp.enable("gopls", false)
vim.cmd.edit(vim.fn.fnameescape(path))

local neotest = require("neotest")
neotest.run.run(path)
local ok = vim.wait(120000, function()
    for _, id in ipairs(neotest.state.adapter_ids()) do
        local counts = neotest.state.status_counts(id)
        if counts and counts.passed > 0 then
            return true
        end
    end
    return false
end, 100)
assert(ok, "neotest did not report a passing Go test")
