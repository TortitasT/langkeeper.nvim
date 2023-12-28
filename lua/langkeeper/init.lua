local augroup = vim.api.nvim_create_augroup("langkeeper", { clear = true })

local module = {}

module.set_session_token = function(session_token)
  require "langkeeper.storage".store_secret({
    key = "langkeeper_session_token",
    value = session_token
  })
end

module.get_session_token = function()
  local _, token = require "langkeeper.storage".find_secret("langkeeper_session_token")

  if token == nil then
    return nil
  end

  return token.value
end

module.login = require "langkeeper.login"
module.ping = require "langkeeper.ping"

module.setup = function()
  -- AUTOCOMMANDS

  -- When the cursor is idle, ping the server, depends on `updatetime`
  -- vim.api.nvim_create_autocmd("CursorHold",
  --   {
  --     callback = function()
  --       module.ping()
  --     end,
  --     group = augroup
  --   }
  -- )
  Recursive_ping = function()
    module.ping()

    vim.defer_fn(function()
      Recursive_ping()
    end, 60000)
  end

  vim.defer_fn(function()
    Recursive_ping()
  end, 60000)

  -- When the buffer is written, ping the server
  vim.api.nvim_create_autocmd("BufWritePost",
    {
      callback = function()
        module.ping()
      end,
      group = augroup
    }
  )

  -- When a new file is created, ping the server
  vim.api.nvim_create_autocmd("BufNewFile",
    {
      callback = function()
        module.ping()
      end,
      group = augroup
    }
  )

  -- When the buffer is entered, ping the server
  vim.api.nvim_create_autocmd("BufEnter",
    {
      callback = function()
        module.ping()
      end,
      group = augroup
    }
  )

  -- COMMANDS

  vim.api.nvim_create_user_command("LangkeeperConfig", function()
    vim.cmd("edit " .. vim.fn.stdpath("config") .. "/langkeeper.json")
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("LangkeeperShowToken", function()
    print(module.get_session_token())
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("LangkeeperLogin", function()
    module.login()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("LangkeeperPing", function()
    module.ping(vim.fn.expand("%:e"))
  end, { nargs = 0 })
end

return module
