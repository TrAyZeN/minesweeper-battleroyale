Gamestate = require "libs.hump.gamestate"
menu = require "menu"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
