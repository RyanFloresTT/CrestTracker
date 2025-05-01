EventHandler = EventHandler or {}

function EventHandler.RegisterEvents(frame, UpdateCrestCounts)
    frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:SetScript("OnEvent", function(self, event)
        if event == "CURRENCY_DISPLAY_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
            UpdateCrestCounts()
        end
    end)
end