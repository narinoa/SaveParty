Global("localization", nil)

Global("Locales", {
	["rus"] = { -- Russian, Win-1251
    ["Invite All"] = "���������� ����",
    ["LABIRINT"] = "��������",
    ["ASTRAL"] = "������",
    ["FRIENDS"] = "������� �� ������",
    ["GUILD"] = "������� �� ������������",
    ["ALL"] = "������� �� ���������",
    ["SCHEMEQUALITY"] = "������������� ����",
    ["Layer"] = "����",
    ["Light mode "] = "���������� ����� ",
    ["INVITATIONS"] = "��������������� ",
    ["OFF"] = " ����",
    ["ON"] = " ���",
    ["Linghtning"] = "������ ������������ ����� ������",
    ["Adv"] = "���������� ����� ������ � ���������� ����������� ����",
    ["Detach"] = "�� ������ ����������� ����",
    ["Battles"] = "�� ������ �������� � �������",
    ["LootFree"] = "���� ��� �����",
    ["LootGroup"] = "���� �������",
    ["LootMaster"] = "����������",
	["ITEM_QUALITY_JUNK"] = "����",
	["ITEM_QUALITY_GOODS"] = "�������",
	["ITEM_QUALITY_COMMON"] = "���������",
	["ITEM_QUALITY_UNCOMMON"] = "�������������",
	["ITEM_QUALITY_RARE"] = "������",
	["ITEM_QUALITY_EPIC"] = "�����������",
	["ITEM_QUALITY_LEGENDARY"] = "��������",
	["ITEM_QUALITY_RELIC"] = "��������",
	[" Not Leader"] = " ������ �� �����",
	[" Leader"] = " ������ �����",
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