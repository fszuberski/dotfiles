local repo = vim.fn.stdpath("cache") .. "/git-smoke"
vim.fn.mkdir(repo, "p")

local function git(args)
    local command = { "git", "-c", "user.name=Neovim Test", "-c", "user.email=nvim@example.invalid", "-c", "commit.gpgsign=false" }
    vim.list_extend(command, args)
    local result = vim.system(command, {
        cwd = repo,
        text = true,
        env = { GIT_CONFIG_NOSYSTEM = "1", GIT_CONFIG_GLOBAL = "/dev/null" },
    }):wait()
    assert(result.code == 0, result.stderr)
end

git({ "init", "--quiet", "--template=" })
vim.fn.writefile({ "original" }, repo .. "/sample.txt")
git({ "add", "sample.txt" })
git({ "commit", "--quiet", "-m", "fixture" })
vim.fn.writefile({ "changed" }, repo .. "/sample.txt")
vim.cmd.cd(vim.fn.fnameescape(repo))
vim.cmd.edit("sample.txt")

assert(vim.wait(5000, function()
    return vim.b.gitsigns_status_dict and (vim.b.gitsigns_status_dict.changed or 0) > 0
end, 50), "gitsigns did not report the changed line")
vim.cmd("Git")
assert(vim.bo.filetype == "fugitive", "Fugitive status did not open")
vim.cmd("DiffviewOpen")
assert(vim.wait(5000, function() return require("diffview.lib").get_current_view() ~= nil end, 50), "Diffview did not open")
