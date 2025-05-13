CrestData = {}

CrestData.crestTypes = {
    { name = "Weathered Undermine Crest", icon = "", id = 3107, quantity = 0},
    { name = "Carved Undermine Crest", icon = "", id = 3108, quantity = 0},
    { name = "Runed Undermine Crest", icon = "", id = 3109 , quantity = 0},
    { name = "Gilded Undermine Crest", icon = "", id = 3110  , quantity = 0}
}

CrestData.crestMax = {
    ["Weathered"] = 632,
    ["Carved"] = 645,
    ["Runed"] = 658,
    ["Gilded"] = 684,
}


CrestData.trackMax = {
    ["Veteran"] = 645,
    ["Champion"] = 658,
    ["Hero"] = 671,
    ["Myth"] = 684,
}

CrestData.ACTIVITY_REWARDS = {
    ["Weathered Undermine Crest"] = {
        {
            source = "Delves", 
            tiers = {
                { range = "1-5", reward = 10 },
            },
            text = "Complete %d more tier +%s delves"
        },
        { source = "Heroic Dungeon Boss", reward = 1, text = "Kill %d more Heroic Dungeon Bosses" },
        { source = "LFR", reward = 15, text = "Complete %d more LFR wings" }
    },
    ["Carved Undermine Crest"] = {
        {
            source = "Delves", 
            tiers = {
                { range = "6-7", reward = 10 },
            },
            text = "Complete %d more tier +%s delves"
        },
        { source = "M 0", reward = 15, text = "Time %d more Mythic 0 Dungeonss" },
        { source = "Normal Raid Boss", reward = 15, text = "Kill %d more Normal bosses" }
    },
    ["Runed Undermine Crest"] = {
        {
            source = "Delves", 
            tiers = {
                { range = "8-11", reward = 10 },
            },
            text = "Complete %d more tier +%s delves"
        },
        {
            source = "Mythic+", 
            tiers = {
                { range = "2", reward = 10 },
                { range = "3", reward = 12 },
                { range = "4", reward = 14 },
                { range = "5", reward = 16 },
                { range = "6", reward = 18 }
            },
            text = "Time %d more +%s keys"
        },
        { source = "Heroic Raid Boss", reward = 15, text = "Kill %d more Heroic bosses" },
    },
    ["Gilded Undermine Crest"] = {
        {
            source = "Mythic+", 
            tiers = {
                { range = "7", reward = 10 },
                { range = "8", reward = 12 },
                { range = "9", reward = 14 },
                { range = "10", reward = 16 },
                { range = "11", reward = 18 },
                { range = "12", reward = 20 },
            },
            text = "Time %d more +%s keys"
        },
        { source = "Mythic Raid Boss", reward = 15, text = "Kill %d more Mythic bosses" },
    }
}

return CrestData