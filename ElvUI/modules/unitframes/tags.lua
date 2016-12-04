local E, L, V, P, G = unpack(select(2, ...));
local _, ns = ...
local ElvUF = ns.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

local _G = _G;
local floor = math.floor;
local format = string.format;

local GetTime = GetTime;
local UnitGUID = UnitGUID;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;
local UnitIsAFK = UnitIsAFK;
local UnitIsDeadOrGhost = UnitIsDeadOrGhost;
local UnitIsConnected = UnitIsConnected;
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local UnitIsDead = UnitIsDead;
local UnitIsGhost = UnitIsGhost;
local UnitPowerType = UnitPowerType;
local UnitLevel = UnitLevel;
local GetQuestGreenRange = GetQuestGreenRange;
local UnitReaction = UnitReaction;
local UnitClass = UnitClass;
local UnitIsPlayer = UnitIsPlayer;
local UnitDetailedThreatSituation = UnitDetailedThreatSituation;
local UnitExists = UnitExists;
local GetThreatStatusColor = GetThreatStatusColor;
local UnitIsDND = UnitIsDND;
local UnitIsPVPFreeForAll = UnitIsPVPFreeForAll;
local UnitIsPVP = UnitIsPVP;
local GetPVPTimer = GetPVPTimer;
local GetShapeshiftFormID = GetShapeshiftFormID;
local GetEclipseDirection = GetEclipseDirection;
local UnitGetIncomingHeals = UnitGetIncomingHeals;
local GetNumPartyMembers = GetNumPartyMembers;
local UnitClassification = UnitClassification;
local GetUnitSpeed = GetUnitSpeed;
local DEFAULT_AFK_MESSAGE = DEFAULT_AFK_MESSAGE;
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER;
local ALTERNATE_POWER_INDEX = ALTERNATE_POWER_INDEX
local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE;
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS;
local MOONKIN_FORM = MOONKIN_FORM;
local PVP = PVP;

------------------------------------------------------------------------
--	Tags
------------------------------------------------------------------------

ElvUF.Tags.Events['altpower:percent'] = "UNIT_POWER UNIT_MAXPOWER"
ElvUF.Tags.Methods['altpower:percent'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	if cur > 0 then
		local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)

		return E:GetFormattedText('PERCENT', cur, max)
	else
		return ''
	end
end

ElvUF.Tags.Events['altpower:current'] = "UNIT_POWER"
ElvUF.Tags.Methods['altpower:current'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	if cur > 0 then
		return cur
	else
		return ''
	end
end

ElvUF.Tags.Events['altpower:current-percent'] = "UNIT_POWER UNIT_MAXPOWER"
ElvUF.Tags.Methods['altpower:current-percent'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	if cur > 0 then
		local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)

		return E:GetFormattedText('CURRENT_PERCENT', cur, max)
	else
		return ''
	end
end

ElvUF.Tags.Events['altpower:deficit'] = "UNIT_POWER UNIT_MAXPOWER"
ElvUF.Tags.Methods['altpower:deficit'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	if cur > 0 then
		local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)

		return E:GetFormattedText('DEFICIT', cur, max)
	else
		return ''
	end
end

ElvUF.Tags.Events['altpower:current-max'] = "UNIT_POWER UNIT_MAXPOWER"
ElvUF.Tags.Methods['altpower:current-max'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	if cur > 0 then
		local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)

		return E:GetFormattedText('CURRENT_MAX', cur, max)
	else
		return ''
	end
end

ElvUF.Tags.Events['altpower:current-max-percent'] = "UNIT_POWER UNIT_MAXPOWER"
ElvUF.Tags.Methods['altpower:current-max-percent'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	if cur > 0 then
		local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)

		return E:GetFormattedText('CURRENT_MAX_PERCENT', cur, max)
	else
		return ''
	end
end

ElvUF.Tags.Events['altpowercolor'] = "UNIT_POWER UNIT_MAXPOWER"
ElvUF.Tags.Methods['altpowercolor'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	if cur > 0 then
		local tPath, r, g, b = UnitAlternatePowerTextureInfo(u, 2)

		if not r then
			r, g, b = 1, 1, 1
		end

		return Hex(r,g,b)
	else
		return ''
	end
end

ElvUF.Tags.Events['afk'] = 'PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['afk'] = function(unit)
	local isAFK = UnitIsAFK(unit)
	if isAFK then
		return ('|cffFFFFFF[|r|cffFF0000%s|r|cFFFFFFFF]|r'):format(DEFAULT_AFK_MESSAGE)
	else
		return ''
	end
end

ElvUF.Tags.Events['healthcolor'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['healthcolor'] = function(unit)
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return Hex(0.84, 0.75, 0.65)
	else
		local r, g, b = ElvUF.ColorGradient(UnitHealth(unit), UnitHealthMax(unit), 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
		return Hex(r, g, b)
	end
end

ElvUF.Tags.Events['health:current'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:current'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	if (status) then
		return status
	else
		return E:GetFormattedText('CURRENT', UnitHealth(unit), UnitHealthMax(unit))
	end
end

ElvUF.Tags.Events['health:deficit'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:deficit'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return E:GetFormattedText('DEFICIT', UnitHealth(unit), UnitHealthMax(unit))
	end
end

ElvUF.Tags.Events['health:current-percent'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:current-percent'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return E:GetFormattedText('CURRENT_PERCENT', UnitHealth(unit), UnitHealthMax(unit))
	end
end

ElvUF.Tags.Events['health:current-max'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:current-max'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return E:GetFormattedText('CURRENT_MAX', UnitHealth(unit), UnitHealthMax(unit))
	end
end

ElvUF.Tags.Events['health:current-max-percent'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:current-max-percent'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return E:GetFormattedText('CURRENT_MAX_PERCENT', UnitHealth(unit), UnitHealthMax(unit))
	end
end

ElvUF.Tags.Events['health:max'] = 'UNIT_MAXHEALTH'
ElvUF.Tags.Methods['health:max'] = function(unit)
	local max = UnitHealthMax(unit)

	return E:GetFormattedText('CURRENT', max, max)
end

ElvUF.Tags.Events['health:percent'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['health:percent'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return E:GetFormattedText('PERCENT', UnitHealth(unit), UnitHealthMax(unit))
	end
end

ElvUF.Tags.Events['health:current-nostatus'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'
ElvUF.Tags.Methods['health:current-nostatus'] = function(unit)
	return E:GetFormattedText('CURRENT', UnitHealth(unit), UnitHealthMax(unit))
end

ElvUF.Tags.Events['health:deficit-nostatus'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'
ElvUF.Tags.Methods['health:deficit-nostatus'] = function(unit)
	return E:GetFormattedText('DEFICIT', UnitHealth(unit), UnitHealthMax(unit))
end

ElvUF.Tags.Events['health:current-percent-nostatus'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'
ElvUF.Tags.Methods['health:current-percent-nostatus'] = function(unit)
	return E:GetFormattedText('CURRENT_PERCENT', UnitHealth(unit), UnitHealthMax(unit))
end

ElvUF.Tags.Events['health:current-max-nostatus'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'
ElvUF.Tags.Methods['health:current-max-nostatus'] = function(unit)
	return E:GetFormattedText('CURRENT_MAX', UnitHealth(unit), UnitHealthMax(unit))
end

ElvUF.Tags.Events['health:current-max-percent-nostatus'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'
ElvUF.Tags.Methods['health:current-max-percent-nostatus'] = function(unit)
	return E:GetFormattedText('CURRENT_MAX_PERCENT', UnitHealth(unit), UnitHealthMax(unit))
end

ElvUF.Tags.Events['health:percent-nostatus'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'
ElvUF.Tags.Methods['health:percent-nostatus'] = function(unit)
	return E:GetFormattedText('PERCENT', UnitHealth(unit), UnitHealthMax(unit))
end

ElvUF.Tags.Events['health:deficit-percent:name'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['health:deficit-percent:name'] = function(unit)
	local currentHealth = UnitHealth(unit)
	local deficit = UnitHealthMax(unit) - currentHealth

	if (deficit > 0 and currentHealth > 0) then
		return _TAGS["health:percent-nostatus"](unit)
	else
		return _TAGS["name"](unit)
	end
end

ElvUF.Tags.Events['powercolor'] = 'UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['powercolor'] = function(unit)
	local _, pToken, altR, altG, altB = UnitPowerType(unit)
	local color = ElvUF['colors'].power[pToken]
	if color then
		return Hex(color[1], color[2], color[3])
	else
		return Hex(altR, altG, altB)
	end
end

ElvUF.Tags.Events['power:current'] = 'UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:current'] = function(unit)
	local pType = UnitPowerType(unit)
	local min = UnitPower(unit, pType)

	return min == 0 and ' ' or	E:GetFormattedText('CURRENT', min, UnitPowerMax(unit, pType))
end

ElvUF.Tags.Events['power:current-max'] = 'UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:current-max'] = function(unit)
	local pType = UnitPowerType(unit)
	local min = UnitPower(unit, pType)

	return min == 0 and ' ' or	E:GetFormattedText('CURRENT_MAX', min, UnitPowerMax(unit, pType))
end

ElvUF.Tags.Events['power:current-percent'] = 'UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:current-percent'] = function(unit)
	local pType = UnitPowerType(unit)
	local min = UnitPower(unit, pType)

	return min == 0 and ' ' or	E:GetFormattedText('CURRENT_PERCENT', min, UnitPowerMax(unit, pType))
end

ElvUF.Tags.Events['power:current-max-percent'] = 'UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:current-max-percent'] = function(unit)
	local pType = UnitPowerType(unit)
	local min = UnitPower(unit, pType)

	return min == 0 and ' ' or	E:GetFormattedText('CURRENT_MAX_PERCENT', min, UnitPowerMax(unit, pType))
end

ElvUF.Tags.Events['power:percent'] = 'UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:percent'] = function(unit)
	local pType = UnitPowerType(unit)
	local min = UnitPower(unit, pType)

	return min == 0 and ' ' or	E:GetFormattedText('PERCENT', min, UnitPowerMax(unit, pType))
end

ElvUF.Tags.Events['power:deficit'] = 'UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:deficit'] = function(unit)
	local pType = UnitPowerType(unit)

	return E:GetFormattedText('DEFICIT', UnitPower(unit, pType), UnitPowerMax(unit, pType))
end

ElvUF.Tags.Events['power:max'] = 'UNIT_DISPLAYPOWER UNIT_MAXPOWER'
ElvUF.Tags.Methods['power:max'] = function(unit)
	local max = UnitPowerMax(unit, UnitPowerType(unit))

	return E:GetFormattedText('CURRENT', max, max)
end

ElvUF.Tags.Events['difficultycolor'] = 'UNIT_LEVEL PLAYER_LEVEL_UP'
ElvUF.Tags.Methods['difficultycolor'] = function(unit)
	local r, g, b = 0.69, 0.31, 0.31
	local level = UnitLevel(unit)
	if (level > 1) then
		local DiffColor = UnitLevel(unit) - UnitLevel("player")
		if (DiffColor >= 5) then
			r, g, b = 0.69, 0.31, 0.31
		elseif (DiffColor >= 3) then
			r, g, b = 0.71, 0.43, 0.27
		elseif (DiffColor >= -2) then
			r, g, b = 0.84, 0.75, 0.65
		elseif (-DiffColor <= GetQuestGreenRange()) then
			r, g, b = 0.33, 0.59, 0.33
		else
			r, g, b = 0.55, 0.57, 0.61
		end
	end

	return Hex(r, g, b)
end

ElvUF.Tags.Events['namecolor'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['namecolor'] = function(unit)
	local unitReaction = UnitReaction(unit, 'player')
	local _, unitClass = UnitClass(unit)
	if (UnitIsPlayer(unit)) then
		local class = ElvUF.colors.class[unitClass]
		if not class then return "" end
		return Hex(class[1], class[2], class[3])
	elseif (unitReaction) then
		local reaction = ElvUF['colors'].reaction[unitReaction]
		return Hex(reaction[1], reaction[2], reaction[3])
	else
		return '|cFFC2C2C2'
	end
end

ElvUF.Tags.Events['smartlevel'] = 'UNIT_LEVEL PLAYER_LEVEL_UP'
ElvUF.Tags.Methods['smartlevel'] = function(unit)
	local level = UnitLevel(unit)
	if level == UnitLevel("player") then
		return ""
	elseif(level > 0) then
		return level
	else
		return "??"
	end
end

ElvUF.Tags.Events['name:veryshort'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['name:veryshort'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and E:ShortenString(name, 5) or ''
end

ElvUF.Tags.Events['name:short'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['name:short'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and E:ShortenString(name, 10) or ''
end

ElvUF.Tags.Events['name:medium'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['name:medium'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and E:ShortenString(name, 15) or ''
end

ElvUF.Tags.Events['name:long'] = 'UNIT_NAME_UPDATE'
ElvUF.Tags.Methods['name:long'] = function(unit)
	local name = UnitName(unit)
	return name ~= nil and E:ShortenString(name, 20) or ''
end

ElvUF.Tags.Events['name:veryshort:status'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH'
ElvUF.Tags.Methods['name:veryshort:status'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	local name = UnitName(unit)
	if (status) then
		return status
	else
		return name ~= nil and E:ShortenString(name, 5) or ''
	end
end

ElvUF.Tags.Events['name:short:status'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH'
ElvUF.Tags.Methods['name:short:status'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	local name = UnitName(unit)
	if (status) then
		return status
	else
		return name ~= nil and E:ShortenString(name, 10) or ''
	end
end

ElvUF.Tags.Events['name:medium:status'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH'
ElvUF.Tags.Methods['name:medium:status'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	local name = UnitName(unit)
	if (status) then
		return status
	else
		return name ~= nil and E:ShortenString(name, 15) or ''
	end
end

ElvUF.Tags.Events['name:long:status'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_HEALTH'
ElvUF.Tags.Methods['name:long:status'] = function(unit)
	local status = UnitIsDead(unit) and L["Dead"] or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]
	local name = UnitName(unit)
	if (status) then
		return status
	else
		return name ~= nil and E:ShortenString(name, 20) or ''
	end
end

ElvUF.Tags.Events["threat:percent"] = 'UNIT_THREAT_LIST_UPDATE'
ElvUF.Tags.Methods["threat:percent"] = function(unit)
	local _, _, percent = UnitDetailedThreatSituation("player", unit)
	if(percent and percent > 0) and (GetNumPartyMembers() or UnitExists("pet")) then
		return format("%.0f%%", percent)
	else 
		return ""
	end
end

ElvUF.Tags.Events["threat:current"] = "UNIT_THREAT_LIST_UPDATE"
ElvUF.Tags.Methods["threat:current"] = function(unit)
	local _, _, percent, _, threatvalue = UnitDetailedThreatSituation("player", unit)
	if(percent and percent > 0) and (GetNumPartyMembers() or UnitExists("pet")) then
		return E:ShortValue(threatvalue)
	else 
		return ""
	end
end

ElvUF.Tags.Events["threatcolor"] = "UNIT_THREAT_LIST_UPDATE"
ElvUF.Tags.Methods["threatcolor"] = function(unit)
	local _, status = UnitDetailedThreatSituation("player", unit)
	if (status) and (GetNumPartyMembers() or UnitExists("pet")) then
		return Hex(GetThreatStatusColor(status))
	else 
		return ""
	end
end

local unitStatus = {}
ElvUF.Tags.OnUpdateThrottle["statustimer"] = 1
ElvUF.Tags.Methods["statustimer"] = function(unit)
	if not UnitIsPlayer(unit) then return; end
	local guid = UnitGUID(unit)
	if (UnitIsAFK(unit)) then
		if not unitStatus[guid] or unitStatus[guid] and unitStatus[guid][1] ~= 'AFK' then
			unitStatus[guid] = {'AFK', GetTime()}
		end
	elseif(UnitIsDND(unit)) then
		if not unitStatus[guid] or unitStatus[guid] and unitStatus[guid][1] ~= 'DND' then
			unitStatus[guid] = {'DND', GetTime()}
		end
	elseif(UnitIsDead(unit)) or (UnitIsGhost(unit))then
		if not unitStatus[guid] or unitStatus[guid] and unitStatus[guid][1] ~= 'Dead' then
			unitStatus[guid] = {'Dead', GetTime()}
		end
	elseif(not UnitIsConnected(unit)) then
		if not unitStatus[guid] or unitStatus[guid] and unitStatus[guid][1] ~= 'Offline' then
			unitStatus[guid] = {'Offline', GetTime()}
		end
	else
		unitStatus[guid] = nil
	end

	if unitStatus[guid] ~= nil then
		local status = unitStatus[guid][1]
		local timer = GetTime() - unitStatus[guid][2]
		local mins = floor(timer / 60)
		local secs = floor(timer - (mins * 60))
		return ("%s (%01.f:%02.f)"):format(status, mins, secs)
	else
		return ""
	end
end

ElvUF.Tags.OnUpdateThrottle['pvptimer'] = 1
ElvUF.Tags.Methods['pvptimer'] = function(unit)
	if (UnitIsPVPFreeForAll(unit) or UnitIsPVP(unit)) then
		local timer = GetPVPTimer()

		if timer ~= 301000 and timer ~= -1 then
			local mins = floor((timer / 1000) / 60)
			local secs = floor((timer / 1000) - (mins * 60))
			return ("%s (%01.f:%02.f)"):format(PVP, mins, secs)
		else
			return PVP
		end
	else
		return ""
	end
end

local function GetClassPower(class)
	local min, max, r, g, b = 0, 0, 0, 0, 0
	if class == 'PALADIN' then
		min = UnitPower('player', SPELL_POWER_HOLY_POWER);
		max = UnitPowerMax('player', SPELL_POWER_HOLY_POWER);
		r, g, b = 228/255, 225/255, 16/255
	elseif class == 'DRUID' and GetShapeshiftFormID() == MOONKIN_FORM then
		min = UnitPower('player', SPELL_POWER_ECLIPSE)
		max = UnitPowerMax('player', SPELL_POWER_ECLIPSE)
		if GetEclipseDirection() == 'moon' then
			r, g, b = .80, .82,  .60
		else
			r, g, b = .30, .52, .90
		end
	elseif class == 'WARLOCK' then
		min = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
		max = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)
		r, g, b = 148/255, 130/255, 201/255
	end

	return min, max, r, g, b
end

ElvUF.Tags.Events['classpowercolor'] = 'UNIT_POWER_FREQUENT PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM'
ElvUF.Tags.Methods['classpowercolor'] = function()
	local _, _, r, g, b = GetClassPower(E.myclass)
	return Hex(r, g, b)
end

ElvUF.Tags.Events['classpower:current'] = 'UNIT_POWER_FREQUENT PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM'
ElvUF.Tags.Methods['classpower:current'] = function()
	local min, max = GetClassPower(E.myclass)
	if min == 0 then
		return ' '
	else
		return E:GetFormattedText('CURRENT', min, max)
	end
end

ElvUF.Tags.Events['classpower:deficit'] = 'UNIT_POWER_FREQUENT PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM'
ElvUF.Tags.Methods['classpower:deficit'] = function()
	local min, max = GetClassPower(E.myclass)
	if min == 0 then
		return ' '
	else
		return E:GetFormattedText('DEFICIT', min, max)
	end
end

ElvUF.Tags.Events['classpower:current-percent'] = 'UNIT_POWER_FREQUENT PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM'
ElvUF.Tags.Methods['classpower:current-percent'] = function()
	local min, max = GetClassPower(E.myclass)
	if min == 0 then
		return ' '
	else
		return E:GetFormattedText('CURRENT_PERCENT', min, max)
	end
end

ElvUF.Tags.Events['classpower:current-max'] = 'UNIT_POWER_FREQUENT PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM'
ElvUF.Tags.Methods['classpower:current-max'] = function()
	local min, max = GetClassPower(E.myclass)
	if min == 0 then
		return ' '
	else
		return E:GetFormattedText('CURRENT_MAX', min, max)
	end
end

ElvUF.Tags.Events['classpower:current-max-percent'] = 'UNIT_POWER_FREQUENT PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM'
ElvUF.Tags.Methods['classpower:current-max-percent'] = function()
	local min, max = GetClassPower(E.myclass)
	if min == 0 then
		return ' '
	else
		return E:GetFormattedText('CURRENT_MAX_PERCENT', min, max)
	end
end

ElvUF.Tags.Events['classpower:percent'] = 'UNIT_POWER_FREQUENT PLAYER_TALENT_UPDATE UPDATE_SHAPESHIFT_FORM'
ElvUF.Tags.Methods['classpower:percent'] = function()
	local min, max = GetClassPower(E.myclass)
	if min == 0 then
		return ' '
	else
		return E:GetFormattedText('PERCENT', min, max)
	end
end

ElvUF.Tags.Events['incomingheals:personal'] = 'UNIT_HEAL_PREDICTION'
ElvUF.Tags.Methods['incomingheals:personal'] = function(unit)
	local heal = UnitGetIncomingHeals(unit, 'player') or 0
	if heal == 0 then
		return ' '
	else
		return E:ShortValue(heal)
	end
end

ElvUF.Tags.Events['incomingheals:others'] = 'UNIT_HEAL_PREDICTION'
ElvUF.Tags.Methods['incomingheals:others'] = function(unit)
	local heal = UnitGetIncomingHeals(unit) or 0
	if heal == 0 then
		return ' '
	else
		return E:ShortValue(heal)
	end
end

ElvUF.Tags.Events['incomingheals'] = 'UNIT_HEAL_PREDICTION'
ElvUF.Tags.Methods['incomingheals'] = function(unit)
	local personal = UnitGetIncomingHeals(unit, 'player') or 0
	local others = UnitGetIncomingHeals(unit) or 0
	local heal = personal + others
	if heal == 0 then
		return ' '
	else
		return E:ShortValue(heal)
	end
end

local baseSpeed = 7;
local speedText = SPEED;

ElvUF.Tags.OnUpdateThrottle['speed:percent'] = 0.1
ElvUF.Tags.Methods['speed:percent'] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)
	local currentSpeedInPercent = (currentSpeedInYards / baseSpeed) * 100

	return format("%s: %d%%", speedText, currentSpeedInPercent)
end

ElvUF.Tags.OnUpdateThrottle['speed:percent-moving'] = 0.1
ElvUF.Tags.Methods['speed:percent-moving'] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)
	local currentSpeedInPercent = currentSpeedInYards > 0 and ((currentSpeedInYards / baseSpeed) * 100)

	if currentSpeedInPercent then
		currentSpeedInPercent = format("%s: %d%%", speedText, currentSpeedInPercent)
	end

	return currentSpeedInPercent or ''
end

ElvUF.Tags.OnUpdateThrottle['speed:percent-raw'] = 0.1
ElvUF.Tags.Methods['speed:percent-raw'] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)
	local currentSpeedInPercent = (currentSpeedInYards / baseSpeed) * 100

	return format("%d%%", currentSpeedInPercent)
end

ElvUF.Tags.OnUpdateThrottle['speed:percent-moving-raw'] = 0.1
ElvUF.Tags.Methods['speed:percent-moving-raw'] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)
	local currentSpeedInPercent = currentSpeedInYards > 0 and ((currentSpeedInYards / baseSpeed) * 100)

	if currentSpeedInPercent then
		currentSpeedInPercent = format("%d%%", currentSpeedInPercent)
	end

	return currentSpeedInPercent or ''
end

ElvUF.Tags.OnUpdateThrottle['speed:yardspersec'] = 0.1
ElvUF.Tags.Methods['speed:yardspersec'] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)

	return format("%s: %.1f", speedText, currentSpeedInYards)
end

ElvUF.Tags.OnUpdateThrottle['speed:yardspersec-moving'] = 0.1
ElvUF.Tags.Methods['speed:yardspersec-moving'] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)

	return currentSpeedInYards > 0 and format("%s: %.1f", speedText, currentSpeedInYards) or ''
end

ElvUF.Tags.OnUpdateThrottle['speed:yardspersec-raw'] = 0.1
ElvUF.Tags.Methods['speed:yardspersec-raw'] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)
	return format("%.1f", currentSpeedInYards)
end

ElvUF.Tags.OnUpdateThrottle['speed:yardspersec-moving-raw'] = 0.1
ElvUF.Tags.Methods['speed:yardspersec-moving-raw'] = function(unit)
	local currentSpeedInYards = GetUnitSpeed(unit)

	return currentSpeedInYards > 0 and format("%.1f", currentSpeedInYards) or ''
end

ElvUF.Tags.Events['classificationcolor'] = 'UNIT_CLASSIFICATION_CHANGED'
ElvUF.Tags.Methods['classificationcolor'] = function(unit)
	local c = UnitClassification(unit)
	if(c == 'rare' or c == 'elite') then
		return Hex(1, 0.5, 0.25) --Orange
	elseif(c == 'rareelite' or c == 'worldboss') then
		return Hex(1, 0, 0) --Red
	end
end

ElvUF.Tags.Events['guild'] = 'PLAYER_GUILD_UPDATE'
ElvUF.Tags.Methods['guild'] = function(unit)
	local guildName = GetGuildInfo(unit)

	return guildName or ""
end

ElvUF.Tags.Events['guild:brackets'] = 'PLAYER_GUILD_UPDATE'
ElvUF.Tags.Methods['guild:brackets'] = function(unit)
	local guildName = GetGuildInfo(unit)

	return guildName and format("<%s>", guildName) or ""
end