local CARD = CARD

CARD.Name = "ce_expansion_beastbound_voltaris"
CARD.Description = "ce_expansion_beastbound_voltaris_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/voltaris"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Legendary",
	Supertype = "Beast",
	Type = "Electric",
	Stage = "Basic",
	HP = 140,
	RetreatCost = 1,
	Weakness = "Water",
	Resistance = "Fire",
	CardNumber = 65,
	Attacks = {
		{
			Name = "Static Gale",
			Cost = 2,
			Damage = 50,
			Effect = "Also does 10 damage to each of your opponent's Benched Beasts.",
		},
		{
			Name = "Thunderbird's Wrath",
			Cost = 4,
			Damage = 160,
			Effect = "Discard 2 Energy attached to Voltaris.",
		},
	},
}
