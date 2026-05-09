local awful = require("awful")

local M = {}
local settings = {
	file_manager = "thunar",
	lock = { "xset", "s", "activate" },
}

function M.configure(opts)
	opts = opts or {}
	settings.file_manager = opts.file_manager or settings.file_manager
	settings.lock = opts.lock or settings.lock
end

function M.lock()
	awful.spawn(settings.lock)
end

function M.file_manager()
	awful.spawn({ settings.file_manager })
end

return M
