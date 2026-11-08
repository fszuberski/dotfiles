local M = {}

local function before(ar, ac, br, bc)
    return ar < br or (ar == br and ac < bc)
end

function M.expand()
    local buf = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(buf)
    if not parser then return end
    local query = vim.treesitter.query.get(parser:lang(), "locals")
    if not query then return end

    local anchor = vim.fn.getpos("v")
    local cursor = vim.fn.getpos(".")
    local sr, sc = anchor[2] - 1, anchor[3] - 1
    local er, ec = cursor[2] - 1, cursor[3] - 1
    if before(er, ec, sr, sc) then sr, sc, er, ec = er, ec, sr, sc end
    local line = vim.api.nvim_buf_get_lines(buf, er, er + 1, true)[1]
    if vim.o.selection ~= "exclusive" and ec < #line then
        ec = ec + 1 + vim.str_utf_end(line, ec + 1)
    end

    local tree = parser:parse()[1]
    if not tree then return end
    local best
    for id, node in query:iter_captures(tree:root(), buf, 0, -1) do
        if query.captures[id] == "local.scope" then
            local nsr, nsc, ner, nec = node:range()
            local contains = not before(sr, sc, nsr, nsc) and not before(ner, nec, er, ec)
            local larger = before(nsr, nsc, sr, sc) or before(er, ec, ner, nec)
            if contains and larger and (not best or before(best[1], best[2], nsr, nsc)
                or (best[1] == nsr and best[2] == nsc and before(ner, nec, best[3], best[4]))) then
                best = { nsr, nsc, ner, nec }
            end
        end
    end
    if not best then return end

    local start_row, start_col, end_row, end_col = unpack(best)
    if end_col == 0 and end_row > start_row then
        end_row = end_row - 1
        end_col = #vim.api.nvim_buf_get_lines(buf, end_row, end_row + 1, true)[1] + 1
    end
    if vim.o.selection ~= "exclusive" then end_col = math.max(0, end_col - 1) end
    local end_line = vim.api.nvim_buf_get_lines(buf, end_row, end_row + 1, true)[1]
    if end_col < #end_line then end_col = end_col + vim.str_utf_start(end_line, end_col + 1) end

    vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    vim.cmd.normal({ "o", bang = true })
    vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
end

return M
