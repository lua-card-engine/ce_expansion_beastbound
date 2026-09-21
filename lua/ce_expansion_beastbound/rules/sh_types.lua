-- Types, weakness, resistance and the damage formula (game-rules.md §2). Every type has exactly one
-- weakness and one resistance.

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

--- The damage a resisted attack loses
Beastbound.RESISTANCE_REDUCTION = 20

--- The six types, in the order the weakness cycle runs
Beastbound.TYPES = {
	"Fighting",
	"Fire",
	"Nature",
	"Water",
	"Electric",
	"Psychic",
}

--- Each type is beaten by the one before it in the cycle:
--- Fighting -> Fire -> Nature -> Water -> Electric -> Psychic -> back to Fighting
Beastbound.WEAKNESS = {
	Fire = "Fighting",
	Nature = "Fire",
	Water = "Nature",
	Electric = "Water",
	Psychic = "Electric",
	Fighting = "Psychic",
}

--- Three reciprocal pairs, deliberately unrelated to the weakness cycle
Beastbound.RESISTANCE = {
	Fire = "Electric",
	Electric = "Fire",
	Nature = "Psychic",
	Psychic = "Nature",
	Water = "Fighting",
	Fighting = "Water",
}

--- The colour each type is drawn in, used for energy pips, badges and the type chart
Beastbound.TYPE_COLORS = {
	Fire = Color(228, 96, 54),
	Nature = Color(108, 182, 82),
	Water = Color(70, 148, 214),
	Electric = Color(232, 194, 62),
	Psychic = Color(174, 104, 196),
	Fighting = Color(184, 106, 70),
}

--- The energy card that provides one unit of a type
Beastbound.TYPE_ENERGY_CARDS = {
	Fire = "ce_expansion_beastbound_fire_energy",
	Nature = "ce_expansion_beastbound_nature_energy",
	Water = "ce_expansion_beastbound_water_energy",
	Electric = "ce_expansion_beastbound_electric_energy",
	Psychic = "ce_expansion_beastbound_psychic_energy",
	Fighting = "ce_expansion_beastbound_fighting_energy",
}

--- The type a card is, if it has one
--- @param card CardEngine.Card?
--- @return string?
function Beastbound.GetType(card)
	return card and card:GetAttribute("Type")
end

--- Whether the attacking type is the defending type's weakness
--- @param attackingType string?
--- @param defendingType string?
--- @return boolean
function Beastbound.IsWeakTo(attackingType, defendingType)
	if (not attackingType or not defendingType) then
		return false
	end

	return Beastbound.WEAKNESS[defendingType] == attackingType
end

--- Whether the defending type resists the attacking type
--- @param attackingType string?
--- @param defendingType string?
--- @return boolean
function Beastbound.Resists(attackingType, defendingType)
	if (not attackingType or not defendingType) then
		return false
	end

	return Beastbound.RESISTANCE[defendingType] == attackingType
end

--- Works out how much damage an attack does: the printed damage, doubled for weakness, then 20 less
--- for resistance, never below zero. Weakness applies before resistance, so a 30-damage attack into
--- a Beast both weak and resistant does 40, not 20.
--- @param baseDamage number The attack's printed damage
--- @param attackingType string? The attacking Beast's type
--- @param defendingType string? The defending Beast's type
--- @return number damage # The damage after weakness and resistance
--- @return boolean wasWeak # Whether weakness applied, so the board can say so
--- @return boolean wasResisted # Whether resistance applied
function Beastbound.CalculateDamage(baseDamage, attackingType, defendingType)
	local damage = baseDamage
	local wasWeak = false
	local wasResisted = false

	-- An attack that does no damage stays at nothing, and resistance isn't reported on it
	if (damage <= 0) then
		return 0, false, false
	end

	if (Beastbound.IsWeakTo(attackingType, defendingType)) then
		damage = damage * 2
		wasWeak = true
	end

	if (Beastbound.Resists(attackingType, defendingType)) then
		damage = damage - Beastbound.RESISTANCE_REDUCTION
		wasResisted = true
	end

	return math.max(0, damage), wasWeak, wasResisted
end
