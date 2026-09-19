local CARD = CARD

CARD.Name = "ce_expansion_beastbound_voltbob"
CARD.Description = "ce_expansion_beastbound_voltbob_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/voltbob"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Electric",
	Stage = "Basic",
	HP = 65,
	RetreatCost = 1,
	Weakness = "Water",
	Resistance = "Fire",
	CardNumber = 37,
	Attacks = {
		{
			Name = "Ooze Spark",
			Cost = 1,
			Damage = 10,
			Effect = "Does 10 damage to Voltbob.",
		},
		{
			Name = "Slippery Shock",
			Cost = 2,
			Damage = 30,
		},
	},
}
