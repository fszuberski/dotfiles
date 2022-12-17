local present, mason = pcall(require, "mason-lspconfig")

if not present then
    return
end

local options = {
    -- https://github.com/williamboman/mason-lspconfig.nvim#automatic-server-setup-advanced-feature
    ensure_installed = {
        'cssls',
        'dockerls',
        'gopls',
        'html',
        'jsonls',
        'marksman',
        'rust_analyzer',
        'solidity',
        'sumneko_lua',
        'taplo',
        'terraformls',
        'tsserver',
        'vimls',
        'yamlls',
    }
}

mason.setup(options)
