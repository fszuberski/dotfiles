local present, mason = pcall(require, "mason-lspconfig")

if not present then
    return
end

local options = {
    -- https://github.com/williamboman/mason-lspconfig.nvim#automatic-server-setup-advanced-feature
    ensure_installed = LSPServers()
}

mason.setup(options)
