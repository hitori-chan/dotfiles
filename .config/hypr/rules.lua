-- rules.lua — window, workspace, and layer rules.

-------------------------
---- QUALITY OF LIFE ----
-------------------------

-- NO suppress-maximize rule (the official example ships one): the fork's
-- initial-maximize fix needs the requests to reach the compositor.

-- Fix dragging issues with XWayland popups (official example).
hl.window_rule({
	name = "xwayland-drag-fix",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Fullscreen media and games intentionally inhibit every hypridle listener:
-- no dim, lock, or DPMS transition while fullscreen content is being watched.
hl.window_rule({
	name = "no-idle-when-fullscreen",
	match = { class = ".*" },
	idle_inhibit = "fullscreen",
})

hl.window_rule({
	name = "no-border-when-maximized",
	match = { fullscreen_state_internal = 1 }, -- 1 = maximized
	border_size = 0,
})

----------------
---- FLOATS ----
----------------

-- Floating-only, like awesome: every window opens floating at its OWN
-- size. Never force one — a fixed-size dialog refuses it and blinks, and a
-- forced size strands a small dialog's content in a corner of the oversized
-- frame (portal dialogs did exactly this). Hyprland falls back to 640x400
-- when a client asks for nothing.
hl.window_rule({
	name = "floating-only",
	match = { class = ".*" },
	float = true,
	center = true,
})

hl.window_rule({
	match = { class = "(pinentry-)(.*)" },
	float = true,
	stay_focused = true,
})

hl.window_rule({ match = { class = "(?i)hyprpolkitagent" }, float = true, center = true, stay_focused = true })

hl.window_rule({
	name = "pip",
	match = { title = "^Picture-in-Picture$" },
	float = true,
	pin = true,
	keep_aspect_ratio = true,
	size = { "monitor_w * 0.26", "monitor_h * 0.26" },
	move = { "monitor_w * 0.72", "monitor_h * 0.70" },
})

---------------
---- GAMES ----
---------------

-- Game content tears (pairs with allow_tearing in look.lua).
hl.window_rule({
	name = "games-immediate",
	match = { content = "game" },
	immediate = true,
})
