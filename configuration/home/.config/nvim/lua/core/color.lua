vim.g.tokyonight_lualine_bold = true
local colors = require("tokyonight.colors").setup({}) -- pass in any of the config options as explained above
local util = require("tokyonight.util")

vim.cmd [[colorscheme tokyonight]]

--[[ local bg = "#000000"
local fg = "#ffffff"


local function hexToRgb(hex_str)
  local hex = "[abcdef0-9][abcdef0-9]"
  local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
  hex_str = string.lower(hex_str)

  assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

  local r, g, b = string.match(hex_str, pat)
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

local function blend(forground, background, alpha)
  background = hexToRgb(background)
  forground = hexToRgb(forground)

  local blendChannel = function(i)
    local ret = (alpha * forground[i] + ((1 - alpha) * background[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

local function darken(hex, amount, background)
  return blend(hex, background or bg, math.abs(amount))
end

local function lighten(hex, amount, forground)
  return blend(hex, forground or fg, math.abs(amount))
end ]]

vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = colors.green })
vim.api.nvim_set_hl(0, 'GitSignsAddNr', { fg = colors.green })
vim.api.nvim_set_hl(0, 'GitSignsAddLn', { fg = colors.green })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = colors.red1 })
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { fg = colors.red1 })
vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', { fg = colors.red1 })

-- TODO: git-conflict.nvim is bugged and doesn't read its config correctly. 
--[[ vim.api.nvim_set_hl(0, 'DiffText', { bg = colors.bg_highlight })
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = colors.bg_highlight })

vim.api.nvim_set_hl(0, 'DiffCurrent', { bg = colors.bg_highlight })
vim.api.nvim_set_hl(0, 'DiffIncoming', { bg = colors.bg_highlight })
vim.api.nvim_set_hl(0, 'DiffAncestor', { bg = colors.blue7 }) ]]

vim.api.nvim_set_hl(0, 'ConflictMarkerCommonAncestorsHunk', { bg = util.darken(colors.purple, 0.2) })
vim.api.nvim_set_hl(0, 'ConflictMarkerCommonAncestors', { bg = util.darken(colors.purple, 0.4) })
vim.api.nvim_set_hl(0, 'ConflictMarkerSeparator', { bg = util.darken(colors.purple, 0.4) })
vim.api.nvim_set_hl(0, 'ConflictMarkerOurs', { bg = util.darken(colors.teal, 0.2) })
vim.api.nvim_set_hl(0, 'ConflictMarkerBegin', { bg = util.darken(colors.teal, 0.4) })
vim.api.nvim_set_hl(0, 'ConflictMarkerTheirs', { bg = util.darken(colors.blue0, 0.2) })
vim.api.nvim_set_hl(0, 'ConflictMarkerEnd', { bg = util.darken(colors.blue0, 0.4) })

