-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'ThePrimeagen/vim-be-good'

    -- web devicons
    use "nvim-tree/nvim-web-devicons"

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        requires = { {
            'nvim-lua/plenary.nvim',
            'nvim-lua/popup.nvim',
            'nvim-telescope/telescope-media-files.nvim',
        } }
    }

    use { "catppuccin/nvim", as = "catppuccin" }
    use { "ellisonleao/gruvbox.nvim" }

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    })

    use "nvim-lua/plenary.nvim" -- don't forget to add this one if you don't have it yet!
    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { { "nvim-lua/plenary.nvim" } }
    }

    -- https://github.com/VonHeikemen/lsp-zero.nvim?tab=readme-ov-file
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            -- Uncomment the two plugins below if you want to manage the language servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }
    -- oil nvim
    use {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup()
        end,
    }
    --- For cheatsheet
    use {
        'sudormrfbin/cheatsheet.nvim',

        requires = {
            { 'nvim-telescope/telescope.nvim' },
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' },
        }
    }
    -- For colorizer
    use 'NvChad/nvim-colorizer.lua'
    -- For terminal support
    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end }
    -- NerdCommenter
    use 'preservim/nerdcommenter'
    -- lualine for neovim
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    -- To display pictures in .md files
    use { 'edluffy/hologram.nvim' }
    -- To open image preview in editor
    use { 'https://github.com/adelarsq/image_preview.nvim' }
    -- To undotree
    use 'mbbill/undotree'
    -- Lua copilot
    use { "zbirenbaum/copilot.lua" }
    -- Zen mode
    use { "folke/zen-mode.nvim" }
    -- Indentation help
    use "lukas-reineke/indent-blankline.nvim"
    -- color scheme with pywal
    use { 'AlphaTechnolog/pywal.nvim', as = 'pywal' }
    -- Autosave
    use({
        "Pocco81/auto-save.nvim",
    })
    -- todo hyghtlight
    use 'folke/todo-comments.nvim'
    -- context highlight
    use 'nvim-treesitter/nvim-treesitter-context'
    -- gitsigns
    use {
        'lewis6991/gitsigns.nvim',
    }
    -- hardtime for good habits
    -- lazy.nvim
    use {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        opts = {}
    }
    use {
        "folke/which-key.nvim",
    }
end)
