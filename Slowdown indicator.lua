local var_0_0 = client.screen_size
local var_0_1 = entity.get_local_player
local var_0_2 = entity.get_prop
local var_0_3 = entity.is_alive
local var_0_4 = globals.curtime
local var_0_5 = math.abs
local var_0_6 = math.floor
local var_0_7 = renderer.indicator
local var_0_8 = renderer.rectangle
local var_0_9 = renderer.text
local var_0_10 = string.format
local var_0_11 = ui.get
local var_0_12 = ui.new_combobox
local var_0_13 = ui.reference
local var_0_14 = ui.set_callback
local var_0_15 = require("gamesense/images").get_panorama_image("icons/ui/warning.svg")
local var_0_16 = var_0_12("VISUALS", "Other ESP", "Display maximum speed", "Off", "Bar", "Indicator")
local var_0_17 = 0

local function var_0_18(arg_1_0)
	local var_1_0 = 248 - 124 * arg_1_0
	local var_1_1 = 195 * arg_1_0
	local var_1_2 = 13

	return var_1_0, var_1_1, var_1_2
end

local function var_0_19(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_3 = arg_2_3 or 0
	arg_2_4 = arg_2_4 or 1

	local var_2_0 = (arg_2_0 - arg_2_3) / (arg_2_4 - arg_2_3)

	if arg_2_5 ~= false then
		var_2_0 = math.min(1, math.max(0, var_2_0))
	end

	return arg_2_1 + (arg_2_2 - arg_2_1) * var_2_0
end

local function var_0_20(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)
	arg_3_8 = arg_3_8 or 1

	var_0_8(arg_3_0, arg_3_1, arg_3_2, arg_3_8, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	var_0_8(arg_3_0, arg_3_1 + arg_3_3 - arg_3_8, arg_3_2, arg_3_8, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	var_0_8(arg_3_0, arg_3_1 + arg_3_8, arg_3_8, arg_3_3 - arg_3_8 * 2, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	var_0_8(arg_3_0 + arg_3_2 - arg_3_8, arg_3_1 + arg_3_8, arg_3_8, arg_3_3 - arg_3_8 * 2, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
end

local function var_0_21(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	var_0_17 = var_0_17 + (1 - arg_4_0) * 0.7 + 0.3

	local var_4_0 = var_0_5(var_0_17 * 0.01 % 2 - 1) * 255
	local var_4_1 = 95
	local var_4_2, var_4_3 = var_0_0()
	local var_4_4 = var_4_2 / 2 - var_4_1
	local var_4_5 = var_4_3 * 0.35
	local var_4_6, var_4_7 = var_0_15:measure(nil, 35)

	var_0_15:draw(var_4_4 - 3, var_4_5 - 4, var_4_6 + 6, var_4_7 + 6, 16, 16, 16, 255 * arg_4_4)

	if arg_4_4 > 0.7 then
		var_0_8(var_4_4 + 13, var_4_5 + 11, 8, 20, 16, 16, 16, 255 * arg_4_4)
	end

	var_0_15:draw(var_4_4, var_4_5, nil, 35, arg_4_1, arg_4_2, arg_4_3, var_4_0 * arg_4_4)
	var_0_9(var_4_4 + var_4_6 + 8, var_4_5 + 3, 255, 255, 255, 255 * arg_4_4, "b", 0, var_0_10("%s %d%%", arg_4_5, arg_4_0 * 100))

	local var_4_8 = var_4_4 + var_4_6 + 8
	local var_4_9 = var_4_5 + 3 + 17
	local var_4_10 = var_4_1
	local var_4_11 = 12

	var_0_20(var_4_8, var_4_9, var_4_10, var_4_11, 0, 0, 0, 255 * arg_4_4, 1)
	var_0_8(var_4_8 + 1, var_4_9 + 1, var_4_10 - 2, var_4_11 - 2, 16, 16, 16, 180 * arg_4_4)
	var_0_8(var_4_8 + 1, var_4_9 + 1, var_0_6((var_4_10 - 2) * arg_4_0), var_4_11 - 2, arg_4_1, arg_4_2, arg_4_3, 180 * arg_4_4)
end

local function var_0_22()
	local var_5_0 = var_0_1()

	if not var_0_3(var_5_0) then
		return
	end

	local var_5_1 = var_0_2(var_5_0, "m_flVelocityModifier")

	if var_5_1 == 1 then
		return
	end

	local var_5_2, var_5_3, var_5_4 = var_0_18(var_5_1)
	local var_5_5 = var_0_19(var_5_1, 1, 0, 0.85, 1)

	if var_0_11(var_0_16) == "Bar" then
		var_0_21(var_5_1, var_5_2, var_5_3, var_5_4, var_5_5, "Slowed down")
	else
		var_0_7(var_5_2, var_5_3, var_5_4, var_5_5 * 255, "SLOW")
	end
end

var_0_14(var_0_16, function()
	(var_0_11(var_0_16) ~= "Off" and client.set_event_callback or client.unset_event_callback)("paint", var_0_22)
end)
