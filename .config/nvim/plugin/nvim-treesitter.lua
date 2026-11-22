vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").install({
	"bash",
	"c",
	"c_sharp",
	"caddy",
	"cpp",
	"css",
	"go",
	"html",
	"java",
	"javascript",
	"json",
	"lua",
	"markdown",
	"nasm",
	"php",
	"python",
	"ruby",
	"rust",
	"toml",
	"tsx",
	"typescript",
	"xml",
	"yaml",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})
