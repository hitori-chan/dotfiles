-- hyprland.lua — entry point. Hyprland >= 0.55 Lua config —
-- https://wiki.hypr.land/Configuring/Start/
-- Layout of this config:
--   theme.lua   colors, fonts, shared metrics — the one source
--   core.lua    monitors, env, autostart, input, misc, render
--   look.lua    borders, colors, the plugins' theme values
--   binds.lua   every keybinding, awesome-faithful (and the keybind reference)
--   rules.lua   window / workspace rules
--   (the bar, maximize, snapping, click policy, and placement are native
--    plugins, managed by hyprpm — github.com/hitori-chan/hyprland-plugins)
--
-- Reloads automatically on save; `hyprctl reload` forces it.
-- For editor autocompletion, point lua-language-server at /usr/share/hypr/stubs.

require("core")
require("look")
require("binds")
require("rules")
