CrestTracker_Locale = CrestTracker_Locale or {}

-- enUS base table
CrestTracker_Locale["enUS"] = {
    ["MYTHIC_BOSSES"] = "Kill %d More Mythic Bosses",
    ["HEROIC_BOSSES"] = "Kill %d More Heroic Dungeon Bosses",
    ["NORMAL_BOSSES"] = "Kill %d More Normal Bosses",
    ["LFR_BOSSES"] = "Kill %d More LFR Bosses",
    ["DELVES"] = "Complete %d More Tier +%s Delves",
    ["SEASON_ONE"] = "The War Within Season 1",
    ["SEASON_TWO"] = "The War Within Season 1",
    ["CREST_NAME"] = "Ethereal",
    ["VETERAN"] = "Veteran",
    ["CHAMPION"] = "Champion",
    ["HERO"] = "Hero",
    ["MYTH"] = "Myth",
    ["MYTHIC_0"] = "Time %d More Mythic 0 Dungeons",
    ["MYTHIC_PLUS"] = "Time %d More +%s Keys",
    ["DELVE"] = "Delves",
    ["MYTHIC"] = "Mythic+",
    ["MYTHIC_RAID_BOSS"] = "Mythic Raid Boss",
    ["HEROIC_RAID_BOSS"] = "Heroic Raid Boss",
    ["NORMAL_RAID_BOSS"] = "Normal Raid Boss",
    ["TIME"] = "Time %d more +%s keys",
    ["HEROIC_DUNGEON"] = "Heroic Dungeon Boss",
    ["H_DUNGEON_KILLS"] = "Kill %d More Heroic Dungeon Bosses",
    ["CRESTS"] = "Crests",
    ["EACH"] = "    (%d each)",
    ["DONE"] = "Done!",
    ["NEED_MORE_CRESTS"] = "Need %d more crests",
    ["ENOUGH_CRESTS"] = "You have enough crests!",
    ["CREST"] = "Crest",
    ["CREST_TRACKER"] = "Crest Tracker",
    ["LFR"] = "LFR Boss",
}

-- Now set dependent keys
CrestTracker_Locale["enUS"]["WEATHERED_CREST"] = "Weathered " .. CrestTracker_Locale["enUS"]["CREST_NAME"] .. " Crest"
CrestTracker_Locale["enUS"]["CARVED_CREST"] = "Carved " .. CrestTracker_Locale["enUS"]["CREST_NAME"] .. " Crest"
CrestTracker_Locale["enUS"]["RUNED_CREST"] = "Runed " .. CrestTracker_Locale["enUS"]["CREST_NAME"] .. " Crest"
CrestTracker_Locale["enUS"]["GILDED_CREST"] = "Gilded " .. CrestTracker_Locale["enUS"]["CREST_NAME"] .. " Crest"

--Перевод ZamestoTV
-- ruRU base table
CrestTracker_Locale["ruRU"] = {
    ["MYTHIC_BOSSES"] = "Убить еще %d боссов эпохальной сложности",
    ["HEROIC_BOSSES"] = "Убить еще %d боссов героической сложности",
    ["NORMAL_BOSSES"] = "Убить еще %d боссов в обычной сложности",
    ["LFR_BOSSES"] = "Убить еще %d боссов в поиске рейда",
    ["DELVES"] = "Завершить еще %d Вылазок уровня +%s",
    ["SEASON_ONE"] = "Сезон 1 «Война внутри»",
    ["SEASON_TWO"] = "Сезон 2 «Война внутри»",
    ["CREST_NAME"] = "Эфирный",
    ["VETERAN"] = "Ветеран",
    ["CHAMPION"] = "Защитник",
    ["HERO"] = "Герой",
    ["MYTH"] = "Легенда",
    ["MYTHIC_0"] = "Пройти еще %d эпохальных подземелий 0",
    ["MYTHIC_PLUS"] = "Пройти еще %d ключей +%s",
    ["DELVE"] = "Вылазки",
    ["MYTHIC"] = "Мифик+",
    ["MYTHIC_RAID_BOSS"] = "Эпохальный рейдовый босс",
    ["HEROIC_RAID_BOSS"] = "Героический рейдовый босс",
    ["NORMAL_RAID_BOSS"] = "Обычный рейдовый босс",
    ["TIME"] = "Пройти еще %d ключей +%s",
    ["HEROIC_DUNGEON"] = "Босс героического подземелья",
    ["H_DUNGEON_KILLS"] = "Убить еще %d боссов героических подземелий",
    ["CRESTS"] = "Гербы",
    ["EACH"] = "    (%d за каждого)",
    ["DONE"] = "Готово!",
    ["NEED_MORE_CRESTS"] = "Нужно еще %d гербов",
    ["ENOUGH_CRESTS"] = "У вас достаточно гербов!",
    ["CREST"] = "Герб",
    ["CREST_TRACKER"] = "Отслеживание гербов",
    ["LFR"] = "Поиск рейда",
}

-- Now set dependent keys
CrestTracker_Locale["ruRU"]["WEATHERED_CREST"] = "Истертый герб " .. CrestTracker_Locale["ruRU"]["CREST_NAME"]
CrestTracker_Locale["ruRU"]["CARVED_CREST"] = "Резной герб " .. CrestTracker_Locale["ruRU"]["CREST_NAME"]
CrestTracker_Locale["ruRU"]["RUNED_CREST"] = "Рунический герб " .. CrestTracker_Locale["ruRU"]["CREST_NAME"]
CrestTracker_Locale["ruRU"]["GILDED_CREST"] = "Позолоченный герб " .. CrestTracker_Locale["ruRU"]["CREST_NAME"]

function CrestTracker_Locale.GetLocalizedStrings()
    local locale = GetLocale()
    return CrestTracker_Locale[locale] or CrestTracker_Locale["enUS"]
end

L = CrestTracker_Locale.GetLocalizedStrings()