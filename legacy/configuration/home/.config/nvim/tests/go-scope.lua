vim.lsp.enable("gopls", false)
vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    "package sample",
    "func sample() {",
    "    if true {",
    '        println("hé")',
    "    }",
    "}",
})
vim.cmd("setfiletype go")
vim.treesitter.get_parser(0, "go"):parse()
assert(vim.treesitter.query.get("go", "locals"), "Go locals query is missing")
vim.api.nvim_win_set_cursor(0, { 4, 10 })

local function press(key)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "xt", false)
end

press("<A-v>")
press("<A-c>")
assert(vim.fn.getpos("v")[2] == 3 and vim.fn.getpos("v")[3] == 13 and vim.fn.getpos(".")[2] == 5, "Go if block was not selected")
press("<A-c>")
assert(vim.fn.getpos("v")[2] == 3 and vim.fn.getpos("v")[3] == 5 and vim.fn.getpos(".")[2] == 5, "Go if statement was not selected")
press("<A-c>")
assert(vim.fn.getpos("v")[2] == 2 and vim.fn.getpos("v")[3] == 15 and vim.fn.getpos(".")[2] == 6, "Go function block was not selected")
press("<A-c>")
assert(vim.fn.getpos("v")[2] == 2 and vim.fn.getpos("v")[3] == 1 and vim.fn.getpos(".")[2] == 6, "Go function scope was not selected")
