local crestTypes = CrestData.crestTypes
local crestMax = CrestData.crestMax
local trackMax = CrestData.trackMax
local ACTIVITY_REWARDS = CrestData.ACTIVITY_REWARDS

local itemNeeds = {
    ["Weathered Undermine Crest"] = 0,
    ["Carved Undermine Crest"] = 0,
    ["Runed Undermine Crest"] = 0,
    ["Gilded Undermine Crest"] = 0,
}

local crestFrames, Tab, Panel, TabName, TabID = UISetup.InitializeUI(crestTypes, itemNeeds, function(crestName, deficit)
    TooltipUtils.GenerateTooltip(crestName, deficit, ACTIVITY_REWARDS)
end)

TabHandler.AddTabTooltip(Tab, "Crests")

local function UpdateCrestCounts()
    CrestLogic.UpdateCrestCounts(crestTypes, crestMax, trackMax, itemNeeds, crestFrames, Panel)
end

local f = CreateFrame("Frame")
EventHandler.RegisterEvents(f, UpdateCrestCounts)

Tab:SetScript("OnClick", function()
    TabHandler.HandleTabClick(TabName, TabID, Panel, UpdateCrestCounts)
end)