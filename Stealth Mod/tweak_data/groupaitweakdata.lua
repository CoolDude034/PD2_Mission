-- Scales enemy spawns to spawn less hordy
-- srry i skipped math school

Hooks:PostHook(GroupAITweakData, "_init_task_data", "_spawn_rates", function(self, difficulty_index, difficulty)
	self.besiege.regroup.duration = {
		30,
		30,
		30
	}
	self.besiege.assault.build_duration = 65

	self.besiege.assault.force = {
		4,
		8,
		10
	}
	self.besiege.assault.force_pool = {
		10,
		20,
		20
	}

	self.besiege.assault.force_balance_mul = {
		1,
		1.1,
		1.2,
		1.3
	}
	self.besiege.assault.force_pool_balance_mul = {
		1,
		1.1,
		1.2,
		1.3
	}
end)