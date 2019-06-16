loveframes = require "libs.loveframes"

local closeButton = loveframes.Create("button")
closeButton:SetPos(300, 200)
closeButton:SetSize(40, 40)
closeButton:SetText("X")
closeButton:SetState("creategame")

function closeButton:OnClick()
    loveframes.SetState("mainmenu")
end

local creategame = {}

function creategame:update(dt)
    loveframes.update(dt)
end

function creategame:draw()
    love.graphics.print("CreateGame", 200, 200)
    loveframes.draw()
end

function creategame:mousepressed(x, y, button)
    loveframes.mousepressed(x, y, button)
end

function creategame:mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function creategame:keypressed(key, code)
    loveframes.keypressed(key)
end

function creategame:keyreleased(key, code)
    loveframes.keyreleased(key)
end

return creategame