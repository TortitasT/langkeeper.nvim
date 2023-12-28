local module = {}

local secrets_path = vim.fn.stdpath("data") .. "/langkeeper_secrets.json"

module.read_secrets = function()
  local file = io.open(secrets_path, "r")
  local contents = "[]"

  if file ~= nil then
    contents = file:read("*a")
    file:close()
  end

  return vim.fn.json_decode(contents)
end

module.find_secret = function(key)
  local secrets = module.read_secrets()

  if secrets == nil then
    return nil, nil
  end

  for i, s in pairs(secrets) do
    if s.key == key then
      return i, s
    end
  end

  return nil, nil
end

module.store_secret = function(secret)
  local file = io.open(secrets_path, "w")
  local secrets = module.read_secrets()

  if file == nil then
    return false
  end

  if secrets == nil then
    secrets = {}
  end

  local found_index, _ = module.find_secret(secret.key)
  if found_index ~= nil then
    secrets[found_index] = secret
  else
    table.insert(secrets, secret)
  end

  file:write(vim.fn.json_encode(secrets))
  file:close()

  return true
end

return module
