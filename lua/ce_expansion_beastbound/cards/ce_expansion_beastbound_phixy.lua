local CARD = CARD

CARD.Name = "ce_expansion_beastbound_phixy"
CARD.Description = "ce_expansion_beastbound_phixy_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/phixy"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Basic",
	HP = 60,
	RetreatCost = 0,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 10,
	Attacks = {
		{
			Name = "Mind Poke",
			Cost = 1,
			Damage = 10,
		},
		{
			Name = "Psy Spark",
			Cost = 1,
			Damage = 20,
			Effect = "Flip a coin. If tails, this attack does nothing.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = {
			-- Psy Spark: "Flip a coin. If tails, this attack does nothing."
			ModifyDamage = function(ctx, damage)
				if (not ctx:FlipHeads("ce_expansion_beastbound_flip_attack_works")) then
					return 0
				end
				
				return damage
			end,
		},
	},
}
