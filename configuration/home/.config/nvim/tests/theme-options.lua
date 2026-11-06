local opts = require("tokyonight.config").options
assert(opts.style == "night" and _G.Colors == nil)
assert(opts.transparent == false and opts.terminal_colors == true)
assert(opts.styles.comments.italic and opts.styles.keywords.italic)
assert(opts.styles.sidebars == "dark" and opts.styles.floats == "dark")
local colors = require("core.color")
assert(type(colors) == "table" and colors.green and colors.orange)
assert(vim.api.nvim_get_hl(0, { name = "Normal" }).bg == tonumber(colors.bg:sub(2), 16))
local function verify()
    for name, spec in pairs({
        GitSignsAdd = { "fg", colors.green }, GitSignsChange = { "fg", colors.blue },
        GitSignsDelete = { "fg", colors.red1 }, DiffviewConflictOurs = { "bg", colors.teal },
        DiffviewConflictTheirs = { "bg", colors.blue0 }, DiffviewConflictAncestor = { "bg", colors.purple },
        CmpBorder = { "fg", colors.blue0 }, CmpDocBorder = { "fg", colors.blue0 },
    }) do
        assert(vim.api.nvim_get_hl(0, { name = name, link = false })[spec[1]] == tonumber(spec[2]:sub(2), 16), name .. " color mismatch")
    end
end
verify()
vim.cmd.colorscheme("tokyonight")
verify()
