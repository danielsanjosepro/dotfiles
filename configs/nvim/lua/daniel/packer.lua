-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'ThePrimeagen/vim-be-good'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    requires = { {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      'nvim-telescope/telescope-media-files.nvim',
    } }
  }

  use { "catppuccin/nvim", as = "catppuccin" }

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

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
  -- For file explorer
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
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
  --- For Bazel support
  use 'google/vim-maktaba'
  use 'bazelbuild/vim-bazel'
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
  use { "zbirenbaum/copilot.lua"  }
  -- Zen mode
  use { "folke/zen-mode.nvim" }
  -- Indentation help
  use "lukas-reineke/indent-blankline.nvim"
  -- color scheme with pywal
  use { 'AlphaTechnolog/pywal.nvim', as = 'pywal' }
  -- Autosave
  use({
	"Pocco81/auto-save.nvim",
	config = function()
		 require("auto-save").setup {
		 }
	end,
  -- todo hyghtlight
  use 'folke/todo-comments.nvim'
})
end)
