function CopLogicFlee.enter(data, new_logic_name, enter_params)
	CopLogicBase.enter(data, new_logic_name, enter_params)
	data.unit:brain():cancel_all_pathing_searches()

	local old_internal_data = data.internal_data
	local my_data = {
		unit = data.unit,
		detection = data.char_tweak.detection.combat
	}

	if old_internal_data then
		if old_internal_data.nearest_cover then
			my_data.nearest_cover = old_internal_data.nearest_cover

			managers.navigation:reserve_cover(my_data.nearest_cover[1], data.pos_rsrv_id)
		end

		if old_internal_data.best_cover then
			my_data.best_cover = old_internal_data.best_cover

			managers.navigation:reserve_cover(my_data.best_cover[1], data.pos_rsrv_id)
		end
	end

	data.internal_data = my_data

	if data.unit:movement():chk_action_forbidden("walk") then
		my_data.wants_stop_old_walk_action = true
	end

	local key_str = tostring(data.key)
	my_data.detection_task_key = "CopLogicFlee._update_enemy_detection" .. key_str

	CopLogicBase.queue_task(my_data, my_data.detection_task_key, CopLogicFlee._update_enemy_detection, data)

	my_data.cover_update_task_key = "CopLogicFlee._update_cover" .. key_str

	CopLogicBase.queue_task(my_data, my_data.cover_update_task_key, CopLogicFlee._update_cover, data, data.t + 1)

	my_data.cover_path_search_id = key_str .. "cover"

	if data.attention_obj and AIAttentionObject.REACT_COMBAT <= data.attention_obj.reaction then
		my_data.want_cover = true
	end

	CopLogicBase._reset_attention(data)
	data.unit:movement():set_stance("wnd")
	data.unit:movement():set_cool(true)

	if my_data ~= data.internal_data then
		return
	end

	data.unit:brain():set_attention_settings({
		cbt = true
	})
end
