CrestTracker_Locale = CrestTracker_Locale or {}

CrestTracker_Locale["enUS"] = {
    ["MYTHIC_BOSSES"] = "Kill %d More Mythic Bosses",
    ["HEROIC_BOSSES"] = "Kill %d More Heroic Dungeon Bosses",
    ["NORMAL_BOSSES"] = "Kill %d More Normal Bosses",
    ["LFR_BOSSES"] = "Kill %d More LFR Bosses",
    ["DELVES"] = "Complete %d More Tier +%s Delves",
    ["SEASON_ONE"] = "The War Within Season 1",
    ["VETERAN"] = "Veteran",
    ["CHAMPION"] = "Champion",
    ["HERO"] = "Hero",
    ["MYTH"] = "Myth",
    ["MYTHIC_0"] = "Time %d More Mythic 0 Dungeons",
    ["MYTHIC_PLUS"] = "Time %d More +%s Keys",
    ["WEATHERED_CREST"] = "Weathered Undermine Crest",
    ["CARVED_CREST"] = "Carved Undermine Crest",
    ["RUNED_CREST"] = "Runed Undermine Crest",
    ["GILDED_CREST"] = "Gilded Undermine Crest",
    ["DEVLE"] = "Delves",
    ["MYTHIC"] = "Mythic+",
    ["MYTHIC_RAID_BOSS"] = "Mythic Raid Boss",
    ["HEROIC_RAID_BOSS"] = "Heroic Raid Boss",
    ["NORMAL_RAID_BOSS"] = "Normal Raid Boss",
    ["TIME"] = "Time %d more +%s keys",
    ["HEROIC_DUNGEON"] = "Heroic Dungeon Boss",
    ["H_DUNGEON_KILLS"] = "Kill %d More Heroic Dungeon Bosses",
    ["CRESTS"] = "Crests",
    ["EACH"] = "    (%d each)"
}

--Перевод ZamestoTV
CrestTracker_Locale["ruRU"] = {
    ["MYTHIC_BOSSES"] = "Убить еще %d боссов эпохальной сложности",
    ["HEROIC_BOSSES"] = "Убить еще %d боссов героической сложности",
    ["NORMAL_BOSSES"] = "Убить еще %d боссов в обычной сложности",
    ["LFR_BOSSES"] = "Убить еще %d боссов в поиске рейда",
    ["DELVES"] = "Завершить еще %d Вылазок уровня +%s",
    ["SEASON_ONE"] = "Сезон 1 «Война внутри»",
    ["VETERAN"] = "Ветеран",
    ["CHAMPION"] = "Защитник",
    ["HERO"] = "Герой",
    ["MYTH"] = "Легенда",
    ["MYTHIC_0"] = "Пройти еще %d эпохальных подземелий 0",
    ["MYTHIC_PLUS"] = "Пройти еще %d ключей +%s",
    ["WEATHERED_CREST"] = "Истертый герб Нижней Шахты",
    ["CARVED_CREST"] = "Резной герб Нижней Шахты",
    ["RUNED_CREST"] = "Рунический герб Нижней Шахты",
    ["GILDED_CREST"] = "Позолоченный герб Нижней Шахты",
    ["DEVLE"] = "Вылазки",
    ["MYTHIC"] = "Мифик+",
    ["MYTHIC_RAID_BOSS"] = "Эпохальный рейдовый босс",
    ["HEROIC_RAID_BOSS"] = "Героический рейдовый босс",
    ["NORMAL_RAID_BOSS"] = "Обычный рейдовый босс",
    ["TIME"] = "Пройти еще %d ключей +%s",
    ["HEROIC_DUNGEON"] = "Босс героического подземелья",
    ["H_DUNGEON_KILLS"] = "Убить еще %d боссов героических подземелий",
    ["CRESTS"] = "Гербы",
    ["EACH"] = "    (%d за каждого)"
}

function CrestTracker_Locale.GetLocalizedStrings()
    local locale = GetLocale()
    return CrestTracker_Locale[locale] or CrestTracker_Locale["enUS"]
end

local L = CrestTracker_Locale.GetLocalizedStrings()
print(L["MYTHIC_BOSSES"])