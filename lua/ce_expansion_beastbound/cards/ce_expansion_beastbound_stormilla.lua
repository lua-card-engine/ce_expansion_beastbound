local CARD = CARD

CARD.Name = "ce_expansion_beastbound_stormilla"
CARD.Description = "ce_expansion_beastbound_stormilla_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/stormilla"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Electric",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_sparkian",
	HP = 160,
	RetreatCost = 2,
	Weakness = "Water",
	Resistance = "Fire",
	CardNumber = 21,
	Attacks = {
		{
			Name = "Thunder Fang",
			Cost = 2,
			Damage = 50,
			Effect = "Flip a coin. If heads, the Defending Beast is now Confused.",
		},
		{
			Name = "Maelstrom Bolt",
			Cost = 3,
			Damage = 110,
			Effect = "Also does 20 damage to 1 of your opponent's Benched Beasts.",
		},
	},
}
