local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "CrestTracker" then
        CrestTrackerSavedConfig = CrestTrackerSavedConfig or {}

        local crestTypes = CrestData.crestTypes
        local ACTIVITY_REWARDS = CrestData.ACTIVITY_REWARDS

        local itemNeeds = {
            ["Weathered " .. CrestData.seasonName .. " Crest"] = 0,
            ["Carved " .. CrestData.seasonName .. " Crest"] = 0,
            ["Runed " .. CrestData.seasonName .. " Crest"] = 0,
            ["Gilded " .. CrestData.seasonName .. " Crest"] = 0,
        }

        -- Create the main CrestTracker frame
        local panel = CreateFrame("Frame", "CrestTrackerFrame", UIParent, "BackdropTemplate")
        panel:SetSize(600, 536)
        panel:SetPoint("CENTER")
        panel:SetFrameStrata("HIGH")
        panel:EnableMouse(true)
        panel:SetMovable(true)
        panel:RegisterForDrag("LeftButton")
        panel:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
        panel:SetBackdropColor(0, 0, 0, 0.85)
        panel:SetScript("OnDragStart", function(self) self:StartMoving() end)
        panel:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
        panel:Hide()


        -- Plain lightly transparent black background (no texture)
        local panelBg = panel:CreateTexture(nil, "BACKGROUND")
        panelBg:SetAllPoints()
        panelBg:SetColorTexture(0, 0, 0, 0.85)

        -- Simple border
        local border = panel:CreateTexture(nil, "BORDER")
        border:SetAllPoints()
        border:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        border:SetVertexColor(0.7, 0.7, 0.7, 0.8)

        local settingsOverlay = CreateSettingsPanel(panel)

        UISetup.InitializeUI(crestTypes, itemNeeds, function(crestName, deficit)
            TooltipUtils.GenerateTooltip(crestName, deficit, ACTIVITY_REWARDS)
        end, settingsOverlay, panel)
    end
end)
