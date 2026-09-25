-- core.lua — monitors, environment, autostart, input, and platform behavior.

local theme = require("theme")

-----------------
---- PLUGINS ----
-----------------

-- Plugins (github.com/hitori-chan/hyprland-plugins) load AFTER this config
-- parses (autostart `hyprpm reload -n`) — binds resolve hl.plugin.* lazily;
-- load order lives in hyprpm.toml.

------------------
---- MONITORS ----
------------------

-- Catch-all for externals.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
	reserved_area = { top = theme.bar_px },
})

-- Internal panel pinned to scale 1 — auto picks 1.5 and zooms everything.
hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@60",
	position = "0x0",
	scale = 1,
	reserved_area = { top = theme.bar_px },
})

-------------
---- ENV ----
-------------

-- Cursor: the compositor syncs its cursor into gsettings (sync on by
-- default), stomping nwg-look's values — env is the one source.
hl.env("XCURSOR_THEME", "phinger-cursors-light")
hl.env("XCURSOR_SIZE", "32")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
-- Qt is themeless outside a DE; gtk3 platform theme = follow GTK's gsettings
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Hyprland owns the fcitx5 environment. Keep GTK_IM_MODULE unset so native
-- GTK3/4 clients use Wayland text-input-v3; XWayland still uses XMODIFIERS.
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	-- The portal unit outlives sessions: after a relog the old process spins
	-- on the dead display at 100% CPU. Import the complete session environment
	-- before restarting it; one shell preserves the required ordering.
	local portal_env = table.concat({
		"DISPLAY",
		"WAYLAND_DISPLAY",
		"HYPRLAND_INSTANCE_SIGNATURE",
		"XDG_CURRENT_DESKTOP",
		"XDG_SESSION_DESKTOP",
		"XDG_SESSION_TYPE",
		"XCURSOR_THEME",
		"XCURSOR_SIZE",
		"QT_QPA_PLATFORM",
		"QT_QPA_PLATFORMTHEME",
		"QT_WAYLAND_DISABLE_WINDOWDECORATION",
		"XMODIFIERS",
		"QT_IM_MODULE",
		"SDL_IM_MODULE",
		"PATH",
		"XDG_DATA_DIRS",
	}, " ")
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd "
			.. portal_env
			.. " && systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal"
	)
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	-- before nm-applet: hyprbar is the SNI host, it must exist when the
	-- applet registers. Keep both in one process chain so registration cannot
	-- race plugin loading.
	hl.exec_cmd("hyprpm reload -n && exec nm-applet --indicator")

	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")

	hl.exec_cmd("fcitx5 -d")
end)

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",

		follow_mouse = 1, -- sloppy focus
		sensitivity = 0,

		repeat_rate = 35,
		repeat_delay = 300,

		touchpad = {
			natural_scroll = false,
			tap_to_click = true,
			clickfinger_behavior = true, -- 2-finger tap = right click, 3 = middle
			disable_while_typing = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

--------------
---- MISC ----
--------------

hl.config({
	misc = {
		font_family = theme.font,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,

		-- honor an app's activation request (raise + focus), as awesome did:
		-- a tray-icon Activate or a clicked notification tells the source app
		-- to present itself, and without this the compositor only flags it
		-- urgent instead of raising it.
		focus_on_activate = true,

		vrr = 3, -- fullscreen game content only
	},

	cursor = {
		no_warps = true,
	},

	xwayland = {
		force_zero_scaling = true, -- no blurry XWayland when a display is scaled
	},

	render = {
		direct_scanout = 2, -- automatically scan out eligible fullscreen clients
	},
})
