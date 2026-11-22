vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.lsp.enable({
	"bashls",
	"clangd",
	"cssls",
	"gopls",
	"html",
	"jdtls",
	"lemminx",
	"lua_ls",
	"phpactor",
	"ruff",
	"rust_analyzer",
	"ts_ls",
	"tombi",
	"ty",
	"yamlls",
})

vim.lsp.linked_editing_range.enable()

vim.keymap.set("n", "<C-w>D", vim.diagnostic.setloclist, {
	desc = "Diagnostics to location list",
})
