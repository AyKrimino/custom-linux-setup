-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	})

	use('nvim-treesitter/nvim-treesitter', {run = ':TsUpdate'})
	use('mbbill/undotree')
	use('tpope/vim-fugitive')

	use 'neovim/nvim-lspconfig'

	use {
		'williamboman/mason.nvim',
		config = function()
			require('mason').setup()
		end
	}

	use {
		'williamboman/mason-lspconfig.nvim',
		after = 'mason.nvim',
		config = function()
			require('mason-lspconfig').setup({
				ensure_installed = {
					'gopls',
					'pyright',
					'lua_ls',
				},
				automatic_installation = true,
			})
		end
	}

	use {
		'hrsh7th/cmp-nvim-lsp',   -- LSP source for nvim-cmp
		'hrsh7th/nvim-cmp',       -- Autocompletion engine
		'L3MON4D3/LuaSnip',       -- Snippet engine
	}

end)

