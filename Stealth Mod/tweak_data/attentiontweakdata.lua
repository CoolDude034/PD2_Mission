Hooks:PostHook(AttentionTweakData, "init", "_upd_attention_data", function(self)
	for setting_name,setting in pairs(self.settings) do
		self.settings[setting_name].notice_requires_FOV = true
	end
end)