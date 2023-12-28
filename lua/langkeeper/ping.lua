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

  local url = config.get("address") .. "/languages/ping"
  local body = {
    extension = file_extension,
  }

  -- THANKS!! https://teukka.tech/vimloop.html

  local results = {}
  local function onread(err, data)
    if err then
      -- print('ERROR: ', err)
      -- TODO handle err
    end
    if data then
      local vals = vim.split(data, "\n")
      for _, d in pairs(vals) do
        if d == "" then goto continue end
        table.insert(results, d)
        ::continue::
      end
    end
  end

  local doLoginIfNeeded = function()
    if not results[1] then
      return false
    end

    local response = results[1]

    if string.find(response, '"401"') then
      require "langkeeper.login" ()
    end
  end

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local stdio = { nil, stdout, stderr }

  handle = vim.loop.spawn("curl", {
    args = {
      "-k",
      '-w "%{http_code}"',
      "-X",
      "POST",
      "-H",
      "Content-Type: application/json",
      "-H",
      "Cookie: id=" .. get_session_token(),
      "-d",
      vim.fn.json_encode(body),
      url,
    },
    stdio = stdio,
  }, function(_, _, _)
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()

    -- When curl is done, check if we need to login again based on the response stored in results
    doLoginIfNeeded()
  end)

  vim.loop.read_start(stdout, onread) -- TODO implement onread handler
  -- vim.loop.read_start(stderr, onread)
end
