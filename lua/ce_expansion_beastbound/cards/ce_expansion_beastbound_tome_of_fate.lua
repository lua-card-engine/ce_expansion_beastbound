local CARD = CARD

CARD.Name = "ce_expansion_beastbound_tome_of_fate"
CARD.Description = "ce_expansion_beastbound_tome_of_fate_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/item-tome-of-fate"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Item",
	Subtype = "Consumable",
	CardNumber = 58,
}

CARD.GameRules = {
	-- "Look at the top 3 cards of your deck. Put 1 into your hand and the rest on the bottom of
	-- your deck in any order."
	OnPlay = function(ctx)
		local deck = ctx:GetDeck()
		local top = {}

		-- The deck is ordered with the top card last
		for index = #deck, math.max(1, #deck - 2), -1 do
			table.insert(top, deck[index])
		end

		if (#top == 0) then
			return false
		end

		local kept = ctx:Choose(top, "ce_expansion_beastbound_prompt_tome_of_fate", 1, false, true)

		if (kept) then
			ctx:MoveCard(kept, "Hand", { faceDown = false })
		end

		local rest = {}

		for _, instance in ipairs(top) do
			if (instance ~= kept) then
				table.insert(rest, instance)
			end
		end

		ctx:PutOnBottomOfDeck(rest)
	end,
}
