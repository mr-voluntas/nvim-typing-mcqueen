-- TODO
-- lool at splitting the new window function into buffer & window

-- 'M' is a convention used for plugins.
local M = {}

M.namespace = vim.api.nvim_create_namespace("nvim-typing-mcqueen")

local function compare_char(key_char)
	print("hello" .. key_char)
end

--@returns: a new window
local function newWindow()
	-- Some sample text to display inside the new window
	local sample_text = "The quick brown fox jumps over the lazy dog."
	local sample_text1 = "The quick brown fox jumps over the lazy dog."
	local sample_text2 = "The quick brown fox jumps over the lazy dog."

	-- create new empty buffer
	local buf = vim.api.nvim_create_buf(false, true)
	print(buf)
	vim.api.nvim_buf_set_keymap(
		buf,
		"i",
		"a",
		":lua require('.aadslkajsdfklj/init.lua').compare_char('a')<CR>",
		{ noremap = true, silent = false }
	)

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

-- TODOs
-- create local buffer keymaps.
-- create a function to take pressed keymap and compare to current char in buffer.

vim.api.nvim_create_user_command("TMC", newWindow, {})

return M
