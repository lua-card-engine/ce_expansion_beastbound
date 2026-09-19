local CARD = CARD

CARD.Name = "ce_expansion_beastbound_aquaskate"
CARD.Description = "ce_expansion_beastbound_aquaskate_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/aquaskate"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_sealpup",
	HP = 105,
	RetreatCost = 1,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 32,
	Attacks = {
		{
			Name = "Aqua Jet",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Frost Spray",
			Cost = 2,
			Damage = 50,
			Effect = "During your opponent's next turn, the Defending Beast's Retreat Cost is 2 more.",
		},
	},
}
