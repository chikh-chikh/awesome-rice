local capi = Capi
local awful = require("awful")
local beautiful = require("theme.theme")
local wibox = require("wibox")
local dpi = Dpi
local config = require("rice.config")
local binding = require("core.binding")
local mod = binding.modifier
local btn = binding.button
local layoutbox_widget = require("ui.topbar.layoutbox")
local clientlist_widget = require("ui.topbar.clientlist")
local taglist_widget = require("ui.topbar.taglist")
local systray_widget = require("ui.topbar.systray")
local torrent_widget = require("ui.topbar.torrent")
local network_widget = require("ui.topbar.network")
local volume_widget = require("ui.topbar.volume")
local weather_widget = require("ui.topbar.weather")
local datetime_widget = require("ui.topbar.datetime")
local tools_widget = require("ui.topbar.tools")
local power_widget = require("ui.topbar.power")
local media_player_widget = require("ui.topbar.media_player")

local keyboardlayout = awful.widget.keyboardlayout()

capi.screen.connect_signal("request::desktop_decoration", function(screen)
    ---@cast screen screen

    local is_primary = screen == capi.screen.primary
    local wibar = awful.wibar({
        position = "top",
		opacity = 0.9,
        screen = screen,
        widget = {
            layout = wibox.layout.align.horizontal,
            expand = "outside",
            {
                id = "#left",
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.wibar.spacing,
            },
            {
                layout = wibox.container.margin,
                left = beautiful.wibar.spacing * 2,
                right = beautiful.wibar.spacing * 2,
                {
                    id = "#middle",
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.wibar.spacing,
                },
            },
            {
                id = "#right",
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.wibar.spacing,
                reverse = true,
            },
        },
    })

    ---@class screen
    ---@field topbar table
    screen.topbar = {
        wibox = wibar,
        clientlist = clientlist_widget.new(wibar),
        systray = is_primary and systray_widget.new(wibar),
        taglist = taglist_widget.new(wibar),
    }

    local left = wibar:get_children_by_id("#left")[1]
    left:add(layoutbox_widget.new(wibar))
    left:add(screen.topbar.clientlist)
    -- if is_primary then
    --     left:add(media_player_widget.new(wibar))
    -- end

    local middle = wibar:get_children_by_id("#middle")[1]
    middle:add(screen.topbar.taglist)

    local right = wibar:get_children_by_id("#right")[1]
    if is_primary then
        right:add(keyboardlayout)
        if config.features.torrent_widget then
            right:add(torrent_widget.new(wibar))
        end
        -- right:add(network_widget.new(wibar))
        right:add(volume_widget.new(wibar))
        if config.features.weather_widget then
            right:add(weather_widget.new(wibar))
        end
        right:add(tools_widget.new(wibar))
        right:add(systray_widget.new(wibar))
        -- right:add(datetime_widget.new(wibar))
        right:add(power_widget.new(wibar))
    else
        right:add(power_widget.new(wibar))
    end

    local wibar_bottom = awful.wibar({
        position = "bottom",
        screen = screen,
        widget = {
            layout = wibox.layout.align.horizontal,
            expand = "outside",
            {
                id = "#left",
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.wibar.spacing,
            },
            {
                layout = wibox.container.margin,
                left = beautiful.wibar.spacing * 2,
                right = beautiful.wibar.spacing * 2,
                {
                    id = "#middle",
                    layout = wibox.layout.fixed.horizontal,
                    spacing = beautiful.wibar.spacing,
                },
            },
            {
                id = "#right",
                layout = wibox.layout.fixed.horizontal,
                spacing = beautiful.wibar.spacing,
                reverse = true,
            },
        },
    })
    ---@class screen
    ---@field bottombar table
    screen.bottombar = {
        wibox = wibar,
        clientlist = clientlist_widget.new(wibar_bottom),
        systray = is_primary and systray_widget.new(wibar_bottom),
        taglist = taglist_widget.new(wibar_bottom),
    }
    local left_b = wibar_bottom:get_children_by_id("#left")[1]
    left_b:add(datetime_widget.new(wibar_bottom))
    -- left_b:add(layoutbox_widget.new(wibar_bottom))
    if is_primary then
        left_b:add(media_player_widget.new(wibar_bottom))
    end

    local right_b = wibar_bottom:get_children_by_id("#right")[1]
    if is_primary then
        if config.features.torrent_widget then
            right_b:add(torrent_widget.new(wibar_bottom))
        end
        right_b:add(network_widget.new(wibar_bottom))
    else
        right_b:add(power_widget.new(wibar_bottom))
    end
end)
