local parsers = {
    "bash", "cmake", "css", "go", "gomod", "gowork", "graphql", "vimdoc",
    "html", "javascript", "json", "json5", "lua", "make", "nix", "python",
    "solidity", "tsx", "typescript", "vim", "yaml",
}

local pending = {}

vim.keymap.set("n", "<A-v>", "van", { remap = true, desc = "Select Tree-sitter node" })
vim.keymap.set("x", "<A-v>", "an", { remap = true, desc = "Expand Tree-sitter selection" })
vim.keymap.set("x", "<A-BS>", "in", { remap = true, desc = "Shrink Tree-sitter selection" })

local function has_parser(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0
end

local function highlight(buf, lang)
    if vim.api.nvim_buf_is_valid(buf) and vim.treesitter.language.get_lang(vim.bo[buf].filetype) == lang and has_parser(lang) then
        vim.treesitter.start(buf, lang)
    end
end

local group = vim.api.nvim_create_augroup("ConfigTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(event)
        local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
        if not lang then
            return
        elseif has_parser(lang) then
            highlight(event.buf, lang)
        elseif not vim.tbl_contains(parsers, lang) then
            return
        elseif pending[lang] then
            table.insert(pending[lang], event.buf)
        elseif vim.fn.executable("tree-sitter") == 0 then
            vim.notify("Tree-sitter parser installation requires the tree-sitter CLI", vim.log.levels.WARN)
        else
            pending[lang] = { event.buf }
            require("nvim-treesitter").install({ lang }):await(function(err)
                local buffers = pending[lang]
                pending[lang] = nil
                if err then
                    vim.notify("Failed to install Tree-sitter parser " .. lang .. ": " .. tostring(err), vim.log.levels.ERROR)
                    return
                end
                for _, buf in ipairs(buffers) do
                    highlight(buf, lang)
                end
            end)
        end
    end,
})
