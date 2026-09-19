local CARD = CARD

CARD.Name = "ce_expansion_beastbound_vineling"
CARD.Description = "ce_expansion_beastbound_vineling_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/vineling"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Nature",
	Stage = "Basic",
	HP = 65,
	RetreatCost = 1,
	Weakness = "Fire",
	Resistance = "Psychic",
	CardNumber = 46,
	Attacks = {
		{
			Name = "Vine Flick",
			Cost = 1,
			Damage = 20,
		},
		{
			Name = "Leech",
			Cost = 2,
			Damage = 20,
			Effect = "Heal 10 damage from Vineling.",
		},
	},
}
