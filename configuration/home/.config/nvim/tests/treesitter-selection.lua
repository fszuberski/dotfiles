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

press("<Esc>")
vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    "local function outer()",
    "  local function inner()",
    "    return 42",
    "  end",
    "end",
})
vim.treesitter.query.set("lua", "locals", "[(function_declaration) (chunk)] @local.scope")
vim.treesitter.get_parser(0, "lua"):parse()
vim.api.nvim_win_set_cursor(0, { 3, 11 })
press("<A-v>")
press("<A-c>")
local start = vim.fn.getpos("v")
local finish = vim.fn.getpos(".")
assert(start[2] == 2 and finish[2] == 4, "scope expansion did not select the inner function")
press("<A-c>")
start = vim.fn.getpos("v")
finish = vim.fn.getpos(".")
assert(start[2] == 1 and finish[2] == 5, "scope expansion did not select the outer function")

press("<Esc>")
vim.api.nvim_win_set_cursor(0, { 3, 11 })
press("<A-v>")
press("o")
press("<A-c>")
start = vim.fn.getpos("v")
finish = vim.fn.getpos(".")
assert(start[2] == 2 and finish[2] == 4, "scope expansion failed for a reversed selection")

vim.treesitter.query.set("lua", "locals", "(identifier) @local.reference")
local old_start, old_finish = vim.fn.getpos("v"), vim.fn.getpos(".")
press("<A-c>")
assert(vim.deep_equal(old_start, vim.fn.getpos("v")) and vim.deep_equal(old_finish, vim.fn.getpos(".")), "missing scopes should leave the selection unchanged")
