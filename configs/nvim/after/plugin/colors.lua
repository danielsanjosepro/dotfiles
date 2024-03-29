require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {
  -- todo
    },
    integrations = {
  telescope = true,
  harpoon = true,
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

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

local pywal_core = require('pywal.core')
local colors = pywal_core.get_colors()

--vim.cmd.colorscheme "pywal"
-- Sets colors to line numbers Above, Current and Below  in this order
function LineNumberColors()
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg=colors["color11"], bold=false})
    vim.api.nvim_set_hl(0, 'LineNr', { fg='white', bold=true })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg=colors["color13"], bold=false })
end

LineNumberColors()
