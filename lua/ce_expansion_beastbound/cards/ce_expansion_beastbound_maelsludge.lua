local CARD = CARD

CARD.Name = "ce_expansion_beastbound_maelsludge"
CARD.Description = "ce_expansion_beastbound_maelsludge_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/maelsludge"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Electric",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_voltbob",
	HP = 150,
	RetreatCost = 2,
	Weakness = "Water",
	Resistance = "Fire",
	CardNumber = 38,
	Attacks = {
		{
			Name = "Conductive Sludge",
			Cost = 2,
			Damage = 50,
			Effect = "The Defending Beast is now Paralyzed.",
		},
		{
			Name = "Overload Surge",
			Cost = 3,
			Damage = 100,
			Effect = "Does 30 damage to Maelsludge.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[1] = function(ctx)
			-- Conductive Sludge: "The Defending Beast is now Paralyzed."
			ctx:ApplyCondition(ctx.defender, "Paralyzed")
		end,
		[2] = function(ctx)
			-- Overload Surge: "Does 30 damage to Maelsludge."
			ctx:DamageSelf(30)
		end,
	},
}
