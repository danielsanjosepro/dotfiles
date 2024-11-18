return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		local home_dir = os.getenv("HOME")
		require("codeium").setup({
			-- Optionally disable cmp source if using virtual text only
			config_path = home_dir .. "/codeium.json",

			enable_cmp_source = false,
			virtual_text = {
				enabled = true,

				-- These are the defaults

				-- Set to true if you never want completions to be shown automatically.
				manual = false,
				-- A mapping of filetype to true or false, to enable virtual text.
				filetypes = {},
				-- Whether to enable virtual text of not for filetypes not specifically listed above.
				default_filetype_enabled = true,
				-- How long to wait (in ms) before requesting completions after typing stops.
				idle_delay = 75,
				-- Priority of the virtual text. This usually ensures that the completions appear on top of
				-- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
				-- desired.
				virtual_text_priority = 65535,
				-- Set to false to disable all key bindings for managing completions.
				map_keys = true,
				-- The key to press when hitting the accept keybinding but no completion is showing.
				-- Defaults to \t normally or <c-n> when a popup is showing.
				accept_fallback = nil,
				-- Key bindings for managing completions in virtual text mode.
				key_bindings = {
					-- Accept the current completion.
					accept = "<Tab>",
					-- Accept the next word.
					accept_word = "<C-w>",
					-- Accept the next line.
					accept_line = false,
					-- Clear the virtual text.
					clear = false,
					-- Cycle to the next completion.
					next = "<M-]>",
					-- Cycle to the previous completion.
					prev = "<M-[>",
				},
			},
			workspace_root = {
				use_lsp = true,
				find_root = nil,
				paths = {
					".bzr",
					".git",
					".hg",
					".svn",
					"_FOSSIL_",
					"package.json",
				},
			},
		})
		local function custom_status()
			local status = require("codeium.virtual_text").status()

			if status.state == "idle" then
				-- Output was cleared, for example when leaving insert mode
				return "Idle."
			end

			if status.state == "waiting" then
				-- Waiting for response
				return "Waiting..."
			end

			if status.state == "completions" and status.total > 0 then
				return string.format("%d/%d", status.current, status.total)
			end

			return "Inactive."
		end

		-- Create a shortcut to display codeium status
		vim.api.nvim_create_user_command("CodeiumStatus", function()
			print(custom_status())
		end, {})
	end,
}
