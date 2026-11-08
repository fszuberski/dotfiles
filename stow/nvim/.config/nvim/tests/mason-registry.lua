local servers = require("mason-lspconfig.settings").current.ensure_installed
local packages = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
assert(#servers > 0, "Mason server list is empty")
for _, server in ipairs(servers) do
    assert(packages[server], "Mason has no package for server: " .. server)
end
