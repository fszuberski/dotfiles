local present, fidget = pcall(require, "fidget")

if not present then
    return
end

local options = {}

fidget.setup(options)
