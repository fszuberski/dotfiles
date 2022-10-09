local present, harpoon = pcall(require, "harpoon")

if not present then
    return
end

local options = {
    menu = {
        width = vim.api.nvim_win_get_width(0) - 120
    }
}

harpoon.setup(options)
