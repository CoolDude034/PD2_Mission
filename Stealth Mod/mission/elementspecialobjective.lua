local get_objective = ElementSpecialObjective.get_objective
function ElementSpecialObjective:get_objective(instigator)
	local objective = get_objective(self, instigator)
	if objective ~= nil then
		objective.stance = "ntl"
	end
	return objective
end