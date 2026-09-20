local CARD = CARD

CARD.Name = "ce_expansion_beastbound_boulderblade"
CARD.Description = "ce_expansion_beastbound_boulderblade_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/boulderblade"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Fighting",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_pebblemite",
	HP = 120,
	RetreatCost = 2,
	Weakness = "Psychic",
	Resistance = "Water",
	CardNumber = 23,
	Attacks = {
		{
			Name = "Stone Edge",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Landslide",
			Cost = 2,
			Damage = 50,
			Effect = "Also does 20 damage to 1 of your opponent's Benched Beasts.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = function(ctx)
			-- Landslide: "Also does 20 damage to 1 of your opponent's Benched Beasts."
			local target = ctx:ChooseOpponentBench()
			
			if (target) then
				ctx:Damage(target, 20)
			end
		end,
	},
}
