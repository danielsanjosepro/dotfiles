local toggle_term = require("toggleterm")


toggle_term.setup {
  -- size can be a number or function which is passed the current terminal
  size = 10,
  open_mapping = [[<leader>tm]],
  --close_mapping = [[<leader>tm]],
  insert_mappings = false,
  terminal_mappings = false,
  shade_terminals = true,
  close_on_exit = false,
  shading_factor = -15,
}
--vim.keymap.set('n', '<leader>tm', toggle_term.smart_toggle(size, dir, direction, name)  , {})

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
