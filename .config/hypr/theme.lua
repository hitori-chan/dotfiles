-- theme.lua — colors, fonts, shared metrics: the one source.
-- Hex is RRGGBB, no leading #. look.lua maps these onto the plugins, so a
-- re-theme stays a token swap here.
--
-- Hyprbar consumes these tokens. Hyprnotify keeps its independently approved
-- glass palette in common/theme.hpp, avoiding a second copy here.

local M = {
	font = "Fira Code", -- shell UI, same face as the terminals
	font_px = 12, -- logical px; monitor scale handles density

	bar_px = 26, -- the wibar: core reserves it

	-- ink
	fg = "AAAAAA", -- normal text
	muted = "8A97A8", -- kickers, letter fallbacks
	empty = "565E6B", -- disabled/placeholder text

	-- accents
	focus = "32D6FF", -- selected menubar entry (awesome fg_focus)
	active = "00CCFF", -- active tag / focused task
	active_bg = "1E2320", -- active tag ground (zenburn)
	urgent = "C83F11",
	urgent_bg = "3F3F3F", -- awesome bg_urgent

	-- glass material: the frosted ground the shell rides on (bar band, menus,
	-- notification cards). blur_size/passes frost it; the compositor's blur
	-- is what the plugins sample, so these live in decoration too.
	glass = "0F1218",
	glass_alpha = 0.62,
	blur_size = 5, -- blur radius ~= size * 2^passes = 20
	blur_passes = 2,

	-- taglist occupancy squares
	square_sel = "F0DFAF", -- tag holds the focused window
	square_unsel = "DCDCCC", -- occupied tag

	frame = "3F3F3F", -- menu panel / card frames

	-- battery (Android's palette, as transcribed)
	charging = "18CC47",
	low = "FF0E01",
	save = "FFC917",

	-- window borders
	border_focus = "6F6F6F",
	border_inactive = "3F3F3F",
}

-- "32D6FF", 0.93 -> "rgba(32D6FFed)"  (the color format hl.config gradients accept)
function M.rgba(hex, alpha)
	return string.format("rgba(%s%02x)", hex, math.floor(alpha * 255 + 0.5))
end

return M
