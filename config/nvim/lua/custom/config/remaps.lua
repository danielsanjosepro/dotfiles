vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {})
-- Allow to add to the global clipboard what you yanked
vim.keymap.set("n", "<leader>y", '"+y', {})
vim.keymap.set("v", "<leader>y", '"+y', {})
vim.keymap.set("n", "<leader>y", '"+y', {})
--  Allow jumping vertically  + centering
vim.keymap.set("n", "<C-u>", "<C-u>zz", {})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {})
-- Allow word replacement
vim.keymap.set("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>//g<left><left>", {})
-- Tab navigation
--vim.keymap.set("n", "<Tab>", "<C-W><C-W>", {})
-- Remove search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", {})
-- Escape insert mode with jj
vim.keymap.set("i", "jj", "<Esc>", {})
vim.keymap.set("i", "jk", "<Esc>", {})
-- Disable arrow keys
vim.keymap.set("n", "<Up>", "<cmd>echo 'Use k to move up'<CR>", {})
vim.keymap.set("n", "<Down>", "<cmd>echo 'Use j to move down'<CR>", {})
vim.keymap.set("n", "<Left>", "<cmd>echo 'Use h to move left'<CR>", {})
vim.keymap.set("n", "<Right>", "<cmd>echo 'Use l to move right'<CR>", {})
-- Also disable them in insert mode
vim.keymap.set("i", "<Up>", "<cmd>echo 'Use k to move up'<CR>", {})
vim.keymap.set("i", "<Down>", "<cmd>echo 'Use j to move down'<CR>", {})
vim.keymap.set("i", "<Left>", "<cmd>echo 'Use h to move left'<CR>", {})
vim.keymap.set("i", "<Right>", "<cmd>echo 'Use l to move right'<CR>", {})
-- Disable mouse
vim.opt.mouse = ""

-- Shortcut for python isort on the current buffer
vim.keymap.set("n", "<leader>pi", ":!isort %<CR><CR>", {})

-- Function to remap word to a different word in a passed directory
local function remap_word(opt)
	local word = opt.fargs[1]
	local replacement = opt.fargs[2]
	local path = opt.fargs[3]
	print("Replacing " .. word .. " by " .. replacement .. " in " .. path)
	vim.cmd("vimgrep /" .. word .. "/ `find " .. path .. " -type f`")
	vim.cmd("cdo s/" .. word .. "/" .. replacement .. "/gc")
end
vim.api.nvim_create_user_command("RemapWord", remap_word, { nargs = "+" })
