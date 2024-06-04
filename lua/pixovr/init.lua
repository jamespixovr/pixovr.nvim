local u = require("pixovr.utils")

local commands = {}
commands["lifecycle"] = require("pixovr.systemtest").systemTestLifecycle
commands["local"] = require("pixovr.systemtest").systemTestLocal
commands["generate"] = require("pixovr.systemtest").ginkgoGenerate
commands["bootstrap"] = require("pixovr.systemtest").ginkgoBookstrap

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
      return { "local", "lifecycle", "generate", "bootstrap" }
    end
  })
end


return M
