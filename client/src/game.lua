Class = require "libs.hump.class"
require "net.client"
require "grid"

local game = {}

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
        if x >= 1 and y >= 1 and x <= grid.size.w and y <= grid.size.h then
            if grid.grid[y][x] == -1 then   -- if cell is unrevealed
                client:sendMessage({"reveal", {x, y}})
            end
        end
    elseif button == 2 then
        grid:markCell(grid:getCellCoordinates(x, y))
    end
end

return game
