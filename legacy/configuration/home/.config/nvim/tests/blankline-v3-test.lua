local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local options
package.preload.ibl = function()
    return { setup = function(opts) options = opts end }
end

require("plugins.configs.blankline-v3")
assert(options, "indent-blankline was not configured")
assert(options.scope.enabled and not options.scope.show_start, "current scope settings changed")
assert(vim.tbl_contains(options.exclude.filetypes, "TelescopePrompt"), "Telescope must be excluded")
assert(vim.tbl_contains(options.exclude.buftypes, "terminal"), "terminal buffers must be excluded")
print("indent-blankline v3 configuration test passed")
