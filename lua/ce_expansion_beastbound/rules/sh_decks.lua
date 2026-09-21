-- The set's own starter decklist. It is what the rules checks run against and what the practice
-- opponent brings, so a list that drifts out of legality fails the self-test loudly.

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- The starter deck's 60 cards, following the set's deck rules and weighted towards Basic Beasts so
--- setup finds one without mulliganing
local STARTER_DECK_CARDS = {
	ce_expansion_beastbound_pyrecko = 4,
	ce_expansion_beastbound_emberaz = 4,
	ce_expansion_beastbound_infernecko = 4,
	ce_expansion_beastbound_turtling = 4,
	ce_expansion_beastbound_turterus = 4,
	ce_expansion_beastbound_starkrat = 4,
	ce_expansion_beastbound_chrysaloid = 4,
	ce_expansion_beastbound_spooklet = 4,
	ce_expansion_beastbound_minor_potion = 4,
	ce_expansion_beastbound_jane = 2,
	ce_expansion_beastbound_shane = 2,
	ce_expansion_beastbound_fire_energy = 12,
	ce_expansion_beastbound_nature_energy = 8,
}

--- Builds the starter deck in the shape Card Engine expects. A fresh copy each time, since a match
--- takes a deck apart.
--- @param deckID string? What to call it, for a caller that wants to tell two apart
--- @param name string? A language key naming it
--- @return table
--- @realm shared
function Beastbound.BuildStarterDeck(deckID, name)
	return {
		id = deckID or "ce_expansion_beastbound_starter",
		name = name or "ce_expansion_beastbound_deck_starter",
		expansion_set = Beastbound.EXPANSION_SET_ID,
		cards = table.Copy(STARTER_DECK_CARDS),
	}
end
