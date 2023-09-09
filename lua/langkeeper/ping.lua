return function(override_file_extension)
  local config = require "langkeeper.config"

  local file_extension = override_file_extension or vim.fn.expand("%:e")
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

  local opts = {
    url = url,
    body = vim.fn.json_encode(body),
    timeout = 1000,
    raw = {
      "-k"
    },
    compressed = true,
    headers = {
      ["Content-Type"] = "application/json",
      ["Cookie"] = "id=" .. get_session_token()
    },
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

  if res.status ~= 200 and res.status ~= 204 then
    print("Langkeeper: Failed to contact the server")
    return false
  end
end
