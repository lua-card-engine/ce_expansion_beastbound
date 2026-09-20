local CARD = CARD

CARD.Name = "ce_expansion_beastbound_lion_gauntlets"
CARD.Description = "ce_expansion_beastbound_lion_gauntlets_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/item-lion-gauntlets"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.Attributes = {
	Rarity = "Uncommon",
	Supertype = "Item",
	Subtype = "Equip",
	CardNumber = 56,
}

CARD.GameRules = {
	-- "Attach to 1 of your Beasts. That Beast's attacks do 20 more damage.
	-- Discard this card if that Beast is Knocked Out."
	OnPlay = function(ctx)
		local target = ctx:ChooseOwnBeast()

		if (not target) then
			return false
		end

		ctx:AttachEnergy(ctx.source, target)
		ctx:AddLastingEffect("beastbound_attack_damage_bonus", { amount = 20 }, target)
	end,
}
