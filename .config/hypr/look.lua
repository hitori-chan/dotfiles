hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		col = {
			active_border = "rgba(FFFFFF17)",
			inactive_border = "rgba(FFFFFF0F)",
		},
		resize_on_border = true,
	},
	decoration = {
		rounding = 6,
		shadow = {
			range = 20,
			color = "rgba(00000073)",
			color_inactive = "rgba(00000038)",
		},
		-- the plugin's glass: highlights (the fork's) caps white at 104/255
		blur = {
			size = 3,
			passes = 2,
			contrast = 1.0,
			vibrancy = 0.6,
			highlights = 0.46,
		},
	},
	animations = { enabled = false },
})
