local present, nvim_comment = pcall(require, "Comment")

if not present then
    return
end

-- https://github.com/numToStr/Comment.nvim
local options = {}

nvim_comment.setup(options)
