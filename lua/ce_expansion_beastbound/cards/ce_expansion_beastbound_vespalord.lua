local CARD = CARD

CARD.Name = "ce_expansion_beastbound_vespalord"
CARD.Description = "ce_expansion_beastbound_vespalord_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/vespalord"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Nature",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_apiscout",
	HP = 140,
	RetreatCost = 1,
	Weakness = "Fire",
	Resistance = "Psychic",
	CardNumber = 36,
	Attacks = {
		{
			Name = "Toxic Stinger",
			Cost = 2,
			Damage = 50,
			Effect = "The Defending Beast is now Poisoned.",
		},
		{
			Name = "Hive Storm",
			Cost = 3,
			Damage = 110,
			Effect = "Also does 20 damage to 1 of your opponent's Benched Beasts.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[1] = function(ctx)
			-- Toxic Stinger: "The Defending Beast is now Poisoned."
			ctx:ApplyCondition(ctx.defender, "Poisoned")
		end,
		[2] = function(ctx)
			-- Hive Storm: "Also does 20 damage to 1 of your opponent's Benched Beasts."
			local target = ctx:ChooseOpponentBench()
			
			if (target) then
				ctx:Damage(target, 20)
			end
		end,
	},
}
