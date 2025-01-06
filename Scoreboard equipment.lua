local var_0_0 = require("gamesense/csgo_weapons")
local var_0_1 = require("table.clear")
local var_0_2 = setmetatable({}, {
	__index = function(arg_1_0, arg_1_1)
		arg_1_0[arg_1_1] = var_0_0[tonumber(arg_1_1)] or false

		return arg_1_0[arg_1_1]
	end
})
local var_0_3 = var_0_0.item_kevlar
local var_0_4 = var_0_0.item_assaultsuit
local var_0_5 = var_0_0.item_heavyassaultsuit
local var_0_6 = var_0_0.item_cutters
local var_0_7 = var_0_0.item_defuser
local var_0_8 = var_0_0.weapon_taser
local var_0_9 = var_0_0.weapon_c4
local var_0_10 = 2
local var_0_11 = 3

local function var_0_12(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		local var_2_0 = arg_2_1[iter_2_0]

		if var_2_0 == nil then
			return false
		elseif iter_2_1 ~= var_2_0 then
			if type(iter_2_1) == "table" and type(var_2_0) == "table" then
				if not var_0_12(iter_2_1, var_2_0) then
					return false
				end
			else
				return false
			end
		end
	end

	for iter_2_2, iter_2_3 in pairs(arg_2_1) do
		if arg_2_0[iter_2_2] == nil then
			return false
		end
	end

	return true
end

local function var_0_13(arg_3_0, arg_3_1)
	local var_3_0 = {}
	local var_3_1 = 1

	for iter_3_0 = 1, #arg_3_0 do
		local var_3_2 = arg_3_1(arg_3_0[iter_3_0])

		if var_3_2 ~= nil then
			var_3_0[var_3_1] = var_3_2
			var_3_1 = var_3_1 + 1
		end
	end

	return var_3_0
end

local function var_0_14(arg_4_0, arg_4_1)
	local var_4_0 = {}

	for iter_4_0, iter_4_1 in pairs(arg_4_0) do
		local var_4_1, var_4_2 = arg_4_1(iter_4_0, iter_4_1)

		var_4_0[var_4_1] = var_4_2
	end

	return var_4_0
end

local function var_0_15(arg_5_0, arg_5_1)
	for iter_5_0 = 1, #arg_5_0 do
		if arg_5_0[iter_5_0] == arg_5_1 then
			return true
		end
	end

	return false
end

local function var_0_16(arg_6_0, arg_6_1)
	for iter_6_0 = #arg_6_0, 1, -1 do
		if arg_6_0[iter_6_0] == arg_6_1 then
			table.remove(arg_6_0, iter_6_0)
		end
	end
end

local var_0_17 = {
	item_remove = 0,
	item_equip = 2,
	item_pickup = 2,
	player_spawn = 1,
	player_death = 0,
	player_disconnect = 0
}

local function var_0_18(arg_7_0, arg_7_1)
	return (var_0_17[arg_7_0[1]] or arg_7_0[1]:byte()) < (var_0_17[arg_7_1[1]] or arg_7_1[1]:byte())
end

local var_0_19 = {}
local var_0_20 = {}
local var_0_21 = {}
local var_0_22

local function var_0_23()
	if var_0_22 ~= nil then
		table.sort(var_0_19, var_0_18)

		for iter_8_0 = 1, #var_0_19 do
			local var_8_0, var_8_1, var_8_2 = unpack(var_0_19[iter_8_0])
			local var_8_3 = var_0_20[var_8_0]

			for iter_8_1 = 1, #var_8_3 do
				xpcall(var_8_3[iter_8_1], client.error_log, var_8_1)
			end
		end

		var_0_1(var_0_19)

		var_0_22 = nil
	end
end

local function var_0_24(arg_9_0, arg_9_1)
	if var_0_20[arg_9_0] == nil then
		local var_9_0 = {}

		var_0_21[arg_9_0] = function(arg_10_0)
			local var_10_0 = globals.curtime()

			if var_0_22 == nil then
				var_0_22 = var_10_0
			elseif var_0_22 ~= var_10_0 then
				var_0_23()

				var_0_22 = var_10_0
			end

			table.insert(var_0_19, {
				arg_9_0,
				arg_10_0
			})
		end

		client.set_event_callback(arg_9_0, var_0_21[arg_9_0])

		var_0_20[arg_9_0] = var_9_0
	end

	table.insert(var_0_20[arg_9_0], arg_9_1)
end

local function var_0_25()
	for iter_11_0, iter_11_1 in pairs(var_0_21) do
		client.unset_event_callback(iter_11_0, iter_11_1)
	end

	var_0_1(var_0_21)
	var_0_1(var_0_20)
	var_0_1(var_0_19)

	var_0_22 = nil
end

local var_0_26 = panorama.open("CSGOHud")
local var_0_27 = var_0_26.FriendsListAPI
local var_0_28 = var_0_26.MyPersonaAPI
local var_0_29 = var_0_26.GameStateAPI
local var_0_30 = panorama.loadstring("\tlet entity_panels = {}\n\tlet entity_flair_panels = {}\n\tlet entity_data = {}\n\tlet event_callbacks = {}\n\n\tlet unmuted_players = {}\n\n\tlet TEAM_COLORS = {\n\t\tCT: \"#B5D4EE40\",\n\t\tTERRORIST: \"#EAD18A61\"\n\t}\n\n\tlet SHADOW_COLORS = {\n\t\tCT: \"#393C40\",\n\t\tTERRORIST: \"#4C4844\"\n\t}\n\n\tlet HIDDEN_IDS = [\"id-sb-name__commendations__leader\", \"id-sb-name__commendations__teacher\", \"id-sb-name__commendations__friendly\", \"id-sb-name__musickit\"]\n\n\tlet SLOT_LAYOUT = `\n\t\t<root>\n\t\t\t<Panel style=\"min-width: 3px; padding-top: 2px; padding-left: 2px; overflow: noclip;\">\n\t\t\t\t<Image id=\"smaller\" textureheight=\"15\" style=\"horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;\"  />\n\t\t\t\t<Image id=\"small\" textureheight=\"17\" style=\"horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;\" />\n\t\t\t\t<Image id=\"medium\" textureheight=\"18\" style=\"horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px; margin-top: -4px;\" />\n\t\t\t\t<Image id=\"large\" textureheight=\"21\" style=\"horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px; margin-top: -5px;\" />\n\t\t\t</Panel>\n\t\t</root>\n\t`\n\n\tlet MIN_WIDTHS = {}\n\tlet MAX_WIDTHS = {}\n\tlet SLOT_OVERRIDE = {}\n\n\tlet GameStateAPI_IsLocalPlayerPlayingMatch_prev\n\tlet FriendsListAPI_IsSelectedPlayerMuted_prev\n\tlet GameStateAPI_IsSelectedPlayerMuted_prev\n\tlet my_xuid = MyPersonaAPI.GetXuid()\n\n\tlet _SetMinMaxWidth = function(weapon, min_width, max_width, slot_override) {\n\t\tif(min_width)\n\t\t\tMIN_WIDTHS[weapon] = min_width\n\n\t\tif(max_width)\n\t\t\tMAX_WIDTHS[weapon] = max_width\n\n\t\tif(slot_override)\n\t\t\tSLOT_OVERRIDE[weapon] = slot_override\n\t}\n\n\tlet _DestroyEntityPanels = function() {\n\t\tfor(key in entity_panels){\n\t\t\tlet panel = entity_panels[key]\n\n\t\t\tif(panel != null && panel.IsValid()) {\n\t\t\t\tvar parent = panel.GetParent()\n\n\t\t\t\tHIDDEN_IDS.forEach(id => {\n\t\t\t\t\tlet panel = parent.FindChildTraverse(id)\n\n\t\t\t\t\tif(panel != null) {\n\t\t\t\t\t\tpanel.style.maxWidth = \"28px\"\n\t\t\t\t\t\tpanel.style.margin = \"0px 5px 0px 5px\"\n\t\t\t\t\t}\n\t\t\t\t})\n\n\t\t\t\tif(parent.FindChildTraverse(\"id-sb-skillgroup-image\") != null) {\n\t\t\t\t\tparent.FindChildTraverse(\"id-sb-skillgroup-image\").style.margin = \"0px 0px 0px 0px\"\n\t\t\t\t}\n\n\t\t\t\tpanel.DeleteAsync(0.0)\n\t\t\t}\n\n\t\t\tdelete entity_panels[key]\n\t\t}\n\t}\n\n\tlet _GetOrCreateCustomPanel = function(xuid) {\n\t\tif(entity_panels[xuid] == null || !entity_panels[xuid].IsValid()){\n\t\t\tentity_panels[xuid] = null\n\n\t\t\t// $.Msg(\"creating panel for \", xuid)\n\t\t\tlet scoreboard_context_panel = $.GetContextPanel().FindChildTraverse(\"ScoreboardContainer\").FindChildTraverse(\"Scoreboard\") || $.GetContextPanel().FindChildTraverse(\"id-eom-scoreboard-container\").FindChildTraverse(\"Scoreboard\")\n\n\t\t\tif(scoreboard_context_panel == null){\n\t\t\t\t// usually happens if end of match scoreboard is open. clean up everything?\n\n\t\t\t\t_Clear()\n\t\t\t\t_DestroyEntityPanels()\n\n\t\t\t\treturn\n\t\t\t}\n\n\t\t\tscoreboard_context_panel.FindChildrenWithClassTraverse(\"sb-row\").forEach(function(el){\n\t\t\t\tlet scoreboard_el\n\n\t\t\t\tif(el.m_xuid == xuid) {\n\t\t\t\t\tel.Children().forEach(function(child_frame){\n\t\t\t\t\t\tlet stat = child_frame.GetAttributeString(\"data-stat\", \"\")\n\t\t\t\t\t\tif(stat == \"name\") {\n\t\t\t\t\t\t\tscoreboard_el = child_frame.GetChild(0)\n\t\t\t\t\t\t} else if(stat == \"flair\") {\n\t\t\t\t\t\t\tentity_flair_panels[xuid] = child_frame.GetChild(0)\n\t\t\t\t\t\t}\n\t\t\t\t\t})\n\n\t\t\t\t\tif(scoreboard_el) {\n\t\t\t\t\t\tlet scoreboard_el_parent = scoreboard_el.GetParent()\n\n\t\t\t\t\t\t// fix some style. this is not restored\n\t\t\t\t\t\t// scoreboard_el_parent.style.overflow = \"clip clip;\"\n\n\t\t\t\t\t\t// create panel\n\t\t\t\t\t\tlet custom_weapons = $.CreatePanel(\"Panel\", scoreboard_el_parent, \"custom-weapons\", {\n\t\t\t\t\t\t\tstyle: \"overflow: noclip; width: fit-children; margin: 0px 0px 0px 0px; padding: 1px 0px 0px 0px; height: 100%; flow-children: left; min-width: 30px;\"\n\t\t\t\t\t\t})\n\n\t\t\t\t\t\tHIDDEN_IDS.forEach(id => {\n\t\t\t\t\t\t\tlet panel = scoreboard_el_parent.FindChildTraverse(id)\n\n\t\t\t\t\t\t\tif(panel != null) {\n\t\t\t\t\t\t\t\tpanel.style.maxWidth = \"0px\"\n\t\t\t\t\t\t\t\tpanel.style.margin = \"0px\"\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t})\n\n\t\t\t\t\t\tif(scoreboard_el_parent.FindChildTraverse(\"id-sb-skillgroup-image\") != null) {\n\t\t\t\t\t\t\tscoreboard_el_parent.FindChildTraverse(\"id-sb-skillgroup-image\").style.margin = \"0px 0px 0px 5px\"\n\t\t\t\t\t\t}\n\n\t\t\t\t\t\tscoreboard_el_parent.MoveChildBefore(custom_weapons, scoreboard_el_parent.GetChild(1))\n\n\t\t\t\t\t\t// create child panels\n\t\t\t\t\t\tlet panel_armor = $.CreatePanel(\"Image\", custom_weapons, \"armor\", {\n\t\t\t\t\t\t\ttextureheight: \"17\",\n\t\t\t\t\t\t\tstyle: \"padding-left: 2px; padding-top: 3px; opacity: 0.2; padding-left: 5px;\"\n\t\t\t\t\t\t})\n\t\t\t\t\t\tpanel_armor.visible = false\n\n\t\t\t\t\t\tlet panel_helmet = $.CreatePanel(\"Image\", custom_weapons, \"helmet\", {\n\t\t\t\t\t\t\ttextureheight: \"22\",\n\t\t\t\t\t\t\tstyle: \"padding-left: 2px; padding-top: 0px; opacity: 0.2; padding-left: 0px; margin-left: 3px; margin-right: -3px;\"\n\t\t\t\t\t\t})\n\t\t\t\t\t\tpanel_helmet.visible = false\n\t\t\t\t\t\tpanel_helmet.SetImage(\"file://{images}/icons/equipment/helmet.svg\")\n\n\t\t\t\t\t\tfor(i=24; i >= 0; i--) {\n\t\t\t\t\t\t\tlet panel_slot_parent = $.CreatePanel(\"Panel\", custom_weapons, `weapon-${i}`)\n\n\t\t\t\t\t\t\tpanel_slot_parent.visible = false\n\t\t\t\t\t\t\tpanel_slot_parent.BLoadLayoutFromString(SLOT_LAYOUT, false, false)\n\t\t\t\t\t\t}\n\n\t\t\t\t\t\t// custom_weapons.style.border = \"1px solid red;\"\n\t\t\t\t\t\tentity_panels[xuid] = custom_weapons\n\n\t\t\t\t\t\treturn custom_weapons\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t})\n\t\t}\n\n\t\treturn entity_panels[xuid]\n\t}\n\n\tlet _UpdatePlayer = function(entindex, weapons, selected_weapon, armor) {\n\t\tif(entindex == null || entindex == 0)\n\t\t\treturn\n\n\t\tentity_data[entindex] = arguments\n\t}\n\n\tlet _ApplyPlayer = function(entindex, weapons, selected_weapon, armor) {\n\t\tlet xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)\n\n\t\t// $.Msg(\"applying for \", entindex, \": \", weapons)\n\t\tlet panel = _GetOrCreateCustomPanel(xuid)\n\n\t\tif(panel == null)\n\t\t\treturn\n\n\t\tlet team = GameStateAPI.GetPlayerTeamName(xuid)\n\t\tlet wash_color = TEAM_COLORS[team] || \"#ffffffff\"\n\n\t\t// panel.style.marginRight = entity_flair_panels[entindex].actuallayoutwidth < 4 ? \"-25px\" : \"0px\"\n\n\t\tfor(i=0; i < 24; i++) {\n\t\t\tlet panel_slot_parent = panel.FindChild(`weapon-${i}`)\n\n\t\t\tif(weapons && weapons[i]) {\n\t\t\t\tlet weapon = weapons[i]\n\t\t\t\tlet selected = weapon == selected_weapon\n\t\t\t\tpanel_slot_parent.visible = true\n\n\t\t\t\tlet slot_override = SLOT_OVERRIDE[weapon] || \"small\"\n\n\t\t\t\tlet panel_slot\n\t\t\t\tpanel_slot_parent.Children().forEach(function(el){\n\t\t\t\t\tif(el.id == slot_override){\n\t\t\t\t\t\tel.visible = true\n\t\t\t\t\t\tpanel_slot = el\n\t\t\t\t\t} else {\n\t\t\t\t\t\tel.visible = false\n\t\t\t\t\t}\n\t\t\t\t})\n\n\t\t\t\tpanel_slot.style.opacity = selected ? \"0.85\" : \"0.35\"\n\n\t\t\t\tlet shadow_color = SHADOW_COLORS[team] || \"#58534D\"\n\t\t\t\t// shadow_color = \"rgba(64, 64, 64, 0.1)\"\n\t\t\t\tpanel_slot.style.imgShadow = selected ? (shadow_color + \" 0px 0px 3px 3.75\") : \"none\"\n\n\t\t\t\tpanel_slot.style.washColorFast = wash_color\n\t\t\t\tpanel_slot.SetImage(\"file://{images}/icons/equipment/\" + weapon + \".svg\")\n\t\t\t\t// panel_slot.style.border = \"1px solid red;\"\n\n\t\t\t\tpanel_slot.style.marginLeft = \"-5px\"\n\t\t\t\tpanel_slot.style.marginRight = \"-5px\"\n\n\t\t\t\tif(weapon == \"knife_ursus\") {\n\t\t\t\t\tpanel_slot.style.marginLeft = \"-2px\"\n\t\t\t\t} else if(weapon == \"knife_widowmaker\") {\n\t\t\t\t\tpanel_slot.style.marginLeft = \"-3px\"\n\t\t\t\t} else if(weapon == \"hkp2000\") {\n\t\t\t\t\tpanel_slot.style.marginRight = \"-4px\"\n\t\t\t\t} else if(weapon == \"incgrenade\") {\n\t\t\t\t\tpanel_slot.style.marginLeft = \"-6px\"\n\t\t\t\t} else if(weapon == \"flashbang\") {\n\t\t\t\t\tpanel_slot.style.marginLeft = \"-5px\"\n\t\t\t\t}\n\n\t\t\t\tpanel_slot_parent.style.minWidth = MIN_WIDTHS[weapon] || \"0px\"\n\t\t\t\tpanel_slot_parent.style.maxWidth = MAX_WIDTHS[weapon] || \"1000px\"\n\t\t\t} else if(panel_slot_parent.visible) {\n\t\t\t\t// $.Msg(\"removed!\")\n\t\t\t\tpanel_slot_parent.visible = false\n\t\t\t\tlet panel_slot = panel_slot_parent.GetChild(0)\n\t\t\t\tpanel_slot.style.opacity = \"0.01\"\n\t\t\t}\n\t\t}\n\n\t\tlet panel_armor = panel.FindChild(\"armor\")\n\t\tlet panel_helmet = panel.FindChild(\"helmet\")\n\n\t\tif(armor != null){\n\t\t\tpanel_armor.visible = true\n\t\t\tpanel_armor.style.washColorFast = wash_color\n\n\t\t\tif(armor == \"helmet\") {\n\t\t\t\tpanel_armor.SetImage(\"file://{images}/icons/equipment/kevlar.svg\")\n\n\t\t\t\tpanel_helmet.visible = true\n\t\t\t\tpanel_helmet.style.washColorFast = wash_color\n\t\t\t} else {\n\t\t\t\tpanel_armor.SetImage(\"file://{images}/icons/equipment/\" + armor + \".svg\")\n\t\t\t}\n\t\t} else {\n\t\t\tpanel_armor.visible = false\n\t\t\tpanel_helmet.visible = false\n\t\t}\n\n\t\treturn true\n\t}\n\n\tlet _ApplyData = function() {\n\t\tfor(entindex in entity_data) {\n\t\t\tentindex = parseInt(entindex)\n\t\t\tlet xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)\n\n\t\t\tif(!entity_data[entindex].applied || entity_panels[xuid] == null || !entity_panels[xuid].IsValid()) {\n\t\t\t\tif(_ApplyPlayer.apply(null, entity_data[entindex])) {\n\t\t\t\t\t// $.Msg(\"successfully appied for \", entindex)\n\t\t\t\t\tentity_data[entindex].applied = true\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n\n\tlet _EnablePlayingMatchHook = function() {\n\t\tif(GameStateAPI_IsLocalPlayerPlayingMatch_prev == null) {\n\t\t\tGameStateAPI_IsLocalPlayerPlayingMatch_prev = GameStateAPI.IsLocalPlayerPlayingMatch\n\n\t\t\tGameStateAPI.IsLocalPlayerPlayingMatch = function() {\n\t\t\t\tif(GameStateAPI.IsDemoOrHltv()) {\n\t\t\t\t\treturn true\n\t\t\t\t}\n\n\t\t\t\treturn GameStateAPI_IsLocalPlayerPlayingMatch_prev.call(GameStateAPI)\n\t\t\t}\n\t\t}\n\t}\n\n\tlet _DisablePlayingMatchHook = function() {\n\t\tif(GameStateAPI_IsLocalPlayerPlayingMatch_prev != null) {\n\t\t\tGameStateAPI.IsLocalPlayerPlayingMatch = GameStateAPI_IsLocalPlayerPlayingMatch_prev\n\t\t\tGameStateAPI_IsLocalPlayerPlayingMatch_prev = null\n\t\t}\n\t}\n\n\tlet _EnableSelectedPlayerMutedHook = function() {\n\t\tif(FriendsListAPI_IsSelectedPlayerMuted_prev == null) {\n\t\t\tFriendsListAPI_IsSelectedPlayerMuted_prev = FriendsListAPI.IsSelectedPlayerMuted\n\n\t\t\tFriendsListAPI.IsSelectedPlayerMuted = function(xuid) {\n\t\t\t\tif(xuid == my_xuid) {\n\t\t\t\t\treturn false\n\t\t\t\t}\n\n\t\t\t\treturn FriendsListAPI_IsSelectedPlayerMuted_prev.call(FriendsListAPI, xuid)\n\t\t\t}\n\t\t}\n\n\t\tif(GameStateAPI_IsSelectedPlayerMuted_prev == null) {\n\t\t\tGameStateAPI_IsSelectedPlayerMuted_prev = GameStateAPI.IsSelectedPlayerMuted\n\n\t\t\tGameStateAPI.IsSelectedPlayerMuted = function(xuid) {\n\t\t\t\tif(xuid == my_xuid) {\n\t\t\t\t\treturn false\n\t\t\t\t}\n\n\t\t\t\treturn GameStateAPI_IsSelectedPlayerMuted_prev.call(GameStateAPI, xuid)\n\t\t\t}\n\t\t}\n\t}\n\n\tlet _DisableSelectedPlayerMutedHook = function() {\n\t\tif(FriendsListAPI_IsSelectedPlayerMuted_prev != null) {\n\t\t\tFriendsListAPI.IsSelectedPlayerMuted = FriendsListAPI_IsSelectedPlayerMuted_prev\n\t\t\tFriendsListAPI_IsSelectedPlayerMuted_prev = null\n\t\t}\n\n\t\tif(GameStateAPI_IsSelectedPlayerMuted_prev != null) {\n\t\t\tGameStateAPI.IsSelectedPlayerMuted = GameStateAPI_IsSelectedPlayerMuted_prev\n\t\t\tGameStateAPI_IsSelectedPlayerMuted_prev = null\n\t\t}\n\t}\n\n\tlet _UnmutePlayer = function(xuid) {\n\t\tif(GameStateAPI.IsSelectedPlayerMuted(xuid)) {\n\t\t\tGameStateAPI.ToggleMute(xuid)\n\t\t\tunmuted_players[xuid] = true\n\n\t\t\treturn true\n\t\t}\n\n\t\treturn false\n\t}\n\n\tlet _RestoreUnmutedPlayers = function(xuid) {\n\t\tfor(xuid in unmuted_players) {\n\t\t\tif(!GameStateAPI.IsSelectedPlayerMuted(xuid) && GameStateAPI.IsPlayerConnected(xuid)) {\n\t\t\t\tGameStateAPI.ToggleMute(xuid)\n\t\t\t}\n\t\t}\n\t\tunmuted_players = {}\n\t}\n\n\tlet _GetAllPlayers = function() {\n\t\tlet result = []\n\n\t\tfor(entindex=1; entindex <= 64; entindex++) {\n\t\t\tlet xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)\n\n\t\t\tif(xuid && xuid != \"0\") {\n\t\t\t\tresult.push(xuid)\n\t\t\t}\n\t\t}\n\n\t\treturn result\n\t}\n\n\tlet _Create = function() {\n\t\tevent_callbacks[\"OnOpenScoreboard\"] = $.RegisterForUnhandledEvent(\"OnOpenScoreboard\", _ApplyData)\n\t\tevent_callbacks[\"Scoreboard_UpdateEverything\"] = $.RegisterForUnhandledEvent(\"Scoreboard_UpdateEverything\", function(){\n\t\t\t// $.Msg(\"cleared applied data\")\n\t\t\tfor(entindex in entity_data) {\n\t\t\t\t// entity_data[entindex].applied = false\n\t\t\t}\n\t\t\t_ApplyData()\n\t\t})\n\t\tevent_callbacks[\"Scoreboard_UpdateJob\"] = $.RegisterForUnhandledEvent(\"Scoreboard_UpdateJob\", _ApplyData)\n\t}\n\n\tlet _Clear = function() {\n\t\tentity_data = {}\n\t}\n\n\tlet _Destroy = function() {\n\t\t// clear entity data\n\t\t_Clear()\n\t\t_DestroyEntityPanels()\n\n\t\tfor(event in event_callbacks){\n\t\t\t$.UnregisterForUnhandledEvent(event, event_callbacks[event])\n\n\t\t\tdelete event_callbacks[event]\n\t\t}\n\n\t\t// $.GetContextPanel().FindChildTraverse(\"TeamSmallContainerCT\").style.width = \"400px\"\n\t\t// $.GetContextPanel().FindChildTraverse(\"TeamSmallContainerT\").style.width = \"400px\"\n\t}\n\n\treturn {\n\t\tcreate: _Create,\n\t\tset_min_max_width: _SetMinMaxWidth,\n\t\tdestroy: _Destroy,\n\t\tclear: _Clear,\n\t\tupdate_player: _UpdatePlayer,\n\t\tenable_playing_match_hook: _EnablePlayingMatchHook,\n\t\tdisable_playing_match_hook: _DisablePlayingMatchHook,\n\t\tenable_selected_player_muted_hook: _EnableSelectedPlayerMutedHook,\n\t\tdisable_selected_player_muted_hook: _DisableSelectedPlayerMutedHook,\n\t\tunmute_player: _UnmutePlayer,\n\t\trestore_unmuted_players: _RestoreUnmutedPlayers,\n\t\tget_all_players: _GetAllPlayers\n\t}\n", "CSGOHud")()
local var_0_31 = {
	[var_0_0.weapon_hegrenade] = 10,
	[var_0_0.weapon_decoy] = var_0_0.weapon_molotov.idx - 1,
	[var_0_0.weapon_smokegrenade] = var_0_0.weapon_smokegrenade.idx - 1,
	[var_0_0.weapon_taser] = 3
}
local var_0_32 = {}
local var_0_33 = 0

for iter_0_0, iter_0_1 in pairs(var_0_0) do
	local var_0_34 = string.byte(iter_0_1.name)

	var_0_32[iter_0_1] = var_0_34
	var_0_33 = math.max(var_0_34, var_0_33)

	local var_0_35 = iter_0_1.console_name:gsub("^item_", ""):gsub("^weapon_", "")

	if iter_0_1.type == "pistol" then
		var_0_30.set_min_max_width(var_0_35, "31px")
	elseif iter_0_1.type == "knife" and iter_0_1 ~= var_0_8 then
		var_0_30.set_min_max_width(var_0_35, "45px", "45px", "smaller")
	end
end

var_0_30.set_min_max_width("knife", nil, nil, "small")
var_0_30.set_min_max_width("knife_t", nil, nil, "small")
var_0_30.set_min_max_width("knife_widowmaker", nil, nil, "small")
var_0_30.set_min_max_width("knife_butterfly", nil, nil, "small")
var_0_30.set_min_max_width("knife_survival_bowie", nil, nil, "large")
var_0_30.set_min_max_width("knife_gut", nil, nil, "medium")
var_0_30.set_min_max_width("knife_karambit", nil, nil, "medium")
var_0_30.set_min_max_width("knife_ursus", nil, nil, "small")
var_0_30.set_min_max_width("hkp2000", nil, nil, "medium")
var_0_30.set_min_max_width("incgrenade", "12px")
var_0_30.set_min_max_width("smokegrenade", "9px")
var_0_30.set_min_max_width("flashbang", "9px", "12px")

for iter_0_2, iter_0_3 in pairs(var_0_0) do
	if var_0_31[iter_0_3] == nil then
		local var_0_36 = var_0_32[iter_0_3] / var_0_33

		if iter_0_3.type == "rifle" or iter_0_3.type == "machinegun" or iter_0_3.type == "sniperrifle" or iter_0_3.type == "smg" or iter_0_3.type == "shotgun" then
			var_0_31[iter_0_3] = 0 + var_0_36
		elseif iter_0_3.type == "pistol" then
			var_0_31[iter_0_3] = 1 + var_0_36
		elseif iter_0_3.type == "knife" or iter_0_3.type == "fists" or iter_0_3.type == "melee" then
			var_0_31[iter_0_3] = 2 + var_0_36
		else
			var_0_31[iter_0_3] = iter_0_3.idx
		end
	end
end

local function var_0_37(arg_12_0, arg_12_1)
	return (var_0_31[arg_12_0] or arg_12_0.idx) < (var_0_31[arg_12_1] or arg_12_1.idx)
end

local var_0_38 = ui.new_checkbox("VISUALS", "Other ESP", "Display equipment on scoreboard")
local var_0_39 = ui.new_multiselect("VISUALS", "Other ESP", "\nScoreboard equipment filter", {
	"Primary",
	"Secondary",
	"Knife",
	"Taser",
	"Grenades",
	"Bomb",
	"Defuse Kit",
	"Armor",
	"Other"
})
local var_0_40 = ui.new_checkbox("VISUALS", "Other ESP", "Enemies only")
local var_0_41 = ui.new_multiselect("VISUALS", "Other ESP", "Auto unmute players", {
	"Self",
	"Friends",
	"All players"
})

ui.set(var_0_39, {
	"Primary",
	"Secondary",
	"Grenades",
	"Bomb"
})

local var_0_42 = {}
local var_0_43 = {}
local var_0_44 = false
local var_0_45 = false

local function var_0_46(arg_13_0)
	return var_0_43[arg_13_0]
end

local function var_0_47(arg_14_0)
	local var_14_0 = var_0_42[arg_14_0]
	local var_14_1 = ui.get(var_0_40) and not entity.is_dormant(arg_14_0) and not entity.is_enemy(arg_14_0)
	local var_14_2 = arg_14_0
	local var_14_3 = entity.get_player_resource()

	if entity.get_prop(var_14_3, "m_bControllingBot", arg_14_0) == 1 then
		var_14_2 = entity.get_prop(var_14_3, "m_iControlledPlayer", arg_14_0)

		var_0_30.update_player(arg_14_0, nil, nil, nil)
	end

	if var_14_0 == nil or var_14_1 then
		var_0_30.update_player(var_14_2, nil, nil, nil)
	else
		var_0_30.update_player(var_14_2, var_14_0.weapons and var_0_13(var_14_0.weapons, var_0_46) or nil, var_14_0.active_weapon and var_0_43[var_14_0.active_weapon] or nil, var_0_44 and var_14_0.armor or nil)
	end
end

local function var_0_48()
	var_0_1(var_0_43)

	if ui.get(var_0_38) then
		local var_15_0 = var_0_14(ui.get(var_0_39), function(arg_16_0, arg_16_1)
			return arg_16_1, true
		end)

		var_0_44 = var_15_0.Armor

		local var_15_1
		local var_15_2 = entity.get_local_player()

		if var_15_2 ~= nil then
			var_15_1 = entity.get_prop(var_15_2, "m_iTeamNum")
		end

		for iter_15_0, iter_15_1 in pairs(var_0_0) do
			local var_15_3 = false

			if iter_15_1.type == "rifle" or iter_15_1.type == "machinegun" or iter_15_1.type == "sniperrifle" or iter_15_1.type == "smg" or iter_15_1.type == "shotgun" then
				var_15_3 = var_15_0.Primary
			elseif iter_15_1.type == "pistol" then
				var_15_3 = var_15_0.Secondary
			elseif iter_15_1 == var_0_8 then
				var_15_3 = var_15_0.Taser
			elseif iter_15_1.type == "c4" then
				var_15_3 = var_15_1 ~= var_0_10 and var_15_0.Bomb
			elseif iter_15_1 == var_0_6 or iter_15_1 == var_0_7 then
				var_15_3 = var_15_1 ~= var_0_11 and var_15_0["Defuse Kit"]
			elseif iter_15_1.type == "knife" or iter_15_1.type == "fists" or iter_15_1.type == "melee" then
				var_15_3 = var_15_0.Knife
			elseif iter_15_1.type == "grenade" or iter_15_1.type == "breachcharge" then
				var_15_3 = var_15_0.Grenades
			elseif iter_15_1 ~= var_0_4 and iter_15_1 ~= var_0_3 and iter_15_1 ~= var_0_5 then
				var_15_3 = var_15_0.Other
			end

			if var_15_3 then
				var_0_43[iter_15_1] = iter_15_1.console_name:gsub("^item_", ""):gsub("^weapon_", "")
			end
		end

		for iter_15_2, iter_15_3 in pairs(var_0_42) do
			var_0_47(iter_15_2)
		end
	end
end

local function var_0_49()
	var_0_23()

	local var_17_0 = entity.get_player_resource()
	local var_17_1 = cvar.mp_free_armor:get_int() > 0
	local var_17_2 = cvar.mp_free_armor:get_int() > 1
	local var_17_3 = cvar.mp_defuser_allocation:get_int() >= 2

	for iter_17_0 = 1, 64 do
		if entity.get_classname(iter_17_0) == "CCSPlayer" then
			local var_17_4

			if not entity.is_dormant(iter_17_0) then
				if entity.is_alive(iter_17_0) then
					var_17_4 = {
						weapons = {}
					}

					local var_17_5 = entity.get_player_weapon(iter_17_0)

					if var_17_5 ~= nil then
						if not var_17_3 and entity.get_prop(iter_17_0, "m_bHasDefuser") == 1 then
							table.insert(var_17_4.weapons, var_0_7)
						end

						for iter_17_1 = 0, 63 do
							local var_17_6 = entity.get_prop(iter_17_0, "m_hMyWeapons", iter_17_1)

							if var_17_6 ~= nil then
								local var_17_7 = var_0_0[entity.get_prop(var_17_6, "m_iItemDefinitionIndex")]

								table.insert(var_17_4.weapons, var_17_7)

								if var_17_6 == var_17_5 then
									var_17_4.active_weapon = var_17_7
								end
							end
						end

						table.sort(var_17_4.weapons, var_0_37)
					end
				else
					var_17_4 = nil
				end
			else
				var_17_4 = var_0_42[iter_17_0]
			end

			if var_17_4 ~= nil then
				if entity.get_prop(var_17_0, "m_iArmor", iter_17_0) > 0 then
					if entity.get_prop(var_17_0, "m_bHasHelmet", iter_17_0) == 1 then
						if not var_17_2 then
							var_17_4.armor = "helmet"
						end
					elseif not var_17_1 then
						var_17_4.armor = "kevlar"
					end
				else
					var_17_4.armor = nil
				end
			end

			if var_0_42[iter_17_0] == nil and var_17_4 ~= nil or var_17_4 == nil and var_0_42[iter_17_0] ~= nil or var_17_4 ~= nil and var_0_42[iter_17_0] ~= nil and not var_0_12(var_17_4, var_0_42[iter_17_0]) then
				var_0_42[iter_17_0] = var_17_4

				var_0_47(iter_17_0)
			end
		end
	end
end

local function var_0_50()
	if var_0_45 then
		var_0_30.destroy()
	end
end

local function var_0_51()
	var_0_1(var_0_42)
	var_0_30.clear()
end

local function var_0_52(arg_20_0)
	local var_20_0 = client.userid_to_entindex(arg_20_0.userid)

	if var_20_0 == entity.get_local_player() then
		client.delay_call(0.1, var_0_48)
	elseif var_20_0 > 0 then
		var_0_47(var_20_0)
	end
end

local function var_0_53(arg_21_0)
	local var_21_0 = client.userid_to_entindex(arg_21_0.userid)

	var_0_42[var_21_0] = nil

	var_0_47(var_21_0)
end

local function var_0_54(arg_22_0)
	local var_22_0 = client.userid_to_entindex(arg_22_0.userid)

	if var_0_42[var_22_0] ~= nil and entity.is_dormant(var_22_0) then
		var_0_42[var_22_0] = nil

		var_0_47(var_22_0)
	end
end

local function var_0_55(arg_23_0)
	local var_23_0 = client.userid_to_entindex(arg_23_0.userid)

	if var_0_42[var_23_0] == nil then
		var_0_42[var_23_0] = {
			weapons = {}
		}
	elseif var_0_42[var_23_0].weapons ~= nil then
		var_0_16(var_0_42[var_23_0].weapons, var_0_9)
	end

	var_0_47(var_23_0)
end

local function var_0_56(arg_24_0)
	local var_24_0 = client.userid_to_entindex(arg_24_0.userid)
	local var_24_1 = var_0_2[arg_24_0.defindex]

	if var_0_42[var_24_0] ~= nil and entity.is_dormant(var_24_0) and var_24_1 and var_24_1 ~= var_0_3 and var_24_1 ~= var_0_4 then
		var_0_16(var_0_42[var_24_0].weapons, var_24_1)
		var_0_47(var_24_0)
	end
end

local function var_0_57(arg_25_0)
	local var_25_0 = client.userid_to_entindex(arg_25_0.userid)
	local var_25_1 = var_0_2[arg_25_0.defindex]

	if var_0_42[var_25_0] ~= nil and entity.is_dormant(var_25_0) and var_25_1 then
		if var_25_1 == var_0_3 or var_25_1 == var_0_4 then
			local var_25_2 = cvar.mp_free_armor:get_int() > 0
			local var_25_3 = cvar.mp_free_armor:get_int() > 1

			if var_25_1 == var_0_3 then
				if not var_25_3 and var_0_42[var_25_0].armor == nil then
					var_0_42[var_25_0].armor = "kevlar"
				end
			elseif not var_25_2 then
				var_0_42[var_25_0].armor = "helmet"
			end
		elseif (var_25_1 == var_0_6 or var_25_1 == var_0_7) and cvar.mp_defuser_allocation:get_int() >= 2 then
			return
		elseif not var_0_15(var_0_42[var_25_0].weapons, var_25_1) then
			table.insert(var_0_42[var_25_0].weapons, var_25_1)
			table.sort(var_0_42[var_25_0].weapons, var_0_37)
			var_0_47(var_25_0)
		end
	end
end

local function var_0_58(arg_26_0)
	local var_26_0 = client.userid_to_entindex(arg_26_0.userid)
	local var_26_1 = var_0_2[arg_26_0.defindex]

	if var_0_42[var_26_0] ~= nil and entity.is_dormant(var_26_0) and var_26_1 then
		var_0_42[var_26_0].active_weapon = var_26_1

		var_0_47(var_26_0)
	end
end

local function var_0_59(arg_27_0)
	local var_27_0 = client.userid_to_entindex(arg_27_0.userid)
	local var_27_1 = client.userid_to_entindex(arg_27_0.botid)
	local var_27_2 = entity.get_player_resource()

	entity.set_prop(var_27_2, "m_bControllingBot", 1, var_27_0)
	entity.set_prop(var_27_2, "m_iControlledPlayer", var_27_1, var_27_0)
	var_0_47(var_27_1)
	var_0_47(var_27_0)
end

local function var_0_60()
	local var_28_0 = ui.get(var_0_38)

	ui.set_visible(var_0_39, var_28_0)
	ui.set_visible(var_0_40, var_28_0)

	if var_28_0 and not var_0_45 then
		client.set_event_callback("paint", var_0_49)
		client.set_event_callback("shutdown", var_0_50)
		client.set_event_callback("level_init", var_0_51)
		client.set_event_callback("player_team", var_0_52)
		var_0_24("player_disconnect", var_0_53)
		var_0_24("player_death", var_0_54)
		var_0_24("player_spawn", var_0_55)
		var_0_24("item_remove", var_0_56)
		var_0_24("item_pickup", var_0_57)
		var_0_24("item_equip", var_0_58)
		var_0_24("bot_takeover", var_0_59)
		var_0_48()
		var_0_30.create()
	elseif not var_28_0 and var_0_45 then
		client.unset_event_callback("paint", var_0_49)
		client.unset_event_callback("shutdown", var_0_50)
		client.unset_event_callback("level_init", var_0_51)
		client.unset_event_callback("player_team", var_0_52)
		var_0_25()
		var_0_1(var_0_42)
		var_0_1(var_0_43)
		var_0_30.destroy()
	end

	var_0_45 = var_28_0
end

local function var_0_61(arg_29_0, arg_29_1)
	if arg_29_1 == nil then
		arg_29_1 = var_0_14(ui.get(var_0_41), function(arg_30_0, arg_30_1)
			return arg_30_1, true
		end)
	end

	if type(arg_29_0) == "table" then
		local var_29_0 = arg_29_0.userid ~= nil and client.userid_to_entindex(arg_29_0.userid)

		if var_29_0 ~= nil then
			arg_29_0 = var_0_29.GetPlayerXuidStringFromEntIndex(var_29_0)

			if type(arg_29_0) ~= "string" or arg_29_0 == "0" then
				return
			end
		else
			return
		end
	end

	if (arg_29_1["All players"] or arg_29_1.Self and arg_29_0 == var_0_28.GetXuid() or arg_29_1.Friends and var_0_27.GetFriendRelationship(arg_29_0) == "friend") and var_0_30.unmute_player(arg_29_0) then
		-- block empty
	end
end

local function var_0_62()
	local var_31_0 = var_0_14(ui.get(var_0_41), function(arg_32_0, arg_32_1)
		return arg_32_1, true
	end)
	local var_31_1 = json.parse(tostring(var_0_30.get_all_players()))

	for iter_31_0 = 1, #var_31_1 do
		var_0_61(var_31_1[iter_31_0], var_31_0)
	end
end

var_0_62()

local function var_0_63()
	var_0_62()
	client.delay_call(5, var_0_62)
end

ui.set_callback(var_0_41, function()
	local var_34_0 = var_0_14(ui.get(var_0_41), function(arg_35_0, arg_35_1)
		return arg_35_1, true
	end)

	var_0_30.restore_unmuted_players()

	if next(var_34_0) then
		var_0_62()
		client.set_event_callback("level_init", var_0_63)
		client.set_event_callback("player_connect_full", var_0_61)

		if var_34_0.Self then
			-- block empty
		else
			var_0_30.disable_selected_player_muted_hook()
		end
	else
		client.unset_event_callback("level_init", var_0_63)
		client.unset_event_callback("player_connect_full", var_0_61)
		var_0_30.disable_selected_player_muted_hook()
	end
end)
var_0_30.enable_playing_match_hook()
client.set_event_callback("shutdown", function()
	var_0_30.disable_playing_match_hook()
	var_0_30.disable_selected_player_muted_hook()
	var_0_30.restore_unmuted_players()
end)
ui.set_callback(var_0_40, function()
	for iter_37_0, iter_37_1 in pairs(var_0_42) do
		if not entity.is_dormant(iter_37_0) and not entity.is_enemy(iter_37_0) then
			var_0_42[iter_37_0] = nil
		end
	end
end)
ui.set_callback(var_0_39, var_0_48)
ui.set_callback(var_0_38, var_0_60)
var_0_60()
