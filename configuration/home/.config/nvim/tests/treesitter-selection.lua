vim.api.nvim_buf_set_lines(0, 0, -1, false, { "local value = (1 + 2)" })
vim.cmd("setfiletype lua")
vim.treesitter.get_parser(0, "lua"):parse()
vim.api.nvim_win_set_cursor(0, { 1, 15 })

local function press(key)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "xt", false)
end

local function selected_width()
    local anchor = vim.fn.getpos("v")
    local cursor = vim.fn.getpos(".")
    assert(anchor[2] == cursor[2], "test selection should remain on one line")
    return math.abs(anchor[3] - cursor[3]) + 1
end

press("<A-v>")
assert(vim.api.nvim_get_mode().mode == "v", "node selection did not enter visual mode")
local first = selected_width()
press("<A-v>")
local expanded = selected_width()
assert(expanded > first, "node selection did not expand")
press("<A-BS>")
assert(selected_width() < expanded, "node selection did not shrink")
