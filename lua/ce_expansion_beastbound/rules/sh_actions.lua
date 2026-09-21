--[[
	The actions a player can take

	See game-rules.md §5. Each action says when it is legal and what it does. Card Engine checks the
	turn, the phase and then IsLegal before it will run Perform, and it re-checks all of it on the
	server no matter what the client believed, so these are the whole of the rules on what a player
	may do.

	The per-turn limits (one energy, one supporter, one retreat, one attack) live in the player's
	match state and are cleared at the start of each turn by sh_rules.lua.
--]]

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--[[
	Helpers shared by the actions
--]]

--- The card a player is trying to play, if it really is in their hand
--- @param match CardEngine.Match
--- @param playerIndex number
--- @param instanceID number
--- @return CardEngine.MatchCardInstance?
--- @return CardEngine.Card?
local function getHandCard(match, playerIndex, instanceID)
	local instance = match:GetInstance(instanceID)

	if (not instance or instance.zone ~= "Hand" or instance.controller ~= playerIndex) then
		return nil, nil
	end

	return instance, match:GetInstanceCard(instance)
end

--- A Beast of the player's that is in play, whether active or benched
--- @param match CardEngine.Match
--- @param playerIndex number
--- @param instanceID number
--- @return CardEngine.MatchCardInstance?
local function getOwnBeast(match, playerIndex, instanceID)
	local instance = match:GetInstance(instanceID)

	if (not instance or instance.controller ~= playerIndex) then
		return nil
	end

	if (instance.zone ~= "Active" and instance.zone ~= "Bench") then
		return nil
	end

	return instance
end

--- Every Beast a player has in play, the Active one first
--- @param match CardEngine.Match
--- @param playerIndex number
--- @return CardEngine.MatchCardInstance[]
function Beastbound.GetBeastsInPlay(match, playerIndex)
	local beasts = {}

	for _, instance in ipairs(match:GetZoneInstances("Active", playerIndex)) do
		table.insert(beasts, instance)
	end

	for _, instance in ipairs(match:GetZoneInstances("Bench", playerIndex)) do
		table.insert(beasts, instance)
	end

	return beasts
end

--- Runs whatever a card says it does, if it says anything at all.
---
--- A card's behaviour lives in CARD.GameRules in its own file, right next to its stats. Most cards
--- have nothing here: an attack with no rules text just does its damage.
--- @param match CardEngine.Match
--- @param card CardEngine.Card?
--- @param key string Which part of the card to run, e.g. "OnPlay"
--- @param context table What the card is acting on
--- @return any
function Beastbound.RunCardScript(match, card, key, context)
	local gameRules = card and card.GameRules

	if (not gameRules or not isfunction(gameRules[key])) then
		return nil
	end

	return gameRules[key](context)
end

--- Runs one of a Beast's attacks, if that attack has an effect
--- @param match CardEngine.Match
--- @param card CardEngine.Card?
--- @param attackIndex number
--- @param context table
--- @return any
function Beastbound.RunAttackScript(match, card, attackIndex, context)
	local attacks = card and card.GameRules and card.GameRules.Attacks

	if (not attacks or not isfunction(attacks[attackIndex])) then
		return nil
	end

	return attacks[attackIndex](context)
end

--[[
	The actions
--]]

--- Whether a player is holding a card that passes a test.
---
--- What every "is this button worth pressing" check needs: an action that plays a card from hand
--- leads nowhere at all when there is no such card to play.
--- @param match CardEngine.Match
--- @param playerIndex number
--- @param predicate fun(card: CardEngine.Card): boolean
--- @return boolean
function Beastbound.HandHas(match, playerIndex, predicate)
	for _, instance in ipairs(match:GetZoneInstances("Hand", playerIndex)) do
		local card = match:GetInstanceCard(instance)

		-- A client cannot read its opponent's hand, and it never asks this about one
		if (card and predicate(card)) then
			return true
		end
	end

	return false
end

Beastbound.Actions = {}

--- Attach 1 Energy card from your hand to 1 of your Beasts. Once per turn (§5).
Beastbound.Actions.AttachEnergy = {
	Phase = "Action",

	IsAvailable = function(match, playerIndex)
		if (match:GetPlayerState(playerIndex, "attachedEnergy")) then
			return false, "ce_expansion_beastbound_already_attached_energy"
		end

		if (not Beastbound.HandHas(match, playerIndex, Beastbound.IsEnergy)) then
			return false, "ce_expansion_beastbound_no_energy_in_hand"
		end

		if (#Beastbound.GetBeastsInPlay(match, playerIndex) == 0) then
			return false, "ce_expansion_beastbound_no_such_beast"
		end

		return true
	end,

	IsLegal = function(match, playerIndex, params)
		if (match:GetPlayerState(playerIndex, "attachedEnergy")) then
			return false, "ce_expansion_beastbound_already_attached_energy"
		end

		local instance, card = getHandCard(match, playerIndex, params.card)

		-- The client cannot see the contents of its opponent's hand, so a card it cannot identify
		-- is treated as "maybe", not as illegal. The server always can, so nothing gets through.
		if (not instance) then
			return false, "ce_expansion_beastbound_card_not_in_hand"
		end

		if (card and not Beastbound.IsEnergy(card)) then
			return false, "ce_expansion_beastbound_not_energy"
		end

		if (not getOwnBeast(match, playerIndex, params.target)) then
			return false, "ce_expansion_beastbound_no_such_beast"
		end

		return true
	end,

	Perform = function(match, playerIndex, params)
		local instance = match:GetInstance(params.card)
		local target = match:GetInstance(params.target)

		CardEngine.Match.AttachCard(match, instance, target)
		CardEngine.Match.SetPlayerState(match, playerIndex, "attachedEnergy", true)

		match:AddLogMessage("ce_expansion_beastbound_log_attached_energy", {
			player = match:GetPlayer(playerIndex).name,
			card = match:GetInstanceCard(instance):GetName(),
			target = match:GetInstanceCard(target):GetName(),
		})
	end,
}

--- Play an Item card. Any number per turn (§5).
Beastbound.Actions.PlayItem = {
	Phase = "Action",

	IsAvailable = function(match, playerIndex)
		if (not Beastbound.HandHas(match, playerIndex, function(card)
				return card:GetAttribute("Supertype") == "Item"
			end)) then
			return false, "ce_expansion_beastbound_no_item_in_hand"
		end

		return true
	end,

	IsLegal = function(match, playerIndex, params)
		local instance, card = getHandCard(match, playerIndex, params.card)

		if (not instance) then
			return false, "ce_expansion_beastbound_card_not_in_hand"
		end

		if (card and card:GetAttribute("Supertype") ~= "Item") then
			return false, "ce_expansion_beastbound_not_item"
		end

		return true
	end,

	Perform = function(match, playerIndex, params)
		local instance = match:GetInstance(params.card)
		local card = match:GetInstanceCard(instance)

		match:AddLogMessage("ce_expansion_beastbound_log_played_card", {
			player = match:GetPlayer(playerIndex).name,
			card = card:GetName(),
		})

		local context = Beastbound.BuildContext(match, playerIndex, instance)
		local played = Beastbound.RunCardScript(match, card, "OnPlay", context)

		-- A card that says it could not be played stays in hand, so a player is not punished for
		-- trying something that turned out to have no legal target
		if (played == false) then
			return
		end

		-- Equipment stays out on the Beast it was attached to; everything else is spent
		if (match:GetInstance(instance.id) and instance.zone == "Hand") then
			CardEngine.Match.MoveCard(match, instance, "Discard", playerIndex)
		end

		Beastbound.CheckKnockOuts(match)
	end,
}

--- Play a Supporter card. Once per turn (§5).
Beastbound.Actions.PlaySupporter = {
	Phase = "Action",

	IsAvailable = function(match, playerIndex)
		if (match:GetPlayerState(playerIndex, "playedSupporter")) then
			return false, "ce_expansion_beastbound_already_played_supporter"
		end

		if (not Beastbound.HandHas(match, playerIndex, function(card)
				return card:GetAttribute("Supertype") == "Supporter"
			end)) then
			return false, "ce_expansion_beastbound_no_supporter_in_hand"
		end

		return true
	end,

	IsLegal = function(match, playerIndex, params)
		if (match:GetPlayerState(playerIndex, "playedSupporter")) then
			return false, "ce_expansion_beastbound_already_played_supporter"
		end

		local instance, card = getHandCard(match, playerIndex, params.card)

		if (not instance) then
			return false, "ce_expansion_beastbound_card_not_in_hand"
		end

		if (card and card:GetAttribute("Supertype") ~= "Supporter") then
			return false, "ce_expansion_beastbound_not_supporter"
		end

		return true
	end,

	Perform = function(match, playerIndex, params)
		local instance = match:GetInstance(params.card)
		local card = match:GetInstanceCard(instance)

		CardEngine.Match.SetPlayerState(match, playerIndex, "playedSupporter", true)

		match:AddLogMessage("ce_expansion_beastbound_log_played_card", {
			player = match:GetPlayer(playerIndex).name,
			card = card:GetName(),
		})

		Beastbound.RunCardScript(match, card, "OnPlay", Beastbound.BuildContext(match, playerIndex, instance))

		if (match:GetInstance(instance.id) and instance.zone == "Hand") then
			CardEngine.Match.MoveCard(match, instance, "Discard", playerIndex)
		end

		Beastbound.CheckKnockOuts(match)
	end,
}

--- Put a Basic Beast from your hand onto your bench (§4, and any turn thereafter).
Beastbound.Actions.PlayBasic = {
	Phase = "Action",

	IsAvailable = function(match, playerIndex)
		if (not match:HasZoneSpace("Bench", playerIndex)) then
			return false, "ce_expansion_beastbound_bench_full"
		end

		if (not Beastbound.HandHas(match, playerIndex, Beastbound.IsBasicBeast)) then
			return false, "ce_expansion_beastbound_no_basic_in_hand"
		end

		return true
	end,

	IsLegal = function(match, playerIndex, params)
		local instance, card = getHandCard(match, playerIndex, params.card)

		if (not instance) then
			return false, "ce_expansion_beastbound_card_not_in_hand"
		end

		if (card and not Beastbound.IsBasicBeast(card)) then
			return false, "ce_expansion_beastbound_not_basic_beast"
		end

		if (not match:HasZoneSpace("Bench", playerIndex)) then
			return false, "ce_expansion_beastbound_bench_full"
		end

		return true
	end,

	Perform = function(match, playerIndex, params)
		local instance = match:GetInstance(params.card)

		CardEngine.Match.MoveCard(match, instance, "Bench", playerIndex, { faceDown = false })

		-- A Beast cannot evolve the turn it was played (§5), so remember when it arrived
		CardEngine.Match.SetInstanceState(match, instance, "playedOnTurn", match:GetTurn())

		match:AddLogMessage("ce_expansion_beastbound_log_benched", {
			player = match:GetPlayer(playerIndex).name,
			card = match:GetInstanceCard(instance):GetName(),
		})
	end,
}

--- Evolve a Beast by putting the next stage on top of it (§5).
Beastbound.Actions.Evolve = {
	Phase = "Action",

	IsAvailable = function(match, playerIndex)
		-- Something in hand has to be able to evolve something in play, or the button leads nowhere
		for _, target in ipairs(Beastbound.GetBeastsInPlay(match, playerIndex)) do
			for _, instance in ipairs(match:GetZoneInstances("Hand", playerIndex)) do
				if (Beastbound.CanEvolve(match, match:GetInstanceCard(instance), target)) then
					return true
				end
			end
		end

		return false, "ce_expansion_beastbound_nothing_to_evolve"
	end,

	IsLegal = function(match, playerIndex, params)
		local instance, card = getHandCard(match, playerIndex, params.card)

		if (not instance) then
			return false, "ce_expansion_beastbound_card_not_in_hand"
		end

		local target = getOwnBeast(match, playerIndex, params.target)

		if (not target) then
			return false, "ce_expansion_beastbound_no_such_beast"
		end

		return Beastbound.CanEvolve(match, card, target)
	end,

	Perform = function(match, playerIndex, params)
		local instance = match:GetInstance(params.card)
		local target = match:GetInstance(params.target)

		Beastbound.Evolve(match, instance, target)
	end,
}

--- Retreat: discard energy equal to the Retreat Cost to swap the Active Beast with a benched one.
--- Once per turn (§5).
Beastbound.Actions.Retreat = {
	Phase = "Action",

	IsAvailable = function(match, playerIndex)
		if (match:GetPlayerState(playerIndex, "retreated")) then
			return false, "ce_expansion_beastbound_already_retreated"
		end

		local active = match:GetZoneSlot("Active", playerIndex, 1)

		if (not active) then
			return false, "ce_expansion_beastbound_no_active_beast"
		end

		local prevented, condition = Beastbound.IsPreventedBy(match, active, "PreventsRetreat")

		if (prevented) then
			return false, Beastbound.CONDITIONS[condition].Label
		end

		if (#match:GetZoneInstances("Bench", playerIndex) == 0) then
			return false, "ce_expansion_beastbound_nothing_to_retreat_to"
		end

		if (Beastbound.CountEnergy(match, active) < Beastbound.GetRetreatCost(match, active)) then
			return false, "ce_expansion_beastbound_not_enough_energy_to_retreat"
		end

		return true
	end,

	IsLegal = function(match, playerIndex, params)
		if (match:GetPlayerState(playerIndex, "retreated")) then
			return false, "ce_expansion_beastbound_already_retreated"
		end

		local active = match:GetZoneSlot("Active", playerIndex, 1)

		if (not active) then
			return false, "ce_expansion_beastbound_no_active_beast"
		end

		local prevented, condition = Beastbound.IsPreventedBy(match, active, "PreventsRetreat")

		if (prevented) then
			return false, Beastbound.CONDITIONS[condition].Label
		end

		local benched = match:GetInstance(params.target)

		if (not benched or benched.zone ~= "Bench" or benched.controller ~= playerIndex) then
			return false, "ce_expansion_beastbound_no_such_beast"
		end

		local cost = Beastbound.GetRetreatCost(match, active)

		if (Beastbound.CountEnergy(match, active) < cost) then
			return false, "ce_expansion_beastbound_not_enough_energy_to_retreat"
		end

		return true
	end,

	Perform = function(match, playerIndex, params)
		local active = match:GetZoneSlot("Active", playerIndex, 1)
		local benched = match:GetInstance(params.target)
		local cost = Beastbound.GetRetreatCost(match, active)

		if (cost > 0) then
			local energy = Beastbound.GetAttachedEnergy(match, active)
			local chosen = match:PromptInstance(playerIndex,
				"ce_expansion_beastbound_prompt_discard_retreat_energy", energy, cost)

			for _, instance in ipairs(match:AsInstanceList(chosen)) do
				CardEngine.Match.DetachCard(match, instance)
				CardEngine.Match.MoveCard(match, instance, "Discard", playerIndex, { keepAttached = true })
			end
		end

		Beastbound.SwapWithActive(match, benched)
		CardEngine.Match.SetPlayerState(match, playerIndex, "retreated", true)

		match:AddLogMessage("ce_expansion_beastbound_log_retreated", {
			player = match:GetPlayer(playerIndex).name,
			card = match:GetInstanceCard(benched):GetName(),
		})
	end,
}

--- Attack with the Active Beast. This ends the turn (§5).
Beastbound.Actions.Attack = {
	Phase = "Action",
	EndsTurn = true,

	-- Whether attacking is possible at all. Which attack, and whether its cost can be paid, is left
	-- to IsLegal, so one attack greying out does not take the other with it.
	IsAvailable = function(match, playerIndex)
		local active = match:GetZoneSlot("Active", playerIndex, 1)

		if (not active) then
			return false, "ce_expansion_beastbound_no_active_beast"
		end

		local prevented, condition = Beastbound.IsPreventedBy(match, active, "PreventsAttack")

		if (prevented) then
			return false, Beastbound.CONDITIONS[condition].Label
		end

		if (match:Query("CanAttack", { instance = active, player = playerIndex }, true) ~= true) then
			return false, "ce_expansion_beastbound_cannot_attack_now"
		end

		local opponent = match:GetOpponentIndex(playerIndex)

		if (not opponent or not match:GetZoneSlot("Active", opponent, 1)) then
			return false, "ce_expansion_beastbound_no_defending_beast"
		end

		return true
	end,

	IsLegal = function(match, playerIndex, params)
		local active = match:GetZoneSlot("Active", playerIndex, 1)

		if (not active) then
			return false, "ce_expansion_beastbound_no_active_beast"
		end

		-- The player going first does not get to attack on turn 1 in most games of this shape, but
		-- Beastbound has no such rule: only conditions and effects can stop an attack
		local prevented, condition = Beastbound.IsPreventedBy(match, active, "PreventsAttack")

		if (prevented) then
			return false, Beastbound.CONDITIONS[condition].Label
		end

		if (match:Query("CanAttack", { instance = active, player = playerIndex }, true) ~= true) then
			return false, "ce_expansion_beastbound_cannot_attack_now"
		end

		local attacks = Beastbound.GetAttacks(match, active)
		local attack = attacks[params.attack]

		if (not attack) then
			return false, "ce_expansion_beastbound_no_such_attack"
		end

		if (not Beastbound.CanPayAttackCost(match, active, attack)) then
			return false, "ce_expansion_beastbound_not_enough_energy"
		end

		local opponent = match:GetOpponentIndex(playerIndex)

		if (not opponent or not match:GetZoneSlot("Active", opponent, 1)) then
			return false, "ce_expansion_beastbound_no_defending_beast"
		end

		return true
	end,

	Perform = function(match, playerIndex, params)
		Beastbound.ResolveAttack(match, playerIndex, params.attack)
	end,
}

--- End your turn without attacking (§5).
Beastbound.Actions.EndTurn = {
	Phase = "Action",
	EndsTurn = true,
	InstantHandover = true,

	IsLegal = function(match, playerIndex, params)
		return true
	end,

	Perform = function(match, playerIndex, params)
		Beastbound.EndTurn(match, playerIndex)
	end,
}
