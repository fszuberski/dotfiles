local present, treesitterContext = pcall(require, "treesitter-context")

if not present then
    return
end

treesitterContext.setup {
    enable = true,
    max_lines = 0,
    trim_scope = "outer",
    zindex = 20,
    mode = "cursor",
}
