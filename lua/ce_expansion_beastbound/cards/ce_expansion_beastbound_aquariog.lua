local CARD = CARD

CARD.Name = "ce_expansion_beastbound_aquariog"
CARD.Description = "ce_expansion_beastbound_aquariog_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/aquariog"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_tadpool",
	HP = 110,
	RetreatCost = 1,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 14,
	Attacks = {
		{
			Name = "Tidal Slap",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Whirlpool",
			Cost = 2,
			Damage = 50,
			Effect = "The Defending Beast is now Confused.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = function(ctx)
			-- Whirlpool: "The Defending Beast is now Confused."
			ctx:ApplyCondition(ctx.defender, "Confused")
		end,
	},
}
