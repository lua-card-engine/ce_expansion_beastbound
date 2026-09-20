local CARD = CARD

CARD.Name = "ce_expansion_beastbound_voltking"
CARD.Description = "ce_expansion_beastbound_voltking_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/voltking"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Electric",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_thunderat",
	HP = 180,
	RetreatCost = 2,
	Weakness = "Water",
	Resistance = "Fire",
	CardNumber = 3,
	Attacks = {
		{
			Name = "Static Claws",
			Cost = 2,
			Damage = 50,
			Effect = "Flip a coin. If heads, the Defending Beast is Paralyzed.",
		},
		{
			Name = "Storm Sabre",
			Cost = 3,
			Damage = 130,
			Effect = "Does 40 more damage if this Beast has no damage counters on it.",
		},
	},
}
