local E, L, V, P, G = unpack(select(2, ...))
local THREAT = E:GetModule("Threat")
local DT = E:GetModule("DataTexts")
local LSM = E.Libs.LSM

local pairs, select = pairs, select
local wipe = wipe

local CreateFrame = CreateFrame
local UnitReaction = UnitReaction
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local GetNumPartyMembers, GetNumRaidMembers = GetNumPartyMembers, GetNumRaidMembers
local UnitExists = UnitExists
local UnitName = UnitName
local UnitIsUnit = UnitIsUnit
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local GetThreatStatusColor = GetThreatStatusColor
local UNKNOWN = UNKNOWN

THREAT.list = {}

function THREAT:UpdatePosition()
	if self.db.position == "RIGHTCHAT" then
		self.bar:SetInside(RightChatDataPanel)
		self.bar:SetParent(RightChatDataPanel)
	else
		self.bar:SetInside(LeftChatDataPanel)
		self.bar:SetParent(LeftChatDataPanel)
	end

	self.bar.text:FontTemplate(LSM:Fetch("font", self.db.textfont), self.db.textSize, self.db.textOutline)
	self.bar:SetFrameStrata("MEDIUM")
end

function THREAT:GetLargestThreatOnList(percent)
	local largestValue, largestUnit = 0, nil
	for unit, threatPercent in pairs(self.list) do
		if threatPercent > largestValue then
			largestValue = threatPercent
			largestUnit = unit
		end
	end

	return (percent - largestValue), largestUnit
end

function THREAT:GetColor(unit)
	local unitReaction = UnitReaction(unit, "player")
	local _, unitClass = UnitClass(unit)
	if UnitIsPlayer(unit) then
		local class = E:ClassColor(unitClass)
		if not class then return 194, 194, 194 end
		return class.r * 255, class.g * 255, class.b * 255
	elseif unitReaction then
		local reaction = ElvUF.colors.reaction[unitReaction]
		return reaction[1] * 255, reaction[2] * 255, reaction[3] * 255
	else
		return 194, 194, 194
	end
end

function THREAT:Update()
	if DT and DT.ShowingBGStats then
		if self.bar:IsShown() then
			self.bar:Hide()
		end

		return
	end

	local isInParty, isInRaid, petExists = GetNumPartyMembers(), GetNumRaidMembers(), select(1, HasPetUI())
	local _, status, percent = UnitDetailedThreatSituation("player", "target")
	if percent and percent > 0 and (isInParty > 0 or petExists == 1) then
		local name = UnitName("target")
		self.bar:Show()
		if percent == 100 then
			--Build threat list
			if petExists == 1 then
				self.list.pet = select(3, UnitDetailedThreatSituation("pet", "target"))
			end

			if isInRaid > 0 then
				for i = 1, 40 do
					if UnitExists("raid"..i) and not UnitIsUnit("raid"..i, "player") then
						self.list["raid"..i] = select(3, UnitDetailedThreatSituation("raid"..i, "target"))
					end
				end
			else
				for i = 1, 4 do
					if UnitExists("party"..i) then
						self.list["party"..i] = select(3, UnitDetailedThreatSituation("party"..i, "target"))
					end
				end
			end

			local leadPercent, largestUnit = self:GetLargestThreatOnList(percent)
			if leadPercent > 0 and largestUnit ~= nil then
				local r, g, b = self:GetColor(largestUnit)
				self.bar.text:SetFormattedText(L["ABOVE_THREAT_FORMAT"], name, percent, leadPercent, r, g, b, UnitName(largestUnit) or UNKNOWN)

				if E.role == "Tank" then
					self.bar:SetStatusBarColor(0, 0.839, 0)
					self.bar:SetValue(leadPercent)
				else
					self.bar:SetStatusBarColor(GetThreatStatusColor(status))
					self.bar:SetValue(percent)
				end
			else
				self.bar:SetStatusBarColor(GetThreatStatusColor(status))
				self.bar.text:SetFormattedText("%s: %.0f%%", name, percent)
				self.bar:SetValue(percent)
			end
		else
			self.bar:SetStatusBarColor(GetThreatStatusColor(status))
			self.bar.text:SetFormattedText("%s: %.0f%%", name, percent)
			self.bar:SetValue(percent)
		end
	else
		self.bar:Hide()
	end

	wipe(self.list)
end

function THREAT:ToggleEnable()
	if self.db.enable then
		self:RegisterEvent("PLAYER_TARGET_CHANGED", "Update")
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", "Update")
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", "Update")
		self:RegisterEvent("RAID_ROSTER_UPDATE", "Update")
		self:RegisterEvent("UNIT_PET", "Update")
		self:Update()
	else
		self.bar:Hide()
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("UNIT_THREAT_LIST_UPDATE")
		self:UnregisterEvent("PARTY_MEMBERS_CHANGED")
		self:UnregisterEvent("RAID_ROSTER_UPDATE")
		self:UnregisterEvent("UNIT_PET")
	end
end

function THREAT:Initialize()
	self.Initialized = true
	self.db = E.db.general.threat

	self.bar = CreateFrame("StatusBar", "ElvUI_ThreatBar", E.UIParent)
	self.bar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(self.bar)
	self.bar:SetMinMaxValues(0, 100)
	self.bar:CreateBackdrop("Default", true)

	self.bar.text = self.bar:CreateFontString(nil, "OVERLAY")
	self.bar.text:FontTemplate(self.db.textfont, self.db.textSize, self.db.textOutline)
	self.bar.text:Point("CENTER", self.bar, "CENTER")

	self:UpdatePosition()
	self:ToggleEnable()
end

local function InitializeCallback()
	THREAT:Initialize()
end

E:RegisterModule(THREAT:GetName(), InitializeCallback)