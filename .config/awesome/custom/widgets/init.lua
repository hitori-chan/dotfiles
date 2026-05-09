local M = {}

function M.battery(opts)
	return require("custom.widgets.battery").new(opts)
end

return M
