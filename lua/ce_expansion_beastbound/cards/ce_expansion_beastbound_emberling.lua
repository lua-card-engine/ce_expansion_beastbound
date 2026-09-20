local CARD = CARD

CARD.Name = "ce_expansion_beastbound_emberling"
CARD.Description = "ce_expansion_beastbound_emberling_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/emberling"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Fire",
	Stage = "Basic",
	HP = 65,
	RetreatCost = 1,
	Weakness = "Fighting",
	Resistance = "Electric",
	CardNumber = 25,
	Attacks = {
		{
			Name = "Spark Bite",
			Cost = 1,
			Damage = 10,
		},
		{
			Name = "Flame Pulse",
			Cost = 1,
			Damage = 20,
			Effect = "Flip a coin. If heads, the Defending Beast is now Burned.",
		},
	},
}
