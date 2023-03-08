NPC_Maker = NPC_Maker or class()

local my_class_name = "NPC_Maker"

function NPC_Maker:init()
    self._actors = {}
end

Hooks:PostHook(GameSetup, "init", "Init" .. my_class_name, function(self, managers)
    managers.npc_maker = NPC_Maker:new()
end)

Hooks:PostHook(GameSetup, "update", "Update" .. my_class_name, function(self, t, dt)
    managers.npc_maker:update(t, dt)
end)
