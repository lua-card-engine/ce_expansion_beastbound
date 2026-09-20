--[[
	How Beastbound looks

	Card Engine decides what happened; this decides how it is shown. Every section here is optional:
	take any of it away and the board still works, just plainer. That is the point of the defaults,
	and it is what another expansion set can rely on while it is being built.
--]]

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- The colour damage counters are drawn in
local COLOR_DAMAGE = Color(220, 70, 70)
local COLOR_DAMAGE_TEXT = Color(255, 235, 235)
local COLOR_CONDITION = Color(180, 90, 200)
local COLOR_EFFECT = Color(90, 160, 220)

--- A short badge for each condition, so a Beast's state reads at a glance
local CONDITION_BADGES = {
	Paralyzed = { text = "PAR", color = Color(230, 200, 60) },
	Confused = { text = "CNF", color = Color(200, 120, 220) },
	Asleep = { text = "SLP", color = Color(110, 140, 220) },
	Poisoned = { text = "PSN", color = Color(120, 190, 90) },
	Burned = { text = "BRN", color = Color(230, 120, 60) },
}

--[[
	Overlays drawn on a card in play
--]]

--- Draws the damage on a Beast as a number in the corner
local function drawDamage(panel, match, instance, w, h)
	local damage = Beastbound.GetDamage(match, instance)

	if (damage <= 0) then
		return
	end

	local text = tostring(damage)

	surface.SetFont("CardEngineSmall")

	local textWidth, textHeight = surface.GetTextSize(text)
	local badgeWidth = math.max(textWidth + 8, 20)

	draw.RoundedBox(4, w - badgeWidth - 2, 2, badgeWidth, textHeight + 4, COLOR_DAMAGE)
	draw.SimpleText(text, "CardEngineSmall", w - badgeWidth * 0.5 - 2, 4,
		COLOR_DAMAGE_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

--- Draws a badge for each Special Condition the Beast is under
local function drawConditions(panel, match, instance, w, h)
	local conditions = Beastbound.GetConditions(match, instance)

	if (#conditions == 0) then
		return
	end

	surface.SetFont("CardEngineTiny")

	local y = 2

	for _, condition in ipairs(conditions) do
		local badge = CONDITION_BADGES[condition]

		if (badge) then
			local textWidth, textHeight = surface.GetTextSize(badge.text)

			draw.RoundedBox(3, 2, y, textWidth + 6, textHeight + 2, badge.color)
			draw.SimpleText(badge.text, "CardEngineTiny", 5, y + 1,
				COLOR_DAMAGE_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			y = y + textHeight + 4
		end
	end
end

--- Draws a pip for each Energy attached, in that Energy's own colour
local function drawEnergy(panel, match, instance, w, h)
	local energy = Beastbound.GetAttachedEnergy(match, instance)

	if (#energy == 0) then
		return
	end

	local size = math.max(5, math.min(9, w / 9))
	local spacing = size + 2
	local x = 3
	local y = h - size - 3

	for _, attached in ipairs(energy) do
		local energyType = match:GetInstanceAttribute(attached, "Type")
		local color = Beastbound.TYPE_COLORS[energyType] or COLOR_EFFECT

		draw.RoundedBox(size * 0.5, x, y, size, size, color)

		x = x + spacing

		-- A Beast with more energy than fits simply stops showing more pips
		if (x + size > w - 3) then
			break
		end
	end
end

--- Draws a marker when something lasting is in force on this Beast
local function drawEffects(panel, match, instance, w, h)
	local effects = match:GetEffects(instance)

	if (#effects == 0) then
		return
	end

	draw.RoundedBox(3, w - 10, h - 10, 7, 7, COLOR_EFFECT)
end

--[[
	The log
--]]

--- @param match CardEngine.Match
--- @param instanceOrID CardEngine.MatchCardInstance|number
--- @return string
local function nameOf(match, instanceOrID)
	local card = match:GetInstanceCard(instanceOrID)

	return card and card:GetName() or CardEngine.T("ce_expansion_beastbound_log_a_card")
end

--[[
	Registration
--]]

CardEngine.GameRules.RegisterPresentation(Beastbound.EXPANSION_SET_ID, {
	--- Where each zone sits. The board mirrors this for the opponent, so it is written once from
	--- the point of view of whoever is looking at it.
	Layout = {
		Battlefield = {
			{ zone = "Active", style = "slots", cardWidth = 96 },
			{ zone = "Bench", style = "slots", cardWidth = 64 },
		},
		Private = {
			{ zone = "Hand", style = "row", cardWidth = 72 },
		},
		Stacks = {
			{ zone = "Prizes", style = "stack", cardWidth = 48 },
			{ zone = "Deck", style = "stack", cardWidth = 48 },
			{ zone = "Discard", style = "stack", cardWidth = 48 },
		},
	},

	--- What is drawn on top of a card that is in play
	CardOverlays = {
		damage = drawDamage,
		conditions = drawConditions,
		energy = drawEnergy,
		effects = drawEffects,
	},

	--- The action bar, in the order a turn tends to go
	Actions = {
		Order = {
			"AttachEnergy",
			"PlayBasic",
			"Evolve",
			"PlayItem",
			"PlaySupporter",
			"Retreat",
			"Attack",
			"EndTurn",
		},

		-- How many cards the player picks before the action is sent. Two means "this card, onto
		-- that one"; one means "just this"; none means it fires straight away.
		AttachEnergy = { Targets = 2 },
		Evolve = { Targets = 2 },
		PlayBasic = { Targets = 1 },
		PlayItem = { Targets = 1 },
		PlaySupporter = { Targets = 1 },
		Retreat = { Targets = 1 },
		EndTurn = { Targets = 0 },

		-- "Attack" on its own is not a move anybody can make: a Beast has two of them and they do
		-- different things, so each becomes its own button, named and priced like the card is. The
		-- board greys out the ones this Beast cannot pay for.
		Attack = {
			Targets = 0,

			Variants = function(match, viewer)
				local variants = {}
				local active = viewer and match:GetZoneSlot("Active", viewer, 1)

				if (not active) then
					return variants
				end

				for index, attack in ipairs(Beastbound.GetAttacks(match, active)) do
					local damage = attack.Damage or 0

					table.insert(variants, {
						key = index,
						params = { attack = index },
						Width = 150,

						label = CardEngine.T(damage > 0
							and "ce_expansion_beastbound_attack_button"
							or "ce_expansion_beastbound_attack_button_no_damage", {
							name = attack.Name,
							damage = damage,
							cost = attack.Cost or 0,
						}),
					})
				end

				return variants
			end,
		},
	},

	--- Beastbound's own lines in the match log, on top of the ones Card Engine writes
	Log = {
		beastbound_damage = function(match, event)
			local key = "ce_expansion_beastbound_log_damage"

			if (event.weak) then
				key = "ce_expansion_beastbound_log_damage_weak"
			elseif (event.resisted) then
				key = "ce_expansion_beastbound_log_damage_resisted"
			end

			return CardEngine.T(key, {
				target = nameOf(match, event.instance),
				amount = event.amount,
			})
		end,

		beastbound_healed = function(match, event)
			return CardEngine.T("ce_expansion_beastbound_log_healed", {
				target = nameOf(match, event.instance),
				amount = event.amount,
			})
		end,

		beastbound_knocked_out = function(match, event)
			return CardEngine.T("ce_expansion_beastbound_log_knocked_out", {
				target = nameOf(match, event.instance),
			})
		end,

		beastbound_prize_taken = function(match, event)
			local matchPlayer = match:GetPlayer(event.player)

			return CardEngine.T("ce_expansion_beastbound_log_prize_taken", {
				player = matchPlayer and matchPlayer.name or "?",
				remaining = event.remaining,
			})
		end,

		beastbound_condition_applied = function(match, event)
			return CardEngine.T("ce_expansion_beastbound_log_condition_applied", {
				target = nameOf(match, event.instance),
				condition = CardEngine.T(Beastbound.CONDITIONS[event.condition].Label),
			})
		end,

		beastbound_condition_cured = function(match, event)
			return CardEngine.T("ce_expansion_beastbound_log_condition_cured", {
				target = nameOf(match, event.instance),
				condition = CardEngine.T(Beastbound.CONDITIONS[event.condition].Label),
			})
		end,

		beastbound_promoted = function(match, event)
			return CardEngine.T("ce_expansion_beastbound_log_promoted", {
				target = nameOf(match, event.instance),
			})
		end,

		beastbound_retreated = function(match, event)
			return CardEngine.T("ce_expansion_beastbound_log_promoted", {
				target = nameOf(match, event.instance),
			})
		end,

		beastbound_mulligan = function(match, event)
			local matchPlayer = match:GetPlayer(event.player)

			return CardEngine.T("ce_expansion_beastbound_log_mulligan", {
				player = matchPlayer and matchPlayer.name or "?",
			})
		end,
	},

	--- The six type colours, reused everywhere a type is shown
	Theme = {
		Background = Color(22, 26, 30),
		Divider = Color(70, 90, 80),
		ActiveTurn = Color(120, 210, 130),
		WaitingTurn = Color(230, 190, 80),
		Types = Beastbound.TYPE_COLORS,
	},
})
