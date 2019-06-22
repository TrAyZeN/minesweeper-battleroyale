loveframes = require "libs.loveframes"
gameSettings = require "gamesettings"

local screenResolutionMultichoice = loveframes.Create("multichoice")
local fullscreenCheckbox = loveframes.Create("checkbox")
local vsyncCheckbox = loveframes.Create("checkbox")
local applychangesButton = loveframes.Create("button")
-- TODO: add volume

screenResolutionMultichoice:SetPos(200, 100)
screenResolutionMultichoice:SetSize(120, 30)
screenResolutionMultichoice:SetState("settings")
local screenResolutions = love.window.getFullscreenModes(1)
table.sort(screenResolutions, function(a, b) return a.width*a.height < b.width*b.height end)
for _, resolution in pairs(screenResolutions) do
    screenResolutionMultichoice:AddChoice(string.format("%dx%d", resolution.width, resolution.height))
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
    local screenResolutionChoice = screenResolutionMultichoice:GetChoice()
    gameSettings.windowSize.w = tonumber(screenResolutionChoice:sub(1, screenResolutionChoice:find("x") - 1))
    gameSettings.windowSize.h = tonumber(screenResolutionChoice:sub(screenResolutionChoice:find("x") + 1, screenResolutionChoice:len()))
    gameSettings.fullscreen = fullscreenCheckbox:GetChecked()
    gameSettings.vsync = vsyncCheckbox:GetChecked()
    
    gameSettings:save()
    gameSettings:applySettings()
end

local settingsWidgets = {
    screenResolutionMultichoice = screenResolutionMultichoice,
    fullscreenCheckbox = fullscreenCheckbox,
    vsyncCheckbox = vsyncCheckbox,
    applychangesButton = applychangesButton
}

return settingsWidgets
