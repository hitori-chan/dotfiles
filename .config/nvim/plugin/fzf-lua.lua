vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/ibhagwan/fzf-lua",
})

require("nvim-web-devicons").setup()
require("fzf-lua").setup()

vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "Fzf files" })
vim.keymap.set("n", "<leader>fg", require("fzf-lua").live_grep, { desc = "Fzf live grep" })
vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers, { desc = "Fzf buffers" })
vim.keymap.set("n", "<leader>fh", require("fzf-lua").oldfiles, { desc = "Fzf history" })
