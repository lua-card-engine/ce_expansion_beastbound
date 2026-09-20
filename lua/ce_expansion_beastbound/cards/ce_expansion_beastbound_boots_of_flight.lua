local CARD = CARD

CARD.Name = "ce_expansion_beastbound_boots_of_flight"
CARD.Description = "ce_expansion_beastbound_boots_of_flight_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/item-boots-of-flight"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Item",
	Subtype = "Equip",
	CardNumber = 55,
}

CARD.GameRules = {
	-- "Attach to 1 of your Beasts. That Beast's Retreat Cost is 0.
	-- Discard this card if that Beast is Knocked Out."
	--
	-- The engine discards whatever is attached along with its host, and drops an effect when the
	-- card that put it there leaves play, so the second sentence needs no code of its own.
	OnPlay = function(ctx)
		local target = ctx:ChooseOwnBeast()

		if (not target) then
			return false
		end

		ctx:AttachEnergy(ctx.source, target)
		ctx:AddLastingEffect("beastbound_retreat_cost_free", nil, target)
	end,
}
