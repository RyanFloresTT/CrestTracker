UISetup = {}

function UISetup.InitializeUI(crestTypes, itemNeeds, GenerateTooltip)
    local crestFrames = {}

    local TabName = "Crests"
    local TabID = CharacterFrame.numTabs + 1

    local Tab = CreateFrame("Button", "$parentTab" .. TabID, CharacterFrame, "CharacterFrameTabTemplate")
    PanelTemplates_SetNumTabs(CharacterFrame, TabID)
    Tab:SetPoint("LEFT", "$parentTab" .. (TabID - 1), "RIGHT", -16, 0)
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
        frame.iconTexture = icon

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
            GameTooltip:AddLine("|T" .. crest.icon .. ":16|t " .. crest.name, 1, 0.82, 0)
            GameTooltip:AddLine(" ")

            local needed = itemNeeds[self.currencyName] or 0
            local owned = crest.quantity or 0
            local deficit = needed - owned

            if deficit > 0 then
                GameTooltip:AddLine(string.format("Need %d more crests", deficit), 1, 0.4, 0.4)
                GameTooltip:AddLine(" ")
                GenerateTooltip(self.currencyName, deficit)
            else
                GameTooltip:AddLine("You have enough crests!", 0, 1, 0)
            end

            GameTooltip:Show()
        end)

        frame:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    return crestFrames, Tab, Panel, TabName, TabID
end

return UISetup