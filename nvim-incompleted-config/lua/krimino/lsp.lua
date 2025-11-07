-- lua/krimino/lsp.lua
local ok_cmp, cmp = pcall(require, "cmp")
local ok_luasnip, luasnip = pcall(require, "luasnip")
local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local lspconfig = require("lspconfig")

-- ensure completion popup shows
vim.o.completeopt = "menu,menuone,noselect"

-- --- cmp setup (optional, safe)
if ok_cmp then
    local snippet_expand = nil
    if ok_luasnip then
        snippet_expand = function(args) luasnip.lsp_expand(args.body) end
    else
        snippet_expand = function() end
    end

    cmp.setup({
        snippet = { expand = snippet_expand },
        mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "buffer" } }),
    })
end

local on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    local opts = { buffer = bufnr, silent = true }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
        local params = vim.lsp.util.make_formatting_params()
        vim.lsp.buf.format(params)
    end, opts)
end

local capabilities = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
)

vim.lsp.config("ts_ls", {
  default_config = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_dir = function(fname)
      return require("lspconfig.util").root_pattern("package.json", ".git")(fname)
    end,
  },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "literal",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
})

vim.lsp.enable({ "ts_ls" })

vim.lsp.config("tailwindcss", {
    default_config = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "html", "svelte", "vue" },
        root_dir = function(fname)
            return require("lspconfig.util").root_pattern("tailwind.config.js", "tailwind.config.ts", "package.json",
            ".git")(fname)
        end,
    },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        tailwindCSS = {
            experimental = {
                classRegex = { "tw`([^`]*)`", "clsx\\(([^)]*)\\)" }, -- supports clsx/tw-template literals
            },
            lint = {
                cssConflict = "warning",
                invalidScreen = "error",
            },
        },
    },
})

vim.lsp.enable({ "tailwindcss" })

vim.lsp.config("gopls", {
    default_config = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = function(fname)
            return require("lspconfig.util").root_pattern("go.work", "go.mod", ".git")(fname)
        end,
    },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            gofumpt = true,
            analyses = { unusedparams = true },
            staticcheck = true,
        },
    },
})

vim.lsp.enable({ "gopls" })

vim.lsp.config("lua_ls", {
    default_config = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_dir = function(fname)
            return require("lspconfig.util").root_pattern(".luarc.json", ".luarc.jsonc", ".git")(fname)
        end,
    },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.enable({ "lua_ls" })
