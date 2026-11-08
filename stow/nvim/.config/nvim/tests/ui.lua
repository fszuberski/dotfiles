assert(vim.o.laststatus == 3, "global status line is not enabled")
assert(type(require("lualine.themes.tokyonight")) == "table", "Tokyo Night lualine theme is unavailable")
assert(require("lualine").get_config().options.theme == "tokyonight", "lualine fell back from Tokyo Night")
assert(vim.o.statusline:find("lualine", 1, true), "lualine did not configure the status line")
vim.api.nvim_buf_set_name(0, vim.fn.stdpath("cache") .. "/status-fixture.txt")
require("lualine").refresh({ scope = "all", place = { "statusline" } })
assert(vim.wait(2000, function()
    return vim.api.nvim_eval_statusline(vim.o.statusline, {}).str ~= ""
end, 50), "lualine did not render")

local progress = require("fidget.progress").handle.create({
    title = "Smoke test",
    lsp_client = { name = "test" },
    percentage = 0,
})
progress:report({ percentage = 50 })
assert(progress.percentage == 50, "progress update failed")
progress:finish()
assert(progress.done, "progress did not finish")
