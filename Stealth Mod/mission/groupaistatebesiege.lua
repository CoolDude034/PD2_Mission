local _spawn_in_group = GroupAIStateBesiege._spawn_in_group
function GroupAIStateBesiege:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, ai_task)
	grp_objective.stance = "ntl"
	grp_objective.pose = "crouch"
	grp_objective.haste = "run"

	_spawn_in_group(self, spawn_group, spawn_group_type, grp_objective, ai_task)
end

local _set_objective_to_enemy_group = GroupAIStateBesiege._set_objective_to_enemy_group
function GroupAIStateBesiege:_set_objective_to_enemy_group(group, grp_objective)
	grp_objective.stance = "ntl"
	grp_objective.pose = "crouch"
	grp_objective.haste = "run"

	_set_objective_to_enemy_group(self, group, grp_objective)
end

local _chk_group_use_flash_grenade = GroupAIStateBesiege._chk_group_use_flash_grenade
function GroupAIStateBesiege:_chk_group_use_flash_grenade(group, task_data, detonate_pos)
	if self._is_spotted then
		_chk_group_use_flash_grenade(self, group, task_data, detonate_pos)
	end
end