local present, hierarchy = pcall(require, "hierarchy-tree-go")

if not present then
    return
end

local options = {
    icon = {
        fold = "", -- fold icon
        unfold = "", -- unfold icon
        func = "₣", -- symbol
        last = '☉', -- last level icon
    },
    hl = {
        current_module = "guifg=#1abc9c", -- highlight cwd module line
        others_module = "guifg=#c0caf5", -- highlight others module line
        cursorline = "guibg=#3d59a1 guifg=#c0caf5" -- hl  window cursorline
    },
    keymap = {
        --global keymap
        incoming = "<space>fi", -- call incoming under cursorword
        outgoing = "<space>fo", -- call outgoing under cursorword
        open = "<space>ho", -- open hierarchy win
        close = "<space>hc", -- close hierarchy win
        -- focus: if hierarchy win is valid but is not current win, set to current win
        -- focus: if hierarchy win is valid and is current win, close
        -- focus  if hierarchy win not existing,open and focus
        focus = "<space>fu",

        -- bufkeymap
        expand = "o", -- expand or collapse hierarchy
        jump = "<CR>", -- jump
        move = "<space><space>" -- switch the hierarchy window position, must be current win
    }
}

hierarchy.setup(options)
