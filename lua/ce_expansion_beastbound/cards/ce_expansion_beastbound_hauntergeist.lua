local CARD = CARD

CARD.Name = "ce_expansion_beastbound_hauntergeist"
CARD.Description = "ce_expansion_beastbound_hauntergeist_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/hauntergeist"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_spooklet",
	HP = 110,
	RetreatCost = 1,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 29,
	Attacks = {
		{
			Name = "Shadow Claw",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Nightmare",
			Cost = 2,
			Damage = 50,
			Effect = "The Defending Beast is now Asleep.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = function(ctx)
			-- Nightmare: "The Defending Beast is now Asleep."
			ctx:ApplyCondition(ctx.defender, "Asleep")
		end,
	},
}
