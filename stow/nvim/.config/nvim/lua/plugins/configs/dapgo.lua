local present, dapgo = pcall(require, "dap-go")

if not present then
    return
end

local options = {

}

dapgo.setup(options)
