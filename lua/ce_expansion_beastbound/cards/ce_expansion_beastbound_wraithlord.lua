local CARD = CARD

CARD.Name = "ce_expansion_beastbound_wraithlord"
CARD.Description = "ce_expansion_beastbound_wraithlord_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/wraithlord"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Beast",
	Type = "Psychic",
	Stage = "Stage 2",
	EvolvesFrom = "ce_expansion_beastbound_hauntergeist",
	HP = 150,
	RetreatCost = 1,
	Weakness = "Electric",
	Resistance = "Nature",
	CardNumber = 30,
	Attacks = {
		{
			Name = "Cursed Grip",
			Cost = 2,
			Damage = 50,
			Effect = "The Defending Beast is now Asleep.",
		},
		{
			Name = "Soul Drain",
			Cost = 3,
			Damage = 100,
			Effect = "Heal 30 damage from Wraithlord.",
		},
	},
}
