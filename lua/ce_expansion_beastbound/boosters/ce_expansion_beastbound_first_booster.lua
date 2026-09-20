local BOOSTER = BOOSTER

BOOSTER.Name = "ce_expansion_beastbound_booster"
BOOSTER.Description = "ce_expansion_beastbound_booster_description"
BOOSTER.Material = "card_engine/expansions/ce_expansion_beastbound/booster.png"
BOOSTER.FrontTexture = "card_engine/expansions/ce_expansion_beastbound/booster"
BOOSTER.RearTexture = "card_engine/expansions/ce_expansion_beastbound/booster_back"

-- The width and height of the booster pack material in pixels.
BOOSTER.MaterialWidth = 261
BOOSTER.MaterialHeight = 446

-- Determines where the tearing will happen when the player opens the booster pack. This is the distance from the top of the booster pack to the tear line.
BOOSTER.SealHeight = 30

-- Prevent the same card from appearing twice in one booster pack
BOOSTER.PreventDuplicates = true

-- The card unique IDs that can appear in this pack: every card in the set
BOOSTER.CardPool = {
	-- Beasts
	"ce_expansion_beastbound_starkrat",
	"ce_expansion_beastbound_thunderat",
	"ce_expansion_beastbound_voltking",
	"ce_expansion_beastbound_grubler",
	"ce_expansion_beastbound_carapacer",
	"ce_expansion_beastbound_hornfist",
	"ce_expansion_beastbound_pyrecko",
	"ce_expansion_beastbound_emberaz",
	"ce_expansion_beastbound_infernecko",
	"ce_expansion_beastbound_phixy",
	"ce_expansion_beastbound_phyxo",
	"ce_expansion_beastbound_phoxerer",
	"ce_expansion_beastbound_tadpool",
	"ce_expansion_beastbound_aquariog",
	"ce_expansion_beastbound_krakentoa",
	"ce_expansion_beastbound_turtling",
	"ce_expansion_beastbound_turterus",
	"ce_expansion_beastbound_turtitan",
	"ce_expansion_beastbound_voltkey",
	"ce_expansion_beastbound_sparkian",
	"ce_expansion_beastbound_stormilla",
	"ce_expansion_beastbound_pebblemite",
	"ce_expansion_beastbound_boulderblade",
	"ce_expansion_beastbound_kragcrush",
	"ce_expansion_beastbound_emberling",
	"ce_expansion_beastbound_pyrenax",
	"ce_expansion_beastbound_solarion",
	"ce_expansion_beastbound_spooklet",
	"ce_expansion_beastbound_hauntergeist",
	"ce_expansion_beastbound_wraithlord",
	"ce_expansion_beastbound_sealpup",
	"ce_expansion_beastbound_aquaskate",
	"ce_expansion_beastbound_ocearus",
	"ce_expansion_beastbound_chrysaloid",
	"ce_expansion_beastbound_apiscout",
	"ce_expansion_beastbound_vespalord",
	"ce_expansion_beastbound_voltbob",
	"ce_expansion_beastbound_maelsludge",
	"ce_expansion_beastbound_emberock",
	"ce_expansion_beastbound_magmacrag",
	"ce_expansion_beastbound_genito",
	"ce_expansion_beastbound_genitron",
	"ce_expansion_beastbound_starieye",
	"ce_expansion_beastbound_stargazer",
	"ce_expansion_beastbound_teristar",
	"ce_expansion_beastbound_vineling",
	"ce_expansion_beastbound_lianalker",
	"ce_expansion_beastbound_foresthing",

	-- Supporters
	"ce_expansion_beastbound_jack",
	"ce_expansion_beastbound_jane",
	"ce_expansion_beastbound_shane",

	-- Items
	"ce_expansion_beastbound_minor_potion",
	"ce_expansion_beastbound_noxious_draught",
	"ce_expansion_beastbound_tactic_scroll",
	"ce_expansion_beastbound_boots_of_flight",
	"ce_expansion_beastbound_lion_gauntlets",
	"ce_expansion_beastbound_runic_sword",
	"ce_expansion_beastbound_tome_of_fate",

	-- Basic Energy
	"ce_expansion_beastbound_electric_energy",
	"ce_expansion_beastbound_fighting_energy",
	"ce_expansion_beastbound_fire_energy",
	"ce_expansion_beastbound_psychic_energy",
	"ce_expansion_beastbound_water_energy",
	"ce_expansion_beastbound_nature_energy",

	-- Legendaries (hidden rares)
	"ce_expansion_beastbound_voltaris",
	"ce_expansion_beastbound_luxpaws",
	"ce_expansion_beastbound_umbramaw",
	"ce_expansion_beastbound_legendary_corrupter",
}

-- Each slot rolls its attributeWeights, then picks a random card that matches the roll and its requiredAttributes.
-- Rarity is decided by the slot; Supertype weights are set to the number of cards in each group, so every card of that
-- rarity is equally likely to be picked.
BOOSTER.SlotConfiguration = {
	-- Slots 1-4: Common Beasts (17 cards) and the occasional Common Item (2 cards)
	{
		attributeWeights = {
			Rarity = { Common = 1 },
			Supertype = { Beast = 17, Item = 2 },
		},
	},
	{
		attributeWeights = {
			Rarity = { Common = 1 },
			Supertype = { Beast = 17, Item = 2 },
		},
	},
	{
		attributeWeights = {
			Rarity = { Common = 1 },
			Supertype = { Beast = 17, Item = 2 },
		},
	},
	{
		attributeWeights = {
			Rarity = { Common = 1 },
			Supertype = { Beast = 17, Item = 2 },
		},
	},

	-- Slot 5: A guaranteed Supporter (all 3 are Common)
	{
		attributeWeights = {
			Rarity = { Common = 1 },
		},
		requiredAttributes = {
			Supertype = "Supporter",
		},
	},

	-- Slots 6-8: Uncommons (14 evolved Beasts and 3 Items)
	{
		attributeWeights = {
			Rarity = { Uncommon = 1 },
		},
	},
	{
		attributeWeights = {
			Rarity = { Uncommon = 1 },
		},
	},
	{
		attributeWeights = {
			Rarity = { Uncommon = 1 },
		},
	},

	-- Slot 9: A guaranteed Rare (17 final-evolution Beasts and 2 Items). 1 in 50 packs has a hidden Legendary here
	-- instead (Voltaris, Luxpaws, Umbramaw or the Legendary Corrupter), so each Legendary is roughly a 1 in 200 pull.
	{
		attributeWeights = {
			Rarity = { Rare = 49, Legendary = 1 },
		},
	},

	-- Slots 10-11: Basic Energy (one of each type possible)
	{
		attributeWeights = {
			Rarity = { Common = 1 },
		},
		requiredAttributes = {
			Supertype = "Energy",
		},
	},
	{
		attributeWeights = {
			Rarity = { Common = 1 },
		},
		requiredAttributes = {
			Supertype = "Energy",
		},
	},
}
