-- 'M' is a convention used for plugins.
local M = {}

M.namespace = vim.api.nvim_create_namespace("nvim-typing-mcqueen")

local function get_char_at_cursor()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	return line:sub(col + 1, col + 1)
end

--@returns: a new window
local function newWindow()
	-- Some sample text to display inside the new window
	local sample_text = "The quick brown fox jumps over the lazy dog."
	local sample_text1 = "The quick brown fox jumps over the lazy dog."
	local sample_text2 = "The quick brown fox jumps over the lazy dog."

	-- create new empty buffer
	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_command("set cmdheight=3")

	-- capture key presses
	vim.api.nvim_buf_attach(buf, false, {
		on_lines = function(_, _, _, _, _, _)
			vim.on_key(function(key)
				local char_at_cursor = get_char_at_cursor()
				print(string.format("Key pressed: %s before char: %s", key, char_at_cursor))
				if key == char_at_cursor then
					print("the same, this is where we would want to highlight the char and move on.")
				end
			end)
		end,
	})

	-- add content to buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { sample_text, sample_text1, sample_text2 })
	--
	-- screen diamentions
	local screen_height = vim.opt.lines:get()
	local screen_width = vim.opt.columns:get()
	-- floating window diamentions (height * 0.8 == 80% of the window)
	local window_height = math.ceil(screen_height * 0.8)
	local window_width = math.ceil(screen_width * 0.8)
	-- calculates the center of the screen
	local row = math.floor((screen_height - window_height) / 2)
	local cols = math.floor((screen_width - window_width) / 2)

	local window_opts = {
		style = "minimal",
		relative = "editor",
		width = window_width,
		height = window_height,
		row = row,
		col = cols,
		anchor = "NW",
		border = {
			"╭",
			"─",
			"╮",
			"│",
			"╯",
			"─",
			"╰",
			"│",
		},
	}

	-- opens a floaty window
	local window = vim.api.nvim_open_win(buf, true, window_opts)

	-- loop through paragraphs within buffer
	local buffer_content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	for _, paragraph in pairs(buffer_content) do
		-- print(text)
		for chars in paragraph:gmatch(".") do
			-- print(chars)
		end
	end
end

vim.api.nvim_create_user_command("TMC", newWindow, {})

return M
