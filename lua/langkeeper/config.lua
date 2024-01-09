local module = {}

module.get = function(key)
  local config_file = vim.fn.stdpath("config") .. "/langkeeper.json"

  local config = {}

  local file = io.open(config_file, "r")
  if file then
    local contents = file:read("*a")
    local succeeds, json = pcall(vim.fn.json_decode, contents)
    if succeeds then
      config = json
    end

    file:close()
  end

  return config[key] or nil
end

return module
