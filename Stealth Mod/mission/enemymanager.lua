function EnemyManager:is_corpse_disposal_enabled()
	return managers.groupai:state():enemy_weapons_hot()
end