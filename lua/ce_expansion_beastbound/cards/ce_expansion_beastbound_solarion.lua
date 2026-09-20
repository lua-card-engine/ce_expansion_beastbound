local CARD = CARD

CARD.Name = "ce_expansion_beastbound_solarion"
CARD.Description = "ce_expansion_beastbound_solarion_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/solarion"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Fire",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_pyrenax",
	HP = 160,
	RetreatCost = 2,
	Weakness = "Fighting",
	Resistance = "Electric",
	CardNumber = 27,
	Attacks = {
		{
			Name = "Radiant Claw",
			Cost = 2,
			Damage = 50,
		},
		{
			Name = "Supernova",
			Cost = 3,
			Damage = 130,
			Effect = "Does 30 damage to Solarion.",
		},
	},
}
