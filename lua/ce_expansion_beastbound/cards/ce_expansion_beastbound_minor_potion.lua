local CARD = CARD

CARD.Name = "ce_expansion_beastbound_minor_potion"
CARD.Description = "ce_expansion_beastbound_minor_potion_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/item-minor-potion"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Item",
	Subtype = "Consumable",
	CardNumber = 52,
}

CARD.GameRules = {
	-- "Heal 20 damage from 1 of your Beasts."
	OnPlay = function(ctx)
		local target = ctx:ChooseOwnBeast()

		if (not target) then
			return false
		end

		ctx:Heal(target, 20)
	end,
}
