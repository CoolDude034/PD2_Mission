function CivilianLogicFlee.enter(data, new_logic_name, enter_params)
	CopLogicBase.enter(data, new_logic_name, enter_params)
	data.unit:brain():cancel_all_pathing_searches()

	local old_internal_data = data.internal_data
	local my_data = {
		unit = data.unit
	}
	data.internal_data = my_data
	my_data.detection = data.char_tweak.detection.cbt

	data.unit:brain():set_update_enabled_state(false)

	local key_str = tostring(data.key)

	managers.groupai:state():register_fleeing_civilian(data.key, data.unit)

	my_data.panic_area = managers.groupai:state():get_area_from_nav_seg_id(data.unit:movement():nav_tracker():nav_segment())

	CivilianLogicFlee.reset_actions(data)

	if data.objective then
		if data.objective.alert_data then
			CivilianLogicFlee.on_alert(data, data.objective.alert_data)

			if my_data ~= data.internal_data then
				return
			end

			if data.unit:anim_data().react_enter and not data.unit:anim_data().idle then
				my_data.delayed_post_react_alert_id = "postreact_alert" .. key_str

				CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_post_react_alert_id, callback(CivilianLogicFlee, CivilianLogicFlee, "post_react_alert_clbk", {
					data = data,
					alert_data = clone(data.objective.alert_data)
				}), TimerManager:game():time() + math.lerp(4, 8, math.random()))
			end
		elseif data.objective.dmg_info then
			CivilianLogicFlee.damage_clbk(data, data.objective.dmg_info)
		end
	end

	data.unit:movement():set_stance(data.is_tied and "cbt" or "ntl")
	data.unit:movement():set_cool(data.is_tied and false or true)

	if my_data ~= data.internal_data then
		return
	end

	CivilianLogicFlee._chk_add_delayed_rescue_SO(data, my_data)

	if data.objective and data.objective.was_rescued then
		data.objective.was_rescued = nil

		if CivilianLogicFlee._get_coarse_flee_path(data) then
			managers.groupai:state():on_civilian_freed()
		end
	end

	if not data.been_outlined and data.char_tweak.outline_on_discover then
		my_data.outline_detection_task_key = "CivilianLogicFlee_upd_outline_detection" .. key_str

		CopLogicBase.queue_task(my_data, my_data.outline_detection_task_key, CivilianLogicIdle._upd_outline_detection, data, data.t + 2)
	end

	if not my_data.detection_task_key and data.unit:anim_data().react_enter then
		my_data.detection_task_key = "CivilianLogicFlee._upd_detection" .. key_str

		CopLogicBase.queue_task(my_data, my_data.detection_task_key, CivilianLogicFlee._upd_detection, data, data.t + 0)
	end

	local attention_settings = nil
	attention_settings = {
		"civ_enemy_cbt",
		"civ_civ_cbt",
		"civ_murderer_cbt"
	}

	CivilianLogicFlee.schedule_run_away_clbk(data)

	if not my_data.delayed_post_react_alert_id and data.unit:movement():stance_name() == "ntl" then
		my_data.delayed_post_react_alert_id = "postreact_alert" .. key_str

		CopLogicBase.add_delayed_clbk(my_data, my_data.delayed_post_react_alert_id, callback(CivilianLogicFlee, CivilianLogicFlee, "post_react_alert_clbk", {
			data = data
		}), TimerManager:game():time() + math.lerp(4, 8, math.random()))
	end

	data.unit:brain():set_attention_settings(attention_settings)

	if data.char_tweak.calls_in and not managers.groupai:state():is_police_called() then
		my_data.call_police_clbk_id = "civ_call_police" .. key_str
		local call_t = math.max(data.call_police_delay_t or 0, TimerManager:game():time() + math.lerp(1, 10, math.random()))

		CopLogicBase.add_delayed_clbk(my_data, my_data.call_police_clbk_id, callback(CivilianLogicFlee, CivilianLogicFlee, "clbk_chk_call_the_police", data), call_t)
	end

	my_data.next_action_t = 0
end
