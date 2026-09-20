local CARD = CARD

CARD.Name = "ce_expansion_beastbound_chrysaloid"
CARD.Description = "ce_expansion_beastbound_chrysaloid_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/chrysaloid"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Nature",
	Stage = "Basic",
	HP = 55,
	RetreatCost = 0,
	Weakness = "Fire",
	Resistance = "Psychic",
	CardNumber = 34,
	Attacks = {
		{
			Name = "Sting Peck",
			Cost = 1,
			Damage = 10,
			Effect = "Flip a coin. If heads, the Defending Beast is now Poisoned.",
		},
		{
			Name = "Pollen Puff",
			Cost = 1,
			Damage = 20,
		},
	},
}
