local CARD = CARD

CARD.Name = "ce_expansion_beastbound_genitron"
CARD.Description = "ce_expansion_beastbound_genitron_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/genitron"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_genito",
	HP = 150,
	RetreatCost = 2,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 42,
	Attacks = {
		{
			Name = "Djinn Ward",
			Cost = 2,
			Damage = 40,
			Effect = "During your opponent's next turn, prevent all effects of attacks done to Genitron by Basic Beasts.",
		},
		{
			Name = "Wish Unbound",
			Cost = 3,
			Damage = 110,
			Effect = "Discard the top card of your deck.",
		},
	},
}
