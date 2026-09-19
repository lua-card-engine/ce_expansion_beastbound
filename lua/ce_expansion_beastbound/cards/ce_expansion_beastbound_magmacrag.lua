local CARD = CARD

CARD.Name = "ce_expansion_beastbound_magmacrag"
CARD.Description = "ce_expansion_beastbound_magmacrag_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/magmacrag"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Fire",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_emberock",
	HP = 150,
	RetreatCost = 2,
	Weakness = "Fighting",
	Resistance = "Electric",
	CardNumber = 40,
	Attacks = {
		{
			Name = "Molten Slam",
			Cost = 2,
			Damage = 50,
			Effect = "Flip a coin. If heads, the Defending Beast is now Burned.",
		},
		{
			Name = "Eruption",
			Cost = 3,
			Damage = 110,
			Effect = "Also does 20 damage to each of your opponent's Benched Beasts.",
		},
	},
}
