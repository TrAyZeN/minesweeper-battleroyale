game = require "states.game"
loveframes = require "libs.loveframes"
gameSettings = require "gamesettings"
joinGameMenu = require "states.joingamemenu"
createGameMenu = require "states.creategamemenu"
settingsMenu = require "states.settingsmenu"

local joinGameButton = loveframes.Create("button")
local createGameButton = loveframes.Create("button")
local settingsButton = loveframes.Create("button")
local quitButton = loveframes.Create("button")
local closeButton = loveframes.Create("button")

joinGameButton:Center()
joinGameButton:SetPos(540, 300)
joinGameButton:SetSize(200, 60)
joinGameButton:SetText("Join Game")
joinGameButton:SetState("mainmenu")
function joinGameButton:OnClick()
    closeButton:SetState("joingame")
    loveframes.SetState("joingame")
end

createGameButton:SetPos(540, 390)
createGameButton:SetSize(200, 60)
createGameButton:SetText("Create Game")
createGameButton:SetState("mainmenu")
function createGameButton:OnClick()
    closeButton:SetState("creategame")
    loveframes.SetState("creategame")
end

settingsButton:SetPos(540, 480)
settingsButton:SetSize(200, 60)
settingsButton:SetText("Settings")
settingsButton:SetState("mainmenu")
function settingsButton:OnClick()
    settingsMenu.screenResolutionMultichoice:SetText(string.format("%dx%d", gameSettings.windowSize.w, gameSettings.windowSize.h))
    settingsMenu.fullscreenCheckbox:SetChecked(gameSettings.fullscreen)
    settingsMenu.vsyncCheckbox:SetChecked(gameSettings.vsync)
    closeButton:SetState("settings")
    loveframes.SetState("settings")
end

quitButton:SetPos(540, 570)
quitButton:SetSize(200, 60)
quitButton:SetText("Quit")
quitButton:SetState("mainmenu")
function quitButton:OnClick()
    love.event.quit()
end

closeButton:SetPos(1140, 100)
closeButton:SetSize(40, 40)
closeButton:SetText("X")
function closeButton:OnClick()
    loveframes.SetState("mainmenu")
end


local menu = {}

function menu:enter()
    loveframes.SetState("mainmenu")
end

function menu:update(dt)
    loveframes.update(dt)
end

function menu:draw()
    loveframes.draw()
end

function menu:mousepressed(x, y, button)
    loveframes.mousepressed(x, y, button)
end

function menu:mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function menu:keypressed(key, code)
    loveframes.keypressed(key)
end

function menu:keyreleased(key, code)
    if key == "return" then
        Gamestate.switch(game)
    end
    loveframes.keyreleased(key)
end

return menu
