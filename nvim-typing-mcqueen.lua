local M = {}

-- Define the content for the new window
local content = {
	"Hello, this is a floating window!",
	"You can add any content you want here.",
	"This is just a simple example.",
}

-- Creates and returns a new floating window
function M.openFloat(window_content)
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Set the lines for the buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, window_content)

	-- Get the dimensions of the current screen
	local ui = vim.api.nvim_list_uis()[1]
	local screen_width = ui.width
	local screen_height = ui.height

	-- Define the width and height of the floating window
	local win_width = 80
	local win_height = 30

	-- Calculate the center position
	local col = math.floor((screen_width - win_width) / 2)
	local row = math.floor((screen_height - win_height) / 2)

	-- Define the border options for the floating window
	local border_opts = {
		"╭",
		"─",
		"╮",
		"│",
		"╯",
		"─",
		"╰",
		"│",
	}

	-- Define the options for the floating window
	local opts = {
		relative = "editor",
		width = win_width,
		height = win_height,
		col = col,
		row = row,
		anchor = "NW",
		style = "minimal",
		border = border_opts,
	}

	-- Open the floating window
	local window = vim.api.nvim_open_win(buf, true, opts)

	-- Set the window highlight for Normal and FloatBorder
	vim.api.nvim_win_set_option(window, "winhl", "Normal:FloatingNormal,FloatBorder:FloatingBorder")

	-- Copy highlight groups for FloatingNormal and FloatingBorder from the current theme
	local function get_hl(name)
		local hl = vim.api.nvim_get_hl_by_name(name, true)
		local result = {}
		if hl.background then
			result.bg = string.format("#%06x", hl.background)
		end
		if hl.foreground then
			result.fg = string.format("#%06x", hl.foreground)
		end
		if hl.reverse then
			result.reverse = hl.reverse
		end
		return result
	end

	local normal_hl = get_hl("Normal")
	local border_hl = get_hl("FloatBorder")

	-- Set the highlight groups for the floating window
	vim.api.nvim_set_hl(0, "FloatingNormal", normal_hl)
	vim.api.nvim_set_hl(0, "FloatingBorder", border_hl)
end

M.openFloatingWindow(content)

return M
