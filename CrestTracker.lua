local crestTypes = {
    { name = "Weathered Undermine Crest", icon = "Interface\\Icons\\inv_misc_crest_weathered", id = 3107, quantity = 0},
    { name = "Carved Undermine Crest", icon = "Interface\\Icons\\inv_misc_crest_carved", id = 3108, quantity = 0},
    { name = "Runed Undermine Crest", icon = "Interface\\Icons\\inv_misc_crest_runed", id = 3109 , quantity = 0},
    { name = "Gilded Undermine Crest", icon = "Interface\\Icons\\inv_misc_crest_gilded", id = 3110  , quantity = 0}
}

local crestMax = {
    ["Weathered"] = 632,
    ["Carved"] = 645,
    ["Runed"] = 658,
    ["Gilded"] = 678,
}

local trackMax = {
    ["Veteran"] = 645,
    ["Champion"] = 658,
    ["Hero"] = 665,
    ["Myth"] = 678,
}

local ACTIVITY_REWARDS = {
    ["Weathered Undermine Crest"] = {
        { source = "Heroic Dungeon Boss", reward = 1, text = "Kill %d more Heroic bosses" },
        { source = "Timewalking Dungeon", reward = 2, text = "Complete %d more Timewalking" },
        { source = "LFR Wing", reward = 3, text = "Complete %d more LFR wings" }
    },
    ["Carved Undermine Crest"] = {
        { source = "M+2-4", reward = 5, text = "Time %d more +2-4 keys" },
        { source = "M+5-7", reward = 8, text = "Time %d more +5-7 keys" },
        { source = "Normal Raid Boss", reward = 2, text = "Kill %d more Normal bosses" }
    },
    ["Runed Undermine Crest"] = {
        {
            source = "Mythic+", 
            tiers = {
                { range = "2-4", reward = 8 },
                { range = "5-9", reward = 12 },
                { range = "10-14", reward = 18 },
                { range = "15-17", reward = 25 }
            },
            text = "Time %d more +%s keys"
        },
        { source = "Heroic Raid Boss", reward = 4, text = "Kill %d more Heroic bosses" },
        { source = "Mythic Raid Boss", reward = 6, text = "Kill %d more Mythic bosses" }
    },
    ["Gilded Undermine Crest"] = {
        {
            source = "Mythic+", 
            tiers = {
                { range = "11-15", reward = 8 },
                { range = "16-19", reward = 15 },
                { range = "20-23", reward = 25 },
                { range = "24+", reward = 40 }
            },
            text = "Time %d more +%s keys"
        },
        { source = "Mythic Raid Boss", reward = 10, text = "Kill %d more Mythic bosses" },
        { source = "Weekly Vault", reward = 15, text = "Wait %d more weeks" }
    }
}

local itemNeeds = {
    ["Weathered Undermine Crest"] = 0,
    ["Carved Undermine Crest"] = 0,
    ["Runed Undermine Crest"] = 0,
    ["Gilded Undermine Crest"] = 0,
}

local function GenerateTooltip(crestName, deficit)
    GameTooltip:AddLine("Earn from:", 0.7, 0.7, 0.7)

    for _, sourceInfo in ipairs(ACTIVITY_REWARDS[crestName]) do
        if sourceInfo.tiers then
            for _, tier in ipairs(sourceInfo.tiers) do
                local activitiesNeeded = math.ceil(deficit / tier.reward)
                local displayText = string.format(sourceInfo.text, activitiesNeeded, tier.range)
                GameTooltip:AddLine(displayText, 0.5, 1, 0.5)
                GameTooltip:AddLine(string.format("  (+%s: %d crests each)", tier.range, tier.reward), 0.7, 0.7, 0.7)
            end
        else
            local activitiesNeeded = math.ceil(deficit / sourceInfo.reward)
            GameTooltip:AddLine(string.format(sourceInfo.text, activitiesNeeded), 0.5, 1, 0.5)
            GameTooltip:AddLine(string.format("  (%s: %d crests each)", sourceInfo.source, sourceInfo.reward), 0.7, 0.7, 0.7)
        end
    end
end

local crestFrames = {}

local TabName = "Crests"
local TabID = CharacterFrame.numTabs + 1

local Tab = CreateFrame("Button", "$parentTab"..TabID, CharacterFrame, "CharacterFrameTabTemplate")
PanelTemplates_SetNumTabs(CharacterFrame, TabID)
Tab:SetPoint("LEFT", "$parentTab"..(TabID-1), "RIGHT", -16, 0)
Tab:SetText(TabName)
Tab:SetID(TabID)

local Panel = CreateFrame("Frame", "CrestFrame", CharacterFrame)
tinsert(CHARACTERFRAME_SUBFRAMES, "CrestFrame")
Panel:Hide()
Panel:SetAllPoints(CharacterFrame)

local title = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -40)
title:SetText("Crest Tracker")

local container = CreateFrame("Frame", nil, Panel)
container:SetSize(300, 200)
container:SetPoint("TOP", title, "BOTTOM", 0, -20)

local lastFrame
for i, crest in ipairs(crestTypes) do
    local frame = CreateFrame("Frame", nil, container)
    frame:SetSize(280, 40)
    frame:SetPoint("TOP", lastFrame or container, "TOP", 0, lastFrame and -45 or 0)

    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.5)

    local icon = frame:CreateTexture(nil, "OVERLAY")
    icon:SetSize(32, 32)
    icon:SetPoint("LEFT", 10, 0)
    icon:SetTexture(crest.icon)

    local nameLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameLabel:SetPoint("LEFT", icon, "RIGHT", 10, 0)
    nameLabel:SetText(crest.name)

    local countLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    countLabel:SetPoint("RIGHT", -10, 0)
    frame.countLabel = countLabel
    frame.currencyName = crest.name

    crestFrames[i] = frame

    lastFrame = frame

    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(crest.name)
        GameTooltip:AddLine(" ")
        
        local needed = itemNeeds[crest.name] or 0
        local owned = crest.quantity or 0
        local deficit = needed - owned
        
        if deficit > 0 then
            GameTooltip:AddLine(string.format("Need %d more crests", deficit), 1, 1, 1)
            GameTooltip:AddLine(" ", 1, 1, 1)
            GenerateTooltip(crest.name, deficit)
        else
            GameTooltip:AddLine("You have enough crests!", 0, 1, 0)
        end
        
        GameTooltip:Show()
    end)
end

local function UpdateCrestCounts()  
    itemNeeds = {
        ["Weathered Undermine Crest"] = 0,
        ["Carved Undermine Crest"] = 0,
        ["Runed Undermine Crest"] = 0,
        ["Gilded Undermine Crest"] = 0,
    }

    if not Panel then return end    

    for slot = 1, 17 do
        local itemLink = GetInventoryItemLink("player", slot)
        if itemLink then
            GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
            GameTooltip:SetHyperlink(itemLink)
    
            local seasonTextFound = false
            for i = 1, GameTooltip:NumLines() do
                local line = _G["GameTooltipTextLeft" .. i]:GetText()
                if line and string.find(line, "The War Within Season 1") then
                    seasonTextFound = true
                    break
                end
            end
    
            if not seasonTextFound then
                local upgradeInfo = C_Item.GetItemUpgradeInfo(itemLink)
                if upgradeInfo then
                    local _, _, _, itemLevel = C_Item.GetItemInfo(itemLink)
                    if not itemLevel then
                        itemLevel = select(4, C_Item.GetItemInfo(itemLink)) or 0
                    end
                    local itemTrack = upgradeInfo.trackString

                    if itemTrack == "Veteran" then
                        if itemLevel < crestMax["Weathered"] then
                            local upgradesNeeded = math.ceil((crestMax["Weathered"] - itemLevel) / 3)
                            itemNeeds["Weathered Undermine Crest"] = itemNeeds["Weathered Undermine Crest"] + (15 * upgradesNeeded)
                            itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + 60
                        else
                            if itemLevel < trackMax["Veteran"] then
                                if itemLevel == crestMax["Weathered"] then
                                    itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + 60
                                else
                                    local upgradesNeeded = math.ceil((trackMax["Veteran"] - itemLevel) / 3)
                                    itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + (15 * upgradesNeeded)
                                end
                            end
                        end
                    elseif itemTrack == "Champion" then
                        if itemLevel < crestMax["Carved"] then
                            local upgradesNeeded = math.ceil((crestMax["Carved"] - itemLevel) / 3)
                            itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + (15 * upgradesNeeded)
                            itemNeeds["Runed Undermine Crest"] = itemNeeds["Runed Undermine Crest"] + 60
                        else
                            if itemLevel < trackMax["Champion"] then
                                if itemLevel == crestMax["Carved"] then
                                    itemNeeds["Runed Undermine Crest"] = itemNeeds["Runed Undermine Crest"] + 60
                                else
                                    local upgradesNeeded = math.ceil((trackMax["Champion"] - itemLevel) / 3)
                                    itemNeeds["Runed Undermine Crest"] = itemNeeds["Runed Undermine Crest"] + (15 * upgradesNeeded)
                                end
                            end
                        end
                    elseif itemTrack == "Hero" then
                        if itemLevel < crestMax["Runed"] then
                            local upgradesNeeded = math.ceil((crestMax["Runed"] - itemLevel) / 3)
                            itemNeeds["Runed Undermine Crest"] = itemNeeds["Runed Undermine Crest"] + (15 * upgradesNeeded)
                            itemNeeds["Gilded Undermine Crest"] = itemNeeds["Gilded Undermine Crest"] + 30
                        else
                            if itemLevel < trackMax["Hero"] then
                                if itemLevel == crestMax["Runed"] then
                                    itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + 30
                                else
                                    local upgradesNeeded = math.ceil((trackMax["Hero"] - itemLevel) / 3)
                                    itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + (15 * upgradesNeeded)
                                end
                            end
                        end
                    elseif itemTrack == "Myth" then
                        if itemLevel < 678 then
                            local upgradesNeeded = math.ceil((678 - itemLevel) / 3)
                            itemNeeds["Gilded Undermine Crest"] = itemNeeds["Gilded Undermine Crest"] + (15 * upgradesNeeded)
                        end
                    end
                end
            end
        end
    end

    for i, crestType in ipairs(crestTypes) do
        local info = C_CurrencyInfo.GetCurrencyInfo(crestType.id)
        if info then
            crestType.quantity = info.quantity
            crestType.icon = info.iconFileID
    
            local frame = crestFrames[i]
            if frame then
                if frame.countLabel then
                    frame.countLabel:SetText(tostring(itemNeeds[crestType.name] - crestType.quantity))
                end
                if frame.iconTexture then
                    frame.iconTexture:SetTexture(crestType.icon)
                end
            end
        end
    end
    
end

Tab:SetScript("OnClick", function()
    for _, frame in pairs(CHARACTERFRAME_SUBFRAMES) do
        if _G[frame] then
            _G[frame]:Hide()
        end
    end

    UpdateCrestCounts()
    Panel:Show()
    CharacterStatsPane:Hide()
    CharacterFrameTitleText:SetText(TabName)
end)

local f = CreateFrame("Frame")
f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
    if event == "CURRENCY_DISPLAY_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
        UpdateCrestCounts()
    end
end)