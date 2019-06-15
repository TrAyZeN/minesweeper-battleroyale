require "net.server"
require "grid"
require "game"
local uuid = require "libs.uuid"
require "libs.DataDumper"

function love.load(arg)
    server = Server(arg[1])
    server:bind()
    print("Minesweeper Battle Royale Server started on port " .. server.port)
    games = {}
    uuid.randomseed(os.time() * 10000)
end

function love.update(dt)
    local event = server:update()
    if event ~= nil and event.type == "connect" then
        print("New connection from peer number " .. event.peer:index())
        return
    elseif event ~= nil and event.type == "disconnect" then
        print("Peer number " .. event.peer:index() .. " disconnected with reason " .. (event.data == 0 and "TIMED_OUT" or DisconnectReason[event.data].name))
        return
    elseif event == nil or not (event.type == "receive") then
        return
    end
    local data = server:readMessage(event.data)
    if data['id'] == nil then
        return
    end
    local id = data['id']
    if id == 1 then -- Create game
        if data['name'] == nil or data['gridWidth'] <= 0 or data['gridHeight'] <= 0 or data['gridMines'] <= 0 then
            server:sendMessage(event.peer:index(), { id = 1, success = false, message = "Missing arguments in game creation request " })
            return
        end
        local uuid = uuid()
        local game = Game(data['name'], data['maxPlayers'], Grid(data['gridWidth'], data['gridHeight'], data['gridMines']), data['password'])
        game:registerPlayer(server, event.peer:index())
        games[uuid] = game
        print("Created a game with ID: " .. uuid)
        server:sendMessage(event.peer:index(), { id = 1, success = true, message = "Successfully created game " .. game.name, gameId = uuid })
        return
    elseif id == 2 then -- Join game
        if data['gameId'] == nil then
            server:sendMessage(event.peer:index(), { id = 2, success = false, message = "You need to specify the id of the game you want to join" })
            return
        end
        local game = games[data['gameId']]
        if game == nil then
            server:sendMessage(event.peer:index(), { id = 2, success = false, message = "Game does not exist" })
            return
        else
            if game:isIn(event.peer:index()) then
                server:sendMessage(event.peer:index(), { id = 2, success = false, message = "You are already in game " .. game.name })
                return
            else
                if game.password ~= nil and data['password'] == nil then
                    server:sendMessage(event.peer:index(), { id = 2, success = false, message = "Missing password to join game " .. game.name })
                    return
                else
                    if game.password ~= data['password'] then
                        server:sendMessage(event.peer:index(), { id = 2, success = true, message = "Wrong password to join game " .. game.name })
                        return
                    else
                        server:sendMessage(event.peer:index(), { id = 2, success = true, gridConfig = game.grid:getConfig() })
                        game:registerPlayer(server, event.peer:index())
                        return
                    end
                end
            end
        end
    elseif id == 3 then -- Chat
        if data['gameId'] == nil then
            server:sendMessage(event.peer:index(), { id = 3, success = false, message = "You need to specify the id of the game you want to chat in" })
            return
        end
        local game = games[data['gameId']]
        if game == nil then
            server:sendMessage(event.peer:index(), { id = 3, success = false, message = "Game does not exist" })
            return
        elseif not game:isIn(event.peer:index()) then
            server:sendMessage(event.peer:index(), { id = 3, success = false, message = "You can't chat in this game" })
            return
        elseif data['message'] == nil then
            server:sendMessage(event.peer:index(), { id = 3, success = false, message = "You should specify a message to send in the chat" })
            return
        elseif data['username'] == nil then
            server:sendMessage(event.peer:index(), { id = 3, success = false, message = "You should specify your username to send a message in the chat" })
            return
        else
            server:broadcast({ id = 3, username = data['username'], message = data['message']})
            return
        end
    elseif id == 4 then -- Cell reveal
        if data['gameId'] == nil then
            server:sendMessage(event.peer:index(), { id = 4, success = false, message = "You need to specify the id of the game you are actually in" })
            return
        end
        local game = games[data['gameId']]
        if game == nil then
            server:sendMessage(event.peer:index(), { id = 4, success = false, message = "Game does not exist" })
            return
        elseif not game:isIn(event.peer:index()) then
            server:sendMessage(event.peer:index(), { id = 4, success = false, message = "You are not present in this game" })
            return
        elseif not game:isAlive(event.peer:index()) then
            server:sendMessage(event.peer:index(), { id = 4, success = false, message = "You are dead, so you can't reveal any cell" })
            return
        elseif data['cell'] == nil then
            server:sendMessage(event.peer:index(), { id = 4, success = false, message = "You should specify a cell to reveal" })
            return
        else
            server:sendMessage(event.peer:index(), { id = 4, success = true, cells = game.grid:revealCells(data['cell'][1], data['cell'][2]) })
            return
        end
    end
end
