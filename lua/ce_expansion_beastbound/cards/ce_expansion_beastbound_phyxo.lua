local CARD = CARD

CARD.Name = "ce_expansion_beastbound_phyxo"
CARD.Description = "ce_expansion_beastbound_phyxo_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/phyxo"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_phixy",
	HP = 105,
	RetreatCost = 1,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 11,
	Attacks = {
		{
			Name = "Confuse Ray",
			Cost = 1,
			Damage = 20,
			Effect = "Flip a coin. If heads, the Defending Beast is now Confused.",
		},
		{
			Name = "Psybeam",
			Cost = 2,
			Damage = 50,
		},
	},
}
