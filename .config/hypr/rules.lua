hl.window_rule({
	name = "xwayland-drag-fix",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})

-- floating only, each window at its own size: forcing one makes fixed-size
-- dialogs blink
hl.window_rule({
	name = "every-window",
	match = { class = ".*" },
	float = true,
	center = true,
	idle_inhibit = "fullscreen",
})

hl.window_rule({
	name = "no-border-when-maximized",
	match = { fullscreen_state_internal = 1 },
	border_size = 0,
})

hl.window_rule({
	name = "password-prompts",
	match = { class = "gcr-prompter|(?i)hyprpolkitagent" },
	stay_focused = true,
})

hl.window_rule({
	name = "pip",
	match = { title = "^Picture-in-Picture$" },
	pin = true,
	keep_aspect_ratio = true,
	size = { "monitor_w * 0.26", "monitor_h * 0.26" },
	move = { "monitor_w * 0.72", "monitor_h * 0.70" },
})

hl.window_rule({
	name = "games-immediate",
	match = { content = "game" },
	immediate = true,
})

-- browsers at 60 fps on battery (the fork's max_fps and on_battery)
hl.window_rule({
	name = "browsers-60-on-battery",
	match = {
		class = "firefox.*|org\\.mozilla\\.firefox|librewolf|chromium.*|google-chrome.*|brave-browser.*|vivaldi.*|microsoft-edge.*",
		on_battery = true,
	},
	max_fps = 60,
})
