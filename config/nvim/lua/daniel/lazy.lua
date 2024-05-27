local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "folke/which-key.nvim",
    "folke/neodev.nvim",
    { 'wbthomason/packer.nvim' },
    { "nvim-tree/nvim-web-devicons" },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim',
            'nvim-lua/popup.nvim',
            'nvim-telescope/telescope-media-files.nvim',
        }
    },

    { "catppuccin/nvim",                  as = "catppuccin" },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config =
            function()
                vim.cmd.colorscheme "gruvbox"
            end,
    },
    "nvim-lua/plenary.nvim", -- don't forget to add this one if you don't have it yet!
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { { "nvim-lua/plenary.nvim" } }
    },

    --- Uncomment the two plugins below if you want to manage the language servers from neovim
    -- {'williamboman/mason.nvim'},
    -- {'williamboman/mason-lspconfig.nvim'},

    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },

    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    -- oil nvim
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup()
        end,
    },
    --- For cheatsheet
    {
        'sudormrfbin/cheatsheet.nvim',

        requires = {
            { 'nvim-telescope/telescope.nvim' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
        }
    },
    -- For colorizer
    'NvChad/nvim-colorizer.lua',
    -- NerdCommenter
    'preservim/nerdcommenter',
    -- lualine for neovim
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    -- To undotree
    'mbbill/undotree',
    -- Lua copilot
    { "zbirenbaum/copilot.lua" },
    -- Zen mode
    { "folke/zen-mode.nvim" },
    -- Indentation help
    "lukas-reineke/indent-blankline.nvim",
    -- Autosave
    {
        "Pocco81/auto-save.nvim",
    },
    -- todo hyghtlight
    'folke/todo-comments.nvim',
    -- context highlight
    { "nvim-treesitter/nvim-treesitter" },
    {
        'nvim-treesitter/nvim-treesitter-context',
        after = 'nvim-treesitter',
        requires = 'nvim-treesitter/nvim-treesitter'
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    },

    -- gitsigns
    { 'lewis6991/gitsigns.nvim' },
    -- hardtime for good habits
    -- lazy.nvim
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {}
    },
    {
        "folke/which-key.nvim",
    },
})
