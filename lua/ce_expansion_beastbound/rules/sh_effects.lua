--[[
	Lasting effects

	The things a card does that outlive the moment it was played: a Beast that takes less damage
	during the opponent's next turn, a Retreat Cost that has gone up, a piece of equipment that keeps
	helping for as long as it stays attached.

	These are registered rather than written inline so that both the server and the client can fold
	them. That is what lets the board grey out a retreat the player can no longer afford without
	asking the server first, and it is why an effect is pure data: a name and some arguments.
--]]

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

--- Takes a fixed amount off the damage a Beast receives.
--- Turterus' Hard Shell, Turtitan's Fortress Guard.
CardEngine.Match.Effects.Register("beastbound_damage_reduction", {
	Label = "ce_expansion_beastbound_effect_damage_reduction",

	Modify = {
		IncomingDamage = function(context, value, effect)
			return math.max(0, value - (effect.args.amount or 0))
		end,
	},
})

--- Adds to what a Beast has to pay to retreat.
--- Aquaskate's Frost Spray, Lianalker's Root Snare.
CardEngine.Match.Effects.Register("beastbound_retreat_cost_increase", {
	Label = "ce_expansion_beastbound_effect_retreat_increase",

	Modify = {
		RetreatCost = function(context, value, effect)
			return value + (effect.args.amount or 0)
		end,
	},
})

--- Stops a Beast attacking at all.
--- Kragcrush's Cataclysm, which costs it the turn after.
CardEngine.Match.Effects.Register("beastbound_cannot_attack", {
	Label = "ce_expansion_beastbound_effect_cannot_attack",

	Modify = {
		CanAttack = function()
			return false
		end,
	},
})

--- Adds to the damage a Beast's attacks do.
--- Lion Gauntlets and Runic Sword, for as long as they stay attached.
CardEngine.Match.Effects.Register("beastbound_attack_damage_bonus", {
	Label = "ce_expansion_beastbound_effect_damage_bonus",

	Modify = {
		OutgoingDamage = function(context, value, effect)
			return value + (effect.args.amount or 0)
		end,
	},
})

--- Makes a Beast free to retreat.
--- Boots of Flight, for as long as it stays attached.
CardEngine.Match.Effects.Register("beastbound_retreat_cost_free", {
	Label = "ce_expansion_beastbound_effect_retreat_free",

	Modify = {
		RetreatCost = function()
			return 0
		end,
	},
})

--- Turns aside the effects of attacks made by Basic Beasts, leaving their damage alone.
--- Genitron's Djinn Ward.
CardEngine.Match.Effects.Register("beastbound_ward_basic_effects", {
	Label = "ce_expansion_beastbound_effect_ward_basic",

	Modify = {
		AttackEffectsApply = function(context, value)
			local match = context.match
			local attacker = context.attacker

			if (not match or not attacker) then
				return value
			end

			-- Only the effects of a Basic Beast's attack are turned aside; its damage still lands
			if (match:GetInstanceAttribute(attacker, "Stage") == "Basic") then
				return false
			end

			return value
		end,
	},
})
