return {
  'ggandor/leap.nvim',
  init = function()
    require 'leap'
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
    vim.api.nvim_create_autocmd('User', {
      callback = function()
        -- Apply zz to center the screen after a leap
        vim.fn.feedkeys 'zz'
      end,
      pattern = 'LeapLeave',
    })
  end,
}
