local curl = require("plenary.curl")

function try_to_login()
  local url = "http://localhost:8000/users/login"

  local body = {
    email = "admin@langmer.es",
    password = "secret"
  }

  local res = curl.post(
    {
      url = url,
      body = vim.fn.json_encode(body),
      headers = {
        ["Content-Type"] = "application/json"
      }
    }
  )

  local set_cookie = res.headers[2]
  local session_token = string.match(set_cookie, "id=([^;]+)")

  require "langkeeper".set_session_token(session_token)
end

try_to_login()

vim.cmd [[
  augroup langkeeper
    command! LangkeeperGetToken :lua print(require("langkeeper").get_session_token())
  augroup END
]]

vim.cmd [[
  augroup langkeeper
    autocmd BufWrite * lua require("langkeeper").ping(vim.fn.expand("%:e"))
  augroup END
]]
