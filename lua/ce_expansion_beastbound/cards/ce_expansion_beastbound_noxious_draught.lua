local CARD = CARD

CARD.Name = "ce_expansion_beastbound_noxious_draught"
CARD.Description = "ce_expansion_beastbound_noxious_draught_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/item-noxious-draught"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Item",
	Subtype = "Consumable",
	CardNumber = 53,
}

CARD.GameRules = {
	-- "Cure any Special Condition affecting 1 of your Beasts and heal 10 damage from it."
	OnPlay = function(ctx)
		local target = ctx:ChooseOwnBeast()

		if (not target) then
			return false
		end

		ctx:CureConditions(target)
		ctx:Heal(target, 10)
	end,
}
