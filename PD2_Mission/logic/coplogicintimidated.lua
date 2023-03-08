function CopLogicIntimidated._chk_begin_alarm_pager(data)
	if managers.groupai:state():whisper_mode() and data.unit:unit_data().has_alarm_pager and data.unit:unit_data()._has_activated_radio then
		data.brain:begin_alarm_pager()
	end
end