-- Setup, turn structure, attacks, evolution and win conditions, following game-rules.md §4 to §7.
-- Per-card effects live in the card files, in CARD.GameRules.

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- Whether a card in hand may be used to evolve a Beast in play
--- @param match CardEngine.Match
--- @param card CardEngine.Card? The card being played, or nil if the viewer cannot see it
--- @param target CardEngine.MatchCardInstance The Beast being evolved
--- @return boolean legal
--- @return string? reason
function Beastbound.CanEvolve(match, card, target)
	-- The client can't see an opponent's hand, so it can't rule this out; the server can
	if (not card) then
		return true
	end

	if (not Beastbound.IsBeast(card)) then
		return false, "ce_expansion_beastbound_not_beast"
	end

	local evolvesFrom = card:GetAttribute("EvolvesFrom")

	if (not evolvesFrom) then
		return false, "ce_expansion_beastbound_does_not_evolve"
	end

	local targetCard = match:GetInstanceCard(target)

	if (targetCard and targetCard:GetUniqueID() ~= evolvesFrom) then
		return false, "ce_expansion_beastbound_wrong_evolution"
	end

	-- Umbramaw is a hidden evolution: the Legendary Corrupter is the only way to put it into play
	if (card:GetAttribute("EvolvesWith")) then
		return false, "ce_expansion_beastbound_hidden_evolution"
	end

	if (match:GetInstanceState(target, "playedOnTurn") == match:GetTurn()) then
		return false, "ce_expansion_beastbound_played_this_turn"
	end

	if (match:GetInstanceState(target, "evolvedOnTurn") == match:GetTurn()) then
		return false, "ce_expansion_beastbound_already_evolved"
	end

	return true
end

--- Evolves a Beast by putting the next stage on top. StackCard carries energy, equipment and damage
--- up to the new stage; conditions are shaken off.
--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number The card from hand
--- @param targetOrID CardEngine.MatchCardInstance|number The Beast in play
--- @return boolean
function Beastbound.Evolve(match, instanceOrID, targetOrID)
	local instance = match:ResolveInstance(instanceOrID)
	local target = match:ResolveInstance(targetOrID)

	if (not instance or not target) then
		return false
	end

	local playerIndex = target.controller

	Beastbound.CureAllConditions(match, target)

	if (not CardEngine.Match.StackCard(match, instance, target)) then
		return false
	end

	CardEngine.Match.SetInstanceState(match, instance, "evolvedOnTurn", match:GetTurn())
	CardEngine.Match.SetInstanceState(match, instance, "playedOnTurn", nil)

	match:AddLogMessage("ce_expansion_beastbound_log_evolved", {
		player = match:GetPlayer(playerIndex).name,
		card = match:GetInstanceCard(instance):GetName(),
	})

	Beastbound.RunCardScript(match, match:GetInstanceCard(instance), "OnEvolve",
		Beastbound.BuildContext(match, playerIndex, instance))

	return true
end

--- Carries out an attack: the confusion check, the damage, then whatever the attack itself does.
--- Attacking ends the turn, whatever happens.
--- @param match CardEngine.Match
--- @param playerIndex number
--- @param attackIndex number
function Beastbound.ResolveAttack(match, playerIndex, attackIndex)
	local attacker = match:GetZoneSlot("Active", playerIndex, 1)
	local opponent = match:GetOpponentIndex(playerIndex)
	local defender = opponent and match:GetZoneSlot("Active", opponent, 1)

	if (not attacker or not defender) then
		Beastbound.EndTurn(match, playerIndex)
		return
	end

	local attacks = Beastbound.GetAttacks(match, attacker)
	local attack = attacks[attackIndex]
	local card = match:GetInstanceCard(attacker)

	match:AddLogMessage("ce_expansion_beastbound_log_attacked", {
		player = match:GetPlayer(playerIndex).name,
		card = card:GetName(),
		attack = attack.Name,
	})

	-- Confusion is checked first: on tails the attack does nothing and the attacker hurts itself (§6)
	if (Beastbound.HasCondition(match, attacker, "Confused")) then
		if (match:FlipCoin(1, "ce_expansion_beastbound_flip_confusion", attacker) ~= 1) then
			Beastbound.DealDamage(match, attacker, 20, {
				ignoreWeakness = true,
				reason = "ce_expansion_beastbound_condition_confused",
			})

			Beastbound.CheckKnockOuts(match)
			Beastbound.EndTurn(match, playerIndex)

			return
		end
	end

	local context = Beastbound.BuildContext(match, playerIndex, attacker, {
		attacker = attacker,
		defender = defender,
		attack = attack,
		attackIndex = attackIndex,
	})

	local entry = card and card.GameRules and card.GameRules.Attacks and card.GameRules.Attacks[attackIndex]
	local damage = attack.Damage or 0

	-- An attack whose damage depends on something says so with ModifyDamage, which runs before the
	-- damage lands. Everything else is an effect that happens after it.
	if (istable(entry) and isfunction(entry.ModifyDamage)) then
		damage = entry.ModifyDamage(context, damage) or 0
	end

	damage = match:Query("OutgoingDamage", {
		instance = attacker,
		player = playerIndex,
		defender = defender,
	}, damage)

	if (damage > 0) then
		context.damage = Beastbound.DealDamage(match, defender, damage, {
			attacker = attacker,
			isAttack = true,
			reason = attack.Name,
		})
	else
		context.damage = 0
	end

	local onResolve = isfunction(entry) and entry or (istable(entry) and entry.OnResolve)

	-- A defender can be shielded from what an attack does but not its damage (Genitron's Djinn Ward)
	local effectsApply = match:Query("AttackEffectsApply", {
		match = match,
		instance = defender,
		player = defender.controller,
		attacker = attacker,
	}, true)

	if (isfunction(onResolve) and effectsApply ~= false) then
		onResolve(context)
	end

	Beastbound.CheckKnockOuts(match)
	Beastbound.EndTurn(match, playerIndex)
end

--- Ends a player's turn: resolves the Between Turns step, then hands over.
--- @param match CardEngine.Match
--- @param playerIndex number
function Beastbound.EndTurn(match, playerIndex)
	if (match:IsFinished()) then
		return
	end

	-- The turn plays out on the board before anything between turns happens
	match:Beat()

	-- Between turns, Poison and Burn do their damage to whoever is out front (§5.4)
	CardEngine.Match.SetPhase(match, "BetweenTurns")

	for index = 1, match:GetPlayerCount() do
		local active = match:GetZoneSlot("Active", index, 1)

		if (active) then
			Beastbound.ResolveBetweenTurnsDamage(match, active)
		end
	end

	Beastbound.CheckKnockOuts(match)

	if (match:IsFinished()) then
		return
	end

	CardEngine.Match.AdvanceTurn(match)
end

--- Clears the once-per-turn limits and draws the turn's card
--- @param match CardEngine.Match
--- @param playerIndex number
function Beastbound.StartTurn(match, playerIndex)
	CardEngine.Match.SetPlayerState(match, playerIndex, "attachedEnergy", false)
	CardEngine.Match.SetPlayerState(match, playerIndex, "playedSupporter", false)
	CardEngine.Match.SetPlayerState(match, playerIndex, "retreated", false)

	local active = match:GetZoneSlot("Active", playerIndex, 1)

	if (active) then
		Beastbound.ResolveTurnStartRecovery(match, active)
	end

	-- The player going first skips their draw on turn 1 (§5.1)
	local isFirstTurn = match:GetTurn() == 1

	if (not isFirstTurn) then
		local drawn = CardEngine.Match.MoveTopCards(match, playerIndex, 1, "Deck", "Hand")

		-- Being made to draw from an empty deck loses you the match (§7), which CheckGameOver
		-- notices by way of this flag
		if (#drawn == 0) then
			CardEngine.Match.SetPlayerState(match, playerIndex, "deckedOut", true)
		end
	end

	CardEngine.Match.SetPhase(match, "Action")
end

--[[
	Setup (§4)
--]]

--- Deals a player an opening hand, mulliganing until they have a Basic Beast. The mulligan count is
--- returned, since each lets the opponent draw an extra card.
--- @param match CardEngine.Match
--- @param playerIndex number
--- @return number # How many times they had to mulligan
local function dealOpeningHand(match, playerIndex)
	local mulligans = 0

	while (true) do
		CardEngine.Match.MoveTopCards(match, playerIndex, Beastbound.OPENING_HAND_SIZE, "Deck", "Hand")

		local hasBasic = false

		for _, instance in ipairs(match:GetZoneInstances("Hand", playerIndex)) do
			if (Beastbound.IsBasicBeast(match:GetInstanceCard(instance))) then
				hasBasic = true
				break
			end
		end

		if (hasBasic) then
			break
		end

		-- No Basic Beast means no way to start, so the hand goes back
		for _, instance in ipairs(match:GetZoneInstances("Hand", playerIndex)) do
			CardEngine.Match.MoveCard(match, instance, "Deck", playerIndex, { faceDown = true })
		end

		CardEngine.Match.ShuffleZone(match, "Deck", playerIndex)

		mulligans = mulligans + 1

		match:AddEvent({
			type = "beastbound_mulligan",
			player = playerIndex,
			count = mulligans,
		})

		-- Guards against a future card pool that would loop forever; an odd hand beats a match that never starts
		if (mulligans >= 10) then
			break
		end
	end

	return mulligans
end

--- Deals the opening state: hands, Active Beasts, benches and prizes (§4)
--- @param match CardEngine.Match
function Beastbound.SetupMatch(match)
	local playerCount = match:GetPlayerCount()
	local mulligans = {}

	for playerIndex = 1, playerCount do
		mulligans[playerIndex] = dealOpeningHand(match, playerIndex)
	end

	-- Every mulligan lets each opponent draw one extra card (§4.1)
	for playerIndex = 1, playerCount do
		local extra = 0

		for otherIndex = 1, playerCount do
			if (otherIndex ~= playerIndex) then
				extra = extra + mulligans[otherIndex]
			end
		end

		if (extra > 0) then
			CardEngine.Match.MoveTopCards(match, playerIndex, extra, "Deck", "Hand")
		end
	end

	-- Each player picks an Active Beast, then as many benched Beasts as they like (§4.2)
	for playerIndex = 1, playerCount do
		local basics = {}

		for _, instance in ipairs(match:GetZoneInstances("Hand", playerIndex)) do
			if (Beastbound.IsBasicBeast(match:GetInstanceCard(instance))) then
				table.insert(basics, instance)
			end
		end

		local active = match:PromptInstance(playerIndex,
			"ce_expansion_beastbound_prompt_choose_active", basics, 1)

		if (active) then
			CardEngine.Match.MoveCard(match, active, "Active", playerIndex, { slot = 1, faceDown = true })
			CardEngine.Match.SetInstanceState(match, active, "playedOnTurn", 0)
		end

		local remaining = {}

		for _, instance in ipairs(basics) do
			if (instance.zone == "Hand") then
				table.insert(remaining, instance)
			end
		end

		if (#remaining > 0) then
			local benched = match:PromptInstance(playerIndex,
				"ce_expansion_beastbound_prompt_choose_bench",
				remaining, math.min(#remaining, Beastbound.MAX_BENCH), true)

			for _, instance in ipairs(match:AsInstanceList(benched)) do
				if (match:HasZoneSpace("Bench", playerIndex)) then
					CardEngine.Match.MoveCard(match, instance, "Bench", playerIndex, { faceDown = true })
					CardEngine.Match.SetInstanceState(match, instance, "playedOnTurn", 0)
				end
			end
		end

		-- Six prize cards off the top (§4.3)
		for _ = 1, Beastbound.PRIZE_COUNT do
			local deck = match:GetZoneEntries("Deck", playerIndex)
			local topID = deck[#deck]

			if (not topID) then
				break
			end

			CardEngine.Match.MoveCard(match, topID, "Prizes", playerIndex, { faceDown = true })
		end
	end

	-- Both sides turn over at once (§4.4)
	for playerIndex = 1, playerCount do
		for _, zoneKey in ipairs({ "Active", "Bench" }) do
			for _, instance in ipairs(match:GetZoneInstances(zoneKey, playerIndex)) do
				instance.faceDown = false
			end
		end
	end

	match:AddEvent({ type = "beastbound_setup_revealed" })

	match.turn = 1
	match.activePlayer = match:Random(1, playerCount)

	match:AddEvent({
		type = "turn_started",
		player = match.activePlayer,
		turn = 1,
		phase = "Action",
	})

	Beastbound.StartTurn(match, match.activePlayer)
end

--- Works out whether anybody has won. All three conditions of §7 are about something happening to a
--- player, so this looks for a player who has lost and declares their opponent the winner.
--- @param match CardEngine.Match
--- @return number? winner
--- @return string? reason
function Beastbound.CheckGameOver(match)
	-- Nothing is decided until the opening state has been dealt
	if (match:GetTurn() < 1) then
		return nil, nil
	end

	for playerIndex = 1, match:GetPlayerCount() do
		local opponent = match:GetOpponentIndex(playerIndex)

		-- Taken all six prizes
		if (match:CountZone("Prizes", playerIndex) == 0) then
			return playerIndex, "ce_expansion_beastbound_win_prizes"
		end

		-- No Beasts left in play, and none to bring out
		if (not match:GetZoneSlot("Active", playerIndex, 1)
				and #match:GetZoneInstances("Bench", playerIndex) == 0) then
			return opponent, "ce_expansion_beastbound_win_no_beasts"
		end

		-- Had to draw with an empty deck
		if (match:GetPlayerState(playerIndex, "deckedOut")) then
			return opponent, "ce_expansion_beastbound_win_decked_out"
		end
	end

	return nil, nil
end

--- Registers the rules with Card Engine. Called from sh_init.lua once every file in rules/ has loaded.
function Beastbound.RegisterGameRules()
	CardEngine.GameRules.Register({
		ExpansionSet = Beastbound.EXPANSION_SET_ID,
		Name = "ce_expansion_beastbound_game_name",

		MinPlayers = 2,
		MaxPlayers = 2,

		Zones = {
			Deck = {
				Label = "ce_expansion_beastbound_zone_deck",
				PerPlayer = true,
				Ordered = true,
				Visibility = CardEngine.VISIBILITY_NONE,
			},
			Hand = {
				Label = "ce_expansion_beastbound_zone_hand",
				PerPlayer = true,
				Visibility = CardEngine.VISIBILITY_OWNER,
			},
			Discard = {
				Label = "ce_expansion_beastbound_zone_discard",
				PerPlayer = true,
				Ordered = true,
				Visibility = CardEngine.VISIBILITY_ALL,
			},
			Prizes = {
				Label = "ce_expansion_beastbound_zone_prizes",
				PerPlayer = true,
				Visibility = CardEngine.VISIBILITY_NONE,
			},
			Active = {
				Label = "ce_expansion_beastbound_zone_active",
				PerPlayer = true,
				Visibility = CardEngine.VISIBILITY_ALL,
				Slots = 1,
			},
			Bench = {
				Label = "ce_expansion_beastbound_zone_bench",
				PerPlayer = true,
				Visibility = CardEngine.VISIBILITY_ALL,
				Slots = 5,
			},
		},

		DeckZone = "Deck",

		Phases = { "Action", "BetweenTurns" },

		Actions = Beastbound.Actions,

		SetupMatch = Beastbound.SetupMatch,
		StartTurn = Beastbound.StartTurn,
		CheckGameOver = Beastbound.CheckGameOver,
	})
end
