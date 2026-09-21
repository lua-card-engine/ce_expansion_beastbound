--[[
	Beastbound's rules checks

	Run with `card_engine_match_selftest` in the server console.

	These follow game-rules.md section by section, so a rule that changes in the document and a rule
	that changes in the code should both end up here. Anything that can be checked without a match
	is; the rest builds one with a fixed seed and drives it.
--]]

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- @return table
local function buildTestDeck()
	return Beastbound.BuildStarterDeck("selftest_deck")
end

--- Starts a two-player match between two copies of that deck
--- @param context CardEngine.MatchTestContext
--- @return CardEngine.Match?
local function startTestMatch(context)
	return context:StartMatch(Beastbound.EXPANSION_SET_ID, { buildTestDeck(), buildTestDeck() })
end

CardEngine.MatchTest.Register(Beastbound.EXPANSION_SET_ID, {
	--[[
		§2 Damage
	--]]

	{
		name = "damage applies weakness, then resistance, in that order",
		run = function(context)
			local calc = Beastbound.CalculateDamage

			context:Equal("plain damage is unchanged", (calc(30, "Fire", "Fire")), 30)
			context:Equal("Nature is weak to Fire, so it doubles", (calc(30, "Fire", "Nature")), 60)
			context:Equal("Electric resists Fire, so it loses 20", (calc(30, "Fire", "Electric")), 10)
			context:Equal("a resisted hit floors at zero", (calc(10, "Fire", "Electric")), 0)
			context:Equal("an attack that does nothing stays at nothing", (calc(0, "Fire", "Nature")), 0)

			-- Nothing in this set is both weak to and resistant to the same type, so the ordering
			-- cannot be seen from the real chart. Bend it briefly to prove it is still right.
			local realResistance = Beastbound.RESISTANCE.Nature
			Beastbound.RESISTANCE.Nature = "Fire"

			context:Equal("doubled first, then reduced", (calc(30, "Fire", "Nature")), 40)

			Beastbound.RESISTANCE.Nature = realResistance
		end,
	},

	{
		name = "the type chart is complete and reciprocal",
		run = function(context)
			for _, beastType in ipairs(Beastbound.TYPES) do
				local weakness = Beastbound.WEAKNESS[beastType]
				local resistance = Beastbound.RESISTANCE[beastType]

				context:Check(beastType .. " has a weakness", weakness ~= nil)
				context:Check(beastType .. " has a resistance", resistance ~= nil)
				context:Equal(beastType .. " resistance is reciprocal",
					Beastbound.RESISTANCE[resistance], beastType)
				context:Check(beastType .. " is not both weak to and resistant to one type",
					weakness ~= resistance)
			end
		end,
	},

	--[[
		§4 Setup
	--]]

	{
		name = "a match deals hands, Active Beasts and six prizes",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			for playerIndex = 1, 2 do
				local label = "seat " .. playerIndex .. " "
				local active = match:GetZoneSlot("Active", playerIndex, 1)

				context:Equal(label .. "has six prizes", match:CountZone("Prizes", playerIndex), 6)
				context:Check(label .. "has an Active Beast", active ~= nil)
				context:Check(label .. "has cards in hand", match:CountZone("Hand", playerIndex) > 0)

				if (active) then
					context:Check(label .. "started with a Basic Beast",
						Beastbound.IsBasicBeast(match:GetInstanceCard(active)))
					context:Equal(label .. "Active Beast was revealed", active.faceDown, false)
				end

				local total = 0

				for _, zoneKey in ipairs({ "Deck", "Hand", "Prizes", "Active", "Bench", "Discard" }) do
					total = total + match:CountZone(zoneKey, playerIndex)
				end

				context:Equal(label .. "still has all 60 cards", total, 60)
			end

			context:Equal("the match is on turn 1", match:GetTurn(), 1)
		end,
	},

	--[[
		§5 Per-turn limits
	--]]

	{
		name = "energy can only be attached once a turn",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local active = match:GetZoneSlot("Active", playerIndex, 1)

			local first = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_fire_energy", playerIndex, "Hand")

			context:Check("the first attach is allowed",
				CardEngine.Match.PerformAction(match, playerIndex, "AttachEnergy",
					{ card = first.id, target = active.id }))

			context:AnswerPrompts(match)

			context:Equal("the energy is on the Beast", Beastbound.CountEnergy(match, active), 1)

			local second = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_fire_energy", playerIndex, "Hand")

			local legal, reason = CardEngine.Match.CanPerformAction(match, playerIndex, "AttachEnergy",
				{ card = second.id, target = active.id })

			context:Equal("the second attach is refused", legal, false)
			context:Equal("and says why", reason, "ce_expansion_beastbound_already_attached_energy")
		end,
	},

	{
		name = "a Beast cannot evolve the turn it was played",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local basic = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_pyrecko", playerIndex, "Hand")

			CardEngine.Match.PerformAction(match, playerIndex, "PlayBasic", { card = basic.id })
			context:AnswerPrompts(match)

			context:Equal("it went to the bench", basic.zone, "Bench")

			local evolution = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_emberaz", playerIndex, "Hand")

			local legal, reason = CardEngine.Match.CanPerformAction(match, playerIndex, "Evolve",
				{ card = evolution.id, target = basic.id })

			context:Equal("evolving it the same turn is refused", legal, false)
			context:Equal("and says why", reason, "ce_expansion_beastbound_played_this_turn")
		end,
	},

	{
		name = "Umbramaw can only be put into play by the Legendary Corrupter",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()

			local luxpaws = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_luxpaws", playerIndex, "Bench")
			CardEngine.Match.SetInstanceState(match, luxpaws, "playedOnTurn", 0)

			local umbramaw = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_umbramaw", playerIndex, "Hand")

			local legal, reason = CardEngine.Match.CanPerformAction(match, playerIndex, "Evolve",
				{ card = umbramaw.id, target = luxpaws.id })

			context:Equal("the normal evolve action refuses it", legal, false)
			context:Equal("because it is a hidden evolution", reason,
				"ce_expansion_beastbound_hidden_evolution")
		end,
	},

	{
		name = "evolution carries energy and damage up to the new stage",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()

			local basic = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_pyrecko", playerIndex, "Bench")
			CardEngine.Match.SetInstanceState(match, basic, "playedOnTurn", 0)

			local energy = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_fire_energy", playerIndex, "Hand")
			CardEngine.Match.AttachCard(match, energy, basic)
			CardEngine.Match.AddCounter(match, basic, Beastbound.DAMAGE_COUNTER, 20)

			local evolution = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_emberaz", playerIndex, "Hand")

			context:Run(match, function()
				Beastbound.Evolve(match, evolution, basic)
			end)

			context:Equal("the new stage is in play", evolution.zone, "Bench")
			context:Equal("the energy came with it", Beastbound.CountEnergy(match, evolution), 1)
			context:Equal("so did the damage", Beastbound.GetDamage(match, evolution), 20)
			context:Check("the old stage is underneath it",
				table.HasValue(evolution.beneath, basic.id))
		end,
	},

	--[[
		The action bar
	--]]

	{
		name = "a player holding Energy is offered the button to attach it",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()

			-- Whatever the deal gave them, they are holding one Energy card
			CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_fire_energy", playerIndex, "Hand")

			-- Two cards go into this: the Energy and the Beast it goes onto. Asking IsLegal with
			-- neither of them is what used to leave every button on the bar permanently greyed out.
			local available, reason = match:CanStartAction(playerIndex, "AttachEnergy", 2)

			context:Check("the button is offered", available, tostring(reason))

			local active = match:GetZoneSlot("Active", playerIndex, 1)
			local energy = match:GetZoneInstances("Hand", playerIndex)

			local held

			for _, instance in ipairs(energy) do
				if (Beastbound.IsEnergy(match:GetInstanceCard(instance))) then
					held = instance
					break
				end
			end

			context:Run(match, function()
				Beastbound.Actions.AttachEnergy.Perform(match, playerIndex, {
					card = held.id,
					target = active.id,
				})
			end)

			context:Equal("and it lands on the Beast", held.zone, active.zone)

			-- Once per turn, so now the button says why not rather than going quiet
			local againAvailable, againReason = match:CanStartAction(playerIndex, "AttachEnergy", 2)

			context:Equal("a second attach is not offered", againAvailable, false)
			context:Equal("and it says why", againReason,
				"ce_expansion_beastbound_already_attached_energy")
		end,
	},

	{
		name = "every action on the bar can be offered to somebody, somewhere",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			-- An action that can never be offered is a button a player can never press. Each one here
			-- either judges itself without a card, or says outright that it needs one.
			for actionName, action in pairs(match:GetRules().Actions) do
				local judgedWithoutCards = (action.IsLegal(match, match:GetActivePlayerIndex(), {})) == true

				context:Check(actionName .. " can be reached",
					judgedWithoutCards or isfunction(action.IsAvailable),
					"it refuses an empty play and has no IsAvailable, so its button would never light up")
			end
		end,
	},

	--[[
		§5 Retreating
	--]]

	{
		name = "retreating discards the energy it costs",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local opening = match:GetZoneSlot("Active", playerIndex, 1)

			-- A Beast that costs something to retreat, rather than whichever one the shuffle happened
			-- to open with
			if (opening) then
				CardEngine.Match.MoveCard(match, opening, "Discard", playerIndex)
			end

			local active = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_turtling", playerIndex, "Active", 1)
			CardEngine.Match.SetInstanceState(match, active, "playedOnTurn", 0)

			-- Somewhere to retreat to, since the opening hand is answered by taking the first Basic
			-- Beast offered and benching nothing
			local benched = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_starkrat", playerIndex, "Bench")
			CardEngine.Match.SetInstanceState(match, benched, "playedOnTurn", 0)

			local cost = Beastbound.GetRetreatCost(match, active)

			context:Equal("a Basic Beast costs one energy to retreat", cost, 1)

			local energy = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_fire_energy", playerIndex, "Hand")
			CardEngine.Match.AttachCard(match, energy, active)

			context:Run(match, function()
				Beastbound.Actions.Retreat.Perform(match, playerIndex, { target = benched.id })
			end)

			-- A cost of exactly one is answered with the instance itself rather than a list of them,
			-- which is the shape that used to be read as an empty list and retreat for free
			context:Equal("the energy it cost went to the discard", energy.zone, "Discard")
			context:Equal("nothing is left attached to it",
				Beastbound.CountEnergy(match, active), 0)
			context:Equal("the benched Beast came out",
				match:GetZoneSlot("Active", playerIndex, 1), benched)
		end,
	},

	{
		name = "a retreating Beast keeps its remaining energy and does not crowd the bench",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local opening = match:GetZoneSlot("Active", playerIndex, 1)

			if (opening) then
				CardEngine.Match.MoveCard(match, opening, "Discard", playerIndex)
			end

			local active = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_turtling", playerIndex, "Active", 1)
			CardEngine.Match.SetInstanceState(match, active, "playedOnTurn", 0)

			local benched = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_starkrat", playerIndex, "Bench")
			CardEngine.Match.SetInstanceState(match, benched, "playedOnTurn", 0)

			for _ = 1, 3 do
				local energy = CardEngine.Match.CreateInstance(match,
					"ce_expansion_beastbound_fire_energy", playerIndex, "Hand")
				CardEngine.Match.AttachCard(match, energy, active)
			end

			local benchBefore = #match:GetZoneInstances("Bench", playerIndex)

			context:Run(match, function()
				Beastbound.Actions.Retreat.Perform(match, playerIndex, { target = benched.id })
			end)

			-- One energy paid the cost of one; the other two are still the retreated Beast's
			context:Equal("the energy left over stays attached", Beastbound.CountEnergy(match, active), 2)
			context:Equal("the retreated Beast is on the bench", active.zone, "Bench")

			for _, attached in ipairs(match:GetAttached(active)) do
				context:Equal("attached energy follows its Beast to the bench", attached.zone, "Bench")
			end

			-- Energy is not a Beast, so it must not take a bench slot of its own
			context:Equal("the bench holds the same number of cards",
				#match:GetZoneInstances("Bench", playerIndex), benchBefore)
		end,
	},

	--[[
		§5 Knock Outs
	--]]

	{
		name = "a Knock Out discards everything attached and awards one prize",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local opponent = match:GetOpponentIndex(playerIndex)
			local victim = match:GetZoneSlot("Active", opponent, 1)

			local energy = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_fire_energy", opponent, "Hand")
			CardEngine.Match.AttachCard(match, energy, victim)

			-- Something to promote, so the match does not simply end instead, and nothing else on the
			-- bench for it to be promoted ahead of
			for _, instance in ipairs(match:GetZoneInstances("Bench", opponent)) do
				CardEngine.Match.MoveCard(match, instance, "Discard", opponent)
			end

			local spare = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_turtling", opponent, "Bench")
			CardEngine.Match.SetInstanceState(match, spare, "playedOnTurn", 0)

			context:Run(match, function()
				Beastbound.DealDamage(match, victim, 9999, { ignoreWeakness = true })
				Beastbound.CheckKnockOuts(match)
			end)

			context:Equal("the Beast went to the discard", victim.zone, "Discard")
			context:Equal("its energy went with it", energy.zone, "Discard")
			context:Equal("the attacker took exactly one prize",
				match:CountZone("Prizes", playerIndex), 5)
			context:Equal("a benched Beast was promoted",
				match:GetZoneSlot("Active", opponent, 1), spare)
		end,
	},

	--[[
		§6 Special Conditions
	--]]

	{
		name = "Poison and Burn sit alongside one other condition",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local active = match:GetZoneSlot("Active", playerIndex, 1)

			Beastbound.ApplyCondition(match, active, "Asleep")
			Beastbound.ApplyCondition(match, active, "Poisoned")
			Beastbound.ApplyCondition(match, active, "Burned")

			context:Check("it is asleep", Beastbound.HasCondition(match, active, "Asleep"))
			context:Check("and poisoned", Beastbound.HasCondition(match, active, "Poisoned"))
			context:Check("and burned", Beastbound.HasCondition(match, active, "Burned"))

			Beastbound.ApplyCondition(match, active, "Confused")

			context:Check("confusion replaced sleep",
				not Beastbound.HasCondition(match, active, "Asleep"))
			context:Check("but poison stayed",
				Beastbound.HasCondition(match, active, "Poisoned"))
		end,
	},

	{
		name = "Poison deals 10 damage between turns and lasts until cured",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local active = match:GetZoneSlot("Active", playerIndex, 1)

			Beastbound.ApplyCondition(match, active, "Poisoned")

			local before = Beastbound.GetDamage(match, active)

			context:Run(match, function()
				Beastbound.ResolveBetweenTurnsDamage(match, active)
			end)

			context:Equal("it took 10 damage", Beastbound.GetDamage(match, active) - before, 10)
			context:Check("and is still poisoned", Beastbound.HasCondition(match, active, "Poisoned"))
		end,
	},

	{
		name = "Paralysis and Sleep stop a Beast attacking and retreating",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local active = match:GetZoneSlot("Active", playerIndex, 1)

			Beastbound.ApplyCondition(match, active, "Paralyzed")
			context:Check("paralysis stops an attack",
				(Beastbound.IsPreventedBy(match, active, "PreventsAttack")))
			context:Check("paralysis stops a retreat",
				(Beastbound.IsPreventedBy(match, active, "PreventsRetreat")))

			Beastbound.CureAllConditions(match, active)
			Beastbound.ApplyCondition(match, active, "Asleep")
			context:Check("sleep stops an attack",
				(Beastbound.IsPreventedBy(match, active, "PreventsAttack")))
		end,
	},

	{
		name = "a benched Beast cannot be given a condition",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local benched = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_turtling", playerIndex, "Bench")

			context:Equal("nothing happens",
				Beastbound.ApplyCondition(match, benched, "Burned"), false)
		end,
	},

	--[[
		§5 Attacking
	--]]

	{
		name = "an attack is paid for in the Beast's own type",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local active = match:GetZoneSlot("Active", playerIndex, 1)

			-- A known Beast out front, so this does not depend on the shuffle
			CardEngine.Match.MoveCard(match, active, "Discard", playerIndex)

			local pyrecko = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_pyrecko", playerIndex, "Active", 1)

			local legal, reason = CardEngine.Match.CanPerformAction(match, playerIndex, "Attack",
				{ attack = 1 })

			context:Equal("with no energy it cannot attack", legal, false)
			context:Equal("and says why", reason, "ce_expansion_beastbound_not_enough_energy")

			local wrong = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_nature_energy", playerIndex, "Hand")
			CardEngine.Match.AttachCard(match, wrong, pyrecko)

			context:Equal("energy of the wrong type does not pay for it",
				(CardEngine.Match.CanPerformAction(match, playerIndex, "Attack", { attack = 1 })), false)

			local right = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_fire_energy", playerIndex, "Hand")
			CardEngine.Match.AttachCard(match, right, pyrecko)

			context:Equal("its own type does",
				(CardEngine.Match.CanPerformAction(match, playerIndex, "Attack", { attack = 1 })), true)
		end,
	},

	{
		name = "a player cannot act on their opponent's turn",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local opponent = match:GetOpponentIndex(match:GetActivePlayerIndex())
			local legal, reason = CardEngine.Match.CanPerformAction(match, opponent, "EndTurn", {})

			context:Equal("acting out of turn is refused", legal, false)
			context:Equal("and says why", reason, "match_not_your_turn")
		end,
	},

	{
		name = "a player cannot play a card that is not in their hand",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local opponent = match:GetOpponentIndex(playerIndex)
			local theirCard = match:GetZoneInstances("Hand", opponent)[1]

			context:Equal("playing from the opponent's hand is refused",
				(CardEngine.Match.CanPerformAction(match, playerIndex, "PlayItem",
					{ card = theirCard.id })), false)

			context:Equal("so is an instance that does not exist",
				(CardEngine.Match.CanPerformAction(match, playerIndex, "PlayItem",
					{ card = 999999 })), false)
		end,
	},

	--[[
		§7 Winning
	--]]

	{
		name = "taking the last prize wins the match",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()

			for _, instance in ipairs(match:GetZoneInstances("Prizes", playerIndex)) do
				CardEngine.Match.MoveCard(match, instance, "Hand", playerIndex)
			end

			local winner, reason = Beastbound.CheckGameOver(match)

			context:Equal("they win", winner, playerIndex)
			context:Equal("for the right reason", reason, "ce_expansion_beastbound_win_prizes")
		end,
	},

	{
		name = "running out of Beasts loses the match",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local opponent = match:GetOpponentIndex(playerIndex)

			for _, zoneKey in ipairs({ "Active", "Bench" }) do
				for _, instance in ipairs(match:GetZoneInstances(zoneKey, opponent)) do
					CardEngine.Match.MoveCard(match, instance, "Discard", opponent)
				end
			end

			local winner, reason = Beastbound.CheckGameOver(match)

			context:Equal("their opponent wins", winner, playerIndex)
			context:Equal("for the right reason", reason, "ce_expansion_beastbound_win_no_beasts")
		end,
	},

	{
		name = "being made to draw from an empty deck loses the match",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local opponent = match:GetOpponentIndex(playerIndex)

			for _, instance in ipairs(match:GetZoneInstances("Deck", opponent)) do
				CardEngine.Match.MoveCard(match, instance, "Discard", opponent)
			end

			-- Hand the turn over properly: the first player skips their draw on turn 1, so the
			-- empty deck only bites on the turn after
			context:Run(match, function()
				Beastbound.EndTurn(match, playerIndex)
			end)

			context:Equal("it is the opponent's turn", match:GetActivePlayerIndex(), opponent)

			local winner, reason = Beastbound.CheckGameOver(match)

			context:Equal("their opponent wins", winner, playerIndex)
			context:Equal("for the right reason", reason, "ce_expansion_beastbound_win_decked_out")
		end,
	},

	--[[
		The bench
	--]]

	{
		name = "the bench holds five and keeps its gaps",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()

			for _, instance in ipairs(match:GetZoneInstances("Bench", playerIndex)) do
				CardEngine.Match.MoveCard(match, instance, "Discard", playerIndex)
			end

			local benched = {}

			for slot = 1, Beastbound.MAX_BENCH do
				benched[slot] = CardEngine.Match.CreateInstance(match,
					"ce_expansion_beastbound_turtling", playerIndex, "Bench", slot)
			end

			context:Equal("five fit", match:CountZone("Bench", playerIndex), Beastbound.MAX_BENCH)
			context:Equal("and there is no room for a sixth",
				match:HasZoneSpace("Bench", playerIndex), false)

			CardEngine.Match.MoveCard(match, benched[2], "Discard", playerIndex)

			context:Equal("slot 1 is untouched",
				match:GetZoneSlot("Bench", playerIndex, 1), benched[1])
			context:Equal("slot 2 is now empty",
				match:GetZoneSlot("Bench", playerIndex, 2), nil)
			context:Equal("slot 3 did not slide down",
				match:GetZoneSlot("Bench", playerIndex, 3), benched[3])
		end,
	},

	--[[
		Card effects
	--]]

	{
		name = "every printed effect has code behind it, and vice versa",
		run = function(context)
			local missingCode, orphanCode, missingPlay = {}, {}, {}

			for _, card in ipairs(CardEngine.Collection.GetAll()) do
				if (card:GetExpansionSetID() == Beastbound.EXPANSION_SET_ID) then
					local rules = card:GetGameRules() or {}
					local supertype = card:GetAttribute("Supertype")

					for index, attack in ipairs(card:GetAttribute("Attacks", {})) do
						local scripted = (rules.Attacks or {})[index] ~= nil

						if (attack.Effect and not scripted) then
							table.insert(missingCode, card:GetUniqueID() .. " attack " .. index)
						elseif (not attack.Effect and scripted) then
							table.insert(orphanCode, card:GetUniqueID() .. " attack " .. index)
						end
					end

					-- Every Item and Supporter does something; none of them is just a blank card
					if ((supertype == "Item" or supertype == "Supporter") and not rules.OnPlay) then
						table.insert(missingPlay, card:GetUniqueID())
					end
				end
			end

			context:Equal("no printed attack effect is left unimplemented",
				#missingCode, 0, table.concat(missingCode, ", "))
			context:Equal("no attack has code without printed text",
				#orphanCode, 0, table.concat(orphanCode, ", "))
			context:Equal("every Item and Supporter does something",
				#missingPlay, 0, table.concat(missingPlay, ", "))
		end,
	},

	{
		name = "an attack effect applies a condition after its damage",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local opponent = match:GetOpponentIndex(playerIndex)

			-- A known board, so this does not depend on the shuffle
			for _, zoneKey in ipairs({ "Active", "Bench" }) do
				for _, instance in ipairs(match:GetZoneInstances(zoneKey, playerIndex)) do
					CardEngine.Match.MoveCard(match, instance, "Discard", playerIndex)
				end

				for _, instance in ipairs(match:GetZoneInstances(zoneKey, opponent)) do
					CardEngine.Match.MoveCard(match, instance, "Discard", opponent)
				end
			end

			-- Maelsludge's Conductive Sludge paralyses without a coin flip, so the result is certain
			local attacker = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_maelsludge", playerIndex, "Active", 1)
			local defender = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_turtling", opponent, "Active", 1)

			for _ = 1, 2 do
				local energy = CardEngine.Match.CreateInstance(match,
					"ce_expansion_beastbound_electric_energy", playerIndex, "Hand")
				CardEngine.Match.AttachCard(match, energy, attacker)
			end

			context:Run(match, function()
				Beastbound.ResolveAttack(match, playerIndex, 1)
			end)

			-- Turtling is Nature, Electric is neither its weakness nor its resistance, so 50 lands
			context:Equal("the printed damage landed", Beastbound.GetDamage(match, defender), 50)
			context:Check("and the condition was applied",
				Beastbound.HasCondition(match, defender, "Paralyzed"))
		end,
	},

	{
		name = "equipment adds to damage and is discarded with its Beast",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local active = match:GetZoneSlot("Active", playerIndex, 1)

			local sword = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_runic_sword", playerIndex, "Hand")

			context:Run(match, function()
				local ctx = Beastbound.BuildContext(match, playerIndex, sword)
				Beastbound.RunCardScript(match, match:GetInstanceCard(sword), "OnPlay", ctx)
			end)

			context:Equal("the sword is attached, not discarded", sword.zone, active.zone)
			context:Equal("attacks do 30 more",
				match:Query("OutgoingDamage", { instance = active, player = playerIndex }, 50), 80)

			-- Knocking the Beast out takes the sword, and its effect, with it
			context:Run(match, function()
				Beastbound.DealDamage(match, active, 9999, { ignoreWeakness = true })
				Beastbound.CheckKnockOuts(match)
			end)

			context:Equal("the sword went to the discard with it", sword.zone, "Discard")
			context:Equal("and stopped helping",
				match:Query("OutgoingDamage", { instance = active, player = playerIndex }, 50), 50)
		end,
	},

	{
		name = "the Legendary Corrupter is the only way Umbramaw reaches the table",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()

			local luxpaws = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_luxpaws", playerIndex, "Bench")
			CardEngine.Match.SetInstanceState(match, luxpaws, "playedOnTurn", 0)

			CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_umbramaw", playerIndex, "Hand")

			local corrupter = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_legendary_corrupter", playerIndex, "Hand")

			context:Run(match, function()
				local ctx = Beastbound.BuildContext(match, playerIndex, corrupter)
				Beastbound.RunCardScript(match, match:GetInstanceCard(corrupter), "OnPlay", ctx)
			end)

			local active = match:GetZoneSlot("Bench", playerIndex, luxpaws.slot)

			context:Check("Umbramaw is now in play", active ~= nil
				and match:GetInstanceCard(active):GetUniqueID() == "ce_expansion_beastbound_umbramaw")
		end,
	},

	{
		name = "a healing card puts damage back",
		run = function(context)
			local match = startTestMatch(context)

			if (not match) then
				return
			end

			local playerIndex = match:GetActivePlayerIndex()
			local active = match:GetZoneSlot("Active", playerIndex, 1)

			CardEngine.Match.AddCounter(match, active, Beastbound.DAMAGE_COUNTER, 50)

			local potion = CardEngine.Match.CreateInstance(match,
				"ce_expansion_beastbound_minor_potion", playerIndex, "Hand")

			context:Run(match, function()
				local ctx = Beastbound.BuildContext(match, playerIndex, potion)
				Beastbound.RunCardScript(match, match:GetInstanceCard(potion), "OnPlay", ctx)
			end)

			context:Equal("20 damage was healed", Beastbound.GetDamage(match, active), 30)
		end,
	},

	--[[
		Bringing a deck to a match
	--]]

	{
		name = "owning the cards is only required when the server says so",
		run = function(context)
			local deck = buildTestDeck()
			local ownsNothing = function() return 0 end
			local ownsEverything = function() return 99 end

			-- Set through the convar rather than with RunConsoleCommand: a console command is queued
			-- for the next frame, and a check that reads the value back in the same breath would be
			-- reading whatever the server happened to be set to instead of what it asked for
			local convar = CardEngine.Convars.MatchRequireOwnedCards
			local wasRequired = convar:GetBool()

			-- Everything is measured first and the server is put back the way it was before anything
			-- is checked, so a failure here cannot leave the setting changed behind it
			convar:SetBool(true)

			local refused, refusedReason = CardEngine.GameRules.CanDeckBeUsed(
				Beastbound.EXPANSION_SET_ID, deck, ownsNothing)

			local collected = CardEngine.GameRules.CanDeckBeUsed(
				Beastbound.EXPANSION_SET_ID, deck, ownsEverything)

			-- With it off, the same deck is allowed. This is the check the Play tab runs too, so the
			-- board and the server can never disagree about which decks are greyed out.
			convar:SetBool(false)

			local allowed = CardEngine.GameRules.CanDeckBeUsed(
				Beastbound.EXPANSION_SET_ID, deck, ownsNothing)

			convar:SetBool(wasRequired)

			context:Equal("an uncollected deck is refused while ownership is required", refused, false)
			context:Equal("and says why", refusedReason, "match_deck_missing_cards")
			context:Equal("a collected deck is fine either way", collected, true)
			context:Equal("turning the requirement off allows it", allowed, true)
		end,
	},

	{
		name = "a deck built for another game is always refused",
		run = function(context)
			local deck = buildTestDeck()
			deck.expansion_set = "some_other_expansion"

			local usable, reason = CardEngine.GameRules.CanDeckBeUsed(
				Beastbound.EXPANSION_SET_ID, deck, function() return 99 end)

			context:Equal("it is refused", usable, false)
			context:Equal("and says why", reason, "match_deck_wrong_set")
		end,
	},

	{
		name = "an incomplete deck is refused however many cards are owned",
		run = function(context)
			local deck = buildTestDeck()
			deck.cards = { ce_expansion_beastbound_pyrecko = 4 }

			local usable, reason = CardEngine.GameRules.CanDeckBeUsed(
				Beastbound.EXPANSION_SET_ID, deck, function() return 99 end)

			context:Equal("it is refused", usable, false)
			context:Equal("and says why", reason, "match_deck_illegal")
		end,
	},

	--[[
		Randomness
	--]]

	{
		name = "a seed plays out the same way every time",
		run = function(context)
			local function rollsFrom(seed)
				local match = CardEngine.Match.New("seedtest", Beastbound.EXPANSION_SET_ID, {
					{ steamID = "1", name = "A" }, { steamID = "2", name = "B" },
				})

				match.rngState = seed
				match.pendingEvents = {}

				local rolls = {}

				for index = 1, 20 do
					rolls[index] = match:Random(1, 100)
				end

				return table.concat(rolls, ",")
			end

			context:Equal("the same seed gives the same rolls", rollsFrom(12345), rollsFrom(12345))
			context:Check("different seeds differ", rollsFrom(12345) ~= rollsFrom(54321))
		end,
	},

	--[[
		Whole games

		The broadest check there is: two AI seats play Beastbound from the opening hand to somebody
		winning, with every turn taken, every prompt answered and every card that turns up resolved.

		A scripted test only reaches the board it was written to build. A game reaches the boards
		nobody thought of, which is where the rules that only go wrong on turn nine live.
	--]]

	{
		name = "two AI players can finish a game of Beastbound",
		run = function(context)
			local match = context:StartMatch(Beastbound.EXPANSION_SET_ID,
				{ buildTestDeck(), buildTestDeck() }, nil, true)

			if (not match) then
				return
			end

			if (not context:PlayOut(match)) then
				return
			end

			local winner, reason = match:GetWinner()

			-- Every way this game can end is somebody winning (§7), so a draw means something
			-- stopped the match rather than won it
			context:Check("somebody won", winner ~= nil, "the match ended without a winner")
			context:Check("and the game said why", reason ~= nil
				and reason ~= "match_ended"
				and reason ~= "match_end_ai_stuck",
				"ended with: " .. tostring(reason))
		end,
	},

	{
		name = "a game plays out the same way from the same seed",
		run = function(context)
			--- Plays a whole game and boils it down to something two runs can be compared on
			--- @param seed number
			--- @return string
			local function outcomeFrom(seed)
				local match = context:StartMatch(Beastbound.EXPANSION_SET_ID,
					{ buildTestDeck(), buildTestDeck() }, seed, true)

				if (not match) then
					return "no match"
				end

				CardEngine.MatchAI.PlayOut(match)

				return string.format("%s/%s/%s",
					tostring(match:GetWinner()), tostring(match.turn), tostring(match.endReason))
			end

			-- A match that is reproducible is a match whose bugs can be chased. This is the check
			-- that says the AI has not smuggled any randomness of its own in alongside the seed.
			context:Equal("the same seed plays the same game", outcomeFrom(818181), outcomeFrom(818181))
		end,
	},
})
