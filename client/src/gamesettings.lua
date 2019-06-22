Class = require "libs.hump.class"

GameSettings = Class {
    windowSize = {},
    fullscreen,
    vsync,
    volume
}

function GameSettings:loadDefault()
    self.windowSize = { w = 1280, h = 720 }
    self.fullscreen = false
    self.vsync = true
    self.volume = 1
end

function GameSettings:loadSettings()
    local size = love.filesystem.getInfo("settings.cfg").size
    local content = love.filesystem.read("settings.cfg", size)
    if content == nil then
        print("An error occured while loading settings")
        return false
    end

    for line in string.gmatch(content, "%S+") do
        local parameter, argument = line:sub(1, line:find("=")-1), line:sub(line:find("=")+1, line:find("\n"))
        if parameter == "windowwidth" then
            self.windowSize.w = tonumber(argument)
        elseif parameter == "windowheight" then
            self.windowSize.h = tonumber(argument)
        elseif parameter == "fullscreen" then
            self.fullscreen = argument == "true"
        elseif parameter == "vsync" then
            self.vsync = argument == "true"
        elseif parameter == "volume" then
            self.volume = tonumber(argument)
        end
    end
    return true
end

function GameSettings:save()
    local settings = ""
    settings = settings .. string.format("windowwidth=%d\n", self.windowSize.w)
    settings = settings .. string.format("windowheight=%d\n", self.windowSize.h)
    settings = settings .. string.format("fullscreen=%s\n", self.fullscreen)
    settings = settings .. string.format("vsync=%s\n", self.vsync)
    settings = settings .. string.format("volume=%d\n", self.volume)
    local success, message = love.filesystem.write("settings.cfg", settings, settings:len())
    return success, message
end

function GameSettings:applySettings()
    local flags = {
        fullscreen = self.fullscreen,
        vsync = self.vsync
    }
    local success = love.window.setMode(self.windowSize.w, self.windowSize.h, flags)
    return success
end

return GameSettings()
