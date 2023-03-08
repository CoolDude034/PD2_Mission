function GroupAIStateBase:_clbk_switch_enemies_to_not_cool()
	for u_key, unit_data in pairs(self._police) do
		if unit_data.unit:movement():cool() and unit_data.assigned_area then
			unit_data.unit:movement():set_cool(false)

			if unit_data.unit:brain():is_available_for_assignment() then
				local new_objective = {
					type = "defend_area",
					path_style = "destination",
					is_default = true,
					forced = true,
					scan = true,
					interrupt_dis = -1,
					haste = "run",
					attitude = "avoid",
					pos = managers.player:player_unit():position(),
					nav_seg = managers.player:player_unit():movement():nav_tracker() and managers.player:player_unit():movement():nav_tracker():nav_segment()
				}

				unit_data.unit:brain():set_objective(new_objective)
			end

			managers.enemy:add_delayed_clbk(self._switch_to_not_cool_clbk_id, callback(self, self, "_clbk_switch_enemies_to_not_cool"), self._t + math.random() * 1)

			return
		end
	end

	self:propagate_alert({
		"vo_cbt",
		[4] = self._unit_type_filter.civilian
	})

	self._switch_to_not_cool_clbk_id = nil
end

function GroupAIStateBase:_set_spotted_mode(toggle)
	if type(toggle) == "boolean" then
		self._is_spotted = toggle
	else
		self._is_spotted = false
	end
end

Hooks:PostHook(GroupAIStateBase, "init", "_force_whisper", function(self)
	self._whisper_mode = true
	self._is_spotted = false
end)

local function disable_corpse_interactions()
	local corpses = {}
	for u_key,u_data in pairs(managers.enemy:all_enemies()) do
		if u_data.unit:character_damage().dead and u_data.unit:character_damage():dead() then
			corpses[u_key] = u_data
		end
	end
	for u_key,u_data in pairs(managers.enemy:all_civilians()) do
		if u_data.unit:character_damage().dead and u_data.unit:character_damage():dead() then
			corpses[u_key] = u_data
		end
	end
	return corpses
end

Hooks:PostHook(GroupAIStateBase, "on_police_called", "_police_called", function(self)
	--tweak_data.attention:init()
		
	for u_key,u_data in pairs(disable_corpse_interactions()) do
		u_data.unit:interaction():set_active(false, true)
	end
end)

Hooks:PostHook(GroupAIStateBase, "on_criminal_nav_seg_change", "_on_criminal_nav_seg_change", function(self)
	self:_set_spotted_mode(false)
end)

Hooks:PostHook(GroupAIStateBase, "criminal_spotted", "_on_criminal_spotted", function(self, unit)
	if unit == managers.player:player_unit() then
		self:_set_spotted_mode(true)
	end
end)
