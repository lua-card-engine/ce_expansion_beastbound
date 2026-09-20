local CARD = CARD

CARD.Name = "ce_expansion_beastbound_ocearus"
CARD.Description = "ce_expansion_beastbound_ocearus_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/ocearus"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_aquaskate",
	HP = 155,
	RetreatCost = 2,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 33,
	Attacks = {
		{
			Name = "Tidal Wave",
			Cost = 2,
			Damage = 50,
		},
		{
			Name = "Deluge",
			Cost = 3,
			Damage = 110,
			Effect = "Flip a coin. If heads, this attack does 30 more damage.",
		},
	},
}
