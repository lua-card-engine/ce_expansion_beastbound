local CARD = CARD

CARD.Name = "ce_expansion_beastbound_grubler"
CARD.Description = "ce_expansion_beastbound_grubler_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/grubler"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Fighting",
	Stage = "Basic",
	HP = 70,
	RetreatCost = 1,
	Weakness = "Psychic",
	Resistance = "Water",
	CardNumber = 4,
	Attacks = {
		{
			Name = "Mandible Bite",
			Cost = 1,
			Damage = 20,
		},
		{
			Name = "Burrow Slam",
			Cost = 2,
			Damage = 30,
		},
	},
}
