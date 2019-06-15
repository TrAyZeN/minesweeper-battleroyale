require "net.server"
require "grid"
require "game"
local uuid = require "libs.uuid"

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
                        server:sendMessage(event.peer:index(), { id = 2, success = true, message = "Successfully joined game " .. game.name })
                        game:registerPlayer(server, event.peer:index())
                        return
                    end
                end
            end
        end
    end
end
