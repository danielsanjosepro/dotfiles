return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim" },

    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox",
        },
        config = function()
            local color_below = "#d3869b"
            local color_above = "#fabd2f"

            -- Sets colors to line numbers Above, Current and Below  in this order
            function LineNumberColors()
                vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = color_above, bold = false })
                vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white', bold = true })
                vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = color_below, bold = false })
            end

            LineNumberColors()
        end,
    }
}
