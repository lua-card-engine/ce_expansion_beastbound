--[[
	Damage, healing, energy and Knock Outs

	The parts of the rules that cards reach for constantly. Everything here goes through the engine's
	own mutation API rather than writing to instances directly, so each change becomes an event the
	board can animate and the log can describe.
--]]

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- The counter damage is tracked under
Beastbound.DAMAGE_COUNTER = "damage"

--- How many Beasts fit on the bench (game-rules.md §4)
Beastbound.MAX_BENCH = 5

--- How many prize cards each player sets aside (game-rules.md §4)
Beastbound.PRIZE_COUNT = 6

--- How many cards a player opens with (game-rules.md §4)
Beastbound.OPENING_HAND_SIZE = 7

--[[
	Reading a Beast
--]]

--- Whether a card is a Beast
--- @param card CardEngine.Card?
--- @return boolean
function Beastbound.IsBeast(card)
	return card ~= nil and card:GetAttribute("Supertype") == "Beast"
end

--- Whether a card is a Basic Beast, the only kind that can be put straight into play
--- @param card CardEngine.Card?
--- @return boolean
function Beastbound.IsBasicBeast(card)
	return Beastbound.IsBeast(card) and card:GetAttribute("Stage") == "Basic"
end

--- A Beast's printed HP
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @return number
function Beastbound.GetMaxHP(match, instanceOrID)
	return match:GetInstanceAttribute(instanceOrID, "HP", 0)
end

--- The damage currently on a Beast
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @return number
function Beastbound.GetDamage(match, instanceOrID)
	return match:GetCounter(instanceOrID, Beastbound.DAMAGE_COUNTER)
end

--- How much damage a Beast can still take before it is Knocked Out
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @return number
function Beastbound.GetRemainingHP(match, instanceOrID)
	return math.max(0, Beastbound.GetMaxHP(match, instanceOrID) - Beastbound.GetDamage(match, instanceOrID))
end

--- Whether a Beast has taken enough damage to be Knocked Out
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @return boolean
function Beastbound.IsKnockedOut(match, instanceOrID)
	local maxHP = Beastbound.GetMaxHP(match, instanceOrID)

	return maxHP > 0 and Beastbound.GetDamage(match, instanceOrID) >= maxHP
end

--- A Beast's attacks, as printed
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @return table[]
function Beastbound.GetAttacks(match, instanceOrID)
	return match:GetInstanceAttribute(instanceOrID, "Attacks", {})
end

--[[
	Energy
--]]

--- Whether a card is an Energy card
--- @param card CardEngine.Card?
--- @return boolean
function Beastbound.IsEnergy(card)
	return card ~= nil and card:GetAttribute("Supertype") == "Energy"
end

--- The energy attached to a Beast, optionally only of one type.
---
--- This set has no colourless energy: an attack is paid for in the attacking Beast's own type, so
--- energy of the wrong type sits there doing nothing but still counts towards a retreat.
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @param energyType string? Only count energy of this type
--- @return CardEngine.MatchCardInstance[]
function Beastbound.GetAttachedEnergy(match, instanceOrID, energyType)
	local energy = {}

	for _, attached in ipairs(match:GetAttached(instanceOrID)) do
		local card = match:GetInstanceCard(attached)

		if (Beastbound.IsEnergy(card) and (not energyType or card:GetAttribute("Type") == energyType)) then
			table.insert(energy, attached)
		end
	end

	return energy
end

--- How much energy is attached to a Beast, optionally only of one type
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @param energyType string?
--- @return number
function Beastbound.CountEnergy(match, instanceOrID, energyType)
	return #Beastbound.GetAttachedEnergy(match, instanceOrID, energyType)
end

--- Whether a Beast has the energy to use one of its attacks
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @param attack table The attack, as printed on the card
--- @return boolean
function Beastbound.CanPayAttackCost(match, instanceOrID, attack)
	local beastType = match:GetInstanceAttribute(instanceOrID, "Type")

	return Beastbound.CountEnergy(match, instanceOrID, beastType) >= (attack.Cost or 0)
end

--- What it costs a Beast to retreat, after anything that changes it (Boots of Flight, Frost Spray)
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @return number
function Beastbound.GetRetreatCost(match, instanceOrID)
	local instance = match:ResolveInstance(instanceOrID)
	local printed = match:GetInstanceAttribute(instanceOrID, "RetreatCost", 0)

	local cost = match:Query("RetreatCost", {
		instance = instance,
		player = instance and instance.controller,
	}, printed)

	return math.max(0, math.floor(cost))
end

--[[
	Damage and healing
--]]

--- Deals damage to a Beast, and Knocks it Out if that is enough.
---
--- The three steps of §2 happen here in order, and then anything in force gets its say through the
--- IncomingDamage query, which is how Turtitan's Fortress Guard holds damage back and how Runic
--- Sword adds to it.
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number The Beast taking the damage
--- @param amount number The damage before weakness, resistance and effects
--- @param options table? `attacker` the Beast dealing it, `ignoreWeakness` to skip the type chart
---        (which is what conditions and self-damage want), `reason` a language key for the log
--- @return number # The damage that actually landed
function Beastbound.DealDamage(match, instanceOrID, amount, options)
	local instance = match:ResolveInstance(instanceOrID)

	if (not instance or amount <= 0) then
		return 0
	end

	options = options or {}

	local damage = amount
	local wasWeak = false
	local wasResisted = false

	if (not options.ignoreWeakness and options.attacker) then
		local attackingType = match:GetInstanceAttribute(options.attacker, "Type")
		local defendingType = match:GetInstanceAttribute(instance, "Type")

		damage, wasWeak, wasResisted = Beastbound.CalculateDamage(damage, attackingType, defendingType)
	end

	damage = match:Query("IncomingDamage", {
		instance = instance,
		player = instance.controller,
		attacker = options.attacker,
		isAttack = options.isAttack == true,
	}, damage)

	damage = math.max(0, math.floor(damage))

	if (damage > 0) then
		CardEngine.Match.AddCounter(match, instance, Beastbound.DAMAGE_COUNTER, damage)
	end

	match:AddEvent({
		type = "beastbound_damage",
		instance = instance.id,
		amount = damage,
		weak = wasWeak,
		resisted = wasResisted,
		reason = options.reason,
		attacker = options.attacker and match:ResolveInstance(options.attacker).id or nil,
	})

	return damage
end

--- Heals damage off a Beast
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @param amount number
--- @return number # How much damage was actually healed
function Beastbound.Heal(match, instanceOrID, amount)
	local instance = match:ResolveInstance(instanceOrID)

	if (not instance or amount <= 0) then
		return 0
	end

	local damage = Beastbound.GetDamage(match, instance)
	local healed = math.min(damage, amount)

	if (healed <= 0) then
		return 0
	end

	CardEngine.Match.AddCounter(match, instance, Beastbound.DAMAGE_COUNTER, -healed)

	match:AddEvent({
		type = "beastbound_healed",
		instance = instance.id,
		amount = healed,
	})

	return healed
end

--[[
	Knock Outs
--]]

--- Knocks a Beast out: it and everything on it go to the discard, and its opponent takes a prize.
---
--- Promoting a replacement is deliberately left to CheckKnockOuts, so that a player who loses their
--- Active Beast and a benched one in the same attack is only asked to promote once.
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
function Beastbound.KnockOut(match, instanceOrID)
	local instance = match:ResolveInstance(instanceOrID)

	if (not instance) then
		return
	end

	local controller = instance.controller
	local opponent = match:GetOpponentIndex(controller)

	match:AddEvent({
		type = "beastbound_knocked_out",
		instance = instance.id,
		player = controller,
	})

	-- Everything attached to it, and every stage beneath it, goes to the discard with it
	CardEngine.Match.MoveCard(match, instance, "Discard", controller)

	if (opponent) then
		Beastbound.TakePrize(match, opponent)
	end
end

--- Takes one prize card into a player's hand
--- @param match CardEngine.Match
--- @param playerIndex number
--- @return boolean # Whether there was a prize left to take
function Beastbound.TakePrize(match, playerIndex)
	local prizes = match:GetZoneInstances("Prizes", playerIndex)

	if (#prizes == 0) then
		return false
	end

	local prize = prizes[#prizes]

	CardEngine.Match.MoveCard(match, prize, "Hand", playerIndex, { faceDown = false })

	match:AddEvent({
		type = "beastbound_prize_taken",
		player = playerIndex,
		remaining = match:CountZone("Prizes", playerIndex),
	})

	return true
end

--- Knocks out every Beast that has taken enough damage, then makes sure both players still have an
--- Active Beast, asking them to promote one from their bench if they do not.
---
--- Runs inside an action's coroutine, since promoting may need to ask.
--- @param match CardEngine.Match
function Beastbound.CheckKnockOuts(match)
	local knockedOut = {}

	for playerIndex = 1, match:GetPlayerCount() do
		for _, zoneKey in ipairs({ "Active", "Bench" }) do
			for _, instance in ipairs(match:GetZoneInstances(zoneKey, playerIndex)) do
				if (Beastbound.IsKnockedOut(match, instance)) then
					table.insert(knockedOut, instance)
				end
			end
		end
	end

	if (#knockedOut == 0) then
		return
	end

	-- The blow that did it is seen landing before the Beast leaves
	match:Beat()

	for _, instance in ipairs(knockedOut) do
		Beastbound.KnockOut(match, instance)
	end

	-- The player who lost their Active Beast promotes first, but both are checked: an attack can
	-- knock out a Beast on either side of the table
	for playerIndex = 1, match:GetPlayerCount() do
		Beastbound.PromoteIfNeeded(match, playerIndex)
	end
end

--- Makes sure a player has an Active Beast, moving one up from the bench if they do not.
---
--- A player with an empty bench and no Active Beast has lost, but that is for CheckGameOver to
--- notice rather than for this to decide.
--- @param match CardEngine.Match
--- @param playerIndex number
--- @return boolean # Whether they have an Active Beast now
function Beastbound.PromoteIfNeeded(match, playerIndex)
	if (match:GetZoneSlot("Active", playerIndex, 1)) then
		return true
	end

	local bench = match:GetZoneInstances("Bench", playerIndex)

	if (#bench == 0) then
		return false
	end

	local chosen = match:PromptInstance(playerIndex, "ce_expansion_beastbound_prompt_promote", bench, 1)

	if (not chosen) then
		chosen = bench[1]
	end

	Beastbound.MoveToActive(match, chosen)

	return true
end

--- Moves a Beast into the Active spot
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
function Beastbound.MoveToActive(match, instanceOrID)
	local instance = match:ResolveInstance(instanceOrID)

	if (not instance) then
		return
	end

	CardEngine.Match.MoveCard(match, instance, "Active", instance.controller, {
		slot = 1,
		faceDown = false,
		keepAttached = true,
	})

	match:AddEvent({
		type = "beastbound_promoted",
		instance = instance.id,
		player = instance.controller,
	})
end

--- Swaps the Active Beast with one from the bench. Conditions do not follow a Beast off the Active
--- spot, so retreating shakes them off.
--- @param match CardEngine.Match
--- @param benchedOrID CardEngine.MatchCardInstance|number The Beast coming up from the bench
--- @return boolean
function Beastbound.SwapWithActive(match, benchedOrID)
	local benched = match:ResolveInstance(benchedOrID)

	if (not benched) then
		return false
	end

	local playerIndex = benched.controller
	local active = match:GetZoneSlot("Active", playerIndex, 1)
	local benchSlot = benched.slot

	if (active) then
		Beastbound.CureAllConditions(match, active)

		-- Whatever Energy is left after paying the Retreat Cost stays on the Beast (§5)
		CardEngine.Match.MoveCard(match, active, "Bench", playerIndex, {
			slot = benchSlot,
			faceDown = false,
			keepAttached = true,
		})
	end

	CardEngine.Match.MoveCard(match, benched, "Active", playerIndex, {
		slot = 1,
		faceDown = false,
		keepAttached = true,
	})

	match:AddEvent({
		type = "beastbound_retreated",
		instance = benched.id,
		player = playerIndex,
	})

	return true
end
