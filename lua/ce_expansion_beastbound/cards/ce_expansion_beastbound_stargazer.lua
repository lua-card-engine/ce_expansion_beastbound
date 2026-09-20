local CARD = CARD

CARD.Name = "ce_expansion_beastbound_stargazer"
CARD.Description = "ce_expansion_beastbound_stargazer_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/stargazer"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_starieye",
	HP = 105,
	RetreatCost = 1,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 44,
	Attacks = {
		{
			Name = "Cosmic Ray",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Gravity Pull",
			Cost = 2,
			Damage = 50,
			Effect = "Move a Special Condition affecting Stargazer to the Defending Beast instead.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = function(ctx)
			-- Gravity Pull: "Move a Special Condition affecting Stargazer to the Defending Beast instead."
			ctx:TransferConditions(ctx.attacker, ctx.defender)
		end,
	},
}
