local CARD = CARD

CARD.Name = "ce_expansion_beastbound_umbramaw"
CARD.Description = "ce_expansion_beastbound_umbramaw_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/umbramaw"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Legendary",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_luxpaws",
	EvolvesWith = "ce_expansion_beastbound_legendary_corrupter",
	HP = 190,
	RetreatCost = 2,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 67,
	Attacks = {
		{
			Name = "Shadow Rake",
			Cost = 2,
			Damage = 60,
			Effect = "Flip a coin. If heads, the Defending Beast is now Confused.",
		},
		{
			Name = "Corrupted Eclipse",
			Cost = 4,
			Damage = 170,
			Effect = "Also does 30 damage to each of your Benched Beasts.",
		},
	},
}
