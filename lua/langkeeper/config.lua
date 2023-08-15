local module = {}

module.get = function(key)
  local config_file = vim.fn.stdpath("config") .. "/langkeeper.json"

  local config = {}

  local file = io.open(config_file, "r")
  if file then
    local contents = file:read("*a")
    config = vim.fn.json_decode(contents)
    file:close()
  end

  return config[key]
end

return module
