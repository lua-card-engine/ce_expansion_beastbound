local CARD = CARD

CARD.Name = "ce_expansion_beastbound_spooklet"
CARD.Description = "ce_expansion_beastbound_spooklet_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/spooklet"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Basic",
	HP = 60,
	RetreatCost = 0,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 28,
	Attacks = {
		{
			Name = "Spooky Touch",
			Cost = 1,
			Damage = 10,
			Effect = "Flip a coin. If heads, the Defending Beast is now Confused.",
		},
		{
			Name = "Chill Wail",
			Cost = 1,
			Damage = 20,
		},
	},
}
