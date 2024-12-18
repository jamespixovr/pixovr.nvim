local u = require("pixovr.utils")

local commands = {}
commands["lifecycle"] = require("pixovr.systemtest").system_test_lifecycle
commands["local"] = require("pixovr.systemtest").system_test_local
commands["debug"] = require("pixovr.systemtest").system_test_local_with_debug
commands["generate"] = require("pixovr.systemtest").ginkgo_generate
commands["bootstrap"] = require("pixovr.systemtest").ginkgo_bootstrap

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
			return { "local", "lifecycle", "generate", "bootstrap", "debug" }
		end,
	})
end

return M
