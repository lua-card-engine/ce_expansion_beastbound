local CARD = CARD

CARD.Name = "ce_expansion_beastbound_pyrenax"
CARD.Description = "ce_expansion_beastbound_pyrenax_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/pyrenax"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Fire",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_emberling",
	HP = 110,
	RetreatCost = 1,
	Weakness = "Fighting",
	Resistance = "Electric",
	CardNumber = 26,
	Attacks = {
		{
			Name = "Molten Bite",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Solar Flare",
			Cost = 2,
			Damage = 50,
			Effect = "Discard a Fire Energy attached to Pyrenax: this attack does 30 more damage.",
		},
	},
}
