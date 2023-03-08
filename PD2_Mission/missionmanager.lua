local player = managers.player

local function spawn_npc(mdl, pos, rot)
    local npc = safe_spawn_unit(Idstring(mdl), pos or player:player_unit():position() + Vector3(0,60,0), rot or Rotation())
    return npc
end

Hooks:PostHook(MissionManager, "init", "_setup_mission", function(self)
end)