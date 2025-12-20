local conform = require("conform")


local function prettier_eslint_d_formatter(bufnr)
	if conform.get_formatter_info("eslint_d", bufnr).available then
		return { "prettierd", "eslint_d" }
	else
		return { "prettierd" }
	end
end

conform.setup({
	formatters = {
		html_beautify = {
			command = "html-beautify",
			require_cwd = false,
		},
		eslint_d = {
			require_cwd = true,
			cwd = require("conform.util").root_file({ ".eslint.js",
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"eslint.config.ts",
				"eslint.config.mts ",
				"eslint.config.cts",
				".eslint.cjs",
				".eslint.mjs",
				".eslint.yaml",
				".eslint.yml",
				".eslint.json", }),
		}
	},

	formatters_by_ft = {
		html = { "html_beautify", },
		css = { "prettierd", },
		python = { "black", stop_after_first = true },
		-- yaml = {  "yamllint", stop_after_first = true },
		markdown = { "prettierd", },
		json = { "prettierd", },
		scss = { "prettierd", },
		astro = { "prettierd", },
		typescript = prettier_eslint_d_formatter,
		javascript = prettier_eslint_d_formatter,
		tsx = prettier_eslint_d_formatter,
		typescriptreact = prettier_eslint_d_formatter,
		javascriptreact = prettier_eslint_d_formatter,
		php = { "prettierd", },
	},
})
