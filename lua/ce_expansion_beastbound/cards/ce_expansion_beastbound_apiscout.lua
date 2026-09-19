local CARD = CARD

CARD.Name = "ce_expansion_beastbound_apiscout"
CARD.Description = "ce_expansion_beastbound_apiscout_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/apiscout"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Nature",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_chrysaloid",
	HP = 95,
	RetreatCost = 1,
	Weakness = "Fire",
	Resistance = "Psychic",
	CardNumber = 35,
	Attacks = {
		{
			Name = "Needle Dive",
			Cost = 1,
			Damage = 30,
			Effect = "Flip a coin. If heads, the Defending Beast is now Poisoned.",
		},
		{
			Name = "Swarm Strike",
			Cost = 2,
			Damage = 50,
		},
	},
}
