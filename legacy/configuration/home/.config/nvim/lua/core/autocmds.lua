local group = vim.api.nvim_create_augroup("ConfigGoFormat", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*.go",
    callback = function(event)
        vim.lsp.buf.format({ bufnr = event.buf, async = false })
    end,
})
