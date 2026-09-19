local CARD = CARD

CARD.Name = "ce_expansion_beastbound_kragcrush"
CARD.Description = "ce_expansion_beastbound_kragcrush_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/kragcrush"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Fighting",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_boulderblade",
	HP = 170,
	RetreatCost = 3,
	Weakness = "Psychic",
	Resistance = "Water",
	CardNumber = 24,
	Attacks = {
		{
			Name = "Boulder Crush",
			Cost = 2,
			Damage = 60,
		},
		{
			Name = "Cataclysm",
			Cost = 3,
			Damage = 120,
			Effect = "Kragcrush can't attack during your next turn.",
		},
	},
}
