local PATH_SECRETS = vim.fn.stdpath("data") .. "/langkeeper_secrets.json"
local PATH_CONFIG = vim.fn.stdpath("config") .. "/langkeeper.json"

local read_items = function(path)
  local file = io.open(path, "w")

  local contents = "[]"

  if file ~= nil then
    contents = file:read("*a")
    file:close()
  end

  return vim.fn.json_decode(contents)
end

local find_item = function(path, key)
  local configs = read_items(path)

  if configs == nil then
    return nil, nil
  end

  for i, c in pairs(configs) do
    if c.key == key then
      return i, c
    end
  end

  return nil, nil
end

local store_item = function(path, item)
  local file = io.open(path, "w")
  local configs = read_items(path)

  if file == nil then
    return false
  end

  if configs == nil then
    configs = {}
  end

  local found_index, _ = find_item(item.key)
  if found_index ~= nil then
    configs[found_index] = item
  else
    table.insert(configs, item)
  end

  file:write(vim.fn.json_encode(configs))
  file:close()

  return true
end

local M = {}

M.find_config = function(key)
  return find_item(PATH_CONFIG, key)
end

M.store_config = function(config)
  return store_item(PATH_CONFIG, config)
end

M.find_secret = function(key)
  return find_item(PATH_SECRETS, key)
end

M.store_secret = function(secret)
  return store_item(PATH_SECRETS, secret)
end

return M
