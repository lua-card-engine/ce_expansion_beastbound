local CARD = CARD

CARD.Name = "ce_expansion_beastbound_tactic_scroll"
CARD.Description = "ce_expansion_beastbound_tactic_scroll_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/item-tactic-scroll"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Item",
	Subtype = "Consumable",
	CardNumber = 54,
}

CARD.GameRules = {
	-- "Draw 3 cards, then discard 1 card from your hand."
	OnPlay = function(ctx)
		ctx:Draw(3)
		ctx:DiscardFromHand(1)
	end,
}
