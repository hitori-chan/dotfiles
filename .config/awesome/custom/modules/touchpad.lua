local awful = require("awful")
local notify = require("custom.utils.notify").new()

local M = {}
local initialized = false
local listener_started = false
local monitor_event = {}
local monitor_cmd = { "udevadm", "monitor", "--udev", "--property", "--subsystem-match=input" }
local monitor_pattern = "(^|/)udevadm monitor --udev --property --subsystem-match=input$"
local external_mouse_cmd = [[
for dev in /dev/input/event*; do
	props=$(udevadm info --query=property --name="$dev" 2>/dev/null) || continue
	echo "$props" | grep -qx 'ID_INPUT_MOUSE=1' || continue
	echo "$props" | grep -Eqx 'ID_BUS=(usb|bluetooth)' && exit 0
done
exit 1
]]

local function trim(value)
	return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function reset_monitor_event()
	monitor_event = { triggered = false }
end

local function is_external_mouse_event(event)
	local devname = event.DEVNAME or ""
	local bus = event.ID_BUS or ""

	return (event.ACTION == "add" or event.ACTION == "remove")
		and event.ID_INPUT_MOUSE == "1"
		and devname:match("^/dev/input/event%d+$") ~= nil
		and (bus == "usb" or bus == "bluetooth")
end

local function maybe_handle_monitor_event()
	if monitor_event.triggered or not is_external_mouse_event(monitor_event) then
		return
	end

	monitor_event.triggered = true
	M.auto()
end

local function handle_monitor_line(line)
	line = trim(line)

	if line == "" then
		return
	end

	if line:match("^UDEV%s+") then
		reset_monitor_event()
		return
	end

	local key, value = line:match("^([%w_]+)=(.*)$")
	if not key then
		return
	end

	monitor_event[key] = value
	maybe_handle_monitor_event()
end

local function kill_existing_listener(callback)
	awful.spawn.easy_async({ "pkill", "-u", os.getenv("USER"), "-f", monitor_pattern }, callback)
end

local function with_touchpad(callback)
	awful.spawn.easy_async_with_shell(
		[[xinput list | grep -Eio '(touchpad|glidepoint)\s*id=[0-9]+' | grep -Eo '[0-9]+' | head -n1]],
		function(stdout)
			local device_id = trim(stdout)

			if device_id == "" then
				notify:send("Touchpad not found", "TOUCHPAD")
				return
			end

			callback(device_id)
		end
	)
end

local function set_enabled(device_id, enabled)
	if enabled then
		awful.spawn({ "xinput", "enable", device_id })
		notify:send("Touchpad is now enabled", "TOUCHPAD")
	else
		awful.spawn({ "xinput", "disable", device_id })
		notify:send("Touchpad is now disabled", "TOUCHPAD")
	end
end

function M.disable()
	with_touchpad(function(device_id)
		set_enabled(device_id, false)
	end)
end

function M.enable()
	with_touchpad(function(device_id)
		set_enabled(device_id, true)
	end)
end

function M.toggle()
	with_touchpad(function(device_id)
		awful.spawn.easy_async({ "xinput", "list-props", device_id }, function(stdout)
			local enabled = tonumber(stdout:match("Device Enabled %(%d+%):%s(%d)"))
			if not enabled then
				notify:send("Touchpad state unknown", "TOUCHPAD")
				return
			end

			set_enabled(device_id, enabled ~= 1)
		end)
	end)
end

function M.auto()
	with_touchpad(function(device_id)
		awful.spawn.easy_async_with_shell(external_mouse_cmd, function(_, _, _, exit_code)
			set_enabled(device_id, exit_code ~= 0)
		end)
	end)
end

function M.listen()
	if listener_started then
		return
	end

	listener_started = true
	reset_monitor_event()

	kill_existing_listener(function()
		local pid_or_err = awful.spawn.with_line_callback(monitor_cmd, {
			stdout = handle_monitor_line,
			exit = function()
				listener_started = false
			end,
		})

		if type(pid_or_err) == "string" then
			listener_started = false
			notify:send("Touchpad watcher failed", "TOUCHPAD")
		end
	end)
end

function M.init()
	if initialized then
		return
	end

	initialized = true
	awesome.connect_signal("custom::touchpad", function(mode)
		if mode == "disable" then
			M.disable()
		elseif mode == "enable" then
			M.enable()
		elseif mode == "auto" then
			M.auto()
		else
			M.toggle()
		end
	end)
end

return M
