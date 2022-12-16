local present, coverage = pcall(require, "coverage")

if not present then
    return
end

local options = {
    commands = true, -- create commands
    auto_reload = true,
    auto_reload_timeout_ms = 100,
    signs = {
        -- use your own highlight groups or text markers
        covered = { hl = "GitSignsAdd", text = "▎" },
        uncovered = { hl = "GitSignsDelete", text = "▎" },
    },
    summary = {
        -- customize the summary pop-up
        min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
    },
    sign_group = "coverage"

}

coverage.setup(options)
