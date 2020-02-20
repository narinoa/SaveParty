Global("localization", nil)

Global("Locales", {
	["rus"] = { -- Russian, Win-1251
    ["Invite All"] = "Пригласить всех",
    ["LABIRINT"] = "Лабиринт",
    ["ASTRAL"] = "Астрал",
    ["FRIENDS"] = "Реакция на друзей",
    ["GUILD"] = "Реакция на согильдийцев",
    ["ALL"] = "Реакция на остальных",
    ["SCHEMEQUALITY"] = "Автоустановка лута",
    ["Layer"] = "Слой",
    ["Light mode "] = "Упрощенный режим ",
    ["INVITATIONS"] = "Автоприглашения ",
    ["OFF"] = " ВЫКЛ",
    ["ON"] = " ВКЛ",
    ["Linghtning"] = "занять пассажирское место Молнии",
    ["Adv"] = "прекратить поиск группы и немедленно отправиться туда",
    ["Detach"] = "Вы готовы отправиться туда",
    ["Battles"] = "Вы готовы вступить в очередь",
    ["LootFree"] = "Бери кто хочет",
    ["LootGroup"] = "Кому повезет",
    ["LootMaster"] = "Заведующий",
	["ITEM_QUALITY_JUNK"] = "Хлам",
	["ITEM_QUALITY_GOODS"] = "Обычные",
	["ITEM_QUALITY_COMMON"] = "Добротные",
	["ITEM_QUALITY_UNCOMMON"] = "Замечательные",
	["ITEM_QUALITY_RARE"] = "Редкие",
	["ITEM_QUALITY_EPIC"] = "Легендарные",
	["ITEM_QUALITY_LEGENDARY"] = "Чудесные",
	["ITEM_QUALITY_RELIC"] = "Реликвии",
	[" Not Leader"] = " больше не лидер",
	[" Leader"] = " теперь лидер",
	},
		
	["eng_eu"] = { -- English, Latin-1
    ["Invite All"] = "Invite all",
	["LABIRINT"] = "Maze",
    ["ASTRAL"] = "Astral",
	["FRIENDS"] = "Reaction to friends",
    ["GUILD"] = "Reaction to guild",
    ["ALL"] = "Reaction to another",
	["SCHEMEQUALITY"] = "Autoset loot scheme",
    ["Layer"] = "Layer",
	["Light mode "] = "Simplified mode",
	["INVITATIONS"] = "Auto invitations ",
    ["OFF"] = " Off",
    ["ON"] = " On",
	["Linghtning"] = "Lightning Bolt",
    ["Adv"] = "Do you want to stop searching for a group and go there immediately",
    ["Detach"] = "Are you ready to go there",
    ["Battles"] = "Are you ready to queue up",
	["LootFree"] = "Take who wants",
	["LootGroup"] = "Who are lucky",
	["LootMaster"] = "Head of Loot",
	["ITEM_QUALITY_JUNK"] = "Junk",
	["ITEM_QUALITY_GOODS"] = "Goods",
	["ITEM_QUALITY_COMMON"] = "Common",
	["ITEM_QUALITY_UNCOMMON"] = "Uncommon",
	["ITEM_QUALITY_RARE"] = "Rare",
	["ITEM_QUALITY_EPIC"] = "Epic",
	["ITEM_QUALITY_LEGENDARY"] = "Legendary",
	["ITEM_QUALITY_RELIC"] = "Relic",
	}
})

--We can now use an official method to get the client language
localization = common.GetLocalization()
function GTL( strTextName )
	return Locales[ localization ][ strTextName ] or Locales[ "eng_eu" ][ strTextName ] or strTextName
end

Global("answers", {
GTL("Adv"),
GTL("Detach"),
GTL("Linghtning"),
GTL("Battles"),
})