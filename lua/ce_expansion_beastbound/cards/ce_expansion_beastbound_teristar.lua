local CARD = CARD

CARD.Name = "ce_expansion_beastbound_teristar"
CARD.Description = "ce_expansion_beastbound_teristar_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/teristar"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_stargazer",
	HP = 150,
	RetreatCost = 2,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 45,
	Attacks = {
		{
			Name = "Nova Beam",
			Cost = 2,
			Damage = 50,
		},
		{
			Name = "Celestial Surge",
			Cost = 3,
			Damage = 110,
			Effect = "Flip 2 coins. This attack does 30 more damage for each heads.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = {
			-- Celestial Surge: "Flip 2 coins. This attack does 30 more damage for each heads."
			ModifyDamage = function(ctx, damage)
				local heads = ctx:FlipCoin(2, "ce_expansion_beastbound_flip_bonus_damage")
				
				return damage + heads * 30
			end,
		},
	},
}
