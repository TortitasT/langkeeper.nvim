return function()
  local curl = require "plenary.curl"
  local config = require "langkeeper.config"

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

  local opts = {
    url = url,
    body = vim.fn.json_encode(body),
    headers = {
      ["Content-Type"] = "application/json"
    },
    raw = {
      "-k"
    },
    compressed = true,
    timeout = 1000,
    on_error = function(_)
    end
  }

  if vim.fn.has("win32") == 1 then
    opts.compressed = false
  end

  local res = curl.post(opts)

  if res.status == 401 then
    print("Langkeeper: Invalid credentials")
    return false
  end

  if res.status ~= 200 then
    print("Langkeeper: Failed to contact the server")
    print(res.body)
    return false
  end

  local set_cookie = nil
  for _, cookie in ipairs(res.headers) do
    if string.match(cookie, "id=") then
      set_cookie = cookie
      break
    end
  end

  if not set_cookie then
    print("Langkeeper: Failed to get authentication cookie")
    return false
  end

  local session_token = string.match(set_cookie, "id=([^;]+)")
  require "langkeeper".set_session_token(session_token)
end
