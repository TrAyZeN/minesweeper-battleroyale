Gamestate = require "libs.hump.gamestate"
require "net.client"
require "grid"

local menu = {}
local game = {}

function menu:draw()
    love.graphics.print("Hey welcome on MineSweeper Battle Royale", 200, 200)
    love.graphics.print("Press enter to play", 200, 210)
end

function menu:keyreleased(key, code)
    if key == "return" then
        Gamestate.switch(game)
    end
end

function game:enter()
    client = Client()
    client:connect()
    print("Client started")
    client:sendMessage("I want the grid")
    grid = Grid(0, 0, 0, 0, 0)
end

function game:update(dt)
    local event = client:update()
    if event == nil or not (event.type == "receive") then
        return
    end

    if event.type == "receive" then
        local data = client:readMessage(event.data)
        -- client:disconnect(DisconnectReason.CONNECTION_TERMINATED)
        if data.type == "config" then
            grid = Grid(0, 0, 20, data.config.size.w, data.config.size.h)
        elseif data.type == "reveal" then
            if data.cellState == -1 then
                -- TODO: game over state
                print("Game over")
            else
                grid.grid[data.position.y][data.position.x] = data.cellState
            end
        end
    end
    return
end

function game:draw()
    grid:draw()
end

function game:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        local x, y = grid:getCellCoordinates(x, y)
        if grid.grid[y][x] == -1 then
            client:sendMessage({"reveal", {x, y}})
        end
    elseif button == 2 then
        grid:markCell(grid:getCellCoordinates(x, y))
    end
end

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end
