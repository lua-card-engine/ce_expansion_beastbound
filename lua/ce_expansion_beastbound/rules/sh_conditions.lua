-- Special Conditions (game-rules.md §6). A Beast has one of the non-damage conditions at a time and
-- a new one replaces it. Poisoned and Burned do damage between turns and sit alongside it, so a
-- Beast carries at most three.

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- The conditions that deal damage between turns. These stack with one of the others.
Beastbound.DAMAGE_CONDITIONS = {
	Poisoned = true,
	Burned = true,
}

--- Every condition, and what it does
Beastbound.CONDITIONS = {
	Paralyzed = {
		Label = "ce_expansion_beastbound_condition_paralyzed",
		PreventsAttack = true,
		PreventsRetreat = true,
	},
	Confused = {
		Label = "ce_expansion_beastbound_condition_confused",
	},
	Asleep = {
		Label = "ce_expansion_beastbound_condition_asleep",
		PreventsAttack = true,
		PreventsRetreat = true,
	},
	Poisoned = {
		Label = "ce_expansion_beastbound_condition_poisoned",
		BetweenTurnsDamage = 10,
	},
	Burned = {
		Label = "ce_expansion_beastbound_condition_burned",
		BetweenTurnsDamage = 20,
	},
}

--- The instance state key a condition is stored under. Damaging conditions get their own slot so
--- they can sit alongside another condition.
--- @param condition string
--- @return string
function Beastbound.GetConditionSlot(condition)
	return Beastbound.DAMAGE_CONDITIONS[condition] and ("condition_" .. condition) or "condition"
end

--- Whether a Beast is under a condition
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @param condition string
--- @return boolean
function Beastbound.HasCondition(match, instanceOrID, condition)
	return match:GetInstanceState(instanceOrID, Beastbound.GetConditionSlot(condition)) == condition
end

--- Every condition currently on a Beast
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @return string[]
function Beastbound.GetConditions(match, instanceOrID)
	local conditions = {}
	local single = match:GetInstanceState(instanceOrID, "condition")

	if (single) then
		table.insert(conditions, single)
	end

	for condition in pairs(Beastbound.DAMAGE_CONDITIONS) do
		if (Beastbound.HasCondition(match, instanceOrID, condition)) then
			table.insert(conditions, condition)
		end
	end

	table.sort(conditions)

	return conditions
end

--- Whether any condition on a Beast stops it doing something
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @param what string Either "PreventsAttack" or "PreventsRetreat"
--- @return boolean prevented
--- @return string? condition # Which condition is in the way
function Beastbound.IsPreventedBy(match, instanceOrID, what)
	for _, condition in ipairs(Beastbound.GetConditions(match, instanceOrID)) do
		local definition = Beastbound.CONDITIONS[condition]

		if (definition and definition[what]) then
			return true, condition
		end
	end

	return false, nil
end

--- Puts a condition on a Beast. A damaging condition takes its own slot; anything else replaces the
--- non-damage condition already there.
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @param condition string
--- @return boolean # Whether the condition was applied
function Beastbound.ApplyCondition(match, instanceOrID, condition)
	local instance = match:ResolveInstance(instanceOrID)

	if (not instance or not Beastbound.CONDITIONS[condition]) then
		return false
	end

	-- A benched Beast is safe
	if (instance.zone ~= "Active") then
		return false
	end

	CardEngine.Match.SetInstanceState(match, instance, Beastbound.GetConditionSlot(condition), condition)

	match:AddEvent({
		type = "beastbound_condition_applied",
		instance = instance.id,
		condition = condition,
	})

	return true
end

--- Takes one condition off a Beast
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @param condition string
function Beastbound.CureCondition(match, instanceOrID, condition)
	local instance = match:ResolveInstance(instanceOrID)

	if (not instance or not Beastbound.HasCondition(match, instance, condition)) then
		return
	end

	CardEngine.Match.SetInstanceState(match, instance, Beastbound.GetConditionSlot(condition), nil)

	match:AddEvent({
		type = "beastbound_condition_cured",
		instance = instance.id,
		condition = condition,
	})
end

--- Takes every condition off a Beast. Used by Noxious Draught, and whenever a Beast leaves the
--- Active spot, since conditions only apply while it is out there.
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @return number # How many conditions were cured
function Beastbound.CureAllConditions(match, instanceOrID)
	local conditions = Beastbound.GetConditions(match, instanceOrID)

	for _, condition in ipairs(conditions) do
		Beastbound.CureCondition(match, instanceOrID, condition)
	end

	CardEngine.Match.SetInstanceState(match, instanceOrID, "paralyzedSince", nil)

	return #conditions
end

--- Moves every condition from one Beast to another, which is Stargazer's Gravity Pull
--- @param match CardEngine.Match
--- @param fromOrID CardEngine.MatchCardInstance|number
--- @param toOrID CardEngine.MatchCardInstance|number
--- @return number # How many conditions moved
function Beastbound.TransferConditions(match, fromOrID, toOrID)
	local conditions = Beastbound.GetConditions(match, fromOrID)

	for _, condition in ipairs(conditions) do
		Beastbound.CureCondition(match, fromOrID, condition)
		Beastbound.ApplyCondition(match, toOrID, condition)
	end

	return #conditions
end

--- Deals the damage Poison and Burn do between turns, then flips to see whether Burn wears off.
--- Called for every Active Beast in the Between Turns step.
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
function Beastbound.ResolveBetweenTurnsDamage(match, instanceOrID)
	local instance = match:ResolveInstance(instanceOrID)

	if (not instance) then
		return
	end

	-- A fixed order rather than pairs(), so the match stays reproducible from its seed
	for _, condition in ipairs({ "Burned", "Poisoned" }) do
		if (Beastbound.IsKnockedOut(match, instance)) then
			return
		end

		if (Beastbound.HasCondition(match, instance, condition)) then
			local definition = Beastbound.CONDITIONS[condition]

			Beastbound.DealDamage(match, instance, definition.BetweenTurnsDamage, {
				ignoreWeakness = true,
				reason = definition.Label,
			})

			-- Burn burns itself out on a heads; poison does not
			if (condition == "Burned" and not Beastbound.IsKnockedOut(match, instance)) then
				local heads = match:FlipCoin(1, "ce_expansion_beastbound_flip_burn_recovery", instance)

				if (heads == 1) then
					Beastbound.CureCondition(match, instance, "Burned")
				end
			end
		end
	end
end

--- Checks whether a Beast shakes off the condition it woke up under. Asleep flips at the start of
--- its controller's turn; Paralysis simply wears off after one of their turns.
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
function Beastbound.ResolveTurnStartRecovery(match, instanceOrID)
	local instance = match:ResolveInstance(instanceOrID)

	if (not instance) then
		return
	end

	if (Beastbound.HasCondition(match, instance, "Asleep")) then
		local heads = match:FlipCoin(1, "ce_expansion_beastbound_flip_sleep_recovery", instance)

		if (heads == 1) then
			Beastbound.CureCondition(match, instance, "Asleep")
		end
	end

	-- Paralysis is applied during the opponent's turn, so it is still in force at the start of the
	-- controller's next turn (which it takes away) and clears at the start of the one after
	if (Beastbound.HasCondition(match, instance, "Paralyzed")) then
		if (match:GetInstanceState(instance, "paralyzedSince")) then
			Beastbound.CureCondition(match, instance, "Paralyzed")
			CardEngine.Match.SetInstanceState(match, instance, "paralyzedSince", nil)
		else
			CardEngine.Match.SetInstanceState(match, instance, "paralyzedSince", match:GetTurn())
		end
	end
end
