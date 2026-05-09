local awful = require("awful")

local M = {}

local function tmp_png()
	return "/tmp/$(date +%F.%T).png"
end

function M.copy_region()
	awful.spawn.with_shell("maim -su | xclip -selection clipboard -t image/png")
end

function M.save_region()
	awful.spawn.with_shell("maim -su " .. tmp_png())
end

function M.copy_window()
	awful.spawn.with_shell("maim -ui $(xdotool getactivewindow) | xclip -selection clipboard -t image/png")
end

function M.save_window()
	awful.spawn.with_shell("maim -ui $(xdotool getactivewindow) " .. tmp_png())
end

function M.copy_screen()
	awful.spawn.with_shell("maim -u | xclip -selection clipboard -t image/png")
end

function M.save_screen()
	awful.spawn.with_shell("maim -u " .. tmp_png())
end

return M
