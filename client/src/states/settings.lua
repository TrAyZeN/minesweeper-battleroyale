loveframes = require "libs.loveframes"

local closeButton = loveframes.Create("button")
closeButton:SetPos(300, 200)
closeButton:SetSize(40, 40)
closeButton:SetText("X")
closeButton:SetState("settings")

function closeButton:OnClick()
    loveframes.SetState("mainmenu")
end

local settings = {}

function settings:update(dt)
    loveframes.update(dt)
end

function settings:draw()
    love.graphics.print("Settings", 200, 200)
    loveframes.draw()
end

function settings:mousepressed(x, y, button)
    loveframes.mousepressed(x, y, button)
end

function settings:mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function settings:keypressed(key, code)
    loveframes.keypressed(key)
end

function settings:keyreleased(key, code)
    loveframes.keyreleased(key)
end

return settings
