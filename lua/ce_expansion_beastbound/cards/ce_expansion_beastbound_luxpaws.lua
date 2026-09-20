local CARD = CARD

CARD.Name = "ce_expansion_beastbound_luxpaws"
CARD.Description = "ce_expansion_beastbound_luxpaws_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/luxpaws"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Legendary",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Basic",
	HP = 100,
	RetreatCost = 1,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 66,
	Attacks = {
		{
			Name = "Gilded Purr",
			Cost = 1,
			Damage = 20,
			Effect = "Heal 20 damage from Luxpaws.",
		},
		{
			Name = "Ankh Radiance",
			Cost = 3,
			Damage = 80,
			Effect = "Heal 30 damage from each of your Beasts.",
		},
	},
}
