--[[
	Beastbound's own decklists

	A deck the set brings itself, rather than one a player built. There is exactly one so far, and it
	has two jobs: it is what the rules checks are run against, and it is what the practice opponent
	brings to a match.

	Those two jobs are the reason it lives here rather than in either of them. A decklist that drifts
	out of legality should fail the self-test, loudly and at a known line, rather than quietly giving
	the AI a deck it cannot open a game with.
--]]

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- The cards in the starter deck: 60 of them, following the set's own deck rules, and weighted
--- towards Basic Beasts so that setup finds one to start with rather than mulliganing its way there.
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

--- Builds the starter deck, in the shape Card Engine expects a deck in.
---
--- A fresh copy each time, since a match takes a deck apart into card instances and nothing should
--- be able to reach back and change the list it was built from.
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
