local CARD = CARD

CARD.Name = "ce_expansion_beastbound_phoxerer"
CARD.Description = "ce_expansion_beastbound_phoxerer_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/phoxerer"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_phyxo",
	HP = 150,
	RetreatCost = 1,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 12,
	Attacks = {
		{
			Name = "Telekinetic Slap",
			Cost = 2,
			Damage = 50,
		},
		{
			Name = "Mind Shatter",
			Cost = 3,
			Damage = 110,
			Effect = "Flip a coin. If heads, the Defending Beast is now Confused.",
		},
	},
}
