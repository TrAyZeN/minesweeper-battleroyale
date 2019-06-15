Class = require "libs.hump.class"
require "grid"
require "net.server"

Game = Class {
    init = function(self, name, maxPlayers, grid, password)
        self.name = name
        self.maxPlayers = maxPlayers <= 0 and 5 or maxPlayers
        self.grid = grid
        self.password = password
    end,
    name,
    maxPlayers,
    grid,
    password,
    players = {}
}

function Game:registerPlayer(peerIndex)
    if self.maxPlayers > #self.players then
        self.players[peerIndex] = true
        return true
    else
        return false
    end
end

function Game:isIn(peerIndex)
    return self.players[peerIndex] ~= nil
end

function Game:isAlive(peerIndex)
    return self.players[peerIndex]
end

function Game:toggleAlive(peerIndex)
    self.players[peerIndex] = not self.players[peerIndex]
end

function Game:setAlive(peerIndex, isAlive)
    self.players[peerIndex] = isAlive
end
