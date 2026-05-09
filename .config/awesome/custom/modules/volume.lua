local awful = require("awful")
local notify = require("custom.utils.notify").new()

local M = {}
local initialized = false
local settings = {
	sink = "@DEFAULT_SINK@",
	step = "5%",
}

function M.configure(opts)
	opts = opts or {}
	settings.sink = opts.sink or settings.sink
	settings.step = opts.step or settings.step
end

local function show_status()
	awful.spawn.easy_async({ "pactl", "get-sink-mute", settings.sink }, function(mute_stdout)
		awful.spawn.easy_async({ "pactl", "get-sink-volume", settings.sink }, function(volume_stdout)
			local state = mute_stdout:match("Mute:%s+yes") and "[Muted]" or "[On]"
			local volume = volume_stdout:match("/%s*(%d+%%)")
			notify:send(state .. " " .. (volume or "unknown"), "VOLUME")
		end)
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
	awesome.connect_signal("custom::volume", show_status)
end

function M.raise()
	change_and_notify({ "pactl", "set-sink-volume", settings.sink, "+" .. settings.step })
end

function M.lower()
	change_and_notify({ "pactl", "set-sink-volume", settings.sink, "-" .. settings.step })
end

function M.toggle_mute()
	change_and_notify({ "pactl", "set-sink-mute", settings.sink, "toggle" })
end

return M
