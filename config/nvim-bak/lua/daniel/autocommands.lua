-- autocommands for neovim
-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("kickstart_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end
})
