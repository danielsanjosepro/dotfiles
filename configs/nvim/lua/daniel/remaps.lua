vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {})
-- Allow to add to the global clipboard what you yanked
vim.keymap.set("n", "<leader>y", "\"+y", {})
vim.keymap.set("v", "<leader>y", "\"+y", {})
vim.keymap.set("n", "<leader>y", "\"+y", {})
--  Allow jumping vertically  + centering
vim.keymap.set("n", "<C-u>", "<C-u>zz", {})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {})
-- Allow word replacement
vim.keymap.set("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>//g<left><left>", {})
-- Tab navigation
vim.keymap.set("n", "<Tab>", "<C-W><C-W>", {})
