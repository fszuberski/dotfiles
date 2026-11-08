local present, autosession = pcall(require, "auto-session")

if not present then
    return
end

local options = {
    -- log_level = 'info',
    log_level = 'error',
    auto_session_suppress_dirs = { '~/' },
}

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

autosession.setup(options)
