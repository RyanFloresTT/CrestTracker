CrestLogic = CrestLogic or {}


function CrestLogic.UpdateCrestCounts(crestTypes, crestMax, trackMax, itemNeeds, crestFrames, Panel)
    for key in pairs(itemNeeds) do
        itemNeeds[key] = 0
    end
    
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
                            local deficit = 15 * upgradesNeeded
                            if deficit > 0 then
                                itemNeeds["Weathered Undermine Crest"] = itemNeeds["Weathered Undermine Crest"] + deficit
                            end
                            itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + 60
                        else
                            if itemLevel < trackMax["Veteran"] then
                                if itemLevel == crestMax["Weathered"] then
                                    itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + 60
                                else
                                    local upgradesNeeded = math.ceil((trackMax["Veteran"] - itemLevel) / 3)
                                    local deficit = 15 * upgradesNeeded
                                    if deficit > 0 then
                                        itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + deficit
                                    end
                                end
                            end
                        end
                    elseif itemTrack == "Champion" then
                        if itemLevel < crestMax["Carved"] then
                            local upgradesNeeded = math.ceil((crestMax["Carved"] - itemLevel) / 3)
                            local deficit = 15 * upgradesNeeded
                            if deficit > 0 then
                                itemNeeds["Carved Undermine Crest"] = itemNeeds["Carved Undermine Crest"] + deficit
                            end
                            itemNeeds["Runed Undermine Crest"] = itemNeeds["Runed Undermine Crest"] + 60
                        else
                            if itemLevel < trackMax["Champion"] then
                                if itemLevel == crestMax["Carved"] then
                                    itemNeeds["Runed Undermine Crest"] = itemNeeds["Runed Undermine Crest"] + 60
                                else
                                    local upgradesNeeded = math.ceil((trackMax["Champion"] - itemLevel) / 3)
                                    local deficit = 15 * upgradesNeeded
                                    if deficit > 0 then
                                        itemNeeds["Runed Undermine Crest"] = itemNeeds["Runed Undermine Crest"] + deficit
                                    end
                                end
                            end
                        end
                    elseif itemTrack == "Hero" then
                        if itemLevel < crestMax["Runed"] then
                            local upgradesNeeded = math.ceil((crestMax["Runed"] - itemLevel) / 3)
                            local deficit = 15 * upgradesNeeded
                            if deficit > 0 then
                                itemNeeds["Runed Undermine Crest"] = itemNeeds["Runed Undermine Crest"] + deficit
                            end
                            itemNeeds["Gilded Undermine Crest"] = itemNeeds["Gilded Undermine Crest"] + 30
                        else
                            if itemLevel < trackMax["Hero"] then
                                if itemLevel == crestMax["Runed"] then
                                    itemNeeds["Gilded Undermine Crest"] = itemNeeds["Gilded Undermine Crest"] + 30
                                else
                                    local upgradesNeeded = math.ceil((trackMax["Hero"] - itemLevel) / 3)
                                    local deficit = 15 * upgradesNeeded
                                    if deficit > 0 then
                                        itemNeeds["Gilded Undermine Crest"] = itemNeeds["Gilded Undermine Crest"] + deficit
                                    end
                                end
                            end
                        end
                    elseif itemTrack == "Myth" then
                        if itemLevel < 678 then
                            local upgradesNeeded = math.ceil((678 - itemLevel) / 3)
                            local deficit = 15 * upgradesNeeded
                            if deficit > 0 then
                                itemNeeds["Gilded Undermine Crest"] = itemNeeds["Gilded Undermine Crest"] + deficit
                            end
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
                    local deficit = itemNeeds[crestType.name] - crestType.quantity
                    if deficit <= 0 then
                        frame.countLabel:SetText("Done!")
                    else
                        frame.countLabel:SetText(tostring(deficit))
                    end
                end
                if frame.iconTexture then
                    frame.iconTexture:SetTexture(crestType.icon)
                end
            end
        end
    end
end