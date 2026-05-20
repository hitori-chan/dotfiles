local awful = require("awful")
local gears = require("gears")

local backlight = require("custom.modules.backlight")
local media = require("custom.modules.media")
local screenshots = require("custom.modules.screenshots")
local system = require("custom.modules.system")
local touchpad = require("custom.modules.touchpad")
local volume = require("custom.modules.volume")

local M = {}

function M.global(modkey)
	return gears.table.join(
		awful.key({}, "XF86AudioRaiseVolume", volume.raise, { description = "raise volume", group = "audio" }),
		awful.key({}, "XF86AudioLowerVolume", volume.lower, { description = "lower volume", group = "audio" }),
		awful.key({}, "XF86AudioMute", volume.toggle_mute, { description = "mute volume", group = "audio" }),

		awful.key(
			{},
			"XF86MonBrightnessUp",
			backlight.increase,
			{ description = "increase brightness", group = "screen" }
		),
		awful.key(
			{},
			"XF86MonBrightnessDown",
			backlight.decrease,
			{ description = "decrease brightness", group = "screen" }
		),

		awful.key({}, "XF86AudioNext", media.next, { description = "next track", group = "audio" }),
		awful.key({}, "XF86AudioPrev", media.previous, { description = "previous track", group = "audio" }),
		awful.key({}, "XF86AudioStop", media.stop, { description = "stop playback", group = "audio" }),
		awful.key({}, "XF86AudioPlay", media.play_pause, { description = "play or pause", group = "audio" }),

		awful.key({}, "XF86TouchpadToggle", touchpad.toggle, { description = "toggle touchpad", group = "input" }),

		awful.key(
			{},
			"Print",
			screenshots.copy_region,
			{ description = "copy selected region to clipboard", group = "screenshot" }
		),
		awful.key(
			{ "Control" },
			"Print",
			screenshots.save_region,
			{ description = "save selected region to file", group = "screenshot" }
		),
		awful.key(
			{ "Shift" },
			"Print",
			screenshots.copy_window,
			{ description = "copy selected window to clipboard", group = "screenshot" }
		),
		awful.key(
			{ "Control", "Shift" },
			"Print",
			screenshots.save_window,
			{ description = "save selected window to file", group = "screenshot" }
		),
		awful.key(
			{ modkey },
			"Print",
			screenshots.copy_screen,
			{ description = "copy fullscreen to clipboard", group = "screenshot" }
		),
		awful.key(
			{ "Control", modkey },
			"Print",
			screenshots.save_screen,
			{ description = "save fullscreen to file", group = "screenshot" }
		),

		awful.key({ modkey, "Mod1" }, "l", system.lock, { description = "lock screen", group = "system" }),
		awful.key({ modkey }, "e", system.file_manager, { description = "file manager", group = "system" })
	)
end

return M
