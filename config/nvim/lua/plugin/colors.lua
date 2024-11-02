-- setup must be called before loading
--vim.cmd.colorscheme "catppuccin"
--vim.o.background = "dark" -- or "light" for light mode
--vim.cmd.colorscheme "gruvbox"

--function setDefaultBackground()
  ---- First we change the background color of colors-wal.vim to be always the same
  --local bg_color = "#1e1e2e"
  ---- We open the file ~/.cache/wal/colors-wal.vim
  --local file = io.open(os.getenv("HOME") .. "/.cache/wal/colors-wal.vim", "a")
  ---- Add let background = "#" to the file
  --file:write("let g:background = \"" .. bg_color .. "\"\n")
  --file:close()
--end

--setDefaultBackground()

--local pywal_core = require('pywal.core')
--local colors = pywal_core.get_colors()

-- use gruvbox colors instead of pywal
local color_below ="#d3869b"
local color_above = "#fabd2f"

-- Sets colors to line numbers Above, Current and Below  in this order
function LineNumberColors()
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg=color_above, bold=false})
    vim.api.nvim_set_hl(0, 'LineNr', { fg='white', bold=true })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg=color_below, bold=false })
end

LineNumberColors()
