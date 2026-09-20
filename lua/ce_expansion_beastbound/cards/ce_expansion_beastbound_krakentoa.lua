local CARD = CARD

CARD.Name = "ce_expansion_beastbound_krakentoa"
CARD.Description = "ce_expansion_beastbound_krakentoa_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/krakentoa"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

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

CARD.GameRules = {
	Attacks = {
		[2] = {
			-- Abyssal Crush: "Does 20 more damage for each other Water-type Beast on your Bench (max +60)."
			ModifyDamage = function(ctx, damage)
				local water = math.min(3, ctx:CountBenchOfType("Water"))
				
				return damage + water * 20
			end,
		},
	},
}
