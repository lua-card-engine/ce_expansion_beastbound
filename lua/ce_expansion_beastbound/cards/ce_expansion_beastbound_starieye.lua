local CARD = CARD

CARD.Name = "ce_expansion_beastbound_starieye"
CARD.Description = "ce_expansion_beastbound_starieye_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/starieye"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Water",
	Stage = "Basic",
	HP = 60,
	RetreatCost = 1,
	Weakness = "Nature",
	Resistance = "Fighting",
	CardNumber = 43,
	Attacks = {
		{
			Name = "Star Poke",
			Cost = 1,
			Damage = 10,
			Effect = "Flip a coin. If heads, the Defending Beast is now Confused.",
		},
		{
			Name = "Twinkle Beam",
			Cost = 2,
			Damage = 30,
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[1] = function(ctx)
			-- Star Poke: "Flip a coin. If heads, the Defending Beast is now Confused."
			if (ctx:FlipHeads("ce_expansion_beastbound_flip_confuse")) then
				ctx:ApplyCondition(ctx.defender, "Confused")
			end
		end,
	},
}
