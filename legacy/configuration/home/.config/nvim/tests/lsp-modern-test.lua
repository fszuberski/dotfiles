local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local configs, enabled, mason = {}, nil, nil
vim.lsp.config = function(name, opts) configs[name] = opts end
vim.lsp.enable = function(names)
    enabled = enabled or {}
    vim.list_extend(enabled, type(names) == "table" and names or { names })
end
package.preload["cmp_nvim_lsp"] = function()
    return { default_capabilities = function() return { completion_test = true } end }
end
package.preload["mason-lspconfig"] = function()
    return { setup = function(opts) mason = opts end }
end

require("plugins.configs.lsp-modern")
assert(configs["*"].capabilities.completion_test, "completion capabilities missing")
assert(configs.gopls.settings.gopls.staticcheck, "Go staticcheck missing")
assert(configs.yamlls.settings.yaml.schemas, "YAML schema missing")
assert(vim.tbl_contains(enabled, "ts_ls") and not vim.tbl_contains(enabled, "tsserver"))
assert(vim.tbl_contains(enabled, "sqls"), "existing SQL server missing")
assert(mason.automatic_enable == false and vim.tbl_contains(mason.ensure_installed, "gopls"))
assert(not vim.tbl_contains(mason.ensure_installed, "sqls"), "SQL server was not previously managed by Mason")
print("modern LSP configuration test passed")
