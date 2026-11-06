require "core.options"
require("plugins.lazy-bootstrap").setup(require "plugins.lazy-spec")
require "core.mappings"

-- automatically format files before saving them
vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.format()]] -- default: async=false, timeout_ms=1000
