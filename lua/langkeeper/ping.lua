return function(file_extension)
  local config = require "langkeeper.config"

  if not file_extension or file_extension == "" then
    return false
  end

  if not config.get("address") then
    return false
  end

  local get_session_token = require "langkeeper".get_session_token

  if not get_session_token() then
    if require "langkeeper.login" () == false then
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
        ["Cookie"] = "id=" .. get_session_token()
      },
      on_error = function(_)
      end
    }
  )

  if res.status == 401 then
    print("Langkeeper: Invalid credentials")
    return false
  end

  if res.status ~= 200 and res.status ~= 204 then
    print("Langkeeper: Failed to contact the server")
    return false
  end
end
