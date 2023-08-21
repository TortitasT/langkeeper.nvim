return function()
  local curl = require("plenary.curl")
  local config = require("langkeeper.config")

  if not config.get("address") then
    print("Langkeeper: Please set your server address")
    return false
  end

  if not config.get("email") or not config.get("password") then
    print("Langkeeper: Please set your email and password")
    return false
  end

  local url = config.get("address") .. "/users/login"
  local body = {
    email = config.get("email"),
    password = config.get("password")
  }

  local res = curl.post({
    url = url,
    body = vim.fn.json_encode(body),
    headers = {
      ["Content-Type"] = "application/json"
    },
    raw = {
      "-k"
    },
    timeout = 1000,
    on_error = function(_)
    end
  })

  if res.status == 401 then
    print("Langkeeper: Invalid credentials")
    return false
  end

  if res.status ~= 200 then
    print("Langkeeper: Failed to contact the server")
    return false
  end

  local set_cookie = res.headers[2]
  local session_token = string.match(set_cookie, "id=([^;]+)")

  require "langkeeper".set_session_token(session_token)
end
