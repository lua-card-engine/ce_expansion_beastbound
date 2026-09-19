local CARD = CARD

CARD.Name = "ce_expansion_beastbound_phixy"
CARD.Description = "ce_expansion_beastbound_phixy_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/phixy"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Basic",
	HP = 60,
	RetreatCost = 0,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 10,
	Attacks = {
		{
			Name = "Mind Poke",
			Cost = 1,
			Damage = 10,
		},
		{
			Name = "Psy Spark",
			Cost = 1,
			Damage = 20,
			Effect = "Flip a coin. If tails, this attack does nothing.",
		},
	},
}
