Gamestate = require "libs.hump.gamestate"
menu = require "states.menu"

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
