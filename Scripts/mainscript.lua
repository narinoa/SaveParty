local Config = {
["ASTRAL"] = false, 
["LABIRINT"] = false, 
["LIGHT"] = false, 
["SCHEMEQUALITY"] = true, 
["INVITATIONS"] = true, 
["FRIENDS"] = true, 
["GUILD"] = false, 
["ALL"] = false, 
['position'] = 2, 
['quality'] = 1, 
 }

local count = 0
local leader = 0

local infotable = {}
local itemtable = {}
local widgets = {}
local qualitywt = {}
local leaderwt = {}

local IsAOPanelEnabled = GetConfig( "EnableAOPanel" ) or GetConfig( "EnableAOPanel" ) == nil
local wtMainPanel =  mainForm:GetChildChecked( "MainPanel", false )
local wtSettingsPanel = mainForm:GetChildChecked( "Settings", false )
local wtContainer = wtMainPanel:GetChildChecked( "Container", false )
local wtButton = mainForm:GetChildChecked( "Button", false )
local wtInviteAll
local wtTextAstral
local wtTextLabirint
local wtTimer = nil
local wtTimeLeader = nil
local wtChat = nil
local valuedText = common.CreateValuedText()
wtButton:SetVal("button_label", userMods.ToWString("SP"))
wtMainPanel:Show(false)
local wtHeader = wtMainPanel:GetChildChecked( "Header", false )
wtHeader:SetVal("name", common.GetAddonName())
local wtPanelLootText = wtMainPanel:GetChildChecked( "LootPanel", false ):GetChildChecked( "ListPanelDescText", false )

local LootType = {
[0] = GTL('LootFree'),
[1] = GTL('LootMaster'),
[2] = GTL('LootGroup'),}

local LootTypeEnum = {
[0] = LOOT_SCHEME_TYPE_FREE_FOR_ALL,
[1] = LOOT_SCHEME_TYPE_MASTER,
[2] = LOOT_SCHEME_TYPE_GROUP,
}

local LootQuality = {
[1] = GTL('ITEM_QUALITY_JUNK'),
[2] = GTL('ITEM_QUALITY_GOODS'),
[3] = GTL('ITEM_QUALITY_COMMON'),
[4] = GTL('ITEM_QUALITY_UNCOMMON'),
[5] = GTL('ITEM_QUALITY_RARE'),
[6] = GTL('ITEM_QUALITY_EPIC'),
[7] = GTL('ITEM_QUALITY_LEGENDARY'),
[8] = GTL('ITEM_QUALITY_RELIC'),
}

local LootQualityColor = {
[1] = "Junk",
[2] = "Goods",
[3] = "Common",
[4] = "Uncommon",
[5] = "Rare",
[6] = "Epic",
[7] = "Legendary",
[8] = "Relic",
}

local fadeDesc = mainForm:GetChildChecked( "fade", true ):GetWidgetDesc()
local ItemPanelDesc = mainForm:GetChildChecked( "ItemPanel", true ):GetWidgetDesc()
local ButtonInviteDesc = mainForm:GetChildChecked( "ButtonInvite", true ):GetWidgetDesc()
local ButtonDeleteDesc = mainForm:GetChildChecked( "ButtonDelete", true ):GetWidgetDesc()
local ButtonDesc = mainForm:GetChildChecked( "Button", true ):GetWidgetDesc()
local ButtonDesc = mainForm:GetChildChecked( "Button", true ):GetWidgetDesc()
local CheckBoxDesc = mainForm:GetChildChecked( "CheckBox", true ):GetWidgetDesc()
local CheckButtonDesc = mainForm:GetChildChecked( "CheckButton", true ):GetWidgetDesc()
local LeaderButtonDesc = mainForm:GetChildChecked( "LeaderButton", true ):GetWidgetDesc()
local TextDesc = mainForm:GetChildChecked( "Text", true ):GetWidgetDesc()

function LogToChat(text, color, value)
	if not wtChat then 
		wtChat = stateMainForm:GetChildUnchecked("ChatLog", false)
		wtChat = wtChat:GetChildUnchecked("Container", true)
		local formatVT = "<html fontname='AllodsFantasy' fontsize='14' shadow='1'><rs class='color'><r name='addon'/><r name='text'/></rs><rs class='valcolor'><r name='value'/></rs></html>"
		valuedText:SetFormat(userMods.ToWString(formatVT))
	end
	if wtChat and wtChat.PushFrontValuedText then
		if not common.IsWString(text) then text = userMods.ToWString(text) end
		valuedText:ClearValues()
		valuedText:SetClassVal( "color", "LogColorYellow" )
		if color then valuedText:SetClassVal( "valcolor", color ) end
		if value then valuedText:SetVal( "value", userMods.ToWString(value) ) end
		valuedText:SetVal( "text", text )
		valuedText:SetVal( "addon", userMods.ToWString("SaveParty: ") )
		wtChat:PushFrontValuedText( valuedText )
	end
end

function StartTimer( wt, interval, tickFunction)
  local wtTimer = mainForm:CreateWidgetByDesc(wt:GetWidgetDesc())
  common.RegisterEventHandler(function(params)
    if params.effectType == ET_FADE and params.wtOwner:IsEqual( wtTimer ) then 
      wtTimer:PlayFadeEffect(0.0, 1.0, interval, EA_MONOTONOUS_INCREASE)
      tickFunction()
    end
  end, "EVENT_EFFECT_FINISHED")
  wtTimer:PlayFadeEffect(0.0, 1.0, interval, EA_MONOTONOUS_INCREASE)
end

function SetPos(wt,posX,sizeX,posY,sizeY,highPosX,highPosY,alignX, alignY, addchild)
  if wt then
    local p = wt:GetPlacementPlain()
    if posX then p.posX = posX end
    if sizeX then p.sizeX = sizeX end
    if posY then p.posY = posY end
    if sizeY then p.sizeY = sizeY end
    if highPosX then p.highPosX = highPosX end
    if highPosY then p.highPosY = highPosY end
	if alignX then p.alignX = alignX end
	if alignY then p.alignY = alignY end
    wt:SetPlacementPlain(p) 
  end
  if addchild then addchild = addchild:AddChild( wt ) end
end

function wtSetPlace(w, place )
	local p=w:GetPlacementPlain()
	for k, v in pairs(place) do	
		p[k]=place[k] or v
	end
	w:SetPlacementPlain(p)
end

function CreateWG(desc, name, parent, show, place)
	local n
	n = mainForm:CreateWidgetByDesc( desc )
	if name then n:SetName( name ) end
	if parent then parent:AddChild(n) end
	if place then wtSetPlace( n, place ) end
	n:Show( show == true )
	return n
end

widgets.ASTRAL = CreateWG(CheckBoxDesc, "ASTRAL", wtMainPanel, true, {alignX=0, sizeX=30, posX=40, highPosX=0, alignY=1, sizeY=30, posY=0, highPosY=5,})
widgets.LABIRINT = CreateWG(CheckBoxDesc, "LABIRINT", wtMainPanel, true, {alignX=0, sizeX=30, posX=125, highPosX=0, alignY=1, sizeY=30, posY=0, highPosY=5,})
widgets.INVITATIONS = CreateWG(CheckButtonDesc, "INVITATIONS", wtMainPanel, true, {alignX=0, sizeX=30, posX=15, highPosX=0, alignY=1, sizeY=30, posY=0, highPosY=5,})
widgets.FRIENDS = CreateWG(CheckBoxDesc, "FRIENDS", wtSettingsPanel, true, {alignX=0, sizeX=30, posX=25, highPosX=0, alignY=0, sizeY=30, posY=20, highPosY=0,})
widgets.GUILD = CreateWG(CheckBoxDesc, "GUILD", wtSettingsPanel, true, {alignX=0, sizeX=30, posX=25, highPosX=0, alignY=0, sizeY=30, posY=45, highPosY=0,})
widgets.ALL = CreateWG(CheckBoxDesc, "ALL", wtSettingsPanel, true, {alignX=0, sizeX=30, posX=25, highPosX=0, alignY=0, sizeY=30, posY=70, highPosY=0,})
widgets.SCHEMEQUALITY = CreateWG(CheckBoxDesc, "SCHEMEQUALITY", wtSettingsPanel, true, {alignX=0, sizeX=30, posX=25, highPosX=0, alignY=0, sizeY=30, posY=95, highPosY=0,})


function Delay(interval, name)
	wtTimer = CreateWG(fadeDesc, name)
	wtTimer:PlayFadeEffect(0.1, 0.0, interval, EA_MONOTONOUS_INCREASE)
end

function DelayLeader(interval, name)
	wtTimeLeader = CreateWG(fadeDesc, name)
	wtTimeLeader:PlayFadeEffect(0.1, 0.0, interval, EA_MONOTONOUS_INCREASE)
end

function DestroyTimer()
wtTimer:FinishFadeEffect()
wtTimer:DestroyWidget()
wtTimer = nil
end

function DestroyTimerLeader()
wtTimeLeader:FinishFadeEffect()
wtTimeLeader:DestroyWidget()
wtTimeLeader = nil
end

function CheckDelay(params)
if params.wtOwner:GetName() == common.GetAddonName().."fade" then
SaveParty()
DestroyTimer()
	end
if params.wtOwner:GetName() == common.GetAddonName().."scheme" then
QualitySet()
DestroyTimer()
	end
if params.wtOwner:GetName() == common.GetAddonName().."leader" then
	if infotable and infotable[leader] then
	group.SetLeader(group.GetMembers()[group.GetMemberIndexByName(infotable[leader])].uniqueId)
	end
	DestroyTimerLeader()
	end
end

function ReactionButton(params)
if DnD:IsDragging() then return end
	if params.sender == "Button" then
		if Config.LIGHT then InviteForNameAll() return end
		if wtMainPanel:IsVisible() then	
			wtMainPanel:Show(false)
			wtContainer:RemoveItems()
		else
			wtMainPanel:Show(true)	
			wtContainer:RemoveItems()
			ShowInfo()
		end  
		elseif params.sender == "InviteAll" then
		InviteForNameAll()
		else
		InviteForName(params.sender)
		end
end

function Delete(params)
if params.widget:GetName()=="ButtonCornerCross" then 
	wtMainPanel:Show(false)
	wtContainer:RemoveItems()
elseif infotable[tonumber(params.sender)] then
	params.widget:GetParent():DestroyWidget()
	infotable[tonumber(params.sender)]=nil
	Save()
	end
if params.widget:GetName()=="ButtonCloseSettings" then 
	 wtSettingsPanel:Show(not wtSettingsPanel:IsVisible())
	end
end

function Load()
local tab = userMods.GetAvatarConfigSection( "PartyCFG" )
	if tab then
	infotable = userMods.GetAvatarConfigSection( "PartyCFG" )
	end
if userMods.GetAvatarConfigSection("SP_Config") then
		Config = userMods.GetAvatarConfigSection("SP_Config")
	else 
	userMods.SetAvatarConfigSection("SP_Config", Config) end
	if not Config.position then Config.position = 0 userMods.SetAvatarConfigSection("SP_Config", Config) end 
	if not Config.quality then Config.quality = 2 userMods.SetAvatarConfigSection("SP_Config", Config) end 
	if not Config.FRIENDS then Config.FRIENDS = true userMods.SetAvatarConfigSection("SP_Config", Config) end 
	if not Config.GUILD then Config.GUILD = false userMods.SetAvatarConfigSection("SP_Config", Config) end 
	if not Config.ALL then Config.ALL = false userMods.SetAvatarConfigSection("SP_Config", Config) end 
	if not Config.SCHEMEQUALITY then Config.SCHEMEQUALITY = true userMods.SetAvatarConfigSection("SP_Config", Config) end 
	wtPanelLootText:SetVal( "list_desctext", LootType[Config.position] )
	qualitywt.text:SetVal( "list_desctext", LootQuality[Config.quality] )
	qualitywt.text:SetClassVal( "class", LootQualityColor[Config.quality] )
end

function Save()
if infotable then
userMods.SetAvatarConfigSection( "PartyCFG", infotable )
	end
end 

function SaveParty()
count = 0
leader = 0
infotable = nil infotable = {}
local members = group.GetMembers()
	if members then
		for k, v in pairs(members) do
			if k >0 then
			table.insert(infotable, object.GetName(v.id))
			end
		end
		Save()
	else 
	infotable = nil infotable = {}
	Save()
	end
	wtContainer:RemoveItems()
	ShowInfo()
end

function InviteForNameAll()
if infotable then
	for _, name in pairs(infotable) do
			if not IsInGroup(name) then
			group.InviteByName( name )
			end
		end
	end
end

function InviteForName(num)
	if infotable then
		for pos, name in pairs(infotable) do
			if tonumber(pos) == tonumber(num) then
				group.InviteByName( name )
			end
		end
	end
end

function IsInGroup(name)
local memberIndex = group.GetMemberIndexByName(name)
	if memberIndex and memberIndex>= 0 then
	return true
	else return false
	end
end

function ShowInfo()
LoadCheckBox()
local avatarName=object.GetName(avatar.GetId())
wtSetPlace(wtMainPanel, {sizeY = 290, sizeX = 420} )
itemtable = nil itemtable = {}
if infotable then
	for k, v in pairs(infotable) do
	local wtItemSlot = CreateWG(ItemPanelDesc, "wtItemSlot", nil, true, {alignX=3, sizeX=372, posX=5, highPosX=25, alignY=3, sizeY=35, posY=0, highPosY=0,})
	if common.GetWStringLength(v)>2 then
			local wtAvatarName = CreateWG(TextDesc, "AvatarName", wtItemSlot, true, {alignX=4, sizeX=200, posX=40, highPosX=0, alignY=4, sizeY=30, posY=5, highPosY=0,})
			local wtInviteButton = CreateWG(ButtonInviteDesc, tostring(k), wtItemSlot, true, {alignX=1, sizeX=25, posX=0, highPosX=10, alignY=4, sizeY=25, posY=5, highPosY=0,})
			local wtDelete = CreateWG(ButtonDeleteDesc, tostring(k), wtItemSlot, true, {alignX=1, sizeX=20, posX=0,  highPosX=40, alignY=4, sizeY=20, posY=5, highPosY=0,})
			local wtLeader = CreateWG(LeaderButtonDesc, tostring(k), wtItemSlot, true, {alignX=4, sizeX=30, posX=5, highPosX=0, alignY=4, sizeY=30, posY=0, highPosY=0,})
			table.insert(itemtable, {wtAvatarName=wtAvatarName, wtInviteButton=wtInviteButton, wtDelete=wtDelete, wtLeader=wtLeader})
			wtAvatarName:SetVal("name", v)
				if infotable and infotable[leader] and leader == k then
				wtLeader:SetVariant(1)
				end
				if IsInGroup(v) then
				wtAvatarName:SetClassVal("class", "tip_green")
				wtInviteButton:Show(false)
				end
				CBcount()
			end
	wtContainer:PushFront( wtItemSlot)
		end 
	end
end
	
function PartyChange()
wtContainer:RemoveItems()
ShowInfo()
end

function CountChange()
--if GetTableSize(infotable) >= #group.GetMembers() then
if #group.GetMembers() >= GetTableSize(infotable) then
	DelayLeader(500, common.GetAddonName().."leader") 
	end
end


function AcceptAdventure()
if Config.INVITATIONS then
local questions = questionLib.GetQuestions()
if questions[0] then
  local question = questionLib.GetInfo( questions[0] )
  if question.questionData then
	for k,v in pairs( question.questionData ) do
		if v.text then 
		local text = userMods.FromWString(v.text)
			for _, answer in pairs(answers) do 
			if text:find(answer) then 
			questionLib.SendData( questions[0], {["choice"] = 1 } )
							end
						end 
					end
				end 
			end
		end 
	end
end

function LoadCheckBox()
for name, val in pairs(widgets) do
	if (Config[name]==true) then 
		val:SetVariant(1 or 0) 
		end
	end
end

local leaderwidgets = {
["1"] = true,
["2"] = true,
["3"] = true,
["4"] = true,
["5"] = true,
}

function CheckBoxReaction(pars)
if pars.sender == pars.widget:GetName() then
	if pars.widget:GetVariant()==0 then 
    Config[pars.sender] = true
	pars.widget:SetVariant(1)
	userMods.SetAvatarConfigSection ("SP_Config", Config)
	if not leaderwidgets[pars.widget:GetName()]	then
	LogToChat(GTL(pars.sender), "LogColorGreen", GTL('ON'))
	else
	LogToChat(infotable[tonumber(pars.sender)], "LogColorGreen", GTL(' Leader'))
	end
	if leaderwidgets[pars.widget:GetName()]	then
	count = count + 1
	leader = tonumber(pars.widget:GetName())
	end
else 
	Config[pars.sender] = false 
	pars.widget:SetVariant(0)
	userMods.SetAvatarConfigSection ("SP_Config", Config)
	if leaderwidgets[pars.widget:GetName()]	then
		count = count - 1
		leader = 0
			end
			if not leaderwidgets[pars.widget:GetName()]	then
			LogToChat(GTL(pars.sender), "LogColorRed", GTL('OFF'))
			else
			LogToChat(infotable[tonumber(pars.sender)], "LogColorRed", GTL(' Not Leader'))
			end
		end
	end
	CBcount()
end 

function CBcount()
for k, v in pairs(itemtable) do
	if count >= 1 and itemtable[k].wtLeader:GetVariant()==0 then
	itemtable[k].wtLeader:Show( false )
	elseif count <= 1 and itemtable[k].wtLeader:GetVariant()==0 then
	itemtable[k].wtLeader:Show( true )
		end
	end
end

function SettingsReaction()
	 wtSettingsPanel:Show(not wtSettingsPanel:IsVisible())
end

function onAOPanelStart( params )
	if IsAOPanelEnabled then
		local SetVal = { val1 = userMods.ToWString("SP"), class1 = "LogColorOrange" }
		local params = { header = SetVal, ptype = "button", size = 32 }
		userMods.SendEvent( "AOPANEL_SEND_ADDON", { name = common.GetAddonName(), sysName = common.GetAddonName(), param = params } )
		wtButton:Show( false )
	end 
end

function OnAOPanelButtonLeftClick( params ) 
	if params.sender == common.GetAddonName() then 
	if Config.LIGHT then InviteForNameAll() return end
	if wtMainPanel:IsVisible() then	
		wtMainPanel:Show(false)
		wtContainer:RemoveItems()
	else
		wtMainPanel:Show(true)	
		wtContainer:RemoveItems()
		ShowInfo()
		end  
	end 
end

function OnAOPanelButtonRightClick( params ) 
	if params.sender == common.GetAddonName() then
	SaveParty()
	end 
end

function onAOPanelChange( params )
	if params.unloading and params.name == "UserAddon/AOPanelMod" then
		wtButton:Show( true )
	end
end

function enableAOPanelIntegration( enable )
	IsAOPanelEnabled = enable
	SetConfig( "EnableAOPanel", enable )
	if enable then
		onAOPanelStart()
	else
		wtButton:Show( true )
	end
end

function AutoSaveParty()
	if matchMaking.IsAvatarInMatchMakingEvent() then
	local info = matchMaking.GetCurrentBattleInfo()
		if userMods.FromWString(info.name) == GTL('LABIRINT') and Config.LABIRINT then
		Delay(1000, common.GetAddonName().."fade") 
		elseif string.find(userMods.FromWString(info.name), GTL("Layer")) and Config.ASTRAL then
		Delay(1000, common.GetAddonName().."fade") 
		end
	end
end

function SlashCMD( params )
	local text = userMods.FromWString(params.text)
if text == "/spmode" then
	if Config.LIGHT then
	Config.LIGHT = false
	LogToChat(GTL('Light mode '), "LogColorRed", GTL('OFF') )
	userMods.SetAvatarConfigSection ("SP_Config", Config)
	elseif not Config.LIGHT then 
	Config.LIGHT = true
	userMods.SetAvatarConfigSection ("SP_Config", Config)
	LogToChat(GTL('Light mode '), "LogColorGreen", GTL('ON'))
		end
	end
if text == "/spinvite" then
	if Config.INVITATIONS then
	Config.INVITATIONS = false
	LogToChat(GTL('INVITATIONS'), "LogColorRed", GTL('OFF') )
	userMods.SetAvatarConfigSection ("SP_Config", Config)
	elseif not Config.INVITATIONS then 
	Config.INVITATIONS = true
	userMods.SetAvatarConfigSection ("SP_Config", Config)
	LogToChat(GTL('INVITATIONS'), "LogColorGreen", GTL('ON'))
		end
	end
end

function listleftbuttonpressed( params )
	if params.sender == "ListPanelButtonLeft" then
	Config.position = Config.position - 1
	if Config.position < 0 then Config.position = GetTableSize(LootType)-1 end
	wtPanelLootText:SetVal( "list_desctext", LootType[Config.position] )
	SchemeSet()
	elseif params.sender == "QualityLeft" then
	Config.quality = Config.quality - 1
	if Config.quality < 1 then Config.quality = GetTableSize(LootQuality) end
	qualitywt.text:SetVal( "list_desctext", LootQuality[Config.quality] )
	qualitywt.text:SetClassVal( "class", LootQualityColor[Config.quality] )
	QualitySet()
	end
	userMods.SetAvatarConfigSection("SP_Config", Config)
end

function listrightbuttonpressed( params )
	if params.sender == "ListPanelButtonRight" then
	Config.position = Config.position + 1
	if Config.position > GetTableSize(LootType)-1 then Config.position = 0 end
	wtPanelLootText:SetVal( "list_desctext", LootType[Config.position] )
	SchemeSet()
	elseif params.sender == "QualityRight" then
	Config.quality = Config.quality + 1
	if Config.quality > GetTableSize(LootQuality) then Config.quality = 1 end
	qualitywt.text:SetVal( "list_desctext", LootQuality[Config.quality] )
	qualitywt.text:SetClassVal( "class", LootQualityColor[Config.quality] )
	QualitySet()
	end
	userMods.SetAvatarConfigSection("SP_Config", Config)
end

function MaybeCloseMsgboxes()
	common.StateUnloadManagedAddon( "ContextUniMessageBox" )
	common.StateLoadManagedAddon( "ContextUniMessageBox" )
end

function IsGuildMember( name )
	if not guild.IsExist() then return false end
	if guild.GetMember(name) then return true end
	return false
end

function IsFriend( name )
	if social.GetFriend(name) then return true end
	return false
end

function AcceptGroup(params)
if Config.INVITATIONS then
if (Config.FRIENDS and IsFriend(params.inviterName) ) or (Config.GUILD and IsGuildMember(params.inviterName)) then
		group.Accept()
		MaybeCloseMsgboxes()
		end
if (Config.ALL and not IsFriend(params.inviterName) and not IsGuildMember(params.inviterName)) then
		group.Accept()
		MaybeCloseMsgboxes()
		end
	end
end

function ChatMessage(params)
if params.chatType == CHAT_TYPE_WHISPER and not params.isEcho then
	local text = userMods.FromWString(params.msg)
		if text == "+++" then
		InviteForNameAll()
		end
		else return 
	end
end

function AppearedGroupRaid()
if group.IsLeader() or raid.IsLeader() then
SchemeSet()
Delay(500, common.GetAddonName().."scheme") 
	end
end

function SchemeSet()
if Config.SCHEMEQUALITY then
	loot.SetLootScheme(Config.position) 
	end
end 

function QualitySet()
if Config.SCHEMEQUALITY then
	loot.SetMinItemQualityForLootScheme(Config.quality) 
	end
end

function Init()
	qualitywt.widget = wtMainPanel:GetChildChecked( "QualityPanel", false )
	qualitywt.text = qualitywt.widget:GetChildChecked( "ListPanelDescText", false )
	qualitywt.text:SetFormat("<html alignx='center' shadow='1'><rs class='class'><r name='list_desctext'/></rs></html>")
	qualitywt.bg = qualitywt.widget:GetChildChecked( "ListTooltipPanel", false )
	qualitywt.leftbutton = qualitywt.widget:GetChildChecked( "ListPanelButtonLeft", false )
	qualitywt.leftbutton:SetName("QualityLeft")
	qualitywt.rightbutton = qualitywt.widget:GetChildChecked( "ListPanelButtonRight", false )
	qualitywt.rightbutton:SetName("QualityRight")
	qualitywt.textfriend = CreateWG(TextDesc, "textfriend", wtSettingsPanel, true, {alignX=4, sizeX=200, posX=50, highPosX=0, alignY=0, sizeY=30, posY=20, highPosY=0,})
	qualitywt.textguild = CreateWG(TextDesc, "textguild", wtSettingsPanel, true, {alignX=4, sizeX=200, posX=50, highPosX=0, alignY=0, sizeY=30, posY=45, highPosY=0,})
	qualitywt.textall = CreateWG(TextDesc, "textall", wtSettingsPanel, true, {alignX=4, sizeX=200, posX=50, highPosX=0, alignY=0, sizeY=30, posY=70, highPosY=0,})
	qualitywt.textschemequality = CreateWG(TextDesc, "textschemequality", wtSettingsPanel, true, {alignX=4, sizeX=200, posX=50, highPosX=0, alignY=0, sizeY=30, posY=95, highPosY=0,})
	qualitywt.textfriend:SetVal("name", GTL("FRIENDS"))
	qualitywt.textguild:SetVal("name", GTL("GUILD"))
	qualitywt.textall:SetVal("name", GTL("ALL"))
	qualitywt.textschemequality:SetVal("name", GTL("SCHEMEQUALITY"))
	wtSetPlace(qualitywt.widget, {highPosX = 40, sizeX = 180})
	wtSetPlace(wtContainer, {sizeX = 395} )
	Load()
	---
	wtInviteAll = CreateWG(ButtonDesc, "InviteAll", wtMainPanel, true, {alignX=1, sizeX=150, posX=0, highPosX=20, alignY=1, sizeY=25, posY=0, highPosY=12,})
	wtTextAstral = CreateWG(TextDesc, "TextAstral", wtMainPanel, true, {alignX=0, sizeX=80, posX=60, highPosX=0, alignY=1, sizeY=30, posY=0, highPosY=5,})
	wtTextLabirint = CreateWG(TextDesc, "TextLabirint", wtMainPanel, true, {alignX=0, sizeX=80, posX=145, highPosX=0, alignY=1, sizeY=30, posY=0, highPosY=5,})	
	wtInviteAll:SetVal("button_label", userMods.ToWString(GTL('Invite All')))
	wtTextLabirint:SetVal("name", GTL('LABIRINT'))
	wtTextAstral:SetVal("name", GTL('ASTRAL'))
	---
	common.RegisterReactionHandler( ReactionButton, "LEFT_CLICK" )
	common.RegisterReactionHandler(listleftbuttonpressed, "list_leftbutton_pressed" )
	common.RegisterReactionHandler(listrightbuttonpressed, "list_rightbutton_pressed" )
	common.RegisterEventHandler( AppearedGroupRaid, "EVENT_GROUP_APPEARED" )
	common.RegisterEventHandler( AppearedGroupRaid, "EVENT_RAID_APPEARED" )
	common.RegisterReactionHandler( Delete, "mouse_left_click" )
	common.RegisterReactionHandler( SaveParty, "RIGHT_CLICK" )
	common.RegisterReactionHandler( CheckBoxReaction, "checkbox" )
	common.RegisterReactionHandler( SettingsReaction, "settings" )
	common.RegisterEventHandler( PartyChange, "EVENT_GROUP_CHANGED" )
	common.RegisterEventHandler( CountChange, "EVENT_GROUP_CHANGED" )
	common.RegisterEventHandler( PartyChange, "EVENT_GROUP_MEMBER_REMOVED" )
	common.RegisterEventHandler( PartyChange, "EVENT_GROUP_DISAPPEARED" )
	common.RegisterEventHandler( onAOPanelStart, "AOPANEL_START" )
    common.RegisterEventHandler( OnAOPanelButtonLeftClick, "AOPANEL_BUTTON_LEFT_CLICK" )  
	common.RegisterEventHandler( OnAOPanelButtonRightClick, "AOPANEL_BUTTON_RIGHT_CLICK" )  
	common.RegisterEventHandler( onAOPanelChange, "EVENT_ADDON_LOAD_STATE_CHANGED" )
	common.RegisterEventHandler( AcceptAdventure, "EVENT_QUESTION_ADDED" )
	common.RegisterEventHandler( AutoSaveParty, "EVENT_MATCH_MAKING_CURRENT_BATTLE_CHANGED" )
	common.RegisterEventHandler( SlashCMD, "EVENT_UNKNOWN_SLASH_COMMAND" )
	common.RegisterEventHandler( ChatMessage, "EVENT_CHAT_MESSAGE" )
	common.RegisterEventHandler( CheckDelay, "EVENT_EFFECT_FINISHED" )
	common.RegisterEventHandler( AcceptGroup, "EVENT_GROUP_INVITE" )
	DnD:Init( wtMainPanel, wtMainPanel, true )
	DnD:Init( wtSettingsPanel, wtSettingsPanel, true )
	DnD:Init( wtButton, wtButton, true )
end

if (avatar.IsExist()) then Init()
else common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")	
end