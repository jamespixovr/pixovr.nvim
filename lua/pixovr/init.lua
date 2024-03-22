local u = require("pixovr.utils")

local commands = {}
commands["lifecycle"] = require("pixovr.systemtest").systemTestLifecycle
commands["local"] = require("pixovr.systemtest").systemTestLocal

local M = {}

M.setup = function()
  vim.api.nvim_create_user_command("Pixovr", function(input)
    if commands[input.args] then
      commands[input.args]()
    else
      u.notify("Pixovr:", "Command " .. input.args .. " not found", "warn")
    end
  end, {
    nargs = 1,
    complete = function()
      return { "local", "lifecycle" }
    end
  })
end


return M
