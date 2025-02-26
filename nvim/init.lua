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
})
