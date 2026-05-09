local M = {}

M.keys = require("custom.keys")
M.widgets = require("custom.widgets")

function M.init(opts)
	opts = opts or {}
	require("custom.utils.notify").configure(opts.notify)
	require("custom.modules.volume").init(opts.volume)
	require("custom.modules.backlight").init(opts.backlight)
	require("custom.modules.system").configure(opts.system)
	require("custom.modules.touchpad").init()
end

function M.autostart()
	local touchpad = require("custom.modules.touchpad")

	touchpad.auto()
	touchpad.listen()
end

return M
