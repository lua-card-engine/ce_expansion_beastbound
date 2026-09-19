local CARD = CARD

CARD.Name = "ce_expansion_beastbound_pebblemite"
CARD.Description = "ce_expansion_beastbound_pebblemite_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/pebblemite"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Fighting",
	Stage = "Basic",
	HP = 70,
	RetreatCost = 1,
	Weakness = "Psychic",
	Resistance = "Water",
	CardNumber = 22,
	Attacks = {
		{
			Name = "Pebble Toss",
			Cost = 1,
			Damage = 10,
		},
		{
			Name = "Rock Fist",
			Cost = 1,
			Damage = 20,
		},
	},
}
