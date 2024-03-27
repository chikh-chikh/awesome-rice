-- DEPENDENCIES (feature flag "wallpaper_menu"): feh, cp, ls

local config = require("rice.config")
if not config.features.wallpaper_menu then
    return
end

local popen = io.popen
local match = string.match
local format = string.format
local insert = table.insert
local awful = require("awful")
local gfilesystem = require("gears.filesystem")
local core = require("core")
local places = require("rice.places")

local feh_prefix = ".fehbg"
local feh_script = core.path.home .. "/" .. feh_prefix

local wallpaper_service = {}

-- local feh = {}
-- function feh.set_script()
--     return "#!/bin/sh \nfeh --bg-fill --randomize ~/.config/awesome/theme/wallpaper/still"
-- end
-- awful.spawn(format("echo -e '%s' >'%s'", feh.set_script, feh_script))

awful.spawn.with_shell('echo -e "#!/bin/bash \nfeh --no-fehbg --bg-fill --randomize ~/.config/awesome/theme/wallpaper/still" >~/.fehbg')
awful.spawn(feh_script)

function wallpaper_service.get_collections()
    local collections = {}

    local directory = places.wallpapers
    local file = popen(format('ls -a "%s"', directory))
    if file then
        for filename in file:lines() do
            local name = match(filename, "^" .. feh_prefix .. ".(.+)")
            if name then
                insert(collections, {
                    name = name,
                    path = directory .. "/" .. filename,
                })
            end
        end
        file:close()
    end

    return collections
end

function wallpaper_service.set_collection(collection)
    awful.spawn(format('cp "%s" "%s"', collection.path, feh_script))
    wallpaper_service.restore()
end

function wallpaper_service.restore()
    if gfilesystem.file_executable(feh_script) then
        awful.spawn(feh_script)
    end
end

return wallpaper_service
