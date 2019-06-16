require "net.client"
require "grid"

local game = {}

function game:enter()
    client = Client()
    client:connect()
    client:sendMessage({ id = 1, name = "Test Game", maxPlayers = 10, gridWidth = 10, gridHeight = 10, gridMines = 15 })
    grid = Grid(0, 0, 0, 0, 0)
end

function game:update(dt)
    local event = client:update()
    if event == nil or not (event.type == "receive") then
        return
    end

    if event.type == "receive" then
        local data = client:readMessage(event.data)
        if data['id'] == 1 then
            gameId = data['gameId']
            grid = Grid(0, 0, 20, data['gridConfig']['size']['w'], data['gridConfig']['size']['h'])
        elseif data['id'] == 4 then
            local cells = data['cells']
            for k, v in pairs(cells) do
                if v == -1 then
                    -- TODO: game over state
                    print("Game over")
                else
                    if grid.grid[k[2]][k[1]] ~= -2 and grid.grid[k[2]][k[1]] ~= -3 then     -- don't reveal flagged and interrogation cells
                        grid.grid[k[2]][k[1]] = v
                    end
                end
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
            if grid.grid[y][x] == -1 then
                -- if cell is unrevealed
                client:sendMessage({ id = 4, cell = { x, y }, gameId = gameId })
            end
        end
    elseif button == 2 then
        grid:markCell(grid:getCellCoordinates(x, y))
    end
end

return game
