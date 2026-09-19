local CARD = CARD

CARD.Name = "ce_expansion_beastbound_sealpup"
CARD.Description = "ce_expansion_beastbound_sealpup_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/sealpup"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Basic",
	HP = 65,
	RetreatCost = 1,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 31,
	Attacks = {
		{
			Name = "Splash Slap",
			Cost = 1,
			Damage = 10,
		},
		{
			Name = "Flipper Smack",
			Cost = 1,
			Damage = 20,
		},
	},
}
