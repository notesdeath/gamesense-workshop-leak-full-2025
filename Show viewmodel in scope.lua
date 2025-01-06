local var_0_0 = require("gamesense/csgo_weapons")
local var_0_1 = require("table.clear")
local var_0_2 = ui.get
local var_0_3 = {}

local function var_0_4()
	for iter_1_0, iter_1_1 in pairs(var_0_0) do
		if iter_1_1.raw.hide_view_model_zoomed then
			table.insert(var_0_3, iter_1_0)

			iter_1_1.raw.hide_view_model_zoomed = false
		end
	end
end

local function var_0_5()
	for iter_2_0 = 1, #var_0_3 do
		local var_2_0 = var_0_3[iter_2_0]

		var_0_0[var_2_0].raw.hide_view_model_zoomed = true
	end

	var_0_1(var_0_3)
end

local var_0_6 = ui.new_checkbox("VISUALS", "Effects", "Show viewmodel in scope")

ui.set_callback(var_0_6, function()
	if var_0_2(var_0_6) then
		var_0_4()
	else
		var_0_5()
	end
end)
client.set_event_callback("shutdown", var_0_5)
