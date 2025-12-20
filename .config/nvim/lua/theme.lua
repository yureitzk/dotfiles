vim.o.termguicolors = true
vim.opt.background = "dark"

local oxocarbon = require('oxocarbon')
vim.cmd("colorscheme oxocarbon")
vim.api.nvim_set_hl(0, "FloatTitle", { fg = oxocarbon.base04, bg = oxocarbon.none })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = oxocarbon.base02, bg = oxocarbon.base02 })
