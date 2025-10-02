-- Set UTF-8 encoding
vim.cmd [[set encoding=UTF-8]]

-- UI enhancements
vim.opt.ruler = true           -- Show line and column number in the status line
vim.opt.showmatch = true       -- Highlight matching brackets, braces, or parentheses

-- Text wrapping
vim.opt.linebreak = true       -- Break lines at words (avoid breaking in the middle of a word)
vim.opt.wrap = true            -- Enable text wrapping
vim.bo.textwidth = 90          -- Wrap text at 90 characters

-- Search settings
vim.opt.hlsearch = true        -- Highlight search results
vim.opt.incsearch = true       -- Incremental search (show results as you type)
vim.opt.smartcase = true       -- Case-sensitive search only if the search term contains uppercase letters
vim.opt.ignorecase = true      -- Case-insensitive search

-- Indentation
vim.opt.autoindent = true      -- Auto-indent new lines
vim.opt.smartindent = true     -- Smart indentation (e.g., after opening a block)
vim.opt.smarttab = true        -- Smart tab behavior (insert spaces for indentation)
vim.bo.shiftwidth = 2          -- Number of spaces for indentation
vim.bo.softtabstop = 2         -- Number of spaces inserted when pressing Tab
vim.bo.tabstop = 2             -- Number of spaces a tab character represents

-- Block cursor in all modes (including insert mode)
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Enable ligatures
vim.opt.conceallevel = 2

-- Clipboard integration (system clipboard for copy-paste)
vim.opt.clipboard = "unnamedplus" -- Use the system clipboard for yanking and pasting
vim.opt.termguicolors = true   -- Enable true color support (better colors in the terminal)
vim.opt.cursorline = true      -- Highlight the current line
vim.opt.background = "dark"

-- Line numbers
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers

vim.cmd("syntax on") -- enables syntax highlighting.
vim.cmd("filetype plugin on") -- enables filetype detection and plugin loading
vim.cmd("filetype indent on") -- enables filetype-specific indentation

-- Vertical movement
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })

-- Search movement
vim.keymap.set('n', 'n', 'nzzzv', { silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = true })

-- leader 
vim.g.mapleader = " "

-- LSP Diagnostics configuration and keybindings
vim.diagnostic.config({
	virtual_text = true,        -- Show diagnostics as virtual text
	signs = true,              -- Show diagnostic signs in the gutter
	underline = true,          -- Underline diagnostic issues
	update_in_insert = false,  -- Don't update diagnostics in insert mode
	severity_sort = true,      -- Sort diagnostics by severity
})

vim.keymap.set('n', '<S-h>', vim.diagnostic.open_float, { desc = 'Show diagnostic in floating window' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = true,
					comments = true,
					operators = false,
					folds = true,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true, -- invert background for search, diffs, statuslines, etc.
				contrast = "dark", -- can be "hard", "soft", or ""
				palette_overrides = {},
				overrides = {},
				dim_inactive = false,
				transparent_mode = false,
			})
			vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		config = function() 
			require("telescope").setup({
			})
			vim.api.nvim_set_keymap('n', '<C-S-p>', '<Cmd>Telescope find_files<CR>', {noremap = true, silent = true })
		end
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup()
		end,
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
	},
	{
		"folke/neodev.nvim",
		opts = {},       -- leave empty to use defaults
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { 
					"eslint",
					"lua_ls", 
					"pyright", 
					"ts_ls", 
					"bashls",
					"cssls",
					"dockerls",
					"gopls",
					"html",
					"sqls",
					"intelephense", -- PHP
					"jdtls", -- JAVA
					"solargraph", -- Ruby
					"ocamllsp", 
					"clangd",
					"rust_analyzer",
					"jsonls",
					"tailwindcss",
					"emmet_ls",
				}, 
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("neodev").setup({})
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Emmet LSP config
			lspconfig.emmet_ls.setup({
				filetypes = { 
					"html", 
					"css", 
					"javascript", 
					"javascriptreact",
					"typescriptreact",
					"php",
				},
				init_options = {
					html = {
						options = {
							["bem.enabled"] = true,
						},
					},
				},
			})

			-- HTML LSP configuration
			lspconfig.html.setup({
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html", "templ" },
				init_options = {
					configurationSection = { "html", "css", "javascript" },
					embeddedLanguages = {
						css = true,
						javascript = true,
					},
					provideFormatter = true,
				},
				capabilities = capabilities, -- Pass the capabilities here
				settings = {},
			})

			-- Go LSP
			lspconfig.gopls.setup({})

			-- Docker LSP
			lspconfig.dockerls.setup({})

			-- CSS LSP
			lspconfig.cssls.setup({
				settings = {
					css = {
						validate = true
					},
					less = {
						validate = true
					},
					scss = {
						validate = true
					}
				}
			})

			-- Bash LSP
			lspconfig.bashls.setup({})

			-- Lua LSP
			lspconfig.lua_ls.setup({
				root_dir = function(fname)
					local root = require("lspconfig").util.root_pattern(".git", ".luarc.json", "lua")(fname)
					if root then
						return root
					end
					return require("lspconfig").util.path.dirname(fname)
				end,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "state" },
						},
						workspace = { 
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					}
				}
			})

			-- Python LSP
			lspconfig.pyright.setup({})

			-- JavaScript/TypeScript LSP
			lspconfig.ts_ls.setup({ capabilities = capabilities })
			lspconfig.eslint.setup({})

			-- SQL LSP
			lspconfig.sqls.setup({})

			-- PHP LSP (Intelephense for PHP)
			lspconfig.intelephense.setup({
			})

			-- Java LSP (jdtls for Java)
			lspconfig.jdtls.setup({
				cmd = { "jdtls" },
				root_dir = require("lspconfig").util.root_pattern("pom.xml", "build.gradle", ".git")(vim.fn.getcwd()),
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- standard LSP keymaps
					vim.keymap.set("n", "<leader>oi", ":lua require'jdtls'.organize_imports()<CR>", { buffer = bufnr })
					vim.keymap.set("n", "<leader>ev", ":lua require'jdtls'.extract_variable()<CR>", { buffer = bufnr })
					vim.keymap.set("n", "<leader>ec", ":lua require'jdtls'.extract_constant()<CR>", { buffer = bufnr })
					vim.keymap.set("n", "<leader>em", ":lua require'jdtls'.extract_method()<CR>", { buffer = bufnr })
				end,
			})

			-- Ruby LSP (Solargraph for Ruby)
			lspconfig.solargraph.setup({
			})

			-- OCaml LSP (for OCaml)
			lspconfig.ocamllsp.setup({
			})

			-- C/C++ LSP (clangd for C and C++)
			lspconfig.clangd.setup({
			})

			-- Rust LSP (rust_analyzer for Rust)
			lspconfig.rust_analyzer.setup({
			})

			-- JSON LSP (for JSON)
			lspconfig.jsonls.setup({
			})

			-- TailwindCSS LSP (for Tailwind CSS)
			lspconfig.tailwindcss.setup({
			})

			-- Keybindings for LSP
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client then
						-- Keybindings
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
						vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = args.buf })
						vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf })
						vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = args.buf })
					end
				end,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP source
			"hrsh7th/cmp-buffer",   -- Buffer source
			"hrsh7th/cmp-path",     -- Path source
			"L3MON4D3/LuaSnip",     -- Snippet engine
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					['<Down>'] = cmp.mapping.select_next_item(),
					['<Up>'] = cmp.mapping.select_prev_item(),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},
	{
		"machakann/vim-highlightedyank",
		event = "VeryLazy",
		config = function()
			vim.g.highlightedyank_highlight_duration = 50  -- in milliseconds
		end
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.tabstop = 2      -- Width of a tab character
		vim.opt_local.shiftwidth = 2   -- Number of spaces for indentation
		vim.opt_local.expandtab = false -- Use tabs instead of spaces
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.opt_local.tabstop = 4      -- Width of a tab character
		vim.opt_local.shiftwidth = 4   -- Number of spaces for indentation
		vim.opt_local.expandtab = false -- Use tabs instead of spaces
		vim.keymap.set("i", "<C-e>", "if err != nil {\n\treturn err\n}", { buffer = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		vim.lsp.buf.format({ async = false }) -- Format on save
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "php",
	callback = function()
		vim.opt_local.tabstop = 4      -- Width of a tab character
		vim.opt_local.shiftwidth = 4   -- Number of spaces for indentation
		vim.opt_local.expandtab = true -- Use spaces instead of tabs
	end,

})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "html",
	callback = function()
		vim.opt_local.tabstop = 2      -- Width of a tab character
		vim.opt_local.shiftwidth = 2   -- Number of spaces for indentation
		vim.opt_local.expandtab = true -- Use spaces instead of tabs
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "css",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.java",
	callback = function()
		vim.lsp.buf.format({ async = false })
		vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.smarttab = true
    
    -- Enable auto-formatting on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
      group = vim.api.nvim_create_augroup("NextNestFormat", { clear = true })
    })
    
    vim.keymap.set("n", "<leader>el", "<cmd>lua vim.diagnostic.open_float({ source = 'eslint' })<cr>", { desc = "Open ESLint diagnostics" })
  end,
  group = vim.api.nvim_create_augroup("NextNestIndent", { clear = true })
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
  group = vim.api.nvim_create_augroup("NestConfigIndent", { clear = true })
})
