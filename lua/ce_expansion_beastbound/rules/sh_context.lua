--[[
	The card script context

	This is what a card's own code is handed, and it is deliberately the only thing it needs. A card
	file should read close to its printed rules text:

		-- "Flip a coin. If heads, the Defending Beast is now Burned."
		function(ctx)
			if (ctx:FlipCoin() == 1) then
				ctx:ApplyCondition(ctx.defender, "Burned")
			end
		end

	Everything here runs on the server inside the action's coroutine, so anything that asks the
	player a question simply blocks until they answer.
--]]

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- @class Beastbound.Context
--- @field match CardEngine.Match The match this is happening in
--- @field player number The seat playing the card or attacking
--- @field opponent number The seat opposite them
--- @field source CardEngine.MatchCardInstance The card being played, or the attacking Beast
--- @field attacker CardEngine.MatchCardInstance? The attacking Beast, when this is an attack
--- @field defender CardEngine.MatchCardInstance? The Beast being attacked
--- @field attack table? The attack being used, as printed on the card
--- @field attackIndex number? Which of the Beast's attacks it is
--- @field damage number? The damage this attack dealt, once it has
local CONTEXT = {}
CONTEXT.__index = CONTEXT

Beastbound.ContextMeta = CONTEXT

--- Builds the context a card script is run with
--- @param match CardEngine.Match
--- @param playerIndex number
--- @param source CardEngine.MatchCardInstance The card doing something
--- @param extra table? Anything else to put on the context, such as the defender
--- @return Beastbound.Context
function Beastbound.BuildContext(match, playerIndex, source, extra)
	local context = setmetatable({
		match = match,
		player = playerIndex,
		opponent = match:GetOpponentIndex(playerIndex),
		source = source,
	}, CONTEXT)

	for key, value in pairs(extra or {}) do
		context[key] = value
	end

	return context
end

--[[
	Chance
--]]

--- Flips one or more coins, and shows the player the result
--- @param count number? How many coins (default: 1)
--- @param label string? A language key saying what the flip is for
--- @return number heads # How many came up heads
--- @return number[] results # Each flip, where 1 is heads and 2 is tails
function CONTEXT:FlipCoin(count, label)
	return self.match:FlipCoin(count or 1, label, self.source)
end

--- Flips one coin and says whether it came up heads
--- @param label string? A language key saying what the flip is for
--- @return boolean
function CONTEXT:FlipHeads(label)
	return self:FlipCoin(1, label) == 1
end

--[[
	Finding Beasts
--]]

--- The Beasts the player has in play, the Active one first
--- @return CardEngine.MatchCardInstance[]
function CONTEXT:GetOwnBeasts()
	return Beastbound.GetBeastsInPlay(self.match, self.player)
end

--- The Beasts the opponent has in play, their Active one first
--- @return CardEngine.MatchCardInstance[]
function CONTEXT:GetOpponentBeasts()
	return Beastbound.GetBeastsInPlay(self.match, self.opponent)
end

--- The player's benched Beasts
--- @return CardEngine.MatchCardInstance[]
function CONTEXT:GetOwnBench()
	return self.match:GetZoneInstances("Bench", self.player)
end

--- The opponent's benched Beasts
--- @return CardEngine.MatchCardInstance[]
function CONTEXT:GetOpponentBench()
	return self.match:GetZoneInstances("Bench", self.opponent)
end

--- The player's Active Beast
--- @return CardEngine.MatchCardInstance?
function CONTEXT:GetOwnActive()
	return self.match:GetZoneSlot("Active", self.player, 1)
end

--- How many of the player's benched Beasts are of a type, which is what Abyssal Crush counts
--- @param beastType string
--- @return number
function CONTEXT:CountBenchOfType(beastType)
	local count = 0

	for _, instance in ipairs(self:GetOwnBench()) do
		if (self.match:GetInstanceAttribute(instance, "Type") == beastType) then
			count = count + 1
		end
	end

	return count
end

--[[
	Asking the player
--]]

--- Asks the player to pick from some Beasts or cards
--- @param candidates CardEngine.MatchCardInstance[] What they may pick from
--- @param promptKey string A language key asking the question
--- @param count number? How many to pick (default: 1)
--- @param optional boolean? Whether they may decline
--- @return CardEngine.MatchCardInstance|CardEngine.MatchCardInstance[]|nil
function CONTEXT:Choose(candidates, promptKey, count, optional)
	return self.match:PromptInstance(self.player, promptKey, candidates, count or 1, optional)
end

--- Asks the player to pick one of their own Beasts
--- @param promptKey string?
--- @return CardEngine.MatchCardInstance?
function CONTEXT:ChooseOwnBeast(promptKey)
	return self:Choose(self:GetOwnBeasts(), promptKey or "ce_expansion_beastbound_prompt_choose_own_beast", 1)
end

--- Asks the player to pick one of the opponent's benched Beasts
--- @param promptKey string?
--- @return CardEngine.MatchCardInstance?
function CONTEXT:ChooseOpponentBench(promptKey)
	return self:Choose(self:GetOpponentBench(),
		promptKey or "ce_expansion_beastbound_prompt_choose_opponent_bench", 1)
end

--- Asks the player a yes or no question
--- @param promptKey string
--- @return boolean
function CONTEXT:Confirm(promptKey)
	return self.match:PromptConfirm(self.player, promptKey)
end

--[[
	Damage and healing
--]]

--- Deals damage to a Beast, without weakness or resistance. Use this for the extra damage a card
--- deals beyond its attack, such as damage to a benched Beast or to itself.
--- @param target CardEngine.MatchCardInstance|number
--- @param amount number
--- @return number # The damage that landed
function CONTEXT:Damage(target, amount)
	return Beastbound.DealDamage(self.match, target, amount, {
		ignoreWeakness = true,
		reason = self.attack and self.attack.Name or nil,
	})
end

--- Deals damage to the attacking Beast itself, which several attacks do as a drawback
--- @param amount number
--- @return number
function CONTEXT:DamageSelf(amount)
	return self:Damage(self.source, amount)
end

--- Deals damage to every one of the opponent's benched Beasts
--- @param amount number
function CONTEXT:DamageOpponentBench(amount)
	for _, instance in ipairs(self:GetOpponentBench()) do
		self:Damage(instance, amount)
	end
end

--- Deals damage to every one of the player's own benched Beasts
--- @param amount number
function CONTEXT:DamageOwnBench(amount)
	for _, instance in ipairs(self:GetOwnBench()) do
		self:Damage(instance, amount)
	end
end

--- Heals damage off a Beast
--- @param target CardEngine.MatchCardInstance|number
--- @param amount number
--- @return number
function CONTEXT:Heal(target, amount)
	return Beastbound.Heal(self.match, target, amount)
end

--- Heals damage off the card doing this
--- @param amount number
--- @return number
function CONTEXT:HealSelf(amount)
	return self:Heal(self.source, amount)
end

--- Heals damage off every Beast the player has in play
--- @param amount number
function CONTEXT:HealOwnBeasts(amount)
	for _, instance in ipairs(self:GetOwnBeasts()) do
		self:Heal(instance, amount)
	end
end

--- The damage currently on a Beast
--- @param target CardEngine.MatchCardInstance|number
--- @return number
function CONTEXT:GetDamageOn(target)
	return Beastbound.GetDamage(self.match, target)
end

--[[
	Conditions
--]]

--- Puts a Special Condition on a Beast
--- @param target CardEngine.MatchCardInstance|number
--- @param condition string One of Paralyzed, Confused, Asleep, Poisoned, Burned
--- @return boolean
function CONTEXT:ApplyCondition(target, condition)
	return Beastbound.ApplyCondition(self.match, target, condition)
end

--- Whether a Beast is under a condition
--- @param target CardEngine.MatchCardInstance|number
--- @param condition string
--- @return boolean
function CONTEXT:HasCondition(target, condition)
	return Beastbound.HasCondition(self.match, target, condition)
end

--- Cures every Special Condition on a Beast
--- @param target CardEngine.MatchCardInstance|number
--- @return number
function CONTEXT:CureConditions(target)
	return Beastbound.CureAllConditions(self.match, target)
end

--- Moves every condition from one Beast to another
--- @param from CardEngine.MatchCardInstance|number
--- @param to CardEngine.MatchCardInstance|number
--- @return number
function CONTEXT:TransferConditions(from, to)
	return Beastbound.TransferConditions(self.match, from, to)
end

--[[
	Energy
--]]

--- How much energy is attached to a Beast, optionally only of one type
--- @param target CardEngine.MatchCardInstance|number
--- @param energyType string?
--- @return number
function CONTEXT:CountEnergy(target, energyType)
	return Beastbound.CountEnergy(self.match, target, energyType)
end

--- Discards energy from a Beast, asking the player which if there is a choice.
---
--- Several attacks offer this as an optional extra cost, so it returns whether it could be paid.
--- @param target CardEngine.MatchCardInstance|number
--- @param count number How much energy to discard
--- @param energyType string? Only energy of this type counts
--- @return boolean # Whether there was enough energy, and it was discarded
function CONTEXT:DiscardEnergy(target, count, energyType)
	local energy = Beastbound.GetAttachedEnergy(self.match, target, energyType)

	if (#energy < count) then
		return false
	end

	local chosen = self.match:PromptInstance(self.player,
		"ce_expansion_beastbound_prompt_discard_energy", energy, count)

	for _, instance in ipairs(self.match:AsInstanceList(chosen)) do
		if (instance) then
			CardEngine.Match.DetachCard(self.match, instance)
			CardEngine.Match.MoveCard(self.match, instance, "Discard", self.player, { keepAttached = true })
		end
	end

	return true
end

--- Attaches an energy card from somewhere to a Beast
--- @param energy CardEngine.MatchCardInstance|number
--- @param target CardEngine.MatchCardInstance|number
function CONTEXT:AttachEnergy(energy, target)
	CardEngine.Match.AttachCard(self.match, energy, target)
end

--[[
	Deck, hand and discard
--]]

--- Draws cards into the player's hand
--- @param count number
--- @return CardEngine.MatchCardInstance[] # The cards drawn, which may be fewer if the deck ran out
function CONTEXT:Draw(count)
	return CardEngine.Match.MoveTopCards(self.match, self.player, count, "Deck", "Hand")
end

--- Puts the top cards of the player's deck into the discard
--- @param count number
--- @return CardEngine.MatchCardInstance[]
function CONTEXT:DiscardTopOfDeck(count)
	return CardEngine.Match.MoveTopCards(self.match, self.player, count, "Deck", "Discard")
end

--- Asks the player to discard cards from their hand
--- @param count number
--- @param promptKey string?
--- @return number # How many were actually discarded
function CONTEXT:DiscardFromHand(count, promptKey)
	local hand = self.match:GetZoneInstances("Hand", self.player)

	if (#hand == 0) then
		return 0
	end

	local chosen = self.match:PromptInstance(self.player,
		promptKey or "ce_expansion_beastbound_prompt_discard_from_hand", hand, math.min(count, #hand))

	local discarded = 0

	for _, instance in ipairs(self.match:AsInstanceList(chosen)) do
		if (instance) then
			CardEngine.Match.MoveCard(self.match, instance, "Discard", self.player)
			discarded = discarded + 1
		end
	end

	return discarded
end

--- The player's deck, in order
--- @return CardEngine.MatchCardInstance[]
function CONTEXT:GetDeck()
	return self.match:GetZoneInstances("Deck", self.player)
end

--- Shuffles the player's deck
function CONTEXT:ShuffleDeck()
	CardEngine.Match.ShuffleZone(self.match, "Deck", self.player)
end

--- Searches the player's deck for cards matching some attributes and lets them pick.
---
--- The deck is a hidden zone, so the prompt is shown only to the player searching it: the opponent
--- is told a search happened, never what was in there.
--- @param attributes table<string, any>? What the card has to be, e.g. { Supertype = "Energy" }
--- @param count number? How many to find (default: 1)
--- @param promptKey string?
--- @return CardEngine.MatchCardInstance[] # What they picked
function CONTEXT:SearchDeck(attributes, count, promptKey)
	local candidates = CardEngine.Match.FindInZone(self.match, "Deck", self.player, attributes)

	if (#candidates == 0) then
		return {}
	end

	local chosen = self.match:PromptInstance(self.player,
		promptKey or "ce_expansion_beastbound_prompt_search_deck", candidates, count or 1, true)

	local found = {}

	for _, instance in ipairs(self.match:AsInstanceList(chosen)) do
		if (instance) then
			table.insert(found, instance)
		end
	end

	return found
end

--- Puts cards on the bottom of the player's deck, in an order they choose
--- @param instances CardEngine.MatchCardInstance[]
--- @param promptKey string?
function CONTEXT:PutOnBottomOfDeck(instances, promptKey)
	if (#instances == 0) then
		return
	end

	local order = self.match:PromptOrder(self.player,
		promptKey or "ce_expansion_beastbound_prompt_order_bottom", instances)

	-- The first card named goes down first, so it ends up deepest
	for _, instanceID in ipairs(order) do
		CardEngine.Match.MoveCard(self.match, instanceID, "Deck", self.player, {
			toBottom = true,
			faceDown = true,
		})
	end
end

--- Moves a card to a zone, for the rare card that needs to do it by hand
--- @param instance CardEngine.MatchCardInstance|number
--- @param zoneKey string
--- @param options table?
function CONTEXT:MoveCard(instance, zoneKey, options)
	CardEngine.Match.MoveCard(self.match, instance, zoneKey, self.player, options)
end

--[[
	Lasting effects
--]]

--- Puts an effect in force until the end of the opponent's next turn, which is how almost every
--- "during your opponent's next turn" card is written.
--- @param effectName string The registered effect to apply
--- @param args table? Arguments for it, such as how much damage it holds back
--- @param target CardEngine.MatchCardInstance|number|nil What it applies to (default: the source)
--- @return CardEngine.MatchEffect?
function CONTEXT:AddEffectUntilOpponentTurnEnds(effectName, args, target)
	local instance = self.match:ResolveInstance(target or self.source)

	return self.match:AddEffect({
		name = effectName,
		args = args,
		source = self.source and self.source.id or nil,
		target = instance and instance.id or nil,
		expiry = { Event = "TurnEnd", Player = self.opponent },
	})
end

--- Puts an effect in force until the end of the player's own next turn, for the cards that hold
--- themselves back rather than the opponent
--- @param effectName string
--- @param args table?
--- @param target CardEngine.MatchCardInstance|number|nil
--- @return CardEngine.MatchEffect?
function CONTEXT:AddEffectUntilOwnTurnEnds(effectName, args, target)
	local instance = self.match:ResolveInstance(target or self.source)

	return self.match:AddEffect({
		name = effectName,
		args = args,
		source = self.source and self.source.id or nil,
		target = instance and instance.id or nil,
		expiry = { Event = "TurnEnd", Player = self.player },
	})
end

--- Puts an effect in force for as long as the card stays where it is, which is what equipment wants
--- @param effectName string
--- @param args table?
--- @param target CardEngine.MatchCardInstance|number
--- @return CardEngine.MatchEffect?
function CONTEXT:AddLastingEffect(effectName, args, target)
	local instance = self.match:ResolveInstance(target)

	return self.match:AddEffect({
		name = effectName,
		args = args,
		source = self.source and self.source.id or nil,
		target = instance and instance.id or nil,
	})
end

--[[
	Odds and ends
--]]

--- Writes a line in the match log
--- @param languageKey string
--- @param params table?
function CONTEXT:Log(languageKey, params)
	self.match:AddLogMessage(languageKey, params)
end

--- The card definition of an instance
--- @param instance CardEngine.MatchCardInstance|number
--- @return CardEngine.Card?
function CONTEXT:GetCard(instance)
	return self.match:GetInstanceCard(instance)
end
