-- binds.lua — every keybinding, awesome-faithful; semantic translations
-- commented inline.
--
-- NOT ported — no Hyprland equivalent, deliberately unbound:
--   Mod+Ctrl+1..9         view multiple tags at once
--   right-click desktop   root menu (session menu lives on Super+W)
--   bare desktop scroll   tag cycling (workspace scroll needs Super held)
--
-- DROPPED with the tiled layouts — this desktop is floating-only, the
-- tiling chords are gone rather than half-working:
--   Mod+Shift+J / K           swap by index (visual no-op in floating)
--   Mod+Shift+H / L           master count
--   Mod+Ctrl+Return           swap with master
--   Mod+B                     flip dwindle split
--   Mod+Ctrl+Space, Mod+V     float toggle (nothing to toggle into)
--   Mod+Ctrl+H / L            column count
--   Mod+Ctrl+M / Shift+M      vertical / horizontal maximize

local mod = "SUPER"
local terminal = "foot"
local fileManager = "thunar"
local scripts = "~/.config/hypr/scripts"

--------------
---- APPS ----
--------------
-- awesome: Return terminal, P menubar, E file manager.
-- DROPPED BY CHOICE: Mod+R/X/S prompts and fuzzel — the
-- menubar is the one launcher (C-Return covers the run prompt);
-- `hyprctl eval` is the lua prompt, this file the keybind reference.

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal), { description = "terminal" })
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "file manager" })

-- awesome's Mod+P menubar (key reference: the plugin's README). Nil-guarded:
-- dead until the plugin installs — there is no fallback launcher.
hl.bind(mod .. " + P", function()
	local a = hl.plugin and hl.plugin.awesome
	if a and a.menubar then
		a.menubar()
	end
end, { description = "app menubar (awesome chord)" })

-----------------
---- WINDOWS ----
-----------------

hl.bind(mod .. " + SHIFT + C", hl.dsp.window.close(), { description = "close window (awesome chord)" })
hl.bind(mod .. " + Q", hl.dsp.window.close(), { description = "close window" })

hl.bind(
	mod .. " + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	{ description = "fullscreen" }
)

-- awesome's Mod+M is a PER-WINDOW flag (any number at once); native
-- maximize is one per workspace, so the plugin provides the semantics
-- (nil-guarded native fallback).
local function max_toggle()
	local a = hl.plugin and hl.plugin.awesome
	if a and a.maximize then
		a.maximize()
	else
		hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
	end
end
hl.bind(mod .. " + M", max_toggle, { description = "maximize (awesome chord)" })
hl.bind(mod .. " + SHIFT + F", max_toggle, { description = "maximize" })

hl.bind(mod .. " + C", hl.dsp.window.center(), { description = "center window" })

-- awesome's Mod+T keep-on-top; pin = floating window on top, on every workspace
hl.bind(mod .. " + T", hl.dsp.window.pin(), { description = "pin on top (awesome keep-on-top)" })

-- awesome's Mod+J/K focus.byidx: the plugin cycles in ARRIVAL order — the
-- native cycle_next walks the z-order list, which raise-on-focus rotates,
-- so cycling backwards bounced between the two newest raises.
local function focus_byidx(forward)
	return function()
		local a = hl.plugin and hl.plugin.awesome
		local fn = a and (forward and a.focus_next or a.focus_prev)
		if fn then
			fn()
		else
			hl.dispatch(hl.dsp.window.cycle_next({ next = forward }))
		end
	end
end
hl.bind(mod .. " + J", focus_byidx(true), { description = "focus next window" })
hl.bind(mod .. " + K", focus_byidx(false), { description = "focus previous window" })
hl.bind(mod .. " + down", focus_byidx(true))
hl.bind(mod .. " + up", focus_byidx(false))

-- awesome's Mod+H/L mwfact, floating translation: nudge the width.
hl.bind(
	mod .. " + L",
	hl.dsp.window.resize({ x = 48, y = 0, relative = true }),
	{ repeating = true, description = "grow window (awesome mwfact+)" }
)
hl.bind(
	mod .. " + H",
	hl.dsp.window.resize({ x = -48, y = 0, relative = true }),
	{ repeating = true, description = "shrink window (awesome mwfact-)" }
)

-- Directional window movement (no awesome ancestor; arrows only, all free chords).
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- awesome's Mod+Tab: previous window ON THIS WORKSPACE — native
-- focus({ last }) is global history, the plugin scopes it (nil-guarded).
hl.bind(mod .. " + Tab", function()
	local a = hl.plugin and hl.plugin.awesome
	if a and a.focus_prev_here then
		a.focus_prev_here()
	else
		hl.dispatch(hl.dsp.focus({ last = true }))
	end
end, { description = "last window on this workspace (awesome chord)" })

hl.bind(mod .. " + U", hl.dsp.focus({ urgent_or_last = true }), { description = "urgent window (awesome chord)" })

hl.bind(mod .. " + O", hl.dsp.window.move({ monitor = "+1" }), { description = "move window to next monitor" })
hl.bind(mod .. " + CTRL + J", hl.dsp.focus({ monitor = "+1" }), { description = "focus next monitor" })
hl.bind(mod .. " + CTRL + K", hl.dsp.focus({ monitor = "-1" }), { description = "focus previous monitor" })

-- Drag to move, right-drag to resize. `mouse` excludes
-- repeating/locked/release — combining is a config error.
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- awesome's client.minimized: the plugin hides the window (unrendered,
-- suspended, its tiling slot freed) and keeps it in the tasklist drawn
-- muted; Mod+N
-- minimizes the focused window, Mod+Ctrl+N (awful.client.restore) brings the
-- last minimized one back in place. Click a task in the bar to toggle it too.
-- Nil-guarded like the menubar bind: dead keys, not errors, until the plugin loads.
hl.bind(mod .. " + N", function()
	local a = hl.plugin and hl.plugin.awesome
	if a and a.minimize then
		a.minimize()
	end
end, { description = "minimize window (awesome)" })
hl.bind(mod .. " + CTRL + N", function()
	local a = hl.plugin and hl.plugin.awesome
	if a and a.restore then
		a.restore()
	end
end, { description = "restore minimized window (awesome)" })

--------------------
---- WORKSPACES ----
--------------------

-- Nine workspaces (the bar's 一..九). awesome semantics: Shift+num moves
-- WITHOUT following (move_to_tag); Ctrl+Shift+num follows.
for i = 1, 9 do
	hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
	hl.bind(mod .. " + CTRL + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = true }))
end

-- awesome: Mod+Left/Right tag prev/next, Mod+Escape jump back, Mod+scroll cycles.
hl.bind(mod .. " + left", hl.dsp.focus({ workspace = "e-1" }), { description = "previous workspace" })
hl.bind(mod .. " + right", hl.dsp.focus({ workspace = "e+1" }), { description = "next workspace" })
hl.bind(
	mod .. " + Escape",
	hl.dsp.focus({ workspace = "previous" }),
	{ description = "back to last workspace (awesome chord)" }
)
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-----------------------------------
---- MEDIA / HARDWARE / SYSTEM ----
-----------------------------------

-- The plugin's value-bar cards are the OSD. Nil-guarded like the
-- menubar bind: dead keys, not errors, until the plugin installs.
local function osd(fn)
	return function()
		local a = hl.plugin and hl.plugin.awesome
		if a and a[fn] then
			a[fn]()
		end
	end
end
hl.bind("XF86AudioRaiseVolume", osd("volume_up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", osd("volume_down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", osd("mute"), { locked = true })
hl.bind("XF86AudioMicMute", osd("mic_mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", osd("brightness_up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", osd("brightness_down"), { locked = true, repeating = true })

-- DND: cards collect silently, the resume replays them newest-first.
-- Nil-guarded like the rest.
hl.bind(mod .. " + SHIFT + D", function()
	local a = hl.plugin and hl.plugin.awesome
	if a and a.suspend then
		a.suspend()
	end
end, { description = "notification DND" })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- The plugin's touchpad flip. Nil-guarded like the menubar bind: dead key,
-- not an error, until the plugin installs.
hl.bind("XF86TouchpadToggle", function()
	local a = hl.plugin and hl.plugin.awesome
	if a and a.touchpad_toggle then
		a.touchpad_toggle()
	end
end, { locked = true })

local shot = scripts .. "/screenshot.sh"
hl.bind("Print", hl.dsp.exec_cmd(shot .. " region copy"), { description = "shot: region > clipboard" })
hl.bind("CTRL + Print", hl.dsp.exec_cmd(shot .. " region save"), { description = "shot: region > file" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(shot .. " window copy"), { description = "shot: window > clipboard" })
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd(shot .. " window save"), { description = "shot: window > file" })
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(shot .. " output copy"), { description = "shot: screen > clipboard" })
hl.bind(mod .. " + CTRL + Print", hl.dsp.exec_cmd(shot .. " output save"), { description = "shot: screen > file" })

-- awesome's Mod+Ctrl+R restart; auto-reload exists, this forces it.
hl.bind(mod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "reload config (awesome chord)" })

hl.bind(
	mod .. " + W",
	hl.dsp.submap("session"),
	{ description = "session menu: L lock  E exit  S suspend  R reboot  P poweroff" }
)
hl.define_submap("session", function()
	local function run_and_reset(cmd)
		return function()
			hl.dispatch(hl.dsp.submap("reset"))
			hl.dispatch(hl.dsp.exec_cmd(cmd))
		end
	end
	hl.bind("L", run_and_reset("loginctl lock-session"))
	hl.bind("S", run_and_reset("systemctl suspend"))
	hl.bind("R", run_and_reset("systemctl reboot"))
	hl.bind("P", run_and_reset("systemctl poweroff"))
	hl.bind("E", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exit())
	end)
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("catchall", hl.dsp.submap("reset"))
end)

hl.bind(mod .. " + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"), { description = "lock screen (awesome chord)" })

hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit(), { description = "quit Hyprland (awesome chord)" })
