-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
-- require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Vicious Library
local vicious = require("vicious")
-- BlingBling Library
local blingbling = require("blingbling")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Get home variable

local home = os.getenv("HOME")
local confdir = home .. "/.config/awesome"
local themes = confdir .. "/themes"

local active_theme = themes .. "/bamboo"

-- }}}



-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(active_theme.."/theme.lua")

-- {{{ Customize theme
theme.wallpaper = "/mnt/softs/luu_tam/Anime/sket_dance_flag_by_dreadlol-d525sle.png"

--theme.bg_normal     = "#d4eee8aa"
--theme.bg_focus      = "#d4eee8ee"
--theme.bg_urgent     = "#ff0000ee"
--theme.bg_minimize   = "#7aab9fee"
--theme.bg_systray    = theme.bg_normal

--theme.fg_normal     = "#535d6c"
--theme.fg_focus      = "#535d6c"
--theme.fg_urgent     = "#535d6c"
--theme.fg_minimize  = "#535d6c"

--theme.border_width  = "1"
--theme.border_normal = "#D4EEE8"
--theme.border_focus  = "#535d6c"


-- }}}

-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = os.getenv("EDITOR") or "emacs"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- {{{ Create some self function

function get_num_of_cores()
   local files = {}
   local tmpfiles = '/tmp/numofcores.txt'
   os.execute('nproc > '..tmpfiles )
   local f = io.open(tmpfiles)
   if not f then
-- Remove tmp file
      os.execute('rm -f '..tmpfiles)
      return 0
   end
--   local coresnum = f.read("*number")
   local coresnum = f:read("*number")
   f:close()
-- Remove tmp file
   os.execute('rm -f '..tmpfiles)
   return coresnum
end


function get_mem_usage()
   local memdata = {}
   memdata = vicious.widgets.mem()
   return "load: "..(memdata[1]).."% "..(memdata[2]).."MB/"..(memdata[3]).."MB"
end


-- }}}


-- {{{ Setup some blingbling and vicious widget

-- Date (textbox)
-- Initialize widget
datewidget = wibox.widget.textbox()
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%A, %F, %B, %R ", 30)

-- Clock widget
clockwidget = blingbling.clock.japanese(" %m、%d、%w、<span color=\"#ffffff\">%H<span color=\""
                                           ..blingbling.helpers.rgb(20,31,82)..
                                           "\">時</span>%M<span color=\""
                                           ..blingbling.helpers.rgb(20,31,82)..
                                           "\">分</span> </span>")

-- Calendar widget
calendarwidget = blingbling.calendar({ widget = clockwidget })
calendarwidget:set_link_to_external_calendar(true)


-- Initialize widget
memwidgetlabel = wibox.widget.textbox()
memwidgetlabel:set_text(' RAM:')

cpuwidgetlabel = wibox.widget.textbox()
cpuwidgetlabel:set_text(' CPU:')


--for i, v in ipairs(memdata) do
--   naughty.notify({ preset = naughty.config.presets.critical,
--                    title = "Test variable",
--                    text = i.."   "..v
--                    text = memdata[2]
--                    text = "test"
--                  })
--end

-- Memory usage (progressbar)
-- Initialize widget
memwidgetpb = blingbling.line_graph({ height = 18,
                                      width = 130,
                                      show_text = true,
                                      label = "load: 0% 0MB/0MB",
                                      rounded_size = 0.3,
                                      background_color = "#00000033",
                                      graph_background_color = "#00000033",
                                      graph_color = "#9d2b2aee",
                                      graph_line_color = "#f19fa0ee"
                                    })
-- Progressbar properties
-- Register widget
vicious.register(memwidgetpb, vicious.widgets.mem, "$1", 2)
-- Use some timer trick for show mem usage
memshowtimer = timer({ timeout = 2 })
memshowtimer:connect_signal("timeout", function()
                               memwidgetpb:set_label(get_mem_usage())
                                       end)
memshowtimer:start()
                              


-- CPU usage (graph)
-- Initialize widget
cpuwidgetgp = blingbling.line_graph({ height = 18,
                                      width = 50,
                                      show_text = true,
                                      label = "load: $percent%",
                                      rounded_size = 0.3,
                                      background_color = "#00000033",
                                      graph_background_color = "#00000033",
                                      graph_color = "#9d2b2aee",
                                      graph_line_color = "#f19fa0ee"
                                    })

-- Register widget
vicious.register(cpuwidgetgp, vicious.widgets.cpu, "$1", 2)


-- CPU cores usage (graph)
num_of_cores = 0
num_of_cores = get_num_of_cores()

cores_graph_conf = { height = 18,
                     width = 18,
                     rounded_size = 0.3 ,
                     show_text = true,
                     label = "$percent%",
                     background_color = "#00000033",
                     graph_background_color = "#00000033",
                     graph_color = "#9d2b2aee",
                     graph_line_color = "#f19fa0ee"

}
cores_graphs = {}
for i=1,num_of_cores do
   cores_graphs[i] = blingbling.progress_graph( cores_graph_conf )
   vicious.register(cores_graphs[i], vicious.widgets.cpu, "$"..(i+1).."", 2)
end


-- MPD Status (textbox)
-- Initialize widget
--mpdwidget = wibox.widget.textbox()
-- Register widget
--vicious.register(mpdwidget, vicious.widgets.mpd,
--    function (mpdwidget, args)
--        if args["{state}"] == "Stop" then 
--            return " - "
--        else 
--            return args["{Artist}"]..' - '.. args["{Title}"]
--        end
--    end, 10)


-- Net widget
--netwidget = blingbling.net({interface = "xenbr0", show_text = true})
--netwidget:set_ippopup()

-- Add some popup
-- Add CPU popup
-- Example with custom colors:
blingbling.popups.htop(cpuwidgetgp, 
                       { title_color = beautiful.notify_font_color_1 , 
                         user_color = beautiful.notify_font_color_2 , 
                         root_color = beautiful.notify_font_color_3 , 
                         terminal =  terminal })




-- }}}





-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = { 
  names = { "Ƹ̵̡Ӝ̵̨̄Ʒ" , "♥❄♥" , "☆" , "( ≧Д≦)" , "(ノಠ益ಠ)ノ彡┻━┻" } ,
  layout = { layouts[1], layouts[1], layouts[2] , layouts[2], layouts[2] }
}

for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag( tags.names ,s, tags.layout )
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
-- mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height = 18, screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
--    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(memwidgetlabel)
    right_layout:add(memwidgetpb)
    right_layout:add(cpuwidgetlabel)
    right_layout:add(cpuwidgetgp)
    for i=1,num_of_cores do
       right_layout:add(cores_graphs[i])
    end
--    right_layout:add(netwidget)
--    right_layout:add(mytextclock)
--    right_layout:add(datewidget)
    right_layout:add(clockwidget)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
--  awful.key({ modkey }, "F12", function () awful.util.spawn("xlock") end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    awful.key({ altkey }, "Tab", function ()
       -- If you want to always position the menu on the same place set coordinates
--       awful.menu.menu_keys.down = { "Down", "Alt_L" }
--       awful.menu:clients({theme = { width = 250 }}, { keygrabber=true, coords={x=525, y=330} })
        for c in awful.client.iterate(function (x) return true end) do
            client.focus = c
            client.focus:raise()
        end
    end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
--    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),

    -- Title bar visibility
    awful.key({ modkey, "Shift" }, "t", function (c)
        -- if   c.titlebar then awful.titlebar.remove(c)
        -- else awful.titlebar.add(c, { modkey = modkey }) end
        awful.titlebar.toggle(c, "top")
    end),

    --  Moving Window to Workspace Left/Right
    awful.key({ modkey, "Shift"   }, ",",
       function (c)
           local curidx = awful.tag.getidx()
           if curidx == 1 then
               awful.client.movetotag(tags[client.focus.screen][9])
           else
               awful.client.movetotag(tags[client.focus.screen][curidx - 1])
           end
       end),
   awful.key({ modkey, "Shift"   }, ".",
       function (c)
           local curidx = awful.tag.getidx()
           if curidx == 9 then
               awful.client.movetotag(tags[client.focus.screen][1])
           else
               awful.client.movetotag(tags[client.focus.screen][curidx + 1])
           end
   end)

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "vlc" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
        awful.titlebar.hide(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}
