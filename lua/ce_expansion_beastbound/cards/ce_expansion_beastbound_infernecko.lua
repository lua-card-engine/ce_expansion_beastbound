local CARD = CARD

CARD.Name = "ce_expansion_beastbound_infernecko"
CARD.Description = "ce_expansion_beastbound_infernecko_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/infernecko"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Fire",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_emberaz",
	HP = 150,
	RetreatCost = 2,
	Weakness = "Fighting",
	Resistance = "Electric",
	CardNumber = 9,
	Attacks = {
		{
			Name = "Cinder Slash",
			Cost = 2,
			Damage = 50,
			Effect = "Flip a coin. If heads, the Defending Beast is now Burned.",
		},
		{
			Name = "Inferno Pounce",
			Cost = 3,
			Damage = 110,
			Effect = "Does 30 more damage if the Defending Beast is Burned.",
		},
	},
}
