local BOOSTER = BOOSTER

BOOSTER.Name = "ce_expansion_beastbound_booster"
BOOSTER.Description = "ce_expansion_beastbound_booster_description"
BOOSTER.Material = "card_engine/expansions/ce_expansion_beastbound/booster.png"

-- The width and height of the booster pack material in pixels.
BOOSTER.MaterialWidth = 261
BOOSTER.MaterialHeight = 446

-- Determines where the tearing will happen when the player opens the booster pack. This is the distance from the top of the booster pack to the tear line.
BOOSTER.SealHeight = 30

-- Uncomment this if there is enough cards in the card pool and you want to prevent duplicates from appearing in the same booster pack
-- BOOSTER.PreventDuplicates = true

-- Define the card pool for this booster pack
-- These are the card unique IDs that can appear in this pack
BOOSTER.CardPool = {
	-- For example:
	-- "ce_expansion_beastbound_first_card",
	-- "ce_expansion_beastbound_second_card",
	-- etc...
}

-- Define the slot configuration for the booster pack
-- Each slot can have:
--   - attributeWeights: Roll for specific attribute values (e.g., Rarity, Type)
--   - requiredAttributes: Filter cards that MUST have certain attributes (e.g., Supertype = "Trainer")
--   - modifiers: Apply modifiers to the card (e.g., condition, foil)
--
-- Legacy support: You can still use rarityWeights instead of attributeWeights.Rarity
BOOSTER.SlotConfiguration = {
	-- Slot 1: Common Cards
	{
		attributeWeights = {
			Rarity = {
				Common = 1,
			},
		},
	},

	-- Slots 2-5: Commons
	{
		attributeWeights = {
			Rarity = {
				Common = 1,
			},
		},
	},
	{
		attributeWeights = {
			Rarity = {
				Common = 1,
			},
		},
	},
	{
		attributeWeights = {
			Rarity = {
				Common = 1,
			},
		},
	},
	{
		attributeWeights = {
			Rarity = {
				Common = 1,
			},
		},
		requiredAttributes = {
			Supertype = "Trainer",
		},
	},

	-- Slots 6-8: Uncommons
	{
		attributeWeights = {
			Rarity = {
				Uncommon = 1,
			},
		},
	},
	{
		attributeWeights = {
			Rarity = {
				Uncommon = 1,
			},
		},
	},
	{
		attributeWeights = {
			Rarity = {
				Uncommon = 1,
			},
		},
	},

	-- Slot 9: Rare / Holo Rare
	{
		attributeWeights = {
			Rarity = {
				Rare = 1,
			},
		},
		-- For nested properties, you can use dot notation to specify the attribute path. For example, if you have a card with a
		-- Variants table and you want to require the Holo variant, you can do:
		-- requiredAttributes = {
		-- 	["Variants.Holo"] = true,
		-- },
	},

	-- Slots 10-11: Basic Energy
	{
		requiredAttributes = {
			Supertype = "Energy",
		},
		attributeWeights = {
			Rarity = {
				Common = 1,
			},
		},
	},
	{
		requiredAttributes = {
			Supertype = "Energy",
		},
		attributeWeights = {
			Rarity = {
				Common = 1,
			},
		},
	},
}
