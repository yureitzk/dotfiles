local present, tk = pcall(require, "telekasten")
if not present then
    return
end

local documents_dir = vim.fn.system("xdg-user-dir DOCUMENTS"):gsub("\n", "")
local notes_dir = documents_dir .. '/notes'
local templates_dir = documents_dir .. '/notes/Templates'

tk.setup({
	home = notes_dir, -- Put the name of your notes directory here
	take_over_my_home = true,
	templates = templates_dir,
	image_subdir = "Files",
	tag_notation = "@tag",
})

