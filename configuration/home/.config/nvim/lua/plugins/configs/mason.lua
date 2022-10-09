local present, mason = pcall(require, "mason")

if not present then
    return
end

local options = {
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
}

mason.setup(options)
