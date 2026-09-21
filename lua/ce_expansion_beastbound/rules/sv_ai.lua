-- The practice opponent: builds a board, feeds its Active Beast and attacks with whatever it can
-- pay for, in the order a person would (§5). It aims to reach the parts of a match only a whole game
-- reaches, not to be hard to beat. Every move goes through CanPerformAction, so a wrong one is
-- refused rather than played.

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- The cards a seat is holding
--- @param match CardEngine.Match
--- @param playerIndex number
--- @return CardEngine.MatchCardInstance[]
local function hand(match, playerIndex)
	return match:GetZoneInstances("Hand", playerIndex)
end

--- Whether an action with these parameters would be allowed right now. Every candidate goes
--- through here, so the AI never proposes what the server would refuse and the rules stay the only
--- authority.
--- @param match CardEngine.Match
--- @param playerIndex number
--- @param actionName string
--- @param params table
--- @return boolean
local function canDo(match, playerIndex, actionName, params)
	return (CardEngine.Match.CanPerformAction(match, playerIndex, actionName, params)) == true
end

--- The healthiest of a list of Beasts: the one with the most HP left is still standing next turn.
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

-- Each answers "is there a move of this kind worth making". They are tried in order and the first
-- that says yes is played; the engine calls back after each one settles.

--- Fills the bench. A Beast on the bench is all that stands between a knock-out and losing (§7).
local function playBasic(match, playerIndex)
	for _, card in ipairs(hand(match, playerIndex)) do
		local params = { card = card.id }

		if (canDo(match, playerIndex, "PlayBasic", params)) then
			return "PlayBasic", params
		end
	end

	return nil
end

--- Evolves whatever can be evolved. A later stage is strictly better and StackCard carries energy
--- and damage up with it.
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

--- Feeds the Active Beast, which pays for attacks. Only one attachment is allowed a turn (§5).
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

--- The cards the AI has already tried to play this turn. A card with no legal target stays in hand
--- on purpose (sh_actions.lua, PlayItem), so a loop would pick it forever without this. Kept out of
--- the match since it is AI bookkeeping and mustn't roll back; weak keys, so it goes with the match.
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

--- Plays Items and Supporters. What a card does is its own business (most prompt for a target,
--- which AnswerPrompt handles); this only decides that playing one is worth a step.
local function playCard(match, playerIndex)
	local target = healthiest(match, Beastbound.GetBeastsInPlay(match, playerIndex))
	local tried = triedCards(match)

	for _, actionName in ipairs({ "PlayItem", "PlaySupporter" }) do
		for _, card in ipairs(hand(match, playerIndex)) do
			if (not tried[card.id]) then
				-- Equipment wants a Beast to go on and a consumable doesn't. Trying both costs a refused check.
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

--- Retreats a nearly-dead Active Beast behind a healthier one. A last resort, since retreating
--- costs energy that would pay for an attack.
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

--- Attacks with the hardest-hitting attack the Active Beast can pay for, by printed damage. Working
--- out weakness and effects here would be a second copy of the combat rules.
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

--- Everything the AI knows how to do, in preference order. Attacking ends the turn (§5), so it
--- comes after building the board.
local STEPS = {
	playBasic,
	evolve,
	attachEnergy,
	playCard,
	retreat,
	attack,
	endTurn,
}

--- The prompts worth having an opinion about. Anything else gets Card Engine's own answer.
local PROMPT_ANSWERS = {
	-- Which Beast to open with or send out: whichever can take the most punishment
	ce_expansion_beastbound_prompt_choose_active = "healthiest",
	ce_expansion_beastbound_prompt_promote = "healthiest",

	-- As many as allowed: an empty bench is how this game is lost (§7)
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
	-- A single instance would be refused for a question wanting several, and none of these ask for more
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

--- Registers the practice opponent. Called from sh_init.lua once every file in rules/ has loaded.
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

			-- Nothing it knows how to do: Card Engine picks at random from what is legal
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
