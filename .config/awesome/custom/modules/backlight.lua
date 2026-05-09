local awful = require("awful")
local notify = require("custom.utils.notify").new()

local M = {}
local initialized = false
local settings = {
	step = "2%",
}

function M.configure(opts)
	opts = opts or {}
	settings.step = opts.step or settings.step
end

local function show_status()
	awful.spawn.easy_async({ "brightnessctl" }, function(stdout)
		local percent = stdout:match("Current brightness:%s*%d+ %((%d+%%)%)")
		notify:send(percent or "unknown", "BRIGHTNESS")
	end)
end

local function change_and_notify(command)
	awful.spawn.easy_async(command, show_status)
end

function M.init(opts)
	M.configure(opts)

	if initialized then
		return
	end

	initialized = true
	awesome.connect_signal("custom::backlight", show_status)
end

function M.increase()
	change_and_notify({ "brightnessctl", "set", settings.step .. "+" })
end

function M.decrease()
	change_and_notify({ "brightnessctl", "set", settings.step .. "-" })
end

return M
