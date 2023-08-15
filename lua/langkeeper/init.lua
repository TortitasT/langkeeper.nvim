local module = {}

module.set_session_token = function(session_token)
  vim.g.langkeeper_session_token = session_token
end

module.get_session_token = function()
  return vim.g.langkeeper_session_token
end

module.ping = function(file_extension)
  local curl = require("plenary.curl")

  local url = "http://localhost:8000/languages/ping"
  local body = {
    extension = file_extension,
  }
  local res = curl.post(
    {
      url = url,
      body = vim.fn.json_encode(body),
      headers = {
        ["Content-Type"] = "application/json",
        ["Cookie"] = "id=" .. module.get_session_token()
      }
    }
  )
end

return module
