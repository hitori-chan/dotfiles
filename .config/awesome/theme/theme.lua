local gears                 = require('gears')
local themes_path           = gears.filesystem.get_configuration_dir() .. 'theme/'
local dpi                   = require('beautiful.xresources').apply_dpi

-- {{{ Main
local theme                 = {}
theme.wallpaper             = themes_path .. 'background.jpg'
-- }}}

-- {{{ Styles
theme.font                  = 'Fira Code 9'
theme.font_icon             = 'Material Icons Round 15'
theme.systray_icon_spacing  = 10

-- {{{ Colors
theme.fg_normal             = '#AAAAAA'
theme.fg_focus              = '#32D6FF'
theme.fg_urgent             = '#C83F11'

theme.bg_normal             = '#131313'
theme.bg_focus              = '#1E2320'
theme.bg_urgent             = '#3F3F3F'
theme.bg_systray            = theme.bg_normal

theme.red                   = '#FF6961'
theme.green                 = '#77DD77'
-- }}}

-- {{{ Borders
theme.useless_gap           = dpi(0)
theme.border_width          = dpi(1)
theme.border_normal         = '#3F3F3F'
theme.border_focus          = '#6F6F6F'
theme.border_marked         = '#CC9393'
-- }}}

-- {{{ Taglist
theme.taglist_fg_focus      = '#00CCFF'
-- }}}

-- {{{ Tasklist
theme.tasklist_bg_focus     = theme.bg_normal
theme.tasklist_fg_focus     = theme.taglist_fg_focus
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color    = '#CC9393'
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height           = dpi(15)
theme.menu_width            = dpi(100)
-- }}}
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = themes_path .. 'taglist/squarefz.png'
theme.taglist_squares_unsel = themes_path .. 'taglist/squarez.png'
--theme.taglist_squares_resize = 'false'
-- }}}

-- {{{ Misc
theme.awesome_icon          = themes_path .. 'awesome-icon.png'
theme.menu_submenu_icon     = themes_path .. 'submenu.png'
-- }}}

-- {{{ Layout
theme.layout_tile           = themes_path .. 'layouts/tile.png'
theme.layout_tileleft       = themes_path .. 'layouts/tileleft.png'
theme.layout_tilebottom     = themes_path .. 'layouts/tilebottom.png'
theme.layout_tiletop        = themes_path .. 'layouts/tiletop.png'
theme.layout_fairv          = themes_path .. 'layouts/fairv.png'
theme.layout_fairh          = themes_path .. 'layouts/fairh.png'
theme.layout_spiral         = themes_path .. 'layouts/spiral.png'
theme.layout_dwindle        = themes_path .. 'layouts/dwindle.png'
theme.layout_max            = themes_path .. 'layouts/max.png'
theme.layout_fullscreen     = themes_path .. 'layouts/fullscreen.png'
theme.layout_magnifier      = themes_path .. 'layouts/magnifier.png'
theme.layout_floating       = themes_path .. 'layouts/floating.png'
theme.layout_cornernw       = themes_path .. 'layouts/cornernw.png'
theme.layout_cornerne       = themes_path .. 'layouts/cornerne.png'
theme.layout_cornersw       = themes_path .. 'layouts/cornersw.png'
theme.layout_cornerse       = themes_path .. 'layouts/cornerse.png'
-- }}}
-- }}}

return theme
