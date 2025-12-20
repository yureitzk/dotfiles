local cmp = require 'cmp'
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lsp-file-operations").setup()

local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.setup({
	completion = {
		completeopt = 'menu,menuone,noinsert'
	},
	snippet = {
		expand = function(args)
			require 'luasnip'.lsp_expand(args.body)
		end,
	},
	window = {
	},
	mapping = cmp.mapping.preset.insert({
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete({
			reason = cmp.ContextReason.Auto,
		}), { "i", "c" }),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({
			select = true,
			behavior = cmp.ConfirmBehavior.Replace,
		}),
	}),
	sources = cmp.config.sources({
		{ name = 'luasnip' },
		{ name = 'nvim_lsp' },
	}, {
		{ name = 'buffer' },
	})
})


local ts_utils = require("nvim-treesitter.ts_utils")

local function ls_name_from_event(event)
	return event.entry.source.source.client.config.name
end

cmp.event:on("confirm_done", function(event)
	local ok, ls_name = pcall(ls_name_from_event, event)
	if ok and vim.tbl_contains({ 'cssls', 'lua_ls' }, ls_name) then
		return
	end

	if ts_utils.get_node_at_cursor() == nil then
		return
	end

	local ts_name = ts_utils.get_node_at_cursor():type()
	if ts_name ~= "named_imports" then
		cmp_autopairs.on_confirm_done()(event)
	end
end)

local present, lsp_format = pcall(require, "lsp-format")
if not present then
	return
end

lsp_format.setup {}


-- Disable lsp syntax highlighting
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
});


-- lsp languages https://github.com/williamboman/mason-lspconfig.nvim
local mason_tool_installer = require("mason-tool-installer")
mason_tool_installer.setup({
	ensure_installed = {
		"astro-language-server",
		"svelte-language-server",
		"css-lsp",
		"vue-language-server",
		"black",
		"csharp-language-server",
		"emmet-language-server",
		"html-lsp",
		"htmlhint",
		"vtsls",
		"phpactor",
		"marksman",
		"js-debug-adapter",
		"ltex-ls",
		"texlab",
		"python-lsp-server",
		"prettierd",
		"clangd",
		"eslint_d",
		"typescript-language-server",
		"yaml-language-server",
		"lua-language-server"
	},
})


local present, lspconfig = pcall(require, "lspconfig")
if not present then
	return
end


lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
	'force',
	lspconfig.util.default_config.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)


local vue_language_server_path = os.getenv("HOME") ..
	'/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server'
local vue_plugin = {
	name = '@vue/typescript-plugin',
	location = vue_language_server_path,
	languages = { 'vue' },
	configNamespace = 'typescript',
	enableForWorkspaceTypeScriptVersions = true,
}
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

local lsps = {
	{ "csharp_ls", {},
		function()
			require("csharpls_extended").buf_read_cmd_bind()
		end
	},
	{ "cssls" },
	{ "phpactor" },
	{ "astro" },
	{ "svelte" },
	{ "pylsp" },
	{ "clangd" },
	{ "texlab" },
	{ "html", {
		capabilities = capabilities
	} },
	{ "marksman", {
		filetypes = { 'md', 'markdown', 'telekasten' }
	} },
	{ "vtsls", {
		settings = {
			vtsls = {
				-- autoUseWorkspaceTsdk = true,
				tsserver = {
					globalPlugins = { vue_plugin }
				},
			},
		},
		filetypes = tsserver_filetypes,
	}
	},
	{ "lua_ls", {
		on_init = function(client)
			local folders = client.workspace_folders

			if folders ~= nil then
				local path = folders[1].name
				if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
					return
				end
			end


			client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT'
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- Depending on the usage, you might want to add additional paths here.
						"${3rd}/luv/library"
						-- "${3rd}/busted/library",
					}
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
					-- library = vim.api.nvim_get_runtime_file("", true)
				}
			})
		end,
		settings = {
			Lua = {}
		}
	} },
	{ "yamlls", {
		settings = {
			yaml = {
				format = {
					enable = true,
				},
			}
		},
		on_attach = function(client, _)
			client.server_capabilities.document_formatting = true
		end
	} },
	{ "ltex", {
		autostart = false,
		filetypes = { "bibtex", "org", "tex", "restructuredtext", "rsweave", "latex", "quarto", "context" }
	} },
	{ "vue_ls", {}, function()
		vim.lsp.enable({ 'vtsls', 'vue_ls' })
	end },
	{ "emmet_language_server", {
		root_dir = function() return vim.uv.cwd() end,
		capabilities = capabilities,
		filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
		init_options = {
			html = {
				options = {
					-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
					["bem.enabled"] = false,
				},
			},
		}
	} },
}

for _, lsp in pairs(lsps) do
	local name, config, cb = lsp[1], lsp[2], lsp[3]
	vim.lsp.enable(name)
	if config then
		vim.lsp.config(name, config)
	end

	if type(cb) == "function" then
		cb()
	end
end
