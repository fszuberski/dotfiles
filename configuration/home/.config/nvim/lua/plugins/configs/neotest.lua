local present1, neotest = pcall(require, "neotest")
local present2, neotest_go = pcall(require, "neotest-go")

if not (present1 and present2) then
    return
end


local options = {
    adapters = {
        neotest_go({
            experimental = {
                test_table = true
            },
            --[[ args = {
                "-covermode=atomic",
                "-coverprofile=coverage.out",
            }, ]]
        })
    },
    diagnostic = {
        enabled = true,
    },
    discovery = {
        -- helps with performance issues in large repos;
        -- could be set back to true once 
        enabled = false
    },
    status = {
        enabled = true,
        signs = true,
        virtual_text = false,
    },
    icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "✖",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "✔",
        running = "~",
        skipped = "ﰸ",
        unknown = "?"
    },
    summary = {
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            output = "o",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t"
        }
    }

}

neotest.setup(options)
