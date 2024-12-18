local Input = require("nui.input")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event
local u = require("pixovr.utils")

local M = {}

local popup_options = {
	relative = "cursor",
	position = {
		row = 1,
		col = 0,
	},
	border = {
		style = "rounded",
		text = {
			top = "[Choose Lifecycle]",
			top_align = "center",
		},
	},
	win_options = {
		winhighlight = "Normal:Normal",
	},
}

M.selectLifecycle = function(callback_fn)
	local menu = Menu(popup_options, {
		lines = {
			Menu.item("Local", { value = "local" }),
			Menu.item("Development", { value = "dev" }),
			Menu.item("Stage", { value = "stage" }),
			Menu.item("Production", { value = "prod" }),
		},
		min_width = 50,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_submit = function(item)
			if item.value == "prod" then
				u.warn("Not implemented")
				return
			end

			callback_fn(item.value)
		end,
	})

	menu:mount()

	menu:on(event.BufLeave, function()
		menu:unmount()
	end)
end

M.trigger_input = function(callback_fn)
	local input_component = Input({
		position = "50%",
		size = {
			width = 50,
		},
		border = {
			style = "single",
			text = {
				top = "Command to run:",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		prompt = "> ",
		default_value = "",
		on_submit = function(value)
			callback_fn(value)
		end,
	})

	input_component:mount()
	input_component:on(event.BufLeave, function()
		input_component:unmount()
	end)
end

return M
