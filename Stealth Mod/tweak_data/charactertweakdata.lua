local FORCED_CROUCH_WALK = {
	["marshal_marksman"] = true,
	["marshal_shield_break"] = true,
	["swat"] = true,
	["fbi_swat"] = true,
	["city_swat"] = true,
	["heavy_swat"] = true,
	["fbi_heavy_swat"] = true,
	["fbi"] = true,
	["sniper"] = true,
	["medic"] = true,
	["taser"] = true,
	["shadow_spooc"] = true,
	["spooc"] = true
}

local DOZERS = {
	["tank"] = true,
	["tank_mini"] = true,
	["tank_hw"] = true,
	["tank_medic"] = true,
	["snowman_boss"] = true,
	["triad_boss"] = true,
	["biker_boss"] = true,
	["hector_boss"] = true
}

Hooks:PostHook(CharacterTweakData, "init", "init_stealth_units", function(self)
	self.old_hoxton_mission.suspicious = nil
	self.spa_vip.suspicious = nil

	for _,cop in pairs(self._enemy_list) do
		--self[cop].allowed_stances = {ntl = true}

		if FORCED_CROUCH_WALK[cop] then
			self[cop].crouch_move = true
			self[cop].allowed_poses = {crouch = true}
			self[cop].silent_priority_shout = "f42"
			self[cop].suspicious = nil
		elseif DOZERS[cop] then
			self[cop].allowed_stances = nil
			self[cop].suspicious = nil
		end
	end
end)