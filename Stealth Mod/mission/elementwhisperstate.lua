function ElementWhisperState:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	managers.groupai:state():set_stealth_hud_disabled(self._values.disable_hud)
	managers.groupai:state():set_whisper_mode(true) -- self._values.state
	ElementWhisperState.super.on_executed(self, instigator)
end