-- the M3 laptop (board j514 or j516) or the ThinkPad
local f = io.open("/sys/firmware/devicetree/base/compatible", "rb")
local M3 = f and f:read("a"):find("apple,j51[46]")
if f then
	f:close()
end
local scale = M3 and "1.5" or "1"

-- dp3: the M3's panel shows its P3 gamut unconverted
hl.monitor({ output = "", scale = scale, cm = M3 and "dp3" or nil })

-- the compositor writes its cursor into gsettings: env is the one source
hl.env("XCURSOR_THEME", "phinger-cursors-light")
hl.env("XCURSOR_SIZE", M3 and "24" or "32")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- no GTK_IM_MODULE: native GTK clients use text-input-v3
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")

hl.on("hyprland.start", function()
	-- the portal unit outlives sessions and spins on a dead display after a
	-- relog: import the environment, then restart it, in that order
	hl.exec_cmd([[dbus-update-activation-environment --systemd \
		DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP XDG_SESSION_TYPE \
		XCURSOR_THEME XCURSOR_SIZE XMODIFIERS QT_IM_MODULE SDL_IM_MODULE PATH XDG_DATA_DIRS \
		QT_QPA_PLATFORMTHEME QT_WAYLAND_DISABLE_WINDOWDECORATION &&
		systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal]])
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	-- the plugin hosts the tray: it must be loaded before nm-applet registers
	hl.exec_cmd("hyprpm reload -n; exec nm-applet --indicator")
	hl.exec_cmd("hyprpaper")
	-- where a finger is enrolled, the lock's mark takes the box's slot
	hl.exec_cmd([[timeout 5 fprintd-list "$USER" | grep -q '^ - #' && hides=true || hides=false
		HYPRLOCK_BOX_HIDES=$hides exec hypridle]])
	hl.exec_cmd("fcitx5 -d")
end)

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.config({
	-- the M3's display has no async flips: a torn frame there is a dropped one
	general = { allow_tearing = not M3 },
	input = {
		repeat_rate = 35,
		repeat_delay = 300,
		touchpad = { clickfinger_behavior = true },
	},
	misc = {
		font_family = "Inter",
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 3, -- fullscreen games only
	},
	cursor = { no_warps = true },
	xwayland = { force_zero_scaling = true },
	render = {
		direct_scanout = 1, -- 2 (games only) if a fullscreen app glitches
		-- the color matrix converts scanned-out sRGB on the M3's P3 panel;
		-- 2 decides before scanout starts and never sets it
		non_shader_cm = M3 and 1 or nil,
	},
})
