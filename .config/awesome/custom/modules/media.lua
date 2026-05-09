local awful = require("awful")

local M = {}

local function playerctl(command)
	awful.spawn({ "playerctl", command })
end

function M.next()
	playerctl("next")
end

function M.previous()
	playerctl("previous")
end

function M.stop()
	playerctl("stop")
end

function M.play_pause()
	playerctl("play-pause")
end

return M
