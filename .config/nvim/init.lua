-- Disable pynvim
vim.g.loaded_python3_provider = 0

-- Show line number
vim.opt.number = true
vim.opt.relativenumber = true

-- Disable prompt mode below status line
vim.opt.showmode = false

-- Tab size
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Colorshcheme
vim.opt.background = "dark"
vim.opt.termguicolors = true

-- Cause all splits to happen below
vim.opt.splitbelow = true

-- Disable mouse
vim.opt.mouse = ""

-- Disable arrow keys
for _, key in ipairs({ "Up", "Down", "Left", "Right" }) do
	vim.keymap.set({ "n", "i", "x" }, string.format("<%s>", key), "<Nop>")
end
