require "net.client"
require "grid"
loveframes = require "libs.loveframes"

local messageList = loveframes.Create("list")
messageList:SetPos(0, 600)
messageList:SetSize(240, 100)
messageList:SetSpacing(5)
messageList:SetAutoScroll(true)
messageList:SetState("game")

local textInput = loveframes.Create("textinput")
textInput:SetPos(0, 700)
textInput:SetSize(240, 20)
textInput:SetState("game")

local game = {}

function game:enter()
    client = Client()
    client:connect()
    client:sendMessage({ id = 1, name = "Test Game", maxPlayers = 10, gridWidth = 10, gridHeight = 10, gridMines = 20 })
    grid = Grid(0, 0, 0, 0, 0)
end

function game:update(dt)
    loveframes.update(dt)

    local event = client:update()
    if event == nil or not (event.type == "receive") then
        return
    end

    if event.type == "receive" then
        local data = client:readMessage(event.data)
        if data['id'] == 1 then
            gameId = data['gameId']
            grid = Grid(0, 0, 20, data['gridConfig']['size']['w'], data['gridConfig']['size']['h'])
        elseif data['id'] == 3 then
            local messageText = loveframes.Create("text")
            messageText:SetText(string.format("%s: %s", data['username'], data['message']))
            messageList:AddItem(messageText)
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
    loveframes.draw()

    grid:draw()
end

function game:mousepressed(x, y, button, istouch, presses)
    loveframes.mousepressed(x, y, button)

    if button == 1 then
        local x, y = grid:getCellCoordinates(x, y)
        if x >= 1 and y >= 1 and x <= grid.size.w and y <= grid.size.h then
            if grid.grid[y][x] == -1 then
                -- if cell is unrevealed
                client:sendMessage({ id = 4, cell = { x, y }, gameId = gameId })
            end
        end
    elseif button == 2 then
        -- TODO: check if there is no more flags + send flagged cells to server
        grid:markCell(grid:getCellCoordinates(x, y))
    end
end

function game:mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function game:keypressed(key, code)
    if key == "return" then
        if textInput:GetFocus() then    -- sends message to server
            local message = textInput:GetText()
            if message ~= "" then
                client:sendMessage({ id = 3, gameId = gameId, username = "username", message = message })
                textInput:SetText("")
            end
        else
            textInput:SetFocus(true)
        end
    end
    loveframes.keypressed(key)
end

function game:keyreleased(key, code)
    loveframes.keyreleased(key)
end

function love.textinput(text)
	loveframes.textinput(text)
end

return game
