local CARD = CARD

CARD.Name = "ce_expansion_beastbound_legendary_corrupter"
CARD.Description = "ce_expansion_beastbound_legendary_corrupter_description"
CARD.Texture = "card_engine/expansions/ce_expansion_beastbound/item-legendary-corrupter"
CARD.RearTexture = "card_engine/expansions/ce_expansion_beastbound/back"
CARD.CardSize = CardEngine.DEFAULT_CARD_MODELS.COMMON_ROUNDED

CARD.HolographicStrength = Vector(1, 1, 1)
CARD.HolographicTexture = "card_engine/holo_rainbow_strong"

CARD.Attributes = {
	Rarity = "Legendary",
	Supertype = "Item",
	Subtype = "Consumable",
	CardNumber = 68,
}

CARD.GameRules = {
	-- "Evolve 1 of your Luxpaws into Umbramaw from your hand or deck. Shuffle your deck afterward."
	--
	-- The only way Umbramaw ever reaches the table: the normal Evolve action refuses it, because
	-- the card carries an EvolvesWith naming this one.
	OnPlay = function(ctx)
		local Beastbound = CardEngine.ExpansionSets.Beastbound
		local match = ctx.match

		local luxpaws = {}

		for _, instance in ipairs(ctx:GetOwnBeasts()) do
			local card = ctx:GetCard(instance)

			if (card and card:GetUniqueID() == "ce_expansion_beastbound_luxpaws") then
				table.insert(luxpaws, instance)
			end
		end

		if (#luxpaws == 0) then
			return false
		end

		-- From hand or deck, whichever it can be found in
		local umbramaw

		for _, zoneKey in ipairs({ "Hand", "Deck" }) do
			local found = CardEngine.Match.FindInZone(match, zoneKey, ctx.player, {
				Supertype = "Beast",
			})

			for _, instance in ipairs(found) do
				local card = match:GetInstanceCard(instance)

				if (card and card:GetUniqueID() == "ce_expansion_beastbound_umbramaw") then
					umbramaw = instance
					break
				end
			end

			if (umbramaw) then
				break
			end
		end

		if (not umbramaw) then
			ctx:ShuffleDeck()
			return false
		end

		local target = ctx:Choose(luxpaws, "ce_expansion_beastbound_prompt_corrupt_luxpaws", 1)

		if (target) then
			Beastbound.Evolve(match, umbramaw, target)
		end

		ctx:ShuffleDeck()
	end,
}
