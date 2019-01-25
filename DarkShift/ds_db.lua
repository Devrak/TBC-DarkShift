--[[
Addon: DarkShift UI
Module: Core , Database
Developed by: ©Devrak 2k19
]]--


local snap

local function db_event(self, event, arg, ...)
	
	-- Events
	if event == "UPDATE_MOUSEOVER_UNIT" then
		
		-- Filter
		if not UnitExists("mouseover") or not UnitIsPlayer("mouseover") then return end
		
		-- C
		local name = UnitName("mouseover")
		local level = UnitLevel("mouseover")
		
		-- DB / Add
		if not snap[name] then
			
			-- Create
			snap[name] = {["guid"] = UnitGUID("mouseover"),["class"] = select(2, UnitClass("mouseover")),["level"] = level,["faction"] = UnitFactionGroup("mouseover"), ["stamp"] = self.dstamp}
			
		-- DB / Update guid
		elseif snap[name]["guid"] == nil then
			
			-- Overwrite
			snap[name] = {["guid"] = UnitGUID("mouseover"),["class"] = select(2, UnitClass("mouseover")),["level"] = level,["faction"] = UnitFactionGroup("mouseover"), ["stamp"] = self.dstamp}
			
		-- DB / Update level
		elseif level < 70 then
			
			-- Update level regardles
			snap[name]["level"] = level
		end
		
		-- Done
		return
		
	elseif event == "UNIT_TARGET" then
		
		-- C
		local unit = arg .. "target"
		
		-- Filter
		if not UnitExists(unit) or not UnitIsPlayer(unit) then return end
		
		-- C2
		local name = UnitName(unit)
		local level = UnitLevel(unit)
		
		-- DB / Add
		if not snap[name] then
			
			-- Create
			snap[name] = {["guid"] = UnitGUID(unit),["class"] = select(2, UnitClass(unit)),["level"] = level,["faction"] = UnitFactionGroup(unit), ["stamp"] = self.dstamp}
			
		-- DB / Update guid
		elseif snap[name]["guid"] == nil then
			
			-- Overwrite
			snap[name] = {["guid"] = UnitGUID(unit),["class"] = select(2, UnitClass(unit)),["level"] = level,["faction"] = UnitFactionGroup(unit), ["stamp"] = self.dstamp}
			
		-- DB / Update level
		elseif level < 70 then
			
			-- Update level regardles
			snap[name]["level"] = level
		end
		
		-- Done
		return
		
	elseif event == "PARTY_MEMBERS_CHANGED" then
		
		-- C
		local party = GetNumPartyMembers()
		
		if party ~= 0 then
			for i = 1, party do
				
				-- C2
				local unit = "party" .. i
				local name = UnitName(unit)
				local level = UnitLevel(unit)
				
				-- DB / Add
				if not snap[name] then
					
					-- Create
					snap[name] = {["guid"] = UnitGUID(unit),["class"] = select(2, UnitClass(unit)),["level"] = level,["faction"] = UnitFactionGroup(unit), ["stamp"] = self.dstamp}
					
				-- DB / Update guid
				elseif snap[name]["guid"] == nil then
					
					-- Overwrite
					snap[name] = {["guid"] = UnitGUID(unit),["class"] = select(2, UnitClass(unit)),["level"] = level,["faction"] = UnitFactionGroup(unit), ["stamp"] = self.dstamp}
					
				-- DB / Update level
				elseif level < 70 then
					
					-- Update level regardles
					snap[name]["level"] = level
				end
			end
		end
		
		-- Done
		return
		
	elseif event == "RAID_ROSTER_UPDATE" then
		
		-- C
		local raid = GetNumRaidMembers()
		
		if raid ~= 0 then
			for i = 1, raid do
				
				-- C2
				local unit = "raid" .. i
				local name = UnitName(unit)
				local level = UnitLevel(unit)
				
				-- DB / Add
				if not snap[name] then
					
					-- Create
					snap[name] = {["guid"] = UnitGUID(unit),["class"] = select(2, UnitClass(unit)),["level"] = level,["faction"] = UnitFactionGroup(unit), ["stamp"] = self.dstamp}
					
				-- DB / Update guid
				elseif snap[name]["guid"] == nil then
					
					-- Overwrite
					snap[name] = {["guid"] = UnitGUID(unit),["class"] = select(2, UnitClass(unit)),["level"] = level,["faction"] = UnitFactionGroup(unit), ["stamp"] = self.dstamp}
					
				-- DB / Update level
				elseif level < 70 then
					
					-- Update level regardles
					snap[name]["level"] = level
				end
			end
		end
		
		-- Done
		return
		
	elseif event == "GUILD_ROSTER_UPDATE" then
		
		-- Count
		local count = GetNumGuildMembers(true)
		
		-- Case 0 Update
		if count == 0 then GuildRoster() return
		
		-- If Needs Then Update
		elseif count ~= self.cguild then
			
			-- Update
			self.cguild = count
			
			-- Guildies List
			for i = 1, count do
				
				-- C2
				local name, _, _, level, class = GetGuildRosterInfo(i)
				
				-- DB / Add
				if not snap[name] then
					
					-- Stuff
					snap[name] = {["class"] = class:upper(),["level"] = level,["faction"] = self.faction, ["stamp"] = self.dstamp}
					
					-- DB / Update level
					elseif level < 70 then
					
					-- Update level regardles
					snap[name] = {["class"] = class:upper(),["level"] = level,["faction"] = self.faction, ["stamp"] = self.dstamp}
				end
			end
		end
		
		-- Done
		return
		
	elseif event == "FRIENDLIST_UPDATE"	 then
		
		-- Frendies List
		for i=1, GetNumFriends() do
			
			-- C2
			local name, level, class = GetFriendInfo(i)
			
			-- DB / Add
			if name and not snap[name] then
				
				-- Add
				snap[name] = {["class"] = class:upper(),["level"] = level,["faction"] = self.faction, ["stamp"] = self.dstamp}
				
			-- DB / Update level
			elseif level < 70 then
				
				-- Update level regardles
				snap[name] = {["class"] = class:upper(),["level"] = level,["faction"] = self.faction, ["stamp"] = self.dstamp}
			end
		end
		
		-- Done
		return
		
	elseif event == "WHO_LIST_UPDATE" then
		
		-- Who List update
		for i=1, GetNumWhoResults() do
			
			local name, _, level, _, _, _, class = GetWhoInfo(i)
			
			-- DB / Add
			if not snap[name] then
				
				-- Stuff
				snap[name] = {["class"] = class,["level"] = level,["faction"] = self.faction, ["stamp"] = self.dstamp}
				
			-- DB / Update level
			elseif level < 70 then
				
				-- Update level regardles
				snap[name] = {["class"] = class,["level"] = level,["faction"] = self.faction, ["stamp"] = self.dstamp}
			end
		end
		
		-- Done
		return
		
	elseif event == "PLAYER_ENTERING_BATTLEGROUND" then
		
		-- Get BattleField Score
		RequestBattlefieldScoreData()
		
		-- Done
		return
		
	elseif event == "CHAT_MSG_BG_SYSTEM_NEUTRAL" or event == "CHAT_MSG_BG_SYSTEM_HORDE" or event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" then
		
		-- Get BattleField Score
		if GetTime() > self.update then RequestBattlefieldScoreData() end
		
		-- Done
		return
		
	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		
		-- C
		local scores = GetNumBattlefieldScores()
		
		-- Have Score
		if scores > 0 then 
			
			-- C2
			local ctime = GetTime()
			
			-- Antispam
			if ctime > self.update then
				
				-- Timer
				self.update = ctime +14
				
				-- Lookup
				for i = 1, scores do
					
					-- C4
					local name, _, _, _, _, faction, _, _, _, class = GetBattlefieldScore(i)
					
					-- DB / Add
					if not snap[name] then
						
						-- Faction
						if faction == 0 then faction = "Horde" else faction = "Alliance" end
						
						-- Add
						snap[name] = {["class"] = class,["faction"] = faction, ["stamp"] = self.dstamp}
					end
				end
			end
		end
		
		-- Done
		return
	end
end


function ds_database()
	
	-- C
	local db_events = CreateFrame("Frame",nil,nil)
	
	-- DB
	if ds_db == nil then ds_db = {} end
	
	-- Snap DB
	snap = ds_db
	
	-- C2
	db_events.cguild = 0
	db_events.update = GetTime()
	db_events.dstamp = date("%y%m%d")
	db_events.faction = UnitFactionGroup("player")
	
	-- Reg Events
	db_events:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	db_events:RegisterEvent("UNIT_TARGET")
	db_events:RegisterEvent("PARTY_MEMBERS_CHANGED")
	db_events:RegisterEvent("RAID_ROSTER_UPDATE")
	db_events:RegisterEvent("WHO_LIST_UPDATE")
	db_events:RegisterEvent("GUILD_ROSTER_UPDATE")
	db_events:RegisterEvent("FRIENDLIST_UPDATE")
	db_events:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
	db_events:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
	db_events:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	db_events:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	db_events:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")

	-- Listen
	db_events:SetScript("OnEvent", db_event)
end