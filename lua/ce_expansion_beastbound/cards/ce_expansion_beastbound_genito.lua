local CARD = CARD

CARD.Name = "ce_expansion_beastbound_genito"
CARD.Description = "ce_expansion_beastbound_genito_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/genito"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Basic",
	HP = 65,
	RetreatCost = 1,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 41,
	Attacks = {
		{
			Name = "Smoke Wisp",
			Cost = 1,
			Damage = 10,
		},
		{
			Name = "Mirage Pulse",
			Cost = 2,
			Damage = 30,
			Effect = "Flip a coin. If heads, the Defending Beast is now Confused.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = function(ctx)
			-- Mirage Pulse: "Flip a coin. If heads, the Defending Beast is now Confused."
			if (ctx:FlipHeads("ce_expansion_beastbound_flip_confuse")) then
				ctx:ApplyCondition(ctx.defender, "Confused")
			end
		end,
	},
}
