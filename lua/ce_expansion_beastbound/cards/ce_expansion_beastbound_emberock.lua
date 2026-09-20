local CARD = CARD

CARD.Name = "ce_expansion_beastbound_emberock"
CARD.Description = "ce_expansion_beastbound_emberock_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/emberock"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Fire",
	Stage = "Basic",
	HP = 70,
	RetreatCost = 1,
	Weakness = "Fighting",
	Resistance = "Electric",
	CardNumber = 39,
	Attacks = {
		{
			Name = "Hot Rock",
			Cost = 1,
			Damage = 20,
		},
		{
			Name = "Magma Fist",
			Cost = 2,
			Damage = 30,
		},
	},
}
