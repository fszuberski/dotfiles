local present, coverage = pcall(require, "coverage")

if not present then
    return
end

local options = {

}

coverage.setup(options)
