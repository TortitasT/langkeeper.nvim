local module = {}

module.setup = function()
end

local function try_to_login()
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

module.set_session_token = function(session_token)
  vim.g.langkeeper_session_token = session_token
end

module.get_session_token = function()
  return vim.g.langkeeper_session_token
end


module.ping = function(file_extension)
  local config = require("langkeeper.config")

  if not config.get("address") then
    print("Langkeeper: Please set your server address")
    return false
  end

  if not module.get_session_token() then
    if try_to_login() == false then
      return false
    end
  end

  local curl = require "plenary.curl"

  local url = config.get("address") .. "/languages/ping"
  local body = {
    extension = file_extension,
  }

  local res = curl.post(
    {
      url = url,
      body = vim.fn.json_encode(body),
      timeout = 1000,
      raw = {
        "-k"
      },
      headers = {
        ["Content-Type"] = "application/json",
        ["Cookie"] = "id=" .. module.get_session_token()
      },
      on_error = function(_)
      end
    }
  )

  if res.status == 401 then
    print("Langkeeper: Invalid credentials")
    return false
  end

  if res.status ~= 200 then
    print("Langkeeper: Failed to contact the server")
    return false
  end
end

return module
