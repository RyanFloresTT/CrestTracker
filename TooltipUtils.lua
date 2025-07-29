TooltipUtils = {}

local L = CrestTracker_Locale.GetLocalizedStrings()

-- Activity icons mapping
local ACTIVITY_ICONS = {
    ["Delves"] = "Interface\\Icons\\INV_Misc_Map_01",
    ["Mythic+"] = "Interface\\Icons\\INV_Misc_Key_01",
    ["Heroic Dungeon Boss"] = "Interface\\Icons\\INV_Misc_GroupLooking",
    ["Normal Raid Boss"] = "Interface\\Icons\\INV_Misc_GroupLooking",
    ["Heroic Raid Boss"] = "Interface\\Icons\\INV_Misc_GroupLooking",
    ["Mythic Raid Boss"] = "Interface\\Icons\\INV_Misc_GroupLooking",
    ["LFR"] = "Interface\\Icons\\INV_Misc_GroupLooking",
    ["M 0"] = "Interface\\Icons\\INV_Misc_Key_01"
}

CrestTrackerSavedConfig = CrestTrackerSavedConfig or {}

function TooltipUtils.GenerateTooltip(crestName, deficit, ACTIVITY_REWARDS)
    GameTooltip:AddLine(L["EARN_FROM"] or "Earn from:", 1, 1, 1)

    local tooltipConfig = CrestTrackerSavedConfig

    local sources = ACTIVITY_REWARDS and ACTIVITY_REWARDS[crestName]
    if type(sources) ~= "table" then return end

    local lastSource = nil
    for _, sourceInfo in ipairs(sources) do
        local sourceType = sourceInfo.source

        local showThisSource = true
        if sourceType == (L["DELVE"]) and not tooltipConfig.showDelves then
            showThisSource = false
        elseif (sourceType == L["MYTHIC"] or sourceType == L["MYTHIC_PLUS"] or sourceType == L["HEROIC_DUNGEON"]) and not tooltipConfig.showDungeon then
            showThisSource = false
        elseif (sourceType == L["LFR"] or sourceType == L["NORMAL_RAID_BOSS"] or sourceType == L["HEROIC_RAID_BOSS"] or sourceType == L["MYTHIC_RAID_BOSS"]) and not tooltipConfig.showRaid then
            showThisSource = false
        end

        if showThisSource then
            if sourceType ~= lastSource then
                GameTooltip:AddLine(" ")
                local icon = ACTIVITY_ICONS[sourceType] or "Interface\\Icons\\INV_Misc_QuestionMark"
                GameTooltip:AddLine("|T" .. icon .. ":16|t " .. sourceType, 1, 0.82, 0)
                lastSource = sourceType
            end

            if sourceType == (L["DELVE"] or "Delves") and sourceInfo.tiers then
                local tierInfo = sourceInfo.tiers[1]
                local activitiesNeeded = math.ceil(deficit / tierInfo.reward)
                GameTooltip:AddLine(string.format("• Complete %d more tier +%s delves", activitiesNeeded, tierInfo.range), 0.1, 0.9, 0.1)
                GameTooltip:AddLine(string.format(L["EACH"] or "    (%d each)", tierInfo.reward), 0.7, 0.7, 0.7)
            elseif sourceInfo.tiers then
                for _, tier in ipairs(sourceInfo.tiers) do
                    local activitiesNeeded = math.ceil(deficit / tier.reward)
                    GameTooltip:AddLine("• " .. string.format(sourceInfo.text, activitiesNeeded, tier.range), 0.1, 0.9, 0.1)
                    GameTooltip:AddLine(string.format(L["EACH"] or "    (%d each)", tier.reward), 0.7, 0.7, 0.7)
                end
            else
                local activitiesNeeded = math.ceil(deficit / sourceInfo.reward)
                GameTooltip:AddLine("• " .. string.format(sourceInfo.text, activitiesNeeded), 0.1, 0.9, 0.1)
                GameTooltip:AddLine(string.format(L["EACH"] or "    (%d each)", sourceInfo.reward), 0.7, 0.7, 0.7)
            end
        end
    end
end

return TooltipUtils