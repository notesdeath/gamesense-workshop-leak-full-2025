local vector = require'vector'
local ffi = require'ffi'

--#region function cache
local ui_get, ui_set, set_vis, set_callback = ui.get, ui.set, ui.set_visible, ui.set_callback

local new_check, new_color_picker, new_slider, new_multiselect, ui_ref = ui.new_checkbox, ui.new_color_picker, ui.new_slider, ui.new_multiselect, ui.reference

local create_interface, screen_size, set_event_callback, unset_event_callback = client.create_interface, client.screen_size, client.set_event_callback, client.unset_event_callback

local get_lp, get_player_wpn, get_prop, is_alive = entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.is_alive

local render_grad = renderer.gradient

local frametime = globals.frametime

local min, max, pi = math.min, math.max, math.pi

local ffi_cdef, ffi_typeof, cast = ffi.cdef, ffi.typeof, ffi.cast
--#endregion

--#region ffi
local raw_iEntityList = create_interface('client.dll', 'VClientEntityList003') or error('VClientEntityList003 not found.', 2)
local iEntityList = cast(ffi_typeof('void***'), raw_iEntityList) or error('raw_iEntityList is nil', 2)
local native_getClientEntity = cast(ffi_typeof('void*(__thiscall*)(void*, int)'), iEntityList[0][3]) or error('native_getClientEntity is nil', 2)
local native_getSpread = vtable_thunk(453, 'float(__thiscall*)(void*)')
local native_getInaccuracy = vtable_thunk(483, 'float(__thiscall*)(void*)')
--#endregion

--#region vars
local screen = vector()

local is_dynamic, is_remove_top, is_disable_anim

local alpha = 0
--#endregion

--#region ui
local tab, container = 'visuals', 'effects'
local ref = {
	enabled = new_check(tab, container, 'Custom scope lines'),
	color = new_color_picker(tab, container, '\n scope_lines_color_picker', 0, 0, 0, 190),
	color2 = new_color_picker(tab, container, '\n scope_lines_color_picker2', 0, 0, 0, 0),
	options = new_multiselect(tab, container, '\n scope_options', {
		'Dynamic offset', 'Remove top line', 'Disable animation'
	}),
	size = new_slider(tab, container, '\n scope_lines_initial_pos', 0, 500, 190),
	offset = new_slider(tab, container, '\n scope_lines_offset', 0, 500, 10),
	thickness = new_slider(tab, container, '\n scope_lines_thickness', 1, 10, 1, true, 'px'),
	fade = new_slider(tab, container, 'Fade animation speed', 3, 20, 12, true, 'fr', 1, {[3]='Off'}),

	scope_ovr = ui_ref(tab, container, 'Remove scope overlay'),
	fov = ui_ref('misc', 'miscellaneous', 'override fov')
}
--#endregion

--#region functions
local clamp=function(a,b,c)return max(b,min(c,a))end
local contains=function(a,b)for c, d in pairs(a) do if d == b then return true end end return false end
--#endregion

--#region callbacks
local callbacks = {
	paint_ui = function()ui_set(ref.scope_ovr, true)end,
	paint = function()
		ui_set(ref.scope_ovr, false)

		screen.x, screen.y = screen_size()

		local offset, size, speed, thicc, clr, clr2 =
			ui_get(ref.offset)*(screen.y/1080),
			ui_get(ref.size)*(screen.y/1080),
			ui_get(ref.fade), ui_get(ref.thickness),
			{ui_get(ref.color)}, {ui_get(ref.color2)}

		local lp = get_lp(); if lp == nil then return end
		local wpn = get_player_wpn(lp); if wpn == nil then return end

		if is_dynamic then
			local wpn_ent = native_getClientEntity(iEntityList, wpn);
			
			if wpn_ent ~= nil then
				local spread, inaccuracy =
					native_getSpread(wpn_ent),
					native_getInaccuracy(wpn_ent)

				local modifier = ((inaccuracy + spread)*360)

				offset, size = offset+modifier, size+modifier
			end
		end

		local scope_lvl = get_prop(wpn, 'm_zoomLevel')
		local scoped, resume =
			get_prop(lp, 'm_bIsScoped') == 1,
			get_prop(lp, 'm_bResumeZoom') == 1

		local valid = is_alive(lp) and wpn ~= nil and scope_lvl ~= nil
		local act = valid and scope_lvl > 0 and scoped and not resume

		local ft = speed > 3 and frametime()*speed or 1

		local half_w, half_h, half_t = screen.x*.5, screen.y*.5, thicc > 1 and thicc*.5 or 0

		if not is_disable_anim then
			offset = offset+size*(1-alpha)
		end

		if alpha > 0 then
			render_grad(half_w-size+2, half_h-half_t, size-offset, thicc, clr2[1], clr2[2], clr2[3], clr2[4]*alpha, clr[1], clr[2], clr[3], clr[4]*alpha, true)
			render_grad(half_w+offset, half_h-half_t, size-offset, thicc, clr[1], clr[2], clr[3], clr[4]*alpha, clr2[1], clr2[2], clr2[3], clr2[4]*alpha, true)
			if not is_remove_top then
				render_grad(half_w-half_t, half_h-size+2, thicc, size-offset, clr2[1], clr2[2], clr2[3], clr2[4]*alpha, clr[1], clr[2], clr[3], clr[4]*alpha, false)
			end
			render_grad(half_w-half_t, half_h+offset, thicc, size-offset, clr[1], clr[2], clr[3], clr[4]*alpha, clr2[1], clr2[2], clr2[3], clr2[4]*alpha, false)
		end

		alpha = clamp(alpha + (act and ft or -ft), 0, 1)
	end,
	shutdown=function()set_vis(ref.scope_ovr, true)ui_set(ref.scope_ovr, true)end
}
--#endregion

--#region ui setup
local function visibility()
	local check = ui_get(ref.enabled)
	local func = check and set_event_callback or unset_event_callback

	if not check then
		alpha = 0
	end

	local options = ui_get(ref.options)

	is_dynamic, is_remove_top, is_disable_anim = 
		contains(options, 'Dynamic offset'), contains(options, 'Remove top line'), contains(options, 'Disable animation')

	set_vis(ref.scope_ovr, not check)
	set_vis(ref.color2, check)
	set_vis(ref.options, check)
	set_vis(ref.size, check)
	set_vis(ref.offset, check)
	set_vis(ref.thickness, check)
	set_vis(ref.fade, check)

	for event, fnc in pairs(callbacks) do func(event, fnc) end
end

set_callback(ref.enabled, visibility); visibility()
set_callback(ref.options, visibility)
--#endregion
