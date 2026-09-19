local CARD = CARD

CARD.Name = "ce_expansion_beastbound_carapacer"
CARD.Description = "ce_expansion_beastbound_carapacer_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/carapacer"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Fighting",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_grubler",
	HP = 120,
	RetreatCost = 2,
	Weakness = "Psychic",
	Resistance = "Water",
	CardNumber = 5,
	Attacks = {
		{
			Name = "Shell Bash",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Crushing Grip",
			Cost = 2,
			Damage = 50,
			Effect = "Flip a coin. If heads, the Defending Beast is Paralyzed.",
		},
	},
}
