CrestData = {}

CrestData.seasonName = L["CREST_NAME"]

CrestData.crestTypes = {
    { name = L["WEATHERED_CREST"] or ("Weathered " .. CrestData.seasonName .. " Crest"), icon = "", id = 3285, quantity = 0},
    { name = L["CARVED_CREST"] or ("Carved " .. CrestData.seasonName .. " Crest"), icon = "", id = 3287, quantity = 0},
    { name = L["RUNED_CREST"] or ("Runed " .. CrestData.seasonName .. " Crest"), icon = "", id = 3289, quantity = 0},
    { name = L["GILDED_CREST"] or ("Gilded " .. CrestData.seasonName .. " Crest"), icon = "", id = 3290, quantity = 0}
}

CrestData.crestMax = {
    ["Weathered"] = 678,
    ["Carved"] = 691,
    ["Runed"] = 704,
    ["Gilded"] = 723,
}

CrestData.trackMax = {
    ["Veteran"] = 691,
    ["Champion"] = 704,
    ["Hero"] = 710,
    ["Myth"] = 723,
}

CrestData.ACTIVITY_REWARDS = {
    [L["WEATHERED_CREST"]] = {
        {
            source = L["DELVE"], 
            tiers = {
                { range = "1-5", reward = 10 },
            },
            text = L["DELVES"]
        },
        { source = L["HEROIC_DUNGEON"], reward = 1, text = L["H_DUNGEON_KILLS"] },
        { source = L["LFR"], reward = 15, text = L["LFR_BOSSES"] }
    },
    [L["CARVED_CREST"] ] = {
        {
            source = L["DELVE"], 
            tiers = {
                { range = "6-7", reward = 10 },
            },
            text = L["DELVES"] 
        },
        { source = L["MYTHIC"], reward = 15, text = L["MYTHIC_0"] },
        { source = L["NORMAL_RAID_BOSS"], reward = 15, text = L["NORMAL_BOSSES"]}
    },
    [L["RUNED_CREST"] ] = {
        {
            source = L["DELVE"] , 
            tiers = {
                { range = "8-11", reward = 10 },
            },
            text = L["DELVES"]
        },
        {
            source = L["MYTHIC"] , 
            tiers = {
                { range = "2", reward = 10 },
                { range = "3", reward = 12 },
                { range = "4", reward = 14 },
                { range = "5", reward = 16 },
                { range = "6", reward = 18 }
            },
            text = L["MYTHIC_PLUS"] 
        },
        { source = L["HEROIC_RAID_BOSS"] , reward = 15, text = L["HEROIC_BOSSES"] },
    },
    [L["GILDED_CREST"] ] = {
        {
            source = L["MYTHIC"] , 
            tiers = {
                { range = "7", reward = 10 },
                { range = "8", reward = 12 },
                { range = "9", reward = 14 },
                { range = "10", reward = 16 },
                { range = "11", reward = 18 },
                { range = "12", reward = 20 },
            },
            text = L["MYTHIC_PLUS"] 
        },
        { source = L["MYTHIC_RAID_BOSS"], reward = 15, text = L["MYTHIC_BOSSES"] },
    }
}

-- New Delve rewards structure
CrestData.DELVE_REWARDS = {
    [1] = { normal = { weathered = 1 }, bountiful = { weathered = 1 } },
    [2] = { normal = { weathered = 2 }, bountiful = { weathered = 2 } },
    [3] = { normal = { weathered = 3 }, bountiful = { weathered = 3 } },
    [4] = { normal = { weathered = 4 }, bountiful = { weathered = 4 } },
    [5] = { normal = { weathered = 5 }, bountiful = { weathered = 5 } },
    [6] = { normal = { carved = 2 }, bountiful = { carved = 2 }, hiddenTrove = { runed = 4 }, hiddenTroveFrequency = "weekly" },
    [7] = { normal = { carved = 4 }, bountiful = { carved = 4 }, hiddenTrove = { runed = 4 }, hiddenTroveFrequency = "weekly" },
    [8] = { normal = { runed = 2 }, bountiful = { runed = 2 }, hiddenTrove = { gilded = 3 }, hiddenTroveFrequency = "weekly" },
    [9] = { normal = { runed = 2 }, bountiful = { runed = 2 }, hiddenTrove = { gilded = 3 }, hiddenTroveFrequency = "weekly" },
    [10] = { normal = { runed = 2 }, bountiful = { runed = 2 }, hiddenTrove = { gilded = 3 }, hiddenTroveFrequency = "weekly" },
    [11] = { normal = { runed = 2 }, bountiful = { runed = 2 }, hiddenTrove = { gilded = 3 }, hiddenTroveFrequency = "weekly" },
}


-- Sample function to print Delve rewards for each tier
function CrestData.PrintDelveRewards()
    for tier = 1, 11 do
        local rewards = CrestData.DELVE_REWARDS[tier]
        print("Delve Tier " .. tier .. ":")
        if rewards.normal then
            for crest, amount in pairs(rewards.normal) do
                print("  Normal: " .. amount .. "x " .. crest)
            end
        end
        if rewards.bountiful then
            for crest, amount in pairs(rewards.bountiful) do
                print("  Bountiful: " .. amount .. "x " .. crest .. " (max 4/day)")
            end
        end
        if rewards.hiddenTrove then
            for crest, amount in pairs(rewards.hiddenTrove) do
                print("  Hidden Trove: " .. amount .. "x " .. crest .. " (weekly)")
            end
        end
    end
end


-- Tooltip function for Delve rewards
function CrestData.AddDelveRewardsToTooltip(tier)
    local rewards = CrestData.DELVE_REWARDS[tier]
    if not rewards then
        GameTooltip:AddLine("No Delve rewards for this tier.", 1, 0.4, 0.4)
        return
    end
    GameTooltip:AddLine("Delve Rewards:", 1, 1, 1)
    if rewards.normal then
        for crest, amount in pairs(rewards.normal) do
            GameTooltip:AddLine("|cffccccccNormal:|r " .. amount .. "x " .. CrestData.GetCrestDisplayName(crest), 0.8, 0.8, 0.8)
        end
    end
    if rewards.bountiful then
        for crest, amount in pairs(rewards.bountiful) do
            GameTooltip:AddLine("|cff33ccffBountiful:|r " .. amount .. "x " .. CrestData.GetCrestDisplayName(crest) .. " |cffaaaaaa(max 4/day)|r", 0.2, 0.7, 1)
        end
    end
    if rewards.hiddenTrove then
        for crest, amount in pairs(rewards.hiddenTrove) do
            GameTooltip:AddLine("|cffffcc00Hidden Trove:|r " .. amount .. "x " .. CrestData.GetCrestDisplayName(crest) .. " |cffaaaaaa(weekly)|r", 1, 0.8, 0.2)
        end
    end
end

-- Helper to get display name for crest type
function CrestData.GetCrestDisplayName(crestKey)
    if crestKey == "weathered" then
        return L["WEATHERED_CREST"] or ("Weathered " .. CrestData.seasonName .. " Crest")
    elseif crestKey == "carved" then
        return L["CARVED_CREST"] or ("Carved " .. CrestData.seasonName .. " Crest")
    elseif crestKey == "runed" then
        return L["RUNED_CREST"] or ("Runed " .. CrestData.seasonName .. " Crest")
    elseif crestKey == "gilded" then
        return L["GILDED_CREST"] or ("Gilded " .. CrestData.seasonName .. " Crest")
    else
        return crestKey
    end
end

return CrestData