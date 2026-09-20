local CARD = CARD

CARD.Name = "ce_expansion_beastbound_pyrecko"
CARD.Description = "ce_expansion_beastbound_pyrecko_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/pyrecko"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Fire",
	Stage = "Basic",
	HP = 60,
	RetreatCost = 1,
	Weakness = "Fighting",
	Resistance = "Electric",
	CardNumber = 7,
	Attacks = {
		{
			Name = "Ember Flick",
			Cost = 1,
			Damage = 10,
			Effect = "Flip a coin. If heads, the Defending Beast is now Burned.",
		},
		{
			Name = "Tail Torch",
			Cost = 2,
			Damage = 30,
		},
	},
}
