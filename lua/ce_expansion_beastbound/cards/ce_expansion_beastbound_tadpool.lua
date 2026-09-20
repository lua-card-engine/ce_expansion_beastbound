local CARD = CARD

CARD.Name = "ce_expansion_beastbound_tadpool"
CARD.Description = "ce_expansion_beastbound_tadpool_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/tadpool"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Basic",
	HP = 65,
	RetreatCost = 1,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 13,
	Attacks = {
		{
			Name = "Splash",
			Cost = 1,
			Damage = 10,
		},
		{
			Name = "Bubble Jet",
			Cost = 2,
			Damage = 30,
		},
	},
}
