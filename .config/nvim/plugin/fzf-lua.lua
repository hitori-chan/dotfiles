vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/ibhagwan/fzf-lua",
})

require("nvim-web-devicons").setup()

vim.ui.select = function(...)
	require("fzf-lua").register_ui_select()
	return vim.ui.select(...)
end

local function fzf(picker)
	return function()
		require("fzf-lua")[picker]()
	end
end

vim.keymap.set("n", "<leader>ff", fzf("files"), { desc = "Fzf files" })
vim.keymap.set("n", "<leader>fg", fzf("live_grep"), { desc = "Fzf live grep" })
vim.keymap.set("n", "<leader>fb", fzf("buffers"), { desc = "Fzf buffers" })
vim.keymap.set("n", "<leader>fh", fzf("oldfiles"), { desc = "Fzf history" })
