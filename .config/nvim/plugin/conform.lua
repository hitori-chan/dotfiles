vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
	default_format_opts = {
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		mdx = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		yaml = { "prettier" },
	},
})

vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = false })
end, { desc = "Format buffer" })
