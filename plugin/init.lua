vim.cmd [[
  augroup langkeeper
    command! LangkeeperGetToken :lua print(require("langkeeper").get_session_token())
    command! LangkeeperConfig :exe 'edit '.stdpath('config').'/langkeeper.json'
  augroup END
]]

vim.cmd [[
  augroup langkeeper
    autocmd BufWrite * lua require("langkeeper").ping(vim.fn.expand("%:e"))
  augroup END
]]
