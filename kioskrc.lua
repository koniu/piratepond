----< burn me kiosk config / awesome 3.4.4+git >----
--{{{ load modules

require("awful")
require("awful.rules")
require("naughty")
require("beautiful")

--}}}
--{{{ common settings

-- initialize color theme
beautiful.init("/usr/share/awesome/themes/default/theme.lua")

-- notifications
naughty.config.padding = 12
naughty.config.default_preset = {
  border_width = 0,
  margin = 20,
  screen = 1,
  position = "top_left"
}

--}}}
--{{{ tag / layout settings

t = tag({})
t.screen = 1
t.selected = true
awful.tag.setproperty(t, "nmaster", 2)
awful.tag.setproperty(t, "mwfact", 0.75)
awful.tag.setproperty(t, "layout", awful.layout.suit.tile.bottom)

--}}}
--{{{ window rules

awful.rules.rules = {

    { rule = {},
      properties = {
          border_width = 10,
          border_color = '#1D1D1D',
          size_hints_honor = false
      } },

    { rule = { instance = "burn" },
        callback = function(c)
            awful.client.setslave(c)
 --           c.hidden = true
        end },
}

--}}}
--{{{ bindings

root.keys(awful.util.table.join(
    awful.key({ }, "F1", function()  end ),
    awful.key({ }, "F2", function()  end ),
    awful.key({ }, "F3", function()  end ),
    awful.key({ }, "F4", function()  end ),
    awful.key({ }, "F5", function() awful.util.spawn("eject -T") end ),
    awful.key({ }, "F6", function() 
        awful.util.spawn_with_shell("xterm -rv -bg 'white' -fg '#150300' -name burn -e sh burnaudio.sh")
    end ),
    awful.key({ }, "F7", function()  end ), 
    awful.key({ }, "F8", function()  end ), 
    awful.key({ }, "F9", function()  end ), 
    awful.key({ }, "F10", function()  end ),
    awful.key({ }, "F11", function()  end ),
   -- awful.key({ }, "F12", function() getclient("instance", "burn").hidden = false end ),
    awful.key({ "Mod1" }, "Tab", function() awful.client.focus.byidx(1) end )
))

--}}}
--{{{ signals 

client.add_signal("manage", function (c, startup)
    -- sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)
end)

client.add_signal("focus", function(c) c.border_color = '#4A4A4A' end)
client.add_signal("unfocus", function(c) c.border_color = '#1D1D1D' end)

--}}}
--{{{ autostart 

awful.util.spawn("pkill xterm")
awful.util.spawn_with_shell("sleep 2; xterm -rv -name player -e ncmpcpp")
awful.util.spawn_with_shell("sleep 1; xterm  -rv -name docs -e elinks http://en.wikipedia.org/wiki/Piracy")
--awful.util.spawn_with_shell("sleep 1; xterm  -rv -bg 'white' -fg '#150300' -name burn -e tail -f ~/burning")

io.stderr:write("--- loaded config ---\n")

--}}}
-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=2:tabstop=2:softtabstop=2:encoding=utf-8:textwidth=80
