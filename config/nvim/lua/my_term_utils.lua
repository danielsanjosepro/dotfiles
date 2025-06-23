-- lua/my_term_utils.lua
local M = {}

M.send_to_background_term = function(cmd)
	-- Create a listed, scratch terminal buffer
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_option(buf, "buftype", "terminal")

	-- Create a unique buffer name using the command and timestamp
	local time = os.date("%Y%m%d_%H%M%S")
	local name = "term://" .. cmd .. " [" .. time .. "]"
	vim.api.nvim_buf_set_name(buf, name)

	-- Temporarily open a window to properly attach the terminal
	local cur_win = vim.api.nvim_get_current_win()
	local temp_win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = 0,
		col = 0,
		width = 1,
		height = 1,
		style = "minimal",
		focusable = false,
	})

	vim.fn.termopen(cmd, {
		on_exit = function(_, code, _)
			print("Command exited with code " .. code)
		end,
	})

	-- Return to previous window and close the tiny floating window
	vim.api.nvim_set_current_win(cur_win)
	vim.api.nvim_win_close(temp_win, true)
end

M.pick_terminal_buffers = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local results = {}
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local name = vim.api.nvim_buf_get_name(buf)
		if name:match("^term://") then
			table.insert(results, {
				bufnr = buf,
				name = name,
			})
		end
	end

	pickers
		.new({}, {
			prompt_title = "Terminal Buffers",
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					return {
						value = entry.bufnr,
						display = entry.name,
						ordinal = entry.name,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					vim.cmd("buffer " .. selection.value)
				end)
				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<leader>ft", M.pick_terminal_buffers, { desc = "Pick terminal buffers" })

return M
