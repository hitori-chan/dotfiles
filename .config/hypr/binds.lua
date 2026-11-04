local mod = "SUPER"

local function awesome(fn)
	return function()
		hl.plugin.awesome[fn]()
	end
end

hl.bind(mod .. " + Return", hl.dsp.exec_cmd("foot"))
hl.bind(mod .. " + P", awesome("menubar"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("thunar"))

hl.bind(mod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

hl.bind(mod .. " + M", awesome("maximize"))
hl.bind(mod .. " + N", awesome("minimize"))
hl.bind(mod .. " + CTRL + N", awesome("restore"))

hl.bind(mod .. " + T", hl.dsp.window.pin())

-- arrival order: the native cycle walks the z-order, which focus rotates
hl.bind(mod .. " + J", awesome("focus_next"))
hl.bind(mod .. " + K", awesome("focus_prev"))
hl.bind(mod .. " + Tab", awesome("focus_prev_here"))

hl.bind(mod .. " + U", hl.dsp.focus({ urgent_or_last = true }))

hl.bind(mod .. " + O", hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mod .. " + CTRL + J", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mod .. " + CTRL + K", hl.dsp.focus({ monitor = "-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

for i = 1, 9 do
	hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mod .. " + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + Escape", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

local locked = { locked = true }
local held = { locked = true, repeating = true }

hl.bind("XF86AudioRaiseVolume", awesome("volume_up"), held)
hl.bind("XF86AudioLowerVolume", awesome("volume_down"), held)
hl.bind("XF86AudioMute", awesome("mute"), locked)
hl.bind("XF86AudioMicMute", awesome("mic_mute"), locked)
hl.bind("XF86MonBrightnessUp", awesome("brightness_up"), held)
hl.bind("XF86MonBrightnessDown", awesome("brightness_down"), held)
hl.bind("XF86TouchpadToggle", awesome("touchpad_toggle"), locked)

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), locked)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), locked)

local shot = "~/.config/hypr/scripts/screenshot.sh"
hl.bind("Print", hl.dsp.exec_cmd(shot .. " region copy"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd(shot .. " region save"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(shot .. " window copy"))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd(shot .. " window save"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(shot .. " output copy"))
hl.bind(mod .. " + CTRL + Print", hl.dsp.exec_cmd(shot .. " output save"))

hl.bind(mod .. " + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mod .. " + CTRL + R", hl.dsp.reload_config())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit())
