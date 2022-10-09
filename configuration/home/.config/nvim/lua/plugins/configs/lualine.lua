local present, lualine = pcall(require, "lualine")

if not present then
    return
end

local options = {
    options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = '',
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { {
            'filename',
            path = 1
        } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(options.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
    table.insert(options.sections.lualine_x, component)
end

ins_right {
    'lsp_progress',
    -- display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' }},
    -- With spinner
    -- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
    --[[ colors = {
	  percentage  = colors.cyan,
	  title  = colors.cyan,
	  message  = colors.cyan,
	  spinner = colors.cyan,
	  lsp_client_name = colors.magenta,
	  use = true,
	}, ]]
    separators = {
        component = ' ',
        progress = ' | ',
        percentage = { pre = '', post = '%% ' },
        -- title = { pre = '', post = ': ' },
        title = { pre = '', post = '' },
        lsp_client_name = { pre = '[', post = ']' },
        spinner = { pre = '', post = '' },
        -- message = { pre = '(', post = ')'},
        -- message = { pre = '', post = '', commenced = 'In Progress', completed = 'Completed' },
        message = { pre = '', post = '' },
    },
    display_components = { 'lsp_client_name', 'spinner', {'title'} },
    -- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
    timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
    -- spinner_symbols = { "┤", "┘", "┴", "└", "├", "┌", "┬", "┐"},
    -- spinner_symbols = {"⠋", "⠙", "⠚", "⠒", "⠂", "⠂", "⠒", "⠲", "⠴", "⠦", "⠖", "⠒", "⠐", "⠐", "⠒", "⠓", "⠋"},
    spinner_symbols = { "∙∙∙", "●∙∙", "∙●∙", "∙∙●" },
}

lualine.setup(options)
