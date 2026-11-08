local path = vim.fn.stdpath("config") .. "/tests/fixtures/go/sample_test.go"
local done, failure = false, nil
assert(#vim.api.nvim_get_runtime_file("parser/go.*", false) > 0, "Go parser not installed in test environment")

require("nio").run(function()
    local adapter = require("neotest.config").adapters[1]
    local tree = adapter.discover_positions(path)
    assert(tree and #tree:children() > 0, "no Go tests discovered")
    assert(tree:children()[1]:data().name == "TestSample", "expected Go test not discovered")
end, function(ok, err)
    failure = not ok and err or nil
    done = true
end)

assert(vim.wait(30000, function() return done end), "Go test discovery timed out")
assert(not failure, tostring(failure))
