game = require "states.game"
loveframes = require "libs.loveframes"

local gameList = loveframes.Create("list")
local joinGameButton = loveframes.Create("button")

gameList:SetPos(100, 100)
gameList:SetSize(200, 200)
gameList:SetState("joingame")

joinGameButton:SetPos(100, 400)
joinGameButton:SetSize(80, 20)
joinGameButton:SetText("Join Game")
joinGameButton:SetState("joingame")
function joinGameButton:OnClick()
    loveframes.SetState("game")
    Gamestate.switch(game)
end

local joinGameMenu = {
    gameList = gameList,
    joinGameButton = joinGameButton
}

return joinGameMenu
