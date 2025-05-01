TabHandler = TabHandler or {}

function TabHandler.HandleTabClick(TabName, TabID, Panel, UpdateCrestCounts)
    for _, frame in pairs(CHARACTERFRAME_SUBFRAMES) do
        if _G[frame] then
            _G[frame]:Hide()
        end
    end

    UpdateCrestCounts()
    Panel:Show()
    CharacterStatsPane:Hide()
    CharacterFrameTitleText:SetText(TabName)
    PanelTemplates_SetTab(CharacterFrame, TabID)
end

function TabHandler.AddTabTooltip(Tab, tooltipText)
    Tab:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(tooltipText, 1, 1, 1)
        GameTooltip:Show()
    end)

    Tab:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end