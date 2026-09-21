-- Beastbound's animations, kept apart because they are the bulk of the presentation and the part
-- with a contract: a presenter is handed the board, the event and a function to call when done.
-- Until it does, the next event waits, so a coin lands before the damage it caused.

CardEngine.ExpansionSets.Beastbound = CardEngine.ExpansionSets.Beastbound or {}

local Beastbound = CardEngine.ExpansionSets.Beastbound

local MATERIAL_PATH = "card_engine/expansions/ce_expansion_beastbound/"

--- Loaded once rather than every frame
local coinFaces = {
	[1] = Material(MATERIAL_PATH .. "coin_heads.png", "smooth"),
	[2] = Material(MATERIAL_PATH .. "coin_tails.png", "smooth"),
}

--- How long one coin spins before it settles, in seconds
local COIN_SPIN_TIME = 0.75

--- How long a settled coin is left on screen
local COIN_HOLD_TIME = 0.6

--- How long a damage number floats for
local DAMAGE_FLOAT_TIME = 0.9

--- Finds the panel showing a card instance, so an animation can happen where the card is
--- @param board Panel
--- @param instanceID number?
--- @return Panel?
local function findCardPanel(board, instanceID)
	if (not instanceID or not board.zonePanels) then
		return nil
	end

	for _, info in ipairs(board.zonePanels) do
		if (IsValid(info.panel)) then
			for _, slot in pairs(info.panel:GetSlots()) do
				if (IsValid(slot) and slot:GetInstanceID() == instanceID) then
					return slot
				end
			end
		end
	end

	return nil
end

--- @param board Panel
--- @param results number[] Each flip, where 1 is heads and 2 is tails
--- @param label string? A language key saying what the flip was for
--- @param finished fun()
local function playCoinFlip(board, results, label, finished)
	local overlay = vgui.Create("EditablePanel", board)
	overlay:SetSize(board:GetWide(), board:GetTall())
	overlay:SetPos(0, 0)
	overlay:SetMouseInputEnabled(false)

	local startedAt = SysTime()
	local count = #results
	local spinTime = COIN_SPIN_TIME
	local totalTime = spinTime + COIN_HOLD_TIME

	overlay.Paint = function(_, w, h)
		local elapsed = SysTime() - startedAt
		local settled = elapsed >= spinTime

		local size = math.min(w, h) * 0.12
		local spacing = size * 1.25
		local totalWidth = count * size + (count - 1) * (spacing - size)
		local x = (w - totalWidth) * 0.5
		local y = h * 0.4

		-- A dim wash, so the coin reads against what is behind it
		surface.SetDrawColor(0, 0, 0, math.min(150, elapsed * 400))
		surface.DrawRect(0, 0, w, h)

		for index = 1, count do
			local face = results[index]

			-- While it spins the face flickers; once settled it is the real result
			if (not settled) then
				face = (math.floor(elapsed * 18) + index) % 2 + 1
			end

			-- Squashed sideways to suggest a coin turning over
			local squash = settled and 1 or math.abs(math.cos(elapsed * 18 + index))
			local drawWidth = math.max(2, size * squash)

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(coinFaces[face] or coinFaces[1])
			surface.DrawTexturedRect(x + (index - 1) * spacing + (size - drawWidth) * 0.5, y,
				drawWidth, size)
		end

		if (label and label ~= "") then
			draw.SimpleText(CardEngine.T(label), "CardEngineMainSmall", w * 0.5, y + size + 10,
				Color(235, 235, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		if (settled) then
			local text = {}

			for _, result in ipairs(results) do
				table.insert(text, CardEngine.T(result == 1 and "match_coin_heads" or "match_coin_tails"))
			end

			draw.SimpleText(table.concat(text, ", "), "CardEngineMainMedium", w * 0.5, y - 14,
				Color(255, 235, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
	end

	-- The queue is released exactly once: by finished, or by the watchdog if that never comes
	timer.Simple(totalTime, function()
		if (IsValid(overlay)) then
			overlay:Remove()
		end

		finished()
	end)
end

--- Floats a damage number off the Beast that took it
--- @param board Panel
--- @param event table
--- @param finished fun()
local function playDamage(board, event, finished)
	local target = findCardPanel(board, event.instance)

	if (not IsValid(target) or event.amount <= 0) then
		finished()
		return
	end

	local x, y = target:GetPos()
	local parent = target:GetParent()

	local float = vgui.Create("EditablePanel", parent)
	float:SetSize(target:GetWide(), 30)
	float:SetPos(x, y)
	float:SetMouseInputEnabled(false)

	local startedAt = SysTime()

	local suffix = ""

	if (event.weak) then
		suffix = " " .. CardEngine.T("ce_expansion_beastbound_weak_marker")
	elseif (event.resisted) then
		suffix = " " .. CardEngine.T("ce_expansion_beastbound_resisted_marker")
	end

	float.Paint = function(panel, w, h)
		local progress = math.min(1, (SysTime() - startedAt) / DAMAGE_FLOAT_TIME)

		panel:SetPos(x, y - progress * 24)

		draw.SimpleText("-" .. event.amount .. suffix, "CardEngineMainSmall", w * 0.5, h * 0.5,
			Color(240, 90, 90, 255 * (1 - progress)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	timer.Simple(DAMAGE_FLOAT_TIME, function()
		if (IsValid(float)) then
			float:Remove()
		end

		finished()
	end)
end

-- Added to the presentation registered by cl_presentation.lua, which loads first

local presentation = CardEngine.GameRules.GetPresentation(Beastbound.EXPANSION_SET_ID)

if (presentation) then
	presentation.Events = {
		--- Only coins are dressed up; anything else returns false and gets Card Engine's own log line
		random = function(board, event, finished)
			if (event.method ~= "coin") then
				return false
			end

			playCoinFlip(board, event.results or {}, event.label, finished)
		end,

		beastbound_damage = playDamage,
	}
end
