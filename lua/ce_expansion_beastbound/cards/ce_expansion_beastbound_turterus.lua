local CARD = CARD

CARD.Name = "ce_expansion_beastbound_turterus"
CARD.Description = "ce_expansion_beastbound_turterus_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/turterus"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Nature",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_turtling",
	HP = 120,
	RetreatCost = 2,
	Weakness = "Fire",
	Resistance = "Psychic",
	CardNumber = 17,
	Attacks = {
		{
			Name = "Hard Shell",
			Cost = 1,
			Damage = 20,
			Effect = "During your opponent's next turn, this Beast takes 20 less damage from attacks.",
		},
		{
			Name = "Vine Slam",
			Cost = 2,
			Damage = 50,
		},
	},
}
