return function(file_extension)
  local config = require "langkeeper.config"
  local module = require "langkeeper"

  if not file_extension then
    return false
  end

  if not config.get("address") then
    return false
  end

  if not module.get_session_token() then
    if require "langkeeper.login" == false then
      return false
    end
  end

  local curl = require "plenary.curl"

  local url = config.get("address") .. "/languages/ping"
  local body = {
    extension = file_extension,
  }

  print(module.get_session_token())


  -- local res = curl.post(
  --   {
  --     url = url,
  --     body = vim.fn.json_encode(body),
  --     timeout = 1000,
  --     raw = {
  --       "-k"
  --     },
  --     headers = {
  --       ["Content-Type"] = "application/json",
  --       ["Cookie"] = "id=" .. module.get_session_token()
  --     },
  --     on_error = function(_)
  --     end
  --   }
  -- )
  --
  -- if res.status == 401 then
  --   print("Langkeeper: Invalid credentials")
  --   return false
  -- end
  --
  -- if res.status ~= 200 then
  --   print("Langkeeper: Failed to contact the server")
  --   return false
  -- end
end
