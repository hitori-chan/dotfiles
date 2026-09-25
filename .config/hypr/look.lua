-- look.lua — everything visual: the awesome-flavored shell wearing the
-- frosted-glass material. Zero gaps and 1px borders stay (windows are not
-- the shell); blur is ON for the frosted bar/menus/cards (windows stay
-- opaque); animations stay off (the plugins honor animations=0 as their
-- kill switch).

local theme = require("theme")

local function argb(hex, alpha)
	return math.floor((alpha or 1.0) * 255 + 0.5) * 0x1000000 + tonumber(hex, 16)
end

hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,

		border_size = 1,
		col = {
			active_border = theme.rgba(theme.border_focus, 1.0),
			inactive_border = theme.rgba(theme.border_inactive, 1.0),
		},

		resize_on_border = true,

		allow_tearing = true, -- only `immediate`-ruled windows (rules.lua) tear

		snap = {
			enabled = false, -- hyprsnap is the magnet; two snap systems disagree
		},
	},

	decoration = {
		shadow = { enabled = false }, -- the shell paints its own card shadows
		glow = { enabled = false },
		-- the bar band, the menus and the notification cards are frosted glass
		blur = {
			enabled = true,
			size = theme.blur_size,
			passes = theme.blur_passes,
		},
	},

	-- awesome had none; the plugins' motion stays dormant under this too
	animations = { enabled = false },

	-- plugin values parse before the plugins load; the load's reparse applies
	-- them. The C++ defaults already ARE this theme — mapping them here keeps
	-- theme.lua the single source.
	plugin = {
		hyprsnap = {
			col_frame = argb(theme.focus), -- the armed snap zone's outline
		},
		hyprnotify = {
			font_size = theme.font_px,
			offset_y = theme.bar_px + 4, -- popups/center clear the bar
		},
		hyprbar = {
			height = theme.bar_px,
			font = theme.font,
			font_size = theme.font_px,
			terminal = "foot",

			col_bg = argb(theme.glass, theme.glass_alpha), -- the frosted band
			col_fg = argb(theme.fg),
			col_muted = argb(theme.muted),
			col_focus = argb(theme.focus),
			col_active = argb(theme.active),
			col_active_bg = argb(theme.active_bg),
			col_empty = argb(theme.empty),
			col_urgent = argb(theme.urgent),
			col_urgent_bg = argb(theme.urgent_bg),
			col_square_sel = argb(theme.square_sel),
			col_square_unsel = argb(theme.square_unsel),
			col_frame = argb(theme.frame),
			col_charging = argb(theme.charging),
			col_low = argb(theme.low),
			col_powersave = argb(theme.save),
		},
	},
})
