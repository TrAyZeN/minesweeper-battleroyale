game = require "states.game"
creategame = require "states.creategame"
settings = require "states.settings"
loveframes = require "libs.loveframes"


local joinGameButton = loveframes.Create("button")
joinGameButton:Center()
joinGameButton:SetPos(20, 380)
joinGameButton:SetSize(200, 60)
joinGameButton:SetText("Join Game")
joinGameButton:SetState("mainmenu")

local createGameButton = loveframes.Create("button")
createGameButton:SetPos(20, 460)
createGameButton:SetSize(200, 60)
createGameButton:SetText("Create Game")
createGameButton:SetState("mainmenu")

local settingsButton = loveframes.Create("button")
settingsButton:SetPos(20, 540)
settingsButton:SetSize(200, 60)
settingsButton:SetText("Settings")
settingsButton:SetState("mainmenu")

local quitButton = loveframes.Create("button")
quitButton:SetPos(20, 620)
quitButton:SetSize(200, 60)
quitButton:SetText("Quit")
quitButton:SetState("mainmenu")


function joinGameButton:OnClick()
    Gamestate.switch(game)
end

function createGameButton:OnClick()
    loveframes.SetState("creategame")
end

function settingsButton:OnClick()
    loveframes.SetState("settings")
end

function quitButton:OnClick()
    love.event.quit()
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
