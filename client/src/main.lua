Gamestate = require "libs.hump.gamestate"
menu = require "states.menu"
gamesettings = require "gamesettings"

function love.load()
    if love.filesystem.getInfo("settings.cfg") then -- load settings if settings file exist
        if gamesettings:loadSettings() then
            gamesettings:applySettings()
        else
            gamesettings:loadDefault()
        end
    else
        gamesettings:loadDefault()
        gamesettings:save()
    end
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
