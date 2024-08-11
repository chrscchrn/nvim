return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
        -- the shit i dont know
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-buffer',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
    },

    config = function()
        local cmp = require'cmp'

        -- Global setup.
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            -- window = {
            --     completion = cmp.config.window.bordered(),
            --     documentation = cmp.config.window.bordered(),
            -- },
            mapping = cmp.mapping.preset.insert({
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                    { name = 'buffer' },
                })
        })

        -- `/` cmdline setup.
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                    { name = 'cmdline' }
                }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })




        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "omnisharp",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", },
                                }
                            }
                        }
                    }
                end,
                ["omnisharp"] = function()
                    require("lspconfig").omnisharp.setup {
                        capabilities = capabilities,
                        cmd = { "dotnet", "/home/chrscchrn/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },

                        settings = {
                            FormattingOptions = {
                                EnableEditorConfigSupport = true,
                                OrganizeImports = true,
                            },
                            MsBuild = {
                                LoadProjectsOnDemand = nil,
                            },
                            RoslynExtensionsOptions = {
                                EnableAnalyzersSupport = true,
                                -- Enables support for showing unimported types and unimported extension
                                -- methods in completion lists. When committed, the appropriate using
                                -- directive will be added at the top of the current file. This option can
                                -- have a negative impact on initial completion responsiveness,
                                -- particularly for the first few completion sessions after opening a
                                -- solution.
                                EnableImportCompletion = true,
                                -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                                -- true
                                AnalyzeOpenDocumentsOnly = nil,
                            },
                            Sdk = {
                                -- Specifies whether to include preview versions of the .NET SDK when
                                -- determining which version to use for project loading.
                                IncludePrereleases = true,
                            },
                        },
                    }
                end,
            }
        })



        -- Setup lspconfig.
        -- require('lspconfig')[sevrer_name].setup {
        --     capabilities = capabilities
        -- }



        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
