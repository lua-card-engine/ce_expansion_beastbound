local CARD = CARD

CARD.Name = "ce_expansion_beastbound_sparkian"
CARD.Description = "ce_expansion_beastbound_sparkian_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/sparkian"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Electric",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_voltkey",
	HP = 110,
	RetreatCost = 1,
	Weakness = "Water",
	Resistance = "Fire",
	CardNumber = 20,
	Attacks = {
		{
			Name = "Arc Dash",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Volt Surge",
			Cost = 2,
			Damage = 50,
			Effect = "Discard an Energy attached to Sparkian: this attack does 20 more damage.",
		},
	},
}
