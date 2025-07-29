EventHandler = EventHandler or {}

function EventHandler.RegisterEvents(frame, UpdateCrestCounts)
    frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    frame:RegisterEvent("ITEM_UPGRADE_MASTER_SET_ITEM")
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("PLAYER_LEVEL_UP")
    frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    
    frame:SetScript("OnEvent", function(self, event)
        if event == "CURRENCY_DISPLAY_UPDATE" or 
           event == "PLAYER_ENTERING_WORLD" or
           event == "PLAYER_EQUIPMENT_CHANGED" or
           event == "ITEM_UPGRADE_MASTER_SET_ITEM" or
           event == "BAG_UPDATE" or
           event == "PLAYER_LEVEL_UP" or
           event == "PLAYER_SPECIALIZATION_CHANGED" then
            UpdateCrestCounts()
        end
    end)
end