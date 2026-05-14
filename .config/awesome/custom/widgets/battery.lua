local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local notify = require("custom.utils.notify").new()
local wibox = require("wibox")

local M = {}

local settings = {
	low_interval = 300,
	low_percent = 10,
	update_interval = 30,
}

local state = {
	ac_online = nil,
	bat_perc = nil,
	low_notified = false,
	last_low_notify = 0,
}

local widgets = setmetatable({}, { __mode = "k" })
local watcher_started = false
local refresh_timer = nil
local paths = {
	battery_capacity = nil,
	mains_online = nil,
}

local function read_file(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end

	local value = file:read("*l")
	file:close()
	return value
end

local function discover_power_supply(type_name)
	local handle = io.popen("ls -1 /sys/class/power_supply 2>/dev/null")
	if not handle then
		return nil
	end

	for entry in handle:lines() do
		local base = "/sys/class/power_supply/" .. entry
		if read_file(base .. "/type") == type_name then
			handle:close()
			return base
		end
	end

	handle:close()
	return nil
end

local function discover_paths()
	local battery = discover_power_supply("Battery")
	local mains = discover_power_supply("Mains")

	paths.battery_capacity = battery and (battery .. "/capacity") or nil
	paths.mains_online = mains and (mains .. "/online") or nil
end

local function icon_for(percent, charging)
	if charging then
		return "\u{e1a3}"
	elseif percent <= 12.5 then
		return "\u{ebdc}"
	elseif percent <= 25 then
		return "\u{ebd9}"
	elseif percent <= 37.5 then
		return "\u{ebe0}"
	elseif percent <= 50 then
		return "\u{ebdd}"
	elseif percent <= 62.5 then
		return "\u{ebe2}"
	elseif percent <= 75 then
		return "\u{ebd4}"
	elseif percent <= 87.5 then
		return "\u{ebd2}"
	end

	return "\u{e1a4}"
end

local function render_widget(widget)
	if not state.bat_perc then
		return
	end

	widget.value:set_markup(state.bat_perc .. "%")
	widget.icon:set_markup(icon_for(state.bat_perc, state.ac_online))
end

local function update_all()
	for widget in pairs(widgets) do
		render_widget(widget)
	end
end

local function maybe_notify_low_battery()
	if state.ac_online or not state.bat_perc then
		return
	end

	if state.bat_perc > settings.low_percent then
		return
	end

	if state.low_notified and os.difftime(os.time(), state.last_low_notify) < settings.low_interval then
		return
	end

	notify:send("Battery low. Plug the cable!", "BATTERY")
	state.last_low_notify = os.time()
	state.low_notified = true
end

local function refresh()
	if not paths.battery_capacity and not paths.mains_online then
		discover_paths()
	end

	local capacity = paths.battery_capacity and tonumber(read_file(paths.battery_capacity))
	local online = paths.mains_online and tonumber(read_file(paths.mains_online)) == 1 or false
	local changed = state.ac_online ~= nil and state.ac_online ~= online

	state.bat_perc = capacity or state.bat_perc
	state.ac_online = online

	if changed then
		notify:send(online and "AC adapter is connected!" or "AC adapter is disconnected!")
	end

	maybe_notify_low_battery()
	update_all()
end

local function start_refresh_timer()
	if refresh_timer or settings.update_interval <= 0 then
		return
	end

	refresh_timer = gears.timer({
		timeout = settings.update_interval,
		autostart = true,
		callback = refresh,
	})
end

local function start_watcher()
	if watcher_started then
		return
	end

	watcher_started = true
	discover_paths()
	refresh()
	start_refresh_timer()

	awful.spawn.easy_async({ "pkill", "-u", os.getenv("USER"), "-x", "acpi_listen" }, function()
		awful.spawn.with_line_callback("acpi_listen", {
			stdout = function(line)
				if line:match("battery") or line:match("ac_adapter") then
					refresh()
				end
			end,
		})
	end)
end

function M.configure(opts)
	opts = opts or {}
	settings.low_interval = opts.low_interval or settings.low_interval
	settings.low_percent = opts.low_percent or settings.low_percent

	if opts.update_interval ~= nil then
		settings.update_interval = opts.update_interval

		if refresh_timer then
			if settings.update_interval <= 0 then
				refresh_timer:stop()
			else
				refresh_timer.timeout = settings.update_interval
				refresh_timer:again()
			end
		end
	end
end

function M.new(opts)
	M.configure(opts)

	local widget = wibox.widget({
		{
			id = "icon",
			text = "\u{e1a6}",
			font = beautiful.font_icon,
			widget = wibox.widget.textbox,
		},
		{
			id = "value",
			widget = wibox.widget.textbox,
		},
		layout = wibox.layout.fixed.horizontal,
	})

	widgets[widget] = true
	start_watcher()
	render_widget(widget)

	return widget
end

return M
