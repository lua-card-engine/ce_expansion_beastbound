local CARD = CARD

CARD.Name = "ce_expansion_beastbound_runic_sword"
CARD.Description = "ce_expansion_beastbound_runic_sword_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/item-runic-sword"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Rare",
	Supertype = "Item",
	Subtype = "Equip",
	CardNumber = 57,
}

CARD.GameRules = {
	-- "Attach to 1 of your Beasts. That Beast's attacks do 30 more damage.
	-- Discard this card if that Beast is Knocked Out."
	OnPlay = function(ctx)
		local target = ctx:ChooseOwnBeast()

		if (not target) then
			return false
		end

		ctx:AttachEnergy(ctx.source, target)
		ctx:AddLastingEffect("beastbound_attack_damage_bonus", { amount = 30 }, target)
	end,
}
