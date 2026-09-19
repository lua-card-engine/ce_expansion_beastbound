local CARD = CARD

CARD.Name = "ce_expansion_beastbound_teristar"
CARD.Description = "ce_expansion_beastbound_teristar_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/teristar"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_stargazer",
	HP = 150,
	RetreatCost = 2,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 45,
	Attacks = {
		{
			Name = "Nova Beam",
			Cost = 2,
			Damage = 50,
		},
		{
			Name = "Celestial Surge",
			Cost = 3,
			Damage = 110,
			Effect = "Flip 2 coins. This attack does 30 more damage for each heads.",
		},
	},
}
