local M = {}

local config = {
	window = nil,
	window_id = nil,
}

-- Define the content for the new window
local content = {
	"Hello, welcome to Typing McQueen!",
}

-- Function to set up autocommands to start/stop logging in insert mode
local function setup_autocommands()
	vim.api.nvim_exec(
		[[
    augroup MyPluginKeyLogger
      autocmd!
      autocmd InsertEnter * lua require('nvim_typing_mcqueen').start_logging_keys()
      autocmd InsertLeave * lua require('nvim_typing_mcqueen').stop_logging_keys()
    augroup END
  ]],
		false
	)
end

-- Function to log key presses
local function start_logging_keys()
	local current_window_id = vim.api.nvim_get_current_win()
	if config.window_id == current_window_id then
		vim.on_key(function(key)
			print(string.format("Key pressed: %s in insert mode", key))
		end, M)
	end
end

-- Function to stop logging key presses
local function stop_logging_keys()
	vim.on_key(nil, M)
end

-- Creates and returns a new floating window
local function new_float_window(window_content)
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

	-- Return new floating window
	return vim.api.nvim_open_win(buf, true, opts)
end

function M.openNewSession(session_content)
	config.window = new_float_window(session_content)
	config.window_id = vim.api.nvim_get_current_win()

	-- Set the window highlight for Normal and FloatBorder
	vim.api.nvim_win_set_option(config.window, "winhl", "Normal:FloatingNormal,FloatBorder:FloatingBorder")

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

	vim.api.nvim_input("i")

	setup_autocommands()
end

M.openNewSession(content)

return M
