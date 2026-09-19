local CARD = CARD

CARD.Name = "ce_expansion_beastbound_krakentoa"
CARD.Description = "ce_expansion_beastbound_krakentoa_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/krakentoa"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_aquariog",
	HP = 170,
	RetreatCost = 3,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 15,
	Attacks = {
		{
			Name = "Tentacle Lash",
			Cost = 2,
			Damage = 50,
		},
		{
			Name = "Abyssal Crush",
			Cost = 3,
			Damage = 120,
			Effect = "Does 20 more damage for each other Water-type Beast on your Bench (max +60).",
		},
	},
}
