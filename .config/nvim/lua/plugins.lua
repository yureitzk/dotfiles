require('lazy').setup({
	{
		'pteroctopus/faster.nvim',
		lazy = false,
		priority = 999,
		opts = {
			-- Behaviour table contains configuration for behaviours faster.nvim uses
			behaviours = {
				-- Bigfile configuration controls disabling and enabling of features when
				-- big file is opened
				bigfile = {
					-- Behaviour can be turned on or off. To turn on set to true, otherwise
					-- set to false
					on = true,
					-- Table which contains names of features that will be disabled when
					-- bigfile is opened. Feature names can be seen in features table below.
					-- features_disabled can also be set to "all" and then all features that
					-- are on (on=true) are going to be disabled for this behaviour
					features_disabled = {
						"illuminate", "matchparen", "lsp", "treesitter",
						"indent_blankline", "vimopts", "syntax", "filetype"
					},
					-- Files larger than `filesize` are considered big files. Value is in MB.
					filesize = 1,
					-- Autocmd pattern that controls on which files behaviour will be applied.
					-- `*` means any file.
					pattern = "*",
					-- Optional extra patterns and sizes for which bigfile behaviour will apply.
					-- Note! that when multiple patterns (including the main one) and filesizes
					-- are defined: bigfile behaviour will be applied for minimum filesize of
					-- those defined in all applicable patterns for that file.
					-- extra_pattern example in multi line comment is bellow:
					--[[
      extra_patterns = {
        -- If this is used than bigfile behaviour for *.md files will be
        -- triggered for filesize of 1.1MiB
        { filesize = 1.1, pattern = "*.md" },
        -- If this is used than bigfile behaviour for *.log file will be
        -- triggered for the value in `behaviours.bigfile.filesize`
        { pattern  = "*.log" },
        -- Next line is invalid without the pattern and will be ignored
        { filesize = 3 },
      },
      ]]
					-- By default `extra_patterns` is an empty table: {}.
					extra_patterns = {},
				},
				-- Fast macro configuration controls disabling and enabling features when
				-- macro is executed
				fastmacro = {
					-- Behaviour can be turned on or off. To turn on set to true, otherwise
					-- set to false
					on = true,
					-- Table which contains names of features that will be disabled when
					-- macro is executed. Feature names can be seen in features table below.
					-- features_disabled can also be set to "all" and then all features that
					-- are on (on=true) are going to be disabled for this behaviour.
					-- Specificaly: lualine plugin is disabled when macros are executed because
					-- if a recursive macro opens a buffer on every iteration this error will
					-- happen after 300-400 hundred iterations:
					-- `E5108: Error executing lua Vim:E903: Process failed to start: too many open files: "/usr/bin/git"`
					features_disabled = { "lualine" },
				}
			},
			-- Feature table contains configuration for features faster.nvim will disable
			-- and enable according to rules defined in behaviours.
			-- Defined feature will be used by faster.nvim only if it is on (`on=true`).
			-- Defer will be used if some features need to be disabled after others.
			-- defer=false features will be disabled first and defer=true features last.
			features = {
				-- Neovim filetype plugin
				-- https://neovim.io/doc/user/filetype.html
				filetype = {
					on = true,
					defer = true,
				},
				-- Illuminate plugin
				-- https://github.com/RRethy/vim-illuminate
				illuminate = {
					on = true,
					defer = false,
				},
				-- Indent Blankline
				-- https://github.com/lukas-reineke/indent-blankline.nvim
				indent_blankline = {
					on = true,
					defer = false,
				},
				-- Neovim LSP
				-- https://neovim.io/doc/user/lsp.html
				lsp = {
					on = true,
					defer = false,
				},
				-- Lualine
				-- https://github.com/nvim-lualine/lualine.nvim
				lualine = {
					on = true,
					defer = false,
				},
				-- Neovim Pi_paren plugin
				-- https://neovim.io/doc/user/pi_paren.html
				matchparen = {
					on = true,
					defer = false,
				},
				-- Neovim syntax
				-- https://neovim.io/doc/user/syntax.html
				syntax = {
					on = true,
					defer = true,
				},
				-- Neovim treesitter
				-- https://neovim.io/doc/user/treesitter.html
				treesitter = {
					on = true,
					defer = false,
				},
				-- Neovim options that affect speed when big file is opened:
				-- swapfile, foldmethod, undolevels, undoreload, list
				vimopts = {
					on = true,
					defer = false,
				}
			}
		}
	},
	'chentoast/marks.nvim',
	{
		'nyoom-engineering/oxocarbon.nvim',
		dependencies = 'pteroctopus/faster.nvim',
		lazy = false,
		priority = 1000,
	},
	{
		"zeioth/garbage-day.nvim",
		dependencies = "neovim/nvim-lspconfig",
		event = "VeryLazy",
		opts = {
			aggressive_mode = false
		}
	},
	'lambdalisue/suda.vim',
	{
		'ptzz/lf.vim',
		config = function()
			vim.g.NERDTreeHijackNetrw = 0
			vim.g.floaterm_opener = 'vsplit'
		end,
		dependencies = {
			'voldikss/vim-floaterm',
		}
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function() require('gitsigns').setup {} end
	},
	'mattn/emmet-vim',
	'lukas-reineke/lsp-format.nvim',
	{
		'lukas-reineke/indent-blankline.nvim',
		dependencies = {
			'pteroctopus/faster.nvim',
			'HiPhish/rainbow-delimiters.nvim',
		},
	},
	'nvim-tree/nvim-web-devicons',
	'romgrk/barbar.nvim',
	{
		'nmac427/guess-indent.nvim',
		config = function() require('guess-indent').setup {} end,
	},
	'frabjous/knap',
	{
		'toppair/peek.nvim',
		event = { 'VeryLazy' },
		build = 'deno task --quiet build:fast'
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'pteroctopus/faster.nvim',
		},
	},
	'Vonr/align.nvim',
	'img-paste-devs/img-paste.vim',
	{
		'NvChad/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup()
		end,
	},
	{
		'folke/which-key.nvim',
		opts = {}
	},
	{
		'jakewvincent/mkdnflow.nvim',
		rocks = 'luautf8',
		config = function()
			require('mkdnflow').setup({
				mappings = {
					MkdnEnter = { { 'i', 'n', 'v' }, '<CR>' }
				}
			})
		end
	},
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},
	{
		'nvim-pack/nvim-spectre',
		dependencies = {
			'nvim-lua/plenary.nvim',
		}
	},
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
			'MunifTanjim/nui.nvim',
		},
		event = 'BufWinEnter'
	},
	{
		{
			"antosha417/nvim-lsp-file-operations",
			dependencies = {
				"nvim-lua/plenary.nvim",
				-- Uncomment whichever supported plugin(s) you use
				-- "nvim-tree/nvim-tree.lua",
				"nvim-neo-tree/neo-tree.nvim",
				-- "simonmclean/triptych.nvim"
			},
			config = function()
				require("lsp-file-operations").setup()
			end,
		},
	},
	'Decodetalkers/csharpls-extended-lsp.nvim',
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'pteroctopus/faster.nvim'
		},
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end
	},
	{
		'windwp/nvim-ts-autotag',
		config = function() require('nvim-ts-autotag').setup({}) end
	},
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
		},
	},
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
			},
			'rcarriga/nvim-dap-ui',
			'nvim-neotest/nvim-nio'
		},
	},
	{
		'folke/trouble.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			warn_no_results = false,
			open_no_results = true,
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},
	{
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip'
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		'neovim/nvim-lspconfig',
		event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
	},
	{ 'artemave/workspace-diagnostics.nvim' },
	-- {
	-- 	'pmizio/typescript-tools.nvim',
	-- 	dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
	-- 	opts = {},
	-- },
	{
		'kevinhwang91/nvim-ufo',
		dependencies = { 'kevinhwang91/promise-async' },
	},
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	},
	{
		'stevearc/conform.nvim',
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		'mfussenegger/nvim-lint',
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		'williamboman/mason.nvim',
		config = function() require('mason').setup {} end,
		run = ':MasonUpdate',
		dependencies = {
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim'
		}
	},
	{
		'renerocksai/telekasten.nvim',
		dependencies = {
			'nvim-telescope/telescope.nvim',
			'nvim-lua/plenary.nvim'
		},
	},
})
