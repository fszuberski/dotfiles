local parsers = {
    "bash", "cmake", "css", "go", "gomod", "gowork", "graphql", "vimdoc",
    "html", "javascript", "json", "json5", "lua", "make", "nix", "python",
    "solidity", "tsx", "typescript", "vim", "yaml",
}

if vim.fn.executable("tree-sitter") == 1 then
    require("nvim-treesitter").install(parsers)
else
    vim.notify("Tree-sitter parser installation requires the tree-sitter CLI", vim.log.levels.WARN)
end

local group = vim.api.nvim_create_augroup("ConfigTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(event)
        local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
        if lang and #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0 then
            vim.treesitter.start(event.buf, lang)
        end
    end,
})
