CrestLogic = CrestLogic or {}

-- Track configuration lookup table
local TRACK_CONFIG = {
    ["Veteran"] = {
        currentCrest = "Weathered",
        nextCrest = "Carved"
    },
    ["Champion"] = {
        currentCrest = "Carved", 
        nextCrest = "Runed"
    },
    ["Hero"] = {
        currentCrest = "Runed",
        nextCrest = "Gilded"
    },
    ["Myth"] = {
        currentCrest = "Gilded",
        nextCrest = nil
    }
}

-- Storage for highest item levels per slot
local highestItemLevels = {}

-- Helper function to get the highest item level the player has had in a slot
local function GetHighestItemLevelInSlot(slot)
    return highestItemLevels[slot] or 0
end

-- Helper function to update the highest item level for a slot
local function UpdateHighestItemLevelInSlot(slot, itemLevel)
    if not highestItemLevels[slot] or itemLevel > highestItemLevels[slot] then
        highestItemLevels[slot] = itemLevel
    end
end

-- Helper function to calculate crest needs for an item
local function CalculateCrestNeeds(itemLevel, trackString, crestMax, trackMax, slot)
    local needs = {}
    local config = TRACK_CONFIG[trackString]
    
    if not config then
        return needs
    end
    
    local currentCrestName = config.currentCrest .. " " .. CrestData.seasonName .. " Crest"
    local nextCrestName = config.nextCrest and (config.nextCrest .. " " .. CrestData.seasonName .. " Crest") or nil

    -- Calculate total crests needed for the complete upgrade path
    local trackMaxValue = trackMax[trackString]

    -- Get the highest item level the player has had in this slot (for discount calculation)
    local highestItemLevel = GetHighestItemLevelInSlot(slot)
    local effectiveItemLevel = math.max(itemLevel, highestItemLevel)
    
    if effectiveItemLevel < crestMax[config.currentCrest] then
        -- Item needs current tier crests to reach current tier max
        local upgradesNeeded = math.floor((crestMax[config.currentCrest] - effectiveItemLevel) / 3)
        local deficit = 15 * upgradesNeeded
        if deficit > 0 then
            needs[currentCrestName] = deficit
        end
        
        -- Also add next tier crests needed for the complete path
        if nextCrestName and trackMaxValue then
            local nextTierUpgradesNeeded = math.floor((trackMaxValue - crestMax[config.currentCrest]) / 3)
            local nextTierAmount = 15 * nextTierUpgradesNeeded
            if nextTierAmount > 0 then
                needs[nextCrestName] = nextTierAmount
            end
        end
    elseif effectiveItemLevel == crestMax[config.currentCrest] then
        -- Item is exactly at current tier max, needs next tier
        if nextCrestName and trackMaxValue then
            local upgradesNeeded = math.floor((trackMaxValue - effectiveItemLevel) / 3)
            local deficit = 15 * upgradesNeeded
            if deficit > 0 then
                needs[nextCrestName] = deficit
            end
        end
    else
        -- Item is above current tier max, check if it needs next tier
        if trackMaxValue and effectiveItemLevel < trackMaxValue then
            -- Item is between current tier max and track max
            local upgradesNeeded = math.floor((trackMaxValue - effectiveItemLevel) / 3)
            local deficit = 15 * upgradesNeeded
            if deficit > 0 and nextCrestName then
                needs[nextCrestName] = deficit
            end
        end
    end
    
    return needs
end

function CrestLogic.UpdateCrestCounts(crestTypes, crestMax, trackMax, itemNeeds, crestFrames, Panel)
    -- Reset item needs
    for key in pairs(itemNeeds) do
        itemNeeds[key] = 0
    end
  
    if not Panel then return end
    
    -- Process each equipment slot
    for slot = 1, 17 do
        local itemLink = GetInventoryItemLink("player", slot)
        if itemLink then
            local upgradeInfo = C_Item.GetItemUpgradeInfo(itemLink)
            if upgradeInfo and upgradeInfo.trackString then
                local _, _, _, itemLevel = C_Item.GetItemInfo(itemLink)
                if not itemLevel then
                    itemLevel = select(4, C_Item.GetItemInfo(itemLink)) or 0
                end
                
                -- Update the highest item level for this slot
                UpdateHighestItemLevelInSlot(slot, itemLevel)
                
                -- Calculate crest needs for this item
                local slotNeeds = CalculateCrestNeeds(itemLevel, upgradeInfo.trackString, crestMax, trackMax, slot)
                
                -- Add to total needs
                for crestName, amount in pairs(slotNeeds) do
                    if itemNeeds[crestName] then
                        itemNeeds[crestName] = itemNeeds[crestName] + amount
                    else
                        itemNeeds[crestName] = amount
                    end
                end
            end
        end
    end

    -- Update UI frames
    for i, crestType in ipairs(crestTypes) do
        local info = C_CurrencyInfo.GetCurrencyInfo(crestType.id)
        if info then
            crestType.quantity = info.quantity
            crestType.icon = info.iconFileID
    
            local frame = crestFrames[i]
            if frame then
                if frame.countLabel then
                    local deficit = itemNeeds[crestType.name] - crestType.quantity
                    local needed = itemNeeds[crestType.name] or 0
                    local owned = crestType.quantity or 0
                    
                    -- Update count label with color coding
                    if deficit <= 0 then
                        frame.countLabel:SetText(L["DONE"] or "Done!")
                        frame.countLabel:SetTextColor(0, 1, 0) -- Green
                    else
                        frame.countLabel:SetText(tostring(deficit))
                        -- Color coding based on progress
                        local progress = owned / needed
                        if progress >= 0.8 then
                            frame.countLabel:SetTextColor(1, 1, 0) -- Yellow (close)
                        elseif progress >= 0.5 then
                            frame.countLabel:SetTextColor(1, 0.5, 0) -- Orange (halfway)
                        else
                            frame.countLabel:SetTextColor(1, 0, 0) -- Red (far)
                        end
                    end
                    
                    -- Update progress bar (respect settings)
                    if frame.progressFill and needed > 0 then
                        local progress = math.min(owned / needed, 1)
                        frame.progressFill:SetWidth(258 * progress)
                        
                        -- Color the progress bar (if enabled)
                        if progress >= 1 then
                            frame.progressFill:SetColorTexture(0, 1, 0, 1) -- Green
                        elseif progress >= 0.8 then
                            frame.progressFill:SetColorTexture(1, 1, 0, 1) -- Yellow
                        elseif progress >= 0.5 then
                            frame.progressFill:SetColorTexture(1, 0.5, 0, 1) -- Orange
                        else
                            frame.progressFill:SetColorTexture(1, 0, 0, 1) -- Red
                        end
                    elseif frame.progressFill and deficit <= 0 then
                        -- When done, show full green progress bar
                        frame.progressFill:SetWidth(258)
                        frame.progressFill:SetColorTexture(0, 1, 0, 1) -- Green
                    end
                end
                if frame.iconTexture then
                    frame.iconTexture:SetTexture(crestType.icon)
                end
            end
        end
    end
end