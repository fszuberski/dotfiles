local config = vim.fn.stdpath("config")
local dir = config .. "/tests/fixtures/go"
local file = dir .. "/format-smoke.go"
vim.fn.writefile({ "package original" }, file)

-- This test exercises LSP independently of parser installation.
vim.api.nvim_del_augroup_by_name("ConfigTreesitter")
vim.lsp.enable("gopls", false)
vim.lsp.config("gopls", {
    cmd = { "python3", config .. "/tests/fake-lsp.py" },
    root_dir = dir,
})
vim.lsp.enable("gopls")
vim.cmd.edit(vim.fn.fnameescape(file))
local buf = vim.api.nvim_get_current_buf()
assert(vim.wait(10000, function()
    return #vim.lsp.get_clients({ bufnr = buf, name = "gopls" }) > 0
end, 50), "test LSP server did not attach")
local client = vim.lsp.get_clients({ bufnr = buf, name = "gopls" })[1]
assert(client.config.capabilities.textDocument.completion.completionItem.snippetSupport, "LSP snippet capability missing")

vim.api.nvim_exec_autocmds("InsertEnter", { buffer = buf })
assert(vim.wait(5000, function()
    for _, source in ipairs(require("cmp").get_registered_sources()) do
        if source.name == "nvim_lsp" then return true end
    end
    return false
end, 50), "LSP completion source did not register")

vim.cmd("silent write")
assert(vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == "package formatted", "Go format-on-save did not apply the server edit")
