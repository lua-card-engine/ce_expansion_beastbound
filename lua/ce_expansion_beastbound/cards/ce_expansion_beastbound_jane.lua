local CARD = CARD

CARD.Name = "ce_expansion_beastbound_jane"
CARD.Description = "ce_expansion_beastbound_jane_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/supporter-jane"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Common",
	Supertype = "Supporter",
	CardNumber = 50,
}

CARD.GameRules = {
	-- "Heal 30 damage from 1 of your Beasts."
	OnPlay = function(ctx)
		local target = ctx:ChooseOwnBeast()

		if (not target) then
			return false
		end

		ctx:Heal(target, 30)
	end,
}
