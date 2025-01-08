local client_register_esp_flag, entity_is_enemy, plist_get = client.register_esp_flag, entity.is_enemy, plist.get

client_register_esp_flag("FAKE", 255, 255, 255, function(c)
	if entity_is_enemy(c) then
		return plist_get(c, "Correction active")
	end
end)
