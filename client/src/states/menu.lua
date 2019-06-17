game = require "states.game"
loveframes = require "libs.loveframes"
gamesettings = require "gamesettings"

local joinGameButton = loveframes.Create("button")
local createGameButton = loveframes.Create("button")
local settingsButton = loveframes.Create("button")
local quitButton = loveframes.Create("button")

local screenResolutionMultichoice = loveframes.Create("multichoice")
local fullscreenCheckbox = loveframes.Create("checkbox")
local vsyncCheckbox = loveframes.Create("checkbox")
local applychangesButton = loveframes.Create("button")
-- TODO: add volume

local closeButton = loveframes.Create("button")

-- main menu widgets
joinGameButton:Center()
joinGameButton:SetPos(540, 300)
joinGameButton:SetSize(200, 60)
joinGameButton:SetText("Join Game")
joinGameButton:SetState("mainmenu")
function joinGameButton:OnClick()
    Gamestate.switch(game)
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
    screenResolutionMultichoice:SetText(string.format("%dx%d", gamesettings.windowSize.w, gamesettings.windowSize.h))
    fullscreenCheckbox:SetChecked(gamesettings.fullscreen)
    vsyncCheckbox:SetChecked(gamesettings.vsync)
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


-- settings widgets
screenResolutionMultichoice:SetPos(200, 100)
screenResolutionMultichoice:SetSize(120, 30)
screenResolutionMultichoice:SetState("settings")
local screenResolutions = {
    {640, 360},     -- 16:9
    {640, 400},     -- 16:10
    {640, 480},     -- 4:3 VGA
    {800, 600},     -- 4:3 SVGA
    {960, 600},     -- 16:10
    {1024, 576},    -- 16:9
    {1024, 768},    -- 4:3 XGA
    {1280, 720},    -- 16:9
    {1280, 960},    -- 4:3
    {1440, 900},    -- 16:10
    {1600, 900},    -- 16:9
    {1920, 1080},   -- 16:9
    {1920, 1200},   -- 16:10
    {1920, 1440},   -- 4:3
    {2560, 1440},   -- 16:9
    {3840, 2160}    -- 16:9
}
for _, resolution in pairs(screenResolutions) do
    screenResolutionMultichoice:AddChoice(string.format("%dx%d", resolution[1], resolution[2]))
end

fullscreenCheckbox:SetPos(200, 300)
fullscreenCheckbox:SetSize(20, 20)
fullscreenCheckbox:SetText("Fullscreen")
fullscreenCheckbox:SetState("settings")

vsyncCheckbox:SetPos(200, 350)
vsyncCheckbox:SetSize(20, 20)
vsyncCheckbox:SetText("Vsync")
vsyncCheckbox:SetState("settings")

applychangesButton:SetPos(200, 500)
applychangesButton:SetSize(100, 20)
applychangesButton:SetText("Apply Changes")
applychangesButton:SetState("settings")
function applychangesButton:OnClick()
    local screenResolutionChoice = screenResolutionMultichoice:GetText()
    gamesettings.windowSize.w = tonumber(screenResolutionChoice:sub(1, screenResolutionChoice:find("x")-1))
    gamesettings.windowSize.h = tonumber(screenResolutionChoice:sub(screenResolutionChoice:find("x")+1, screenResolutionChoice:len()))
    gamesettings.fullscreen = fullscreenCheckbox:GetChecked()
    gamesettings.vsync = vsyncCheckbox:GetChecked()
    gamesettings:save()
    gamesettings:applySettings()
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
