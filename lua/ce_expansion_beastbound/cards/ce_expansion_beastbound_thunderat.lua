local CARD = CARD

CARD.Name = "ce_expansion_beastbound_thunderat"
CARD.Description = "ce_expansion_beastbound_thunderat_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/thunderat"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Beast",
	Type = "Electric",
	Stage = "Stage 1",
	EvolvesFrom = "ce_expansion_beastbound_starkrat",
	HP = 110,
	RetreatCost = 1,
	Weakness = "Water",
	Resistance = "Fire",
	CardNumber = 2,
	Attacks = {
		{
			Name = "Jolt Bite",
			Cost = 1,
			Damage = 30,
		},
		{
			Name = "Charged Tackle",
			Cost = 3,
			Damage = 60,
			Effect = "Does 20 more damage if Thunderat has 2 or more Energy attached.",
		},
	},
}

CARD.GameRules = {
	Attacks = {
		[2] = {
			-- Charged Tackle: "Does 20 more damage if Thunderat has 2 or more Energy attached."
			ModifyDamage = function(ctx, damage)
				if (ctx:CountEnergy(ctx.attacker) >= 2) then
					return damage + 20
				end
				
				return damage
			end,
		},
	},
}
