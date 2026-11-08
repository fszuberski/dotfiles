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

        local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
        if vim.fn.filereadable(lockfile) == 1 then
            local lock = vim.json.decode(table.concat(vim.fn.readfile(lockfile), "\n"))
            local revision = lock["lazy.nvim"] and lock["lazy.nvim"].commit
            if revision then
                assert(type(revision) == "string" and #revision == 40 and revision:match("^%x+$"), "Invalid lazy.nvim lockfile revision")
                output = vim.fn.system({ "git", "-C", path, "checkout", "--detach", revision })
                if vim.v.shell_error ~= 0 then
                    error("Failed to check out locked lazy.nvim revision: " .. output)
                end
            end
        end
    end

    vim.opt.runtimepath:prepend(path)
    require("lazy").setup(specs)
end

return M
