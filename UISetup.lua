ProgressBarMax = 500

-- Settings panel overlay with checkboxes for various options
-- This panel allows users to toggle settings like showing delves, dungeons and raids.
function CreateSettingsPanel(parent)
    CrestTrackerSavedConfig = CrestTrackerSavedConfig or {}
    local defaults = {
        showDelves = true,
        showDungeon = true,
        showRaid = true,
        progressBars = true,
    }

    -- UI creation below
    local overlay = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    overlay:SetSize(400, 300)
    overlay:SetPoint("CENTER")
    overlay:SetFrameStrata("DIALOG")
    overlay:Hide()
    overlay:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    })
    overlay:SetBackdropColor(0, 0, 0, 0.85)

    for key, value in pairs(defaults) do
        if CrestTrackerSavedConfig[key] == nil then
            CrestTrackerSavedConfig[key] = value
        end
    end

    local function bindCheckbox(check, key)
        check:SetChecked(CrestTrackerSavedConfig[key])
        check:SetScript("OnClick", function(self)
            CrestTrackerSavedConfig[key] = self:GetChecked()
        end)
    end


    local showDelvesCheck = CreateFrame("CheckButton", nil, overlay, "ChatConfigCheckButtonTemplate")
    showDelvesCheck:SetPoint("TOPLEFT", 24, -32)
    showDelvesCheck.Text:SetText("Show Delves")
    bindCheckbox(showDelvesCheck, "showDelves")

    local showDungeonCheck = CreateFrame("CheckButton", nil, overlay, "ChatConfigCheckButtonTemplate")
    showDungeonCheck:SetPoint("TOPLEFT", showDelvesCheck, "BOTTOMLEFT", 0, -16)
    showDungeonCheck.Text:SetText("Show Dungeons")
    bindCheckbox(showDungeonCheck, "showDungeon")

    local showRaidCheck = CreateFrame("CheckButton", nil, overlay, "ChatConfigCheckButtonTemplate")
    showRaidCheck:SetPoint("TOPLEFT", showDungeonCheck, "BOTTOMLEFT", 0, -16)
    showRaidCheck.Text:SetText("Show Raids")
    bindCheckbox(showRaidCheck, "showRaid")

    local progressBarsCheck = CreateFrame("CheckButton", nil, overlay, "ChatConfigCheckButtonTemplate")
    progressBarsCheck:SetPoint("TOPLEFT", showRaidCheck, "BOTTOMLEFT", 0, -16)
    progressBarsCheck.Text:SetText("Show Progress Bars")
    bindCheckbox(progressBarsCheck, "progressBars")

    local closeBtn = CreateFrame("Button", nil, overlay, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", overlay, "TOPRIGHT", -8, -8)
    closeBtn:SetScript("OnClick", function() overlay:Hide() end)

    return overlay
end

UISetup = {}

function UISetup.InitializeUI(crestTypes, itemNeeds, GenerateTooltip, settingsOverlay, Panel)
    local crestFrames = {}

    -- Function to refresh crest counts
    local function RefreshCrestCounts()
        for i, crest in ipairs(crestTypes) do
            local frame = crestFrames[i]
            if frame then
                if itemNeeds[crest.name] > 0 then
                    frame.countLabel:SetText("Progress: " .. (crest.quantity or 0) .. " / " .. (itemNeeds[crest.name] or 0))
                    local needed = itemNeeds[crest.name] or 0
                    local owned = crest.quantity or 0
                    local progressWidth = 0
                    if needed > 0 then
                        progressWidth = math.floor((owned / needed) * ProgressBarMax)
                    end
                    frame.progressFill:SetWidth(progressWidth)
                else
                    frame.countLabel:SetText("No Crests Needed")
                    frame.progressFill:SetWidth(ProgressBarMax)
                end
            end
        end
    end

    Panel:SetScript("OnShow", function()
        CrestLogic.UpdateCrestCounts(crestTypes, CrestData.crestMax, CrestData.trackMax, itemNeeds, crestFrames, Panel)
        RefreshCrestCounts()
    end)


    -- Close button
    local closeButton = CreateFrame("Button", nil, Panel, "UIPanelCloseButton")
    closeButton:SetSize(32, 32)
    closeButton:SetPoint("TOPRIGHT", Panel, "TOPRIGHT", -8, -8)
    closeButton:SetScript("OnClick", function() Panel:Hide() end)

    -- Title
    local title = Panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -40)
    title:SetText(L["CREST_TRACKER"] or "Crest Tracker")

    -- Settings button
    local settingsButton = CreateFrame("Button", nil, Panel, "UIPanelButtonTemplate")
    settingsButton:SetSize(80, 25)
    settingsButton:SetPoint("TOPRIGHT", -48, -40)
    settingsButton:SetText("Settings")

    -- Settings panel
    Panel:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            if settingsOverlay:IsShown() then
                settingsOverlay:Hide()
            else
                settingsOverlay:Show()
            end
        end
    end)

    settingsButton:SetScript("OnClick", function()
        if settingsOverlay then
            if settingsOverlay:IsShown() then
                settingsOverlay:Hide()
            else
                settingsOverlay:Show()
            end
        else
            print("Settings not ready yet.")
        end
    end)

    -- Crest info container
    local container = CreateFrame("Frame", nil, Panel)
    container:SetSize(540, 650)
    container:SetPoint("TOP", title, "BOTTOM", 0, -10)

    -- Populate crest info rows
    local lastFrame
    for i, crest in ipairs(crestTypes) do
        local frame = CreateFrame("Frame", nil, container)
        frame:SetSize(500, 80)
        frame:SetPoint("TOP", lastFrame or container, "TOP", 0, lastFrame and -85 or 0)

        local icon = frame:CreateTexture(nil, "OVERLAY")
        icon:SetSize(48, 48)
        icon:SetPoint("LEFT", 20, 0)
        icon:SetTexture(crest.icon)
        frame.iconTexture = icon

        local nameLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        nameLabel:SetPoint("LEFT", icon, "RIGHT", 16, 0)
        nameLabel:SetText(crest.name)

        local countLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        countLabel:SetPoint("RIGHT", -24, 0)
        countLabel:SetText("Count: " .. (crest.quantity or 0))
        frame.countLabel = countLabel
        frame.currencyName = crest.name

        local progressBg = frame:CreateTexture(nil, "BACKGROUND")
        progressBg:SetSize(ProgressBarMax, 10)
        progressBg:SetPoint("BOTTOM", 0, 0)
        progressBg:SetColorTexture(0.2, 0.2, 0.2, 0.8)
        frame.progressBg = progressBg

        local progressFill = frame:CreateTexture(nil, "OVERLAY")
        progressFill:SetSize(0, 8)
        progressFill:SetPoint("LEFT", progressBg, "LEFT", 1, 0)
        progressFill:SetColorTexture(0.8, 0.8, 0.8, 1)
        frame.progressFill = progressFill

        frame:SetScript("OnEnter", function(f)
            GameTooltip:SetOwner(f, "ANCHOR_RIGHT")
            GameTooltip:AddLine("|T" .. crest.icon .. ":16|t " .. crest.name, 1, 0.82, 0)
            GameTooltip:AddLine(" ")
            local needed = itemNeeds[f.currencyName] or 0
            local owned = crest.quantity or 0
            local deficit = needed - owned
            if needed > 0 then
                local progress = math.floor((owned / needed) * 100)
                GameTooltip:AddLine(string.format("Progress: %d%% (%d/%d)", progress, owned, needed), 1, 1, 1)
                GameTooltip:AddLine(" ")
            end
            if deficit > 0 then
                GameTooltip:AddLine(string.format(L["NEED_MORE_CRESTS"] or "Need %d more crests", deficit), 1, 0.4, 0.4)
                GameTooltip:AddLine(" ")
                if GenerateTooltip then
                    GenerateTooltip(f.currencyName, deficit)
                end
            else
                GameTooltip:AddLine(L["ENOUGH_CRESTS"] or "You have enough crests!", 0, 1, 0)
            end
            GameTooltip:Show()
        end)
        frame:SetScript("OnLeave", function() GameTooltip:Hide() end)

        local needed = itemNeeds[crest.name] or 0
        local owned = crest.quantity or 0
        local progressWidth = 0
        if needed > 0 then
            progressWidth = math.floor((owned / needed) * ProgressBarMax)
        else 
            progressWidth = ProgressBarMax
        end
        frame.progressFill:SetWidth(progressWidth)

        crestFrames[i] = frame
        lastFrame = frame
    end

    -- Slash command to toggle CrestTracker frame
    SLASH_CRESTTRACKER1 = "/cresttracker"
    SlashCmdList["CRESTTRACKER"] = function()
        if Panel:IsShown() then
            Panel:Hide()
        else
            Panel:Show()
        end
    end

    return crestFrames, Panel
end