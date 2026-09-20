local CARD = CARD

CARD.Name = "ce_expansion_beastbound_hornfist"
CARD.Description = "ce_expansion_beastbound_hornfist_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/hornfist"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Fighting",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_carapacer",
	HP = 160,
	RetreatCost = 2,
	Weakness = "Psychic",
	Resistance = "Water",
	CardNumber = 6,
	Attacks = {
		{
			Name = "Horn Jab",
			Cost = 2,
			Damage = 50,
		},
		{
			Name = "Battering Ram",
			Cost = 3,
			Damage = 110,
			Effect = "Does 30 more damage if the Defending Beast already has damage on it.",
		},
	},
}
