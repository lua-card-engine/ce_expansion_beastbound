local CARD = CARD

CARD.Name = "ce_expansion_beastbound_lianalker"
CARD.Description = "ce_expansion_beastbound_lianalker_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/lianalker"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Nature",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_vineling",
	HP = 110,
	RetreatCost = 1,
	Weakness = "Fire",
	Resistance = "Psychic",
	CardNumber = 47,
	Attacks = {
		{
			Name = "Root Snare",
			Cost = 1,
			Damage = 30,
			Effect = "During your opponent's next turn, the Defending Beast's Retreat Cost is 2 more.",
		},
		{
			Name = "Bramble Slash",
			Cost = 2,
			Damage = 50,
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[1] = function(ctx)
			-- Root Snare: "During your opponent's next turn, the Defending Beast's Retreat Cost is 2 more."
			ctx:AddEffectUntilOpponentTurnEnds("beastbound_retreat_cost_increase",
				{ amount = 2 }, ctx.defender)
		end,
	},
}
