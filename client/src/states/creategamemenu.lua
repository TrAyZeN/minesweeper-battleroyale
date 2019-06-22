loveframes = require "libs.loveframes"

local gameNameTextinput = loveframes.Create("textinput")
local maxPlayersNumberbox = loveframes.Create("numberbox")
local gridWidthNumberbox = loveframes.Create("numberbox")
local gridHeightNumberbox = loveframes.Create("numberbox")
local gridMinesNumberbox = loveframes.Create("numberbox")
local confirmCreateGameButton = loveframes.Create("button")

gameNameTextinput:SetPos(200, 100)
gameNameTextinput:SetState("creategame")

maxPlayersNumberbox:SetPos(200, 140)
maxPlayersNumberbox:SetMin(2)
maxPlayersNumberbox:SetState("creategame")

gridWidthNumberbox:SetPos(200, 180)
gridWidthNumberbox:SetMin(2)
gridWidthNumberbox:SetState("creategame")

gridHeightNumberbox:SetPos(200, 220)
gridHeightNumberbox:SetMin(2)
gridHeightNumberbox:SetState("creategame")

gridMinesNumberbox:SetPos(200, 260)
gridMinesNumberbox:SetMin(2)
gridMinesNumberbox:SetState("creategame")

confirmCreateGameButton:SetPos(200, 320)
confirmCreateGameButton:SetText("Create game")
confirmCreateGameButton:SetState("creategame")

local createGameWidgets = {
    gameNameTextinput = gameNameTextinput,
    maxPlayersNumberbox = maxPlayersNumberbox,
    gridWidthNumberbox = gridWidthNumberbox,
    gridHeightNumberbox = gridHeightNumberbox,
    gridMinesNumberbox = gridMinesNumberbox,
    confirmCreateGameButton = confirmCreateGameButton
}

return createGameWidgets
