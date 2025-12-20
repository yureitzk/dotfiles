--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
local function get_pkg_path(pkg, path)
  pcall(require, 'mason')
  local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
  path = path or ''
  local ret = root .. '/packages/' .. pkg .. '/' .. path
  return ret
end

local dap = require("dap")

local js_based_languages = { "typescript", "javascript", "typescriptreact" }

if not dap.adapters["pwa-node"] then
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
				"${port}",
			},
		},
	}
end

if not dap.adapters["pwa-chrome"] then
	dap.adapters["pwa-chrome"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
				"${port}",
			},
		},
	}
end

for _, language in ipairs(js_based_languages) do
	require("dap").configurations[language] = {
		{
			name = "Launch file",
			type = "pwa-node",
			request = "launch",
			program = "${file}",
			cwd = "${workspaceFolder}",
			args = { "${file}" },
			skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
			sourceMaps = true,
			sourceMapPathOverrides = {
				["./*"] = "${workspaceFolder}/src/*",
			},
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Auto Attach",
			cwd = vim.fn.getcwd(),
			protocol = "inspector",
            skipFiles = {
              '${workspaceFolder}/node_modules/**/*.js',
              '${workspaceFolder}/packages/**/node_modules/**/*.js',
              '${workspaceFolder}/packages/**/**/node_modules/**/*.js',
              '<node_internals>/**',
              'node_modules/**',
              '**/node_modules/**',
            },
		},
		{
			name = "Attach",
			type = "pwa-node",
			request = "attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
			sourceMaps = true,
		},
		{
			name = "Launch & Debug Chrome",
			type = "pwa-chrome",
			request = "launch",
			url = function()
				local co = coroutine.running()
				return coroutine.create(function()
					vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:3000" }, function(url)
						if url == nil or url == "" then
							return
						else
							coroutine.resume(co, url)
						end
					end)
				end)
			end,
			webRoot = vim.fn.getcwd(),
			protocol = "inspector",
			sourceMaps = true,
			skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
			userDataDir = false,
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},

			-- From https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/dap.lua
			-- To test how it behaves
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
			sourceMapPathOverrides = {
				["./*"] = "${workspaceFolder}/src/*",
			},
		},
		language == "javascript" and {
			name = "----- ↑ launch.json configs (if available) ↑ -----",
			type = "",
			request = "launch",
		} or nil,
	}
end


local dapui = require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end
