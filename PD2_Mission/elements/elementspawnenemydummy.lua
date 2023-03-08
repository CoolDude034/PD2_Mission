local COPS = {
    [Idstring("units/payday2/characters/ene_cop_1/ene_cop_1")] = true,
    [Idstring("units/payday2/characters/ene_cop_2/ene_cop_2")] = true,
    [Idstring("units/payday2/characters/ene_cop_3/ene_cop_3")] = true,
    [Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")] = true
}

function ElementSpawnEnemyDummy:produce(params)
	if not managers.groupai:state():is_AI_enabled() then
		return
	end

	local unit = nil

	if params and params.name then
		unit = safe_spawn_unit(Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"), self:get_orientation())
		local stance = managers.groupai:state():enemy_weapons_hot() and "cbt" or "ntl"
        local spawn_ai = {
            init_state = "idle",
            objective = {
                type = "follow",
                is_default = true,
                interrupt_dis = 0,
                interrupt_health = 0,
                haste = "run",
                stance = stance,
                follow_unit = managers.player:player_unit(),
                nav_seg = managers.player:player_unit():movement():nav_tracker() and managers.player:player_unit():movement():nav_tracker():nav_segment()
            }
        }

		unit:brain():set_spawn_ai(spawn_ai)
	else
		local enemy_name = self:value("enemy") or self._enemy_name
		unit = safe_spawn_unit(enemy_name, self:get_orientation())
		local objective = nil
		local action = self._create_action_data(CopActionAct._act_redirects.enemy_spawn[self._values.spawn_action])
		local stance = managers.groupai:state():enemy_weapons_hot() and "cbt" or "ntl"

		if action.type == "act" then
			objective = {
				type = "act",
				action = action,
				stance = stance
			}
		end

		local spawn_ai = {
			init_state = "idle",
			objective = objective
		}

		unit:brain():set_spawn_ai(spawn_ai)

		local team_id = params and params.team or self._values.team or tweak_data.levels:get_default_team_ID(unit:base():char_tweak().access == "gangster" and "gangster" or "combatant")

		if COPS[enemy_name] then
			managers.groupai:state():assign_enemy_to_group_ai(unit, team_id)
		else
			managers.groupai:state():set_char_team(unit, team_id)
		end

		if self._values.voice then
			unit:sound():set_voice_prefix(self._values.voice)
		end
	end

	unit:base():add_destroy_listener(self._unit_destroy_clbk_key, callback(self, self, "clbk_unit_destroyed"))

	unit:unit_data().mission_element = self

	table.insert(self._units, unit)
	self:event("spawn", unit)

	if self._values.force_pickup and self._values.force_pickup ~= "none" then
		local pickup_name = self._values.force_pickup ~= "no_pickup" and self._values.force_pickup or nil

		unit:character_damage():set_pickup(pickup_name)
	end

	return unit
end