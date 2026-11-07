local spec = dofile("lua/plugins/lazy-spec.lua")
local file = assert(io.open("README.md", "r"), "Neovim README is missing")
local readme = file:read("*a")
file:close()
for _, plugin in ipairs(spec) do
    assert(readme:find("https://github.com/" .. plugin[1], 1, true), "README missing plugin: " .. plugin[1])
end
assert(readme:find("https://github.com/folke/lazy.nvim", 1, true), "README missing lazy.nvim")
for _, mode in ipairs({ "unit", "smoke", "quick", "all" }) do
    assert(readme:find("tests/run.sh " .. mode, 1, true), "README missing test mode: " .. mode)
end
print("README plugin inventory test passed")
