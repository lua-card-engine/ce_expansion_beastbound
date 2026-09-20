local CARD = CARD

CARD.Name = "ce_expansion_beastbound_kragcrush"
CARD.Description = "ce_expansion_beastbound_kragcrush_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/kragcrush"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Fighting",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_boulderblade",
	HP = 170,
	RetreatCost = 3,
	Weakness = "Psychic",
	Resistance = "Water",
	CardNumber = 24,
	Attacks = {
		{
			Name = "Boulder Crush",
			Cost = 2,
			Damage = 60,
		},
		{
			Name = "Cataclysm",
			Cost = 3,
			Damage = 120,
			Effect = "Kragcrush can't attack during your next turn.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = function(ctx)
			-- Cataclysm: "Kragcrush can't attack during your next turn."
			ctx:AddEffectUntilOwnTurnEnds("beastbound_cannot_attack", nil, ctx.attacker)
		end,
	},
}
