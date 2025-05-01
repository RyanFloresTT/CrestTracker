TooltipUtils = {}

function TooltipUtils.GenerateTooltip(crestName, deficit, ACTIVITY_REWARDS)
    GameTooltip:AddLine("Earn from:", 1, 1, 1)

    local lastSource = nil
    for _, sourceInfo in ipairs(ACTIVITY_REWARDS[crestName]) do
        if sourceInfo.source ~= lastSource then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(sourceInfo.source, 1, 0.82, 0)
            lastSource = sourceInfo.source
        end

        if sourceInfo.tiers then
            for _, tier in ipairs(sourceInfo.tiers) do
                local activitiesNeeded = math.ceil(deficit / tier.reward)
                local displayText = string.format(sourceInfo.text, activitiesNeeded, tier.range)
                GameTooltip:AddLine("• " .. displayText, 0.1, 0.9, 0.1)
                GameTooltip:AddLine(string.format("    (%d each)", tier.reward), 0.7, 0.7, 0.7)
            end
        else
            local activitiesNeeded = math.ceil(deficit / sourceInfo.reward)
            GameTooltip:AddLine("• " .. string.format(sourceInfo.text, activitiesNeeded), 0.1, 0.9, 0.1)
            GameTooltip:AddLine(string.format("    (%d each)", sourceInfo.reward), 0.7, 0.7, 0.7)
        end
    end
end

return TooltipUtils