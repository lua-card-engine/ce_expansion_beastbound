local CARD = CARD

CARD.Name = "ce_expansion_beastbound_turtitan"
CARD.Description = "ce_expansion_beastbound_turtitan_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/turtitan"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Nature",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_turterus",
	HP = 180,
	RetreatCost = 3,
	Weakness = "Fire",
	Resistance = "Psychic",
	CardNumber = 18,
	Attacks = {
		{
			Name = "Fortress Guard",
			Cost = 2,
			Damage = 40,
			Effect = "During your opponent's next turn, this Beast takes 30 less damage from attacks.",
		},
		{
			Name = "Titan Crush",
			Cost = 3,
			Damage = 110,
		},
	},
}
