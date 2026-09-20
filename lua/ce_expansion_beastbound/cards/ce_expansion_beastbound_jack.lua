local CARD = CARD

CARD.Name = "ce_expansion_beastbound_jack"
CARD.Description = "ce_expansion_beastbound_jack_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/supporter-jack"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Supporter",
	CardNumber = 49,
}

CARD.GameRules = {
	-- "Search your deck for a Fighting Energy card and attach it to 1 of your Beasts.
	-- Shuffle your deck afterward."
	OnPlay = function(ctx)
		local found = ctx:SearchDeck({ Supertype = "Energy", Type = "Fighting" }, 1)
		local target = found[1] and ctx:ChooseOwnBeast()

		if (found[1] and target) then
			ctx:AttachEnergy(found[1], target)
		end

		ctx:ShuffleDeck()
	end,
}
