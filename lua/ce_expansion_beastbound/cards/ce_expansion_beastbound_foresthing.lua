local CARD = CARD

CARD.Name = "ce_expansion_beastbound_foresthing"
CARD.Description = "ce_expansion_beastbound_foresthing_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/foresthing"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Nature",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_lianalker",
	HP = 160,
	RetreatCost = 2,
	Weakness = "Fire",
	Resistance = "Psychic",
	CardNumber = 48,
	Attacks = {
		{
			Name = "Overgrowth",
			Cost = 2,
			Damage = 50,
			Effect = "Heal 20 damage from Foresthing.",
		},
		{
			Name = "Ancient Roots",
			Cost = 3,
			Damage = 90,
			Effect = "Search your deck for a Energy card, attach it to Foresthing, then shuffle your deck.",
		},
	},
}
