local CARD = CARD

CARD.Name = "ce_expansion_beastbound_voltkey"
CARD.Description = "ce_expansion_beastbound_voltkey_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/voltkey"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Electric",
	Stage = "Basic",
	HP = 60,
	RetreatCost = 1,
	Weakness = "Water",
	Resistance = "Fire",
	CardNumber = 19,
	Attacks = {
		{
			Name = "Key Spark",
			Cost = 1,
			Damage = 10,
		},
		{
			Name = "Lock Jolt",
			Cost = 1,
			Damage = 20,
			Effect = "Flip a coin. If tails, this attack does nothing.",
		},
	},
}
