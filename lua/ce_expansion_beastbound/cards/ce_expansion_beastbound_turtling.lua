local CARD = CARD

CARD.Name = "ce_expansion_beastbound_turtling"
CARD.Description = "ce_expansion_beastbound_turtling_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/turtling"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Nature",
	Stage = "Basic",
	HP = 70,
	RetreatCost = 1,
	Weakness = "Fire",
	Resistance = "Psychic",
	CardNumber = 16,
	Attacks = {
		{
			Name = "Shell Bump",
			Cost = 1,
			Damage = 10,
		},
		{
			Name = "Leaf Cutter",
			Cost = 1,
			Damage = 20,
		},
	},
}
