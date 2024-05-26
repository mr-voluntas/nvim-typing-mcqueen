-- 'M' is a convention used for plugins.
local M = {}

-- session = window, content
-- window: floaty, bottom, top.
-- content: set of content to practice typing with (100 words, 500 words, GO kws, lua kws, short, med, long)

--@returns: a new window
local function newWindow()
	-- Some sample text to display inside the new window
	local sample_text = "The quick brown fox jumps over the lazy dog."

	-- create new empty buffer.
	local buf = vim.api.nvim_create_buf(false, true)

	-- set the lines for the buffer
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { sample_text })
	--
	-- window diamentions
	local screen_height = vim.opt.lines:get()
	local screen_width = vim.opt.columns:get()
	-- floating window diamentions (height * 0.8 == 80% of the window)
	local window_height = math.ceil(screen_height * 0.8)
	local window_width = math.ceil(screen_width * 0.8)
	-- calculates the center of the window
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

	local window = vim.api.nvim_open_win(buf, true, window_opts)
end

vim.api.nvim_create_user_command("TMC", newWindow, {})
return M
