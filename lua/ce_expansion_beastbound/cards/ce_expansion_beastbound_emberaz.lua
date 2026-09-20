local CARD = CARD

CARD.Name = "ce_expansion_beastbound_emberaz"
CARD.Description = "ce_expansion_beastbound_emberaz_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/emberaz"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Fire",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_pyrecko",
	HP = 105,
	RetreatCost = 1,
	Weakness = "Fighting",
	Resistance = "Electric",
	CardNumber = 8,
	Attacks = {
		{
			Name = "Flame Dash",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Scorch Claw",
			Cost = 2,
			Damage = 50,
			Effect = "Flip a coin. If heads, the Defending Beast is now Burned.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = function(ctx)
			-- Scorch Claw: "Flip a coin. If heads, the Defending Beast is now Burned."
			if (ctx:FlipHeads("ce_expansion_beastbound_flip_burn")) then
				ctx:ApplyCondition(ctx.defender, "Burned")
			end
		end,
	},
}
