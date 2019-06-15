Class = require "libs.hump.class"
require "net.client"
game = require "states.game"

local menu = {}

function menu:draw()
    love.graphics.print("Hey welcome on MineSweeper Battle Royale", 200, 200)
    love.graphics.print("Press enter to play", 200, 210)
end

function menu:keyreleased(key, code)
    if key == "return" then
        Gamestate.switch(game)
    end
end

return menu
