local beautiful = require("beautiful")
local naughty = require("naughty")

local M = {}
M.__index = M
local icon_cache = {}
local random_seeded = false
local settings = {
	icon_dir = nil,
}
local image_extensions = {
	bmp = true,
	gif = true,
	jpeg = true,
	jpg = true,
	png = true,
	svg = true,
	webp = true,
}

local function seed_random()
	if random_seeded then
		return
	end

	random_seeded = true
	math.randomseed(os.time())
end

local function shell_quote(value)
	return "'" .. tostring(value):gsub("'", [['"'"']]) .. "'"
end

local function is_image_path(path)
	local extension = path:match("%.([%w]+)$")
	return extension and image_extensions[extension:lower()]
end

local function scan_icon_dir(dir)
	local icons = {}
	local handle = io.popen("find -L " .. shell_quote(dir) .. " -type f 2>/dev/null")
	if not handle then
		return icons
	end

	for icon in handle:lines() do
		if is_image_path(icon) then
			table.insert(icons, icon)
		end
	end

	handle:close()
	return icons
end

local function random_icon_from_dir(dir)
	if not dir or dir == "" then
		return nil
	end

	if not icon_cache[dir] then
		icon_cache[dir] = scan_icon_dir(dir)
	end

	local icons = icon_cache[dir]
	if #icons == 0 then
		return nil
	end

	seed_random()
	return icons[math.random(#icons)]
end

local function notification_icon()
	return random_icon_from_dir(settings.icon_dir) or beautiful.awesome_icon
end

function M.configure(opts)
	opts = opts or {}
	settings.icon_dir = opts.icon_dir or settings.icon_dir
end

function M.new()
	return setmetatable({
		icon = nil,
		id = nil,
	}, M)
end

function M:send(text, title)
	self.icon = self.icon or notification_icon()
	self.id = naughty.notify({
		title = title,
		text = text,
		icon = self.icon,
		replaces_id = self.id,
	}).id
end

return M
