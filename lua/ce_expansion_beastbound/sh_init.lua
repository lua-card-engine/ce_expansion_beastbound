CardEngine = CardEngine or {}
CardEngine.ExpansionSets = CardEngine.ExpansionSets or {}
CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}
CardEngine.ExpansionSets.Beastbound.EXPANSION_SET_ID = "ce_expansion_beastbound"

hook.Add(
	"CardEngineInitializeExpansionSets",
	"CardEngine.Beastbound.InitializeExpansionSet",
	function()
		-- Register the expansion set with its metadata and filterable attributes
		CardEngine.ExpansionSet.Register({
			UniqueID = CardEngine.ExpansionSets.Beastbound.EXPANSION_SET_ID,
			Name = "expansion_set_ce_expansion_beastbound",
			RemoteDownloadURL = "https://card-engine-r2.luttonline.nl",

			-- Define which attributes should appear as filters in the collection menu
			FilterableAttributes = {
				Supertype = {
					Name = "collection_filter_supertype",
					AttributeName = "Supertype",
					IsArray = false,
				},
				Rarity = {
					Name = "collection_filter_rarity",
					AttributeName = "Rarity",
					IsArray = false,
				},
			},

			-- The rules decks built from this set must follow (see game-rules.md, "Deck construction").
			-- Card Engine uses these in the Decks tab, and to validate decks on the server.
			DeckRules = {
				MinCards = 60,
				MaxCards = 60,

				-- No more than 4 copies of any single named card...
				MaxCopies = 4,

				-- ...except for these
				CopyLimits = {
					{
						Name = "ce_expansion_beastbound_deck_rule_energy_unlimited",
						Attributes = { Supertype = "Energy" },
						MaxCopies = false, -- Unlimited
					},
					{
						Name = "ce_expansion_beastbound_deck_rule_legendary_limit",
						Attributes = { Rarity = "Legendary" },
						MaxCopies = 1,
					},
				},

				Requirements = {
					{
						Name = "ce_expansion_beastbound_deck_rule_needs_basic_beast",
						Attributes = { Supertype = "Beast", Stage = "Basic" },
						MinCards = 1,
					},
				},
			},
		})

		--------------------------------------------------------------------------------------
		--- Choose ONE of the following two methods to load cards for this expansion set. ---
		--------------------------------------------------------------------------------------

		-- Method 1: Load all cards from a directory of files
		CardEngine.Collection.IncludeDirectory(
			CardEngine.PathCombine("ce_expansion_beastbound", "cards/"),
			nil,
			-- Automatically inject the ExpansionSet property into all cards loaded from this expansion set
			function(fileName, cardFilePath)
				CARD.ExpansionSet = CardEngine.ExpansionSets.Beastbound.EXPANSION_SET_ID
			end
		)

		-- Method 2: Load all cards from a single file (recommended to reduce amount of files in the expansion set)
		-- Use tools/concat_cards.js to combine all card files into a single file for this method
		--[[
		local sharedFilePath = CardEngine.PathCombine("ce_expansion_beastbound", "cards/sh_all_cards.lua")
		AddCSLuaFile(sharedFilePath)
		local ALL_CARDS = include(sharedFilePath)

		CardEngine.Collection.IncludeRegistrations(
			ALL_CARDS,
			-- Automatically inject the ExpansionSet property into all cards loaded from this expansion set
			function(fileName, cardFilePath)
				CARD.ExpansionSet = CardEngine.ExpansionSets.Beastbound.EXPANSION_SET_ID
			end
		)
		--]]

		CardEngine.Booster.IncludeDirectory(
			CardEngine.PathCombine("ce_expansion_beastbound", "boosters/"),
			nil,
			function(fileName, boosterFilePath)
				BOOSTER.ExpansionSet = CardEngine.ExpansionSets.Beastbound.EXPANSION_SET_ID
			end
		)

		CardEngine.Language.IncludeDirectory(CardEngine.PathCombine("ce_expansion_beastbound", "languages/"))

		-- The rules of the game itself: zones, turns, actions, conditions and how it is presented.
		-- Registration is deferred until every file in here has loaded, so it does not matter which
		-- order the folder is read in.
		CardEngine.IncludeDirectory(CardEngine.PathCombine("ce_expansion_beastbound", "rules/"))

		CardEngine.ExpansionSets.Beastbound.RegisterGameRules()

		-- The practice opponent, so the game can be played without finding a second person.
		-- Server only: it reads the match itself rather than a filtered view of it.
		if (SERVER) then
			CardEngine.ExpansionSets.Beastbound.RegisterAI()
		end
	end
)
