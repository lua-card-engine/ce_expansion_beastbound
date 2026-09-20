local CARD = CARD

CARD.Name = "ce_expansion_beastbound_starkrat"
CARD.Description = "ce_expansion_beastbound_starkrat_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/starkrat"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Electric",
	Stage = "Basic",
	HP = 65,
	RetreatCost = 1,
	Weakness = "Water",
	Resistance = "Fire",
	CardNumber = 1,
	Attacks = {
		{
			Name = "Static Nip",
			Cost = 1,
			Damage = 10,
			Effect = "Flip a coin. If heads, the Defending Beast is Paralyzed.",
		},
		{
			Name = "Scurry Shock",
			Cost = 2,
			Damage = 30,
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[1] = function(ctx)
			-- Static Nip: "Flip a coin. If heads, the Defending Beast is Paralyzed."
			if (ctx:FlipHeads("ce_expansion_beastbound_flip_paralyze")) then
				ctx:ApplyCondition(ctx.defender, "Paralyzed")
			end
		end,
	},
}
