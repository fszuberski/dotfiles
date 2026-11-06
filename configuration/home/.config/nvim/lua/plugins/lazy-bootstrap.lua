local M = {}

function M.setup(specs)
    local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.uv.fs_stat(path) then
        local output = vim.fn.system({
            "git", "clone", "--filter=blob:none", "--branch=stable",
            "https://github.com/folke/lazy.nvim.git", path,
        })
        if vim.v.shell_error ~= 0 then
            error("Failed to install lazy.nvim: " .. output)
        end
    end

    vim.opt.runtimepath:prepend(path)
    require("lazy").setup(specs)
end

return M
