--[[
	Beastbound's practice opponent

	Enough of a player to hold up its end of a game: it builds a board, feeds its Active Beast, and
	attacks with whatever it can pay for. It is not trying to be hard to beat. It is trying to reach
	the parts of a match that only a whole game reaches, so that a rule which only goes wrong on turn
	nine goes wrong somewhere somebody can see it.

	Everything here runs on the server, inside the match, and goes out through the same
	CanPerformAction gate a player's request does. So a move this file gets wrong is refused rather
	than played, and the worst an outright bug can do is waste a turn.

	The order it plays in is the order a person would: set up, then commit, then swing (§5).
--]]

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--[[
	Reading the board
--]]

--- The cards a seat is holding
--- @param match CardEngine.Match
--- @param playerIndex number
--- @return CardEngine.MatchCardInstance[]
local function hand(match, playerIndex)
	return match:GetZoneInstances("Hand", playerIndex)
end

--- Whether an action with these parameters would be allowed right now.
---
--- Every candidate goes through here before it is returned, so the AI never proposes something the
--- server is about to refuse. It also keeps the rules the single authority: this file holds opinions
--- about what is worth doing, never about what is allowed.
--- @param match CardEngine.Match
--- @param playerIndex number
--- @param actionName string
--- @param params table
--- @return boolean
local function canDo(match, playerIndex, actionName, params)
	return (CardEngine.Match.CanPerformAction(match, playerIndex, actionName, params)) == true
end

--- The healthiest of a list of Beasts.
---
--- Used wherever the AI has to pick one of its own and has no better reason: the one with the most
--- HP left is the one that will still be standing next turn.
--- @param match CardEngine.Match
--- @param instances CardEngine.MatchCardInstance[]
--- @return CardEngine.MatchCardInstance?
local function healthiest(match, instances)
	local best, bestHP

	for _, instance in ipairs(instances) do
		local hp = Beastbound.GetRemainingHP(match, instance)

		if (not bestHP or hp > bestHP) then
			best, bestHP = instance, hp
		end
	end

	return best
end

--[[
	Deciding what to do

	Each of these answers "is there a move of this kind worth making", and returns it if so. They are
	tried in order, so the first one that says yes is what happens next. A turn is a run of these:
	the engine calls back after each one settles, until something ends it.
--]]

--- Fills the bench. A Beast on the bench is the only thing between a knock-out and losing the game
--- (§7), so this comes before anything clever.
local function playBasic(match, playerIndex)
	for _, card in ipairs(hand(match, playerIndex)) do
		local params = { card = card.id }

		if (canDo(match, playerIndex, "PlayBasic", params)) then
			return "PlayBasic", params
		end
	end

	return nil
end

--- Evolves whatever can be evolved. A later stage is strictly better than what it replaces, and
--- StackCard carries the energy and the damage up with it, so there is never a reason to wait.
local function evolve(match, playerIndex)
	local beasts = Beastbound.GetBeastsInPlay(match, playerIndex)

	for _, card in ipairs(hand(match, playerIndex)) do
		for _, target in ipairs(beasts) do
			local params = { card = card.id, target = target.id }

			if (canDo(match, playerIndex, "Evolve", params)) then
				return "Evolve", params
			end
		end
	end

	return nil
end

--- Feeds the Active Beast, since that is the one that has to pay for an attack. Only one attachment
--- is allowed a turn (§5), so there is no point spreading it around.
local function attachEnergy(match, playerIndex)
	local active = match:GetZoneSlot("Active", playerIndex, 1)

	if (not active) then
		return nil
	end

	for _, card in ipairs(hand(match, playerIndex)) do
		local params = { card = card.id, target = active.id }

		if (canDo(match, playerIndex, "AttachEnergy", params)) then
			return "AttachEnergy", params
		end
	end

	return nil
end

--- The cards the AI has already tried to play this turn, per match.
---
--- A card whose effect turns out to have no legal target stays in hand on purpose, so that a player
--- is not punished for trying (sh_actions.lua, PlayItem). That is right for a person, who will then
--- try something else, and a trap for a loop: the card is still there, still looks playable, and
--- would be picked again forever. Remembering what has already been tried is what closes it.
---
--- Kept out of the match, because it is bookkeeping about the AI rather than part of the game and
--- must not be rolled back with the board. Weak keys, so it goes when the match does.
--- @type table<CardEngine.Match, { turn: number, cards: table<number, boolean> }>
local triedThisTurn = setmetatable({}, { __mode = "k" })

--- The set of cards already tried this turn, starting a fresh one when the turn has moved on
--- @param match CardEngine.Match
--- @return table<number, boolean>
local function triedCards(match)
	local tried = triedThisTurn[match]

	if (not tried or tried.turn ~= match:GetTurn()) then
		tried = { turn = match:GetTurn(), cards = {} }
		triedThisTurn[match] = tried
	end

	return tried.cards
end

--- Plays Items and Supporters, aimed at the healthiest Beast when they ask for one.
---
--- What a card actually does is its own business: most of them prompt for their target while they
--- resolve, which AnswerPrompt below deals with. This only decides that playing one is worth a step.
local function playCard(match, playerIndex)
	local target = healthiest(match, Beastbound.GetBeastsInPlay(match, playerIndex))
	local tried = triedCards(match)

	for _, actionName in ipairs({ "PlayItem", "PlaySupporter" }) do
		for _, card in ipairs(hand(match, playerIndex)) do
			if (not tried[card.id]) then
				-- An equipment wants a Beast to go on and a consumable does not. Trying one and
				-- falling back to the other costs a refused check and saves knowing which is which.
				local candidates = {
					{ card = card.id, target = target and target.id },
					{ card = card.id },
				}

				for _, params in ipairs(candidates) do
					if (canDo(match, playerIndex, actionName, params)) then
						tried[card.id] = true

						return actionName, params
					end
				end
			end
		end
	end

	return nil
end

--- Retreats a nearly-dead Active Beast behind a healthier one.
---
--- Only when it is about to be knocked out anyway: retreating costs energy that would otherwise have
--- paid for an attack, so it is a last resort rather than a habit.
local function retreat(match, playerIndex)
	local active = match:GetZoneSlot("Active", playerIndex, 1)

	if (not active) then
		return nil
	end

	local maxHP = Beastbound.GetMaxHP(match, active)

	if (maxHP <= 0 or Beastbound.GetRemainingHP(match, active) > maxHP * 0.25) then
		return nil
	end

	local replacement = healthiest(match, match:GetZoneInstances("Bench", playerIndex))

	if (not replacement
		or Beastbound.GetRemainingHP(match, replacement) <= Beastbound.GetRemainingHP(match, active)) then
		return nil
	end

	local params = { target = replacement.id }

	if (not canDo(match, playerIndex, "Retreat", params)) then
		return nil
	end

	return "Retreat", params
end

--- Attacks with the hardest-hitting attack the Active Beast can pay for.
---
--- Printed damage, rather than what would actually land: weakness, resistance and whatever the
--- attack itself does are worked out while it resolves, and guessing at them here would be a second
--- copy of the combat rules that could disagree with the first.
local function attack(match, playerIndex)
	local active = match:GetZoneSlot("Active", playerIndex, 1)

	if (not active) then
		return nil
	end

	local bestIndex, bestDamage

	for index, printed in ipairs(Beastbound.GetAttacks(match, active)) do
		if (canDo(match, playerIndex, "Attack", { attack = index })) then
			local damage = printed.Damage or 0

			if (not bestDamage or damage > bestDamage) then
				bestIndex, bestDamage = index, damage
			end
		end
	end

	if (not bestIndex) then
		return nil
	end

	return "Attack", { attack = bestIndex }
end

--- Ends the turn, which is always legal and so is always the last word
local function endTurn(match, playerIndex)
	if (not canDo(match, playerIndex, "EndTurn", {})) then
		return nil
	end

	return "EndTurn", {}
end

--- Everything the AI knows how to do, in the order it prefers to do it.
---
--- Building the board comes before using it, and the two moves that hand the turn over come last:
--- an attack ends the turn whatever happens (§5), so attacking early would throw the rest away.
local STEPS = {
	playBasic,
	evolve,
	attachEnergy,
	playCard,
	retreat,
	attack,
	endTurn,
}

--[[
	Answering questions
--]]

--- The prompts Beastbound puts to a player that are worth having an opinion about. Anything not
--- here falls through to Card Engine's own answer, which is what a player out of time would get.
local PROMPT_ANSWERS = {
	-- Which Beast to open with, and which to send out when the Active one is knocked out. The same
	-- question either way: whichever of them can take the most punishment.
	ce_expansion_beastbound_prompt_choose_active = "healthiest",
	ce_expansion_beastbound_prompt_promote = "healthiest",

	-- How many Beasts to start on the bench. As many as it is allowed: an empty bench is how this
	-- game is lost (§7), and a full one costs nothing.
	ce_expansion_beastbound_prompt_choose_bench = "all",
}

--- Picks as many candidates as the question will take
--- @param request CardEngine.MatchPromptRequest
--- @return number[]
local function answerAll(request)
	local candidates = request.candidates or {}
	local chosen = {}

	for index = 1, math.min(request.max or 1, #candidates) do
		chosen[index] = candidates[index]
	end

	return chosen
end

--- Picks whichever candidate has the most HP left
--- @param match CardEngine.Match
--- @param request CardEngine.MatchPromptRequest
--- @return number? # The instance ID chosen
local function answerHealthiest(match, request)
	-- Answering a question that wants several with a single instance would be refused, and none of
	-- the questions this is used for asks for more than one. Leave anything else to the default.
	if ((request.max or 1) > 1) then
		return nil
	end

	local instances = {}

	for _, instanceID in ipairs(request.candidates or {}) do
		local instance = match:GetInstance(instanceID)

		if (instance) then
			table.insert(instances, instance)
		end
	end

	local chosen = healthiest(match, instances)

	return chosen and chosen.id or nil
end

--[[
	Registration
--]]

--- Registers the practice opponent with Card Engine.
---
--- Called from sh_init.lua once every file in rules/ has loaded, for the same reason the rules
--- themselves are: so it does not depend on the order the folder happens to be read in.
--- @realm server
function Beastbound.RegisterAI()
	CardEngine.MatchAI.Register(Beastbound.EXPANSION_SET_ID, {
		Name = "ce_expansion_beastbound_ai_name",

		Decks = function()
			return { Beastbound.BuildStarterDeck("ce_expansion_beastbound_ai_starter") }
		end,

		ChooseAction = function(match, playerIndex)
			for _, step in ipairs(STEPS) do
				local actionName, params = step(match, playerIndex)

				if (actionName) then
					return actionName, params
				end
			end

			-- Nothing it knows how to do. Card Engine picks at random out of whatever is legal,
			-- which is a worse turn than this file would have played but is still a turn.
			return nil, nil
		end,

		AnswerPrompt = function(match, playerIndex, request)
			local policy = PROMPT_ANSWERS[request.prompt]

			if (not policy or #(request.candidates or {}) == 0) then
				return nil
			end

			if (policy == "all") then
				return answerAll(request)
			end

			return answerHealthiest(match, request)
		end,
	})
end
