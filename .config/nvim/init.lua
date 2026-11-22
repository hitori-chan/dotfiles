vim.loader.enable()

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.asmsyntax = "nasm"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.splitbelow = true

vim.opt.mouse = ""
for _, key in ipairs({ "Up", "Down", "Left", "Right" }) do
	vim.keymap.set({ "n", "i", "x" }, string.format("<%s>", key), "<Nop>")
end

vim.cmd("packadd! nvim.undotree")

vim.filetype.add({
	filename = { Caddyfile = "caddy" },
	pattern = {
		["Caddyfile%..*"] = "caddy",
		[".*%.[Cc]addyfile"] = "caddy",
	},
})
