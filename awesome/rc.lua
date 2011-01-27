-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")

-- Calendar
require("calendar2")

-- other widgets
require("vicious")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/ricardo/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- {{{ Variables
local home   = os.getenv("HOME")
local exec   = awful.util.spawn
-- }}}

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
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

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- tags = {}
-- for s = 1, screen.count() do
--     -- Each screen has its own tag table.
--     tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
-- end
-- Per screen/tags layout
-- layouts[1] refers to table above, which in this case is floating
tags = {
    settings = {
        -- first monitor
        { names  = { "www", "chrome", "mutt", 4, 5, 6 },
          layout = { layouts[1], layouts[1], layouts[2], layouts[2], layouts[2], layouts[2] }
        },
        -- second monitor
        { names  = { "gmail", "rss", 3, 4, 5, 6},
          layout = { layouts[1], layouts[1], layouts[2], layouts[2], layouts[2], layouts[2] }
        }
    }
}

for s = 1, screen.count() do
    tags[s] = awful.tag(tags.settings[s].names, s, tags.settings[s].layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })
-- }}}

-- Create a systray
mysystray = widget({ type = "systray" })

-- {{{ Weather widget
weathericon = widget({ type = 'imagebox' })
weathericon.image = image(beautiful.widget_weather)
weatherwidget = widget({ type = 'textbox' })
vicious.register(weatherwidget, vicious.widgets.weather, "${tempc}°/${tempf}° ${sky}  ", 3600, "KSFO")
-- }}}
-- {{{ CPU usage widget
cpugraph = awful.widget.graph()
cpugraph:set_width(40):set_height(20)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_gradient_angle(0):set_gradient_colors({ beautiful.fg_end_widget,
beautiful.fg_center_widget, beautiful.fg_widget })
vicious.register(cpugraph, vicious.widgets.cpu, "$1")
-- }}}
-- {{{ Network usage
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
-- Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, "${eth2 down_kb}K/${eth2 up_kb}K", 3)
-- }}}

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
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if client.focus == c then
                                                  c.minimized = true
                                              else 
                                                  if not c:isvisible() then
                                                    awful.tag.viewonly(c:tags()[1])
                                                  end
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
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        weatherwidget, weathericon,
        cpugraph.widget,
        upicon, netwidget, dnicon,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

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
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal, false) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    -- awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompts
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    -- to disable startup notification (see call to exec (... ,false))
    -- from http://git.sysphere.org/awesome-configs/tree/rc.lua
    -- awful.key({ modkey         }, "r",
    --     function ()
    --         awful.prompt.run({ prompt = "Run: " },
    --         mypromptbox[mouse.screen].widget,
    --         function (...) mypromptbox[mouse.screen].text = exec(unpack(arg), false) end,
    --         awful.completion.shell,
    --         awful.util.getdir("cache") .. "/history")
    --     end),
    awful.key({ modkey,           }, "F3", 
        function ()
            awful.prompt.run(
                { prompt = "Dict: " }, 
                mypromptbox[mouse.screen].widget,
                function (words) exec("dict "..words.." | ".."xmessage -timeout 10 -file -") end
            )
        end),
    awful.key({ modkey, "Shift"  }, "w", 
        function ()
            awful.prompt.run({ prompt = "Web: " }, 
            mypromptbox[mouse.screen].widget,
            function (url) exec("google-chrome "..url) end,
            nil,
            awful.util.getdir("cache") .. "/url_history")
        end),

    -- personalized shortcuts
    awful.key({ modkey,           }, "l",     function () exec("xscreensaver-command -lock", false)    end),
    awful.key({ modkey, "Shift"   }, "f",     function () 
                                                awful.tag.viewonly(tags[1][1])
                                                exec("/opt/firefox-4/firefox -no-remote -P minefield", false)    
                                              end),
    awful.key({ modkey, "Shift"   }, "m",     function () 
                                                awful.tag.viewonly(tags[2][1])
                                                exec("/opt/firefox-4/firefox -no-remote -P gmail", false)    
                                              end),
    awful.key({ modkey, "Shift"   }, "s",     function () 
                                                awful.tag.viewonly(tags[2][2])
                                                exec("/opt/firefox-4/firefox -no-remote -P reader", false)    
                                              end),
    awful.key({ modkey, "Shift"   }, "l",     function () exec(editor_cmd .. " " .. home .. "/privado/LIFE", false)    end),
    awful.key({ modkey, "Control" }, "m",     function () 
                                                exec(terminal .. " -title mutt -e mutt", false)
                                                awful.tag.viewonly(tags[1][3])  
                                              end),
    awful.key({ modkey,           }, "c",     function ()
                                                exec("google-chrome", false)  
                                                -- switch to the chrome desktop
                                                awful.tag.viewonly(tags[1][2])  
                                              end),
    awful.key({ modkey,           }, "v",     function()
                                                exec("vmware-view", false) 
                                              end),
    -- +, -, *, / in the numpad
--    awful.key({ modkey,           }, "#86",     function() exec("mpc next") end),
--    awful.key({ modkey,           }, "#82",     function() exec("mpc prev") end),
--    awful.key({ modkey,           }, "#63",     function() exec("mpc play") end),
--    awful.key({ modkey,           }, "#106",    function() exec("mpc pause") end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({ modkey, "Shift"   }, "n",
              function ()
                  local allclients = client.get(mouse.screen)
                  for _,c in ipairs(allclients) do
                      -- original was [mouse.screen] but that doesn't work
                      if c.minimized and c:tags()[1] == awful.tag.selected(mouse.screen) then
                          c.minimized = false
                          client.focus = c
                          c:raise()
                          return
                      end
                  end
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
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
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Gmpc" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "gkrellm" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --  properties = { tag = tags[1][1] } },
    { rule = { name = "mutt" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Google-chrome" },
      properties = { tag = tags[1][2] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
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
end)

client.add_signal("focus",
    function(c) 
        c.border_color = beautiful.border_focus
        c.opacity = 1
    end)
client.add_signal("unfocus", 
    function(c) 
        c.border_color = beautiful.border_normal 
        c.opacity = 0.8
    end)
-- }}}

-- {{{ autorun 
autorun = true
autorunApps = 
{
    "gmpc --start-hidden",
    "xsetroot -cursor_name left_ptr"
}
if autorun then
    for app =1, #autorunApps do
        awful.util.spawn(autorunApps[app], false)
    end
end
-- }}}

calendar2.addCalendarToWidget(mytextclock, "<span color='green'>%s</span>")