local present, harpoon = pcall(require, "harpoon")

if not present then
    return
end

local options = {
    menu = {
        width = math.min(math.max(1, vim.o.columns - 4), math.max(40, vim.api.nvim_win_get_width(0) - 120))
    }
}

harpoon.setup(options)
