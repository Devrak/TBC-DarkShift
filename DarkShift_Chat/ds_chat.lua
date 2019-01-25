--[[
Addon: DarkShift UI
Module: Chat
Developed by: ©Devrak 2k19
]]--


local ds_chat, db_snap

local function ds_chat_onSendText(this)
	
	-- Force Sticky for Extra channels
	local attr = this:GetAttribute("chatType")
	
	if attr == "CHANNEL" or attr == "YELL" or attr == "EMOTE" or attr == "OFFICER" or attr == "WHISPER"then
		ChatFrameEditBox:SetAttribute("stickyType", attr)
	end
end


local function ds_chat_onWindowName(frame)
	
	-- Update New Chat Window Name
	local tab = _G[frame:GetName().."Tab"]
	tab.fullText = tab:GetText()
	
	if frame.isDocked and ds_chat.conf.TabDockP == "RIGHT" or frame.isDocked and ds_chat.conf.TabDockP == "LEFT" then
		tab:SetText(string.upper(string.sub(tab.fullText, 1,1)))
	end
end


local function ds_chat_combatLogFix()
	
	-- Fixes Combat log baner for skins
	local pad = CombatLogQuickButtonFrame_Custom:GetHeight()
	local ski = ds_chat.conf.ChatBgTs[ds_chat.conf.ChatBgCh[2]]
	local cbg = _G[COMBATLOG:GetName().."Background"]
	
	cbg:ClearAllPoints()
	cbg:SetPoint("TOPLEFT", COMBATLOG ,"TOPLEFT", ski.bgH, ski.bgV+pad)
	cbg:SetPoint("BOTTOMRIGHT", COMBATLOG ,"BOTTOMRIGHT", ski.bgh, ski.bgv)
end


local function ds_chat_tabBg(tab, show)
	
	-- Tab Square Bg for dock/undock
	local reg0, reg1, reg2, text = tab:GetRegions()
	
	if show then
		reg0:SetAlpha(1)
		reg1:SetAlpha(1)
		reg2:SetAlpha(1)
	else
		reg0:SetAlpha(0)
		reg1:SetAlpha(0)
		reg2:SetAlpha(0)
	end
end


local function ds_chat_tabBgRev(tab, rew)
	
	-- Tab Bg Image Flip for dock/undock
	local reg0, reg1, reg2, text = tab:GetRegions()
	local reg3 = tab:GetHighlightTexture()
	
	if rew then
		
		-- Flip Bg Images
		if ds_chat.conf.SkinName == "Blizzard" then
			reg0:SetTexCoord(0,1,0,0,0.25,1,0.25,0)
			reg1:SetTexCoord(0.75,1,0.75,0,0.25,1,0.25,0)
			reg2:SetTexCoord(0.75,1,0.75,0,1,1,1,0)
		else
			reg0:SetTexCoord(0,1,0,0,1,1,1,0)
			reg1:SetTexCoord(0,1,0,0,1,1,1,0)
			reg2:SetTexCoord(0,1,0,0,1,1,1,0)
		end
		
		-- Highlight
		reg3:SetPoint("LEFT", reg0, "LEFT", 0, 6)
		reg3:SetPoint("RIGHT", reg2, "RIGHT", 0, 6)
	else
		
		-- Normal Bg Images
		if ds_chat.conf.SkinName == "Blizzard" then
			reg0:SetTexCoord(0,0.25,0,1)
			reg1:SetTexCoord(0.25,0.75,0,1)
			reg2:SetTexCoord(0.75,1,0,1)
		else
			reg0:SetTexCoord(0,1,0,1)
			reg1:SetTexCoord(0,1,0,1)
			reg2:SetTexCoord(0,1,0,1)
		end
		
		-- Highlight
		reg3:SetPoint("LEFT", reg0, "LEFT", 0, -6)
		reg3:SetPoint("RIGHT", reg2, "RIGHT", 0, -6)
	end
end


local function ds_chat_dockUpdate()
	
	-- Dock updates ( Docking & Undocking ) of Tabs
	local dock = ds_chat.dock
	local maxv = math.ceil((ChatFrame1:GetHeight()+16) / 32) if maxv < 6 then maxv = 6 end
	local dockReg, dockHig, chatTab, tabText, last
	
	-- Loop Thru
	for index, chatFrame in ipairs(DOCKED_CHAT_FRAMES) do
		
		-- Positioning of docked frames
		dockReg = _G[chatFrame:GetName().."TabDockRegion"]
		dockHig = _G[chatFrame:GetName().."TabDockRegionHighlight"]
		chatTab = _G[chatFrame:GetName().."Tab"]
		tabText = _G[chatFrame:GetName().."TabText"]
		
		-- R
		if ds_chat.conf.TabDockP == "RIGHT" then
			
			-- Position based on last Tab
			chatTab:ClearAllPoints()
			
			if last then
				if index ~= maxv then
					
					-- Normal Tab
					chatTab:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, 0)
					chatTab:SetWidth(32)
				else
					-- Next Row
					chatTab:SetPoint("TOPLEFT", dock, "TOPLEFT", 32, 0)
					chatTab:SetWidth(32)
				end
			else
				-- First Skinned Tab
				chatTab:SetPoint("TOPLEFT", dock, "TOPLEFT", 0, 0)
				chatTab:SetWidth(32)
			end
			
			-- MonkaS
			last = chatTab
			
			-- Text
			tabText:ClearAllPoints()
			tabText:SetPoint("CENTER", chatTab, "CENTER", 0,0)
			
			-- Dock
			dockReg:ClearAllPoints()
			dockReg:SetWidth(50)
			dockReg:SetPoint("LEFT", chatTab, "RIGHT", -12, 0)
			dockHig:ClearAllPoints()
			dockHig:SetPoint("LEFT", chatTab, "RIGHT", -12, 0)
			
		-- L
		elseif ds_chat.conf.TabDockP == "LEFT" then
			
			-- Position based on last Tab
			chatTab:ClearAllPoints()
			
			if last then
				if index ~= maxv then
					
					-- Normal Tab
					chatTab:SetPoint("TOPRIGHT", last, "BOTTOMRIGHT", 0, 0)
					chatTab:SetWidth(32)
				else
					-- Next Row Tab
					chatTab:SetPoint("TOPRIGHT", dock, "TOPRIGHT", -32, 0)
					chatTab:SetWidth(32)
				end
			else
				-- First Skinned Tab
				chatTab:SetPoint("TOPRIGHT", dock, "TOPRIGHT", 0, 0)
				chatTab:SetWidth(32)
			end
			
			-- MonkaS
			last = chatTab
			
			-- Text
			tabText:ClearAllPoints()
			tabText:SetPoint("CENTER", chatTab, "CENTER", 0,0)
			
			-- Dock
			dockReg:ClearAllPoints()
			dockReg:SetWidth(50)
			dockReg:SetPoint("RIGHT", chatTab, "LEFT", 35, 0)
			dockHig:ClearAllPoints()
			dockHig:SetPoint("RIGHT", chatTab, "LEFT", 15, 0)
			
		-- T
		elseif ds_chat.conf.TabDockP == "TOP"  then
			
			-- Position based on last Tab
			chatTab:ClearAllPoints()	
			
			if last then
				chatTab:SetPoint("BOTTOMLEFT", last, "BOTTOMRIGHT", 0, 0)
			else
				chatTab:SetPoint("BOTTOMLEFT", dock, "BOTTOMLEFT", 0, 0)
			end
			
			-- MonkaS
			last = chatTab
			
			-- Text
			tabText:ClearAllPoints()
			tabText:SetPoint("CENTER", chatTab, "CENTER", 0,-6)
			
		-- B
		elseif ds_chat.conf.TabDockP == "BOTTOM"  then
			
			-- Position based on last Tab
			chatTab:ClearAllPoints()
			
			if last then
				chatTab:SetPoint("TOPLEFT", last, "TOPRIGHT", 0, 0)
			else
				chatTab:SetPoint("TOPLEFT", dock, "TOPLEFT", 0, 0)
			end
			
			-- MonkaS
			last = chatTab
			
			-- Text
			tabText:ClearAllPoints()
			tabText:SetPoint("CENTER", chatTab, "CENTER", 0,6)
		end
		
		-- Text Color
		tabText:SetTextColor(ds_chat.conf.TabFoCol.r,ds_chat.conf.TabFoCol.g,ds_chat.conf.TabFoCol.b,ds_chat.conf.TabFoCol.a)
		
		-- Alphas
		if ds_chat.conf.TabScrol then
			
			-- Case it got hidden ?
			chatTab:Show()
			
			-- Reset
			if chatFrame == SELECTED_DOCK_FRAME then
				chatTab:SetAlpha(CHAT_FRAME_BUTTON_MAX_ALPHA)
			else
				chatTab:SetAlpha(CHAT_FRAME_BUTTON_MIN_ALPHA)
			end
		end
	end
	
	-- Combat Log Fix
	ds_chat_combatLogFix()
end


local function ds_chat_dockDock(frame)
	
	-- Updates Docked Tabs
	local text = _G[frame:GetName().."TabText"]
	local reg0 = _G[frame:GetName().."TabLeft"]
	local tab  = _G[frame:GetName().."Tab"]
	
	-- R & L
	if ds_chat.conf.TabDockP == "RIGHT" or  ds_chat.conf.TabDockP == "LEFT" then
		
		-- Clear
		text:SetText(string.upper(string.sub(tab.fullText, 1,1)))
		text:SetFont(ds_chat.conf.TabFoFam, ds_chat.conf.TabFoSiz+4)
		
		-- Hide Bg
		ds_chat_tabBg(tab)
		
		-- Square BG
		tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, 0)
		tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
		
	-- B
	elseif ds_chat.conf.TabDockP == "BOTTOM" then
		
		-- Clear
		text:ClearAllPoints()
		text:SetPoint("TOPLEFT", reg0, "TOPRIGHT", 0,-7)
		
		-- Invarse bottom
		ds_chat_tabBgRev(tab,true)
		
		-- Square BG
		tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, 0)
		tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 11)
	end
	
	-- Square Bg
	tab.bg:Hide()
	
	-- Force Update
	FCF_DockUpdate()
end


local function ds_chat_dockUndock(frame)
	
	-- Updates Undocked Tabs
	local text = _G[frame:GetName().."TabText"]
	local reg0 = _G[frame:GetName().."TabLeft"]
	local reg1 = _G[frame:GetName().."TabMiddle"]
	local tab  = _G[frame:GetName().."Tab"]
	
	-- Text / Font
	if ds_chat.conf.TabDockP == "RIGHT" or ds_chat.conf.TabDockP == "LEFT" then
		text:SetText(tab.fullText)
		text:SetFont(ds_chat.conf.TabFoFam, ds_chat.conf.TabFoSiz)
	end
	
	-- Text / Pos
	text:ClearAllPoints()
	text:SetPoint("BOTTOMLEFT", reg0, "BOTTOMRIGHT", 0,7)
	text:SetTextColor(ds_chat.conf.TabFoCol.r,ds_chat.conf.TabFoCol.g,ds_chat.conf.TabFoCol.b,ds_chat.conf.TabFoCol.a)
	
	-- Invarse bottom
	if ds_chat.conf.TabDockP == "BOTTOM" then
		ds_chat_tabBgRev(tab)
	end
	
	-- Square Bg
	if ds_chat.conf.TabBgsTx ~= "Color" then
		tab.bg:Hide()
	end
	
	-- Normal Bg
	tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -11)
	tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
	ds_chat_tabBg(tab,true)
	
	-- Force Update
	FCF_DockUpdate()
end


local function ds_chat_tabPosition(chatFrame, x)
	
	-- Undocked Tab position fix
	local chatTab = _G[chatFrame:GetName().."Tab"]
	
	chatTab:ClearAllPoints()
	chatTab:SetPoint("BOTTOMLEFT", chatFrame:GetName().."Background", "TOPLEFT", x+2, ds_chat.conf.TabDPadT)
end


local function ds_chat_onHeaderUpdate(box)
	
	-- Header updates for EditBoxes
	if box:GetName() ~= "MacroEditBox" then
		box:SetTextInsets(-2 + ds_chat.conf.EditBgTs[ds_chat.conf.EditBgTx].ins + _G[box:GetName().."Header"]:GetWidth(), 14, 0, 0)
	end
end


local function ds_chat_que()
	
	-- Who Quee With Cooldwon
	for k in pairs(ds_chat.queue) do
		
		-- C
		local curTime = GetTime()
		ds_chat.queryTimeOut = curTime+10
		ds_chat.query = k
		
		-- Time since last que > 5 sec = Fast Que
		if curTime-5 > ds_chat.queryTime then SendWho(k)
			
		-- Timed Que
		else
			ds_chat.queryTime = curTime+5
			ds_chat:SetScript("OnUpdate",function()
				if GetTime() > ds_chat.queryTime then
					if not ds_chat.whoOpen then
						SendWho(k)
						ds_chat:SetScript("OnUpdate",nil)
					end
				end
			end)
		end
		
		-- Done ( its 1 by 1 )
		return
	end
end


local function ds_chat_onWho()
	
	-- Stops Queries when WhoFrame is Visible
	if WhoFrame:IsVisible() and not ds_chat.whoOpen then
		
		-- Stuff
		ds_chat.query = nil
		ds_chat.whoOpen = true
		
	-- Proceed with que on Close
	elseif not WhoFrame:IsVisible() and ds_chat.whoOpen then
		
		-- Stuff
		ds_chat.whoOpen = false
		
		-- Quee
		ds_chat_que()
	end
end


local function ds_chat_SendWho(args)
	
	-- Overrides WHO Querries if User makes a Querrie
	if args ~= ds_chat.query then ds_chat.query = nil end
	
	-- LibWho ?
	if args == ds_chat.query and ds_chat.L then
		ds_chat.L:Who(args)
		
	-- Normal
	else
		-- Que & Cooldown
		ds_chat.sendWho(args)
		ds_chat.queryTime = GetTime()
	end
end


local function ds_chat_FriendsFrame_OnEvent()
	
	-- Block WhoFrame for chat Querries
	if ds_chat.query and event == 'WHO_LIST_UPDATE' then return
	
	-- Pass to original
	else ds_chat.ofriends() end
end


local function ds_chat_onItemRef(link, text, button)
	
	-- Additional Chat Link Handling
	local type = string.sub(text, 13 , 15)
	
	-- If its Hyperlink
	if ( type == "ref" ) then
		ds_chat.box:Show()
		ds_chat.box:SetText(string.sub(text,20,-6))
		ds_chat.box:SetAutoFocus(true)
		return
		
	-- If its Group invite
	elseif ( type == "inv") then
		InviteUnit(string.sub(text, 17 , -12))
		return
		
	-- If its Apply for group
	elseif ( type == "app") then
		ChatFrame_OpenChat("/w ".. string.sub(text, 17 , -14) .." ".. ds_chat.conf.applyGrp)
		return
	end
	
	-- Org itemRef
	SetItemRef(link, text, button)
end


local function ds_chat_filter(name,level,mtype)
	
	-- If in Guild ? Or Friends List ? or My Whisper list
	if ds_chat.whisp[name] or ds_chat.guild[name] or ds_chat.friends[name] then return false
	
	-- Whiper Filter
	elseif mtype == "CHAT_MSG_WHISPER" and level < ds_chat.conf.MsgLevel then return true
	
	-- Extended
	elseif ( mtype == "CHAT_MSG_CHANNEL" or mtype == "CHAT_MSG_SAY" or mtype == "CHAT_MSG_YELL" ) and ds_chat.conf.MsgChans == 1 and level < ds_chat.conf.MsgLevel then return true else
	
	-- Pass
	return false end
end


local function ds_chat_queryAddMessages()

	-- Normal case
	if db_snap[ds_chat.query] then 
		
		-- Loop
		for i = 1 , #ds_chat.queue[ds_chat.query] do
		
			-- Filter
			if ds_chat.conf.MsgLevel == 0 or not ds_chat_filter(ds_chat.query,db_snap[ds_chat.query]["level"],ds_chat.queue[ds_chat.query][i]["Type"]) then
		
				-- Class Color
				if ds_chat.conf.NameColo == 1 then ds_chat.queue[ds_chat.query][i]["text"] = string.gsub(ds_chat.queue[ds_chat.query][i]["text"], '%['.. ds_chat.query ..'%]', '[|cff' .. ds_chat.classColor[db_snap[ds_chat.query]["class"]] .. '' .. ds_chat.query ..'|r]', 1) end
				
				-- TimeStamps
				if ( ds_chat.conf.TimeStmp ~= "Not" ) then ds_chat.queue[ds_chat.query][i]["text"] = "|cff".. ds_chat.conf.TimeColo .. date(ds_chat.conf.TimeStmp) .."|r "..ds_chat.queue[ds_chat.query][i]["text"] end
		
				-- Add
				ds_chat.oaddm(ds_chat.queue[ds_chat.query][i]["frame"],ds_chat.queue[ds_chat.query][i]["text"],ds_chat.queue[ds_chat.query][i]["r"],ds_chat.queue[ds_chat.query][i]["g"],ds_chat.queue[ds_chat.query][i]["b"])
			end
		end
	
	-- Failed que
	else
	
		-- Loop
		for i = 1 , #ds_chat.queue[ds_chat.query] do
			
			-- TimeStamps
			if ( ds_chat.conf.TimeStmp ~= "Not" ) then ds_chat.queue[ds_chat.query][i]["text"] = "|cff".. ds_chat.conf.TimeColo .. date(ds_chat.conf.TimeStmp) .."|r "..ds_chat.queue[ds_chat.query][i]["text"] end
		
			-- Add
			ds_chat.oaddm(ds_chat.queue[ds_chat.query][i]["frame"],ds_chat.queue[ds_chat.query][i]["text"],ds_chat.queue[ds_chat.query][i]["r"],ds_chat.queue[ds_chat.query][i]["g"],ds_chat.queue[ds_chat.query][i]["b"])
		end
	end
	
	-- Reset
	ds_chat.queue[ds_chat.query] = nil
	ds_chat.query = nil
	
	-- Queee
	ds_chat_que()
end


local function ds_chat_onAddMessage(frame,text,r,g,b)
	
	-- Chat Message Handling ( STUFF )
	if 	event == 'CHAT_MSG_CHANNEL' or
		event == 'CHAT_MSG_GUILD' or
		event == 'CHAT_MSG_OFFICER' or
		event == 'CHAT_MSG_PARTY' or
		event == 'CHAT_MSG_PARTY_LEADER' or
		event == 'CHAT_MSG_RAID' or
		event == 'CHAT_MSG_RAID_LEADER' or
		event == 'CHAT_MSG_BATTLEGROUND' or
		event == 'CHAT_MSG_BATTLEGROUND_LEADER' or
		event == 'CHAT_MSG_WHISPER_INFORM' or
		event == 'CHAT_MSG_WHISPER' or
		event == 'CHAT_MSG_YELL' or
		event == 'CHAT_MSG_SAY'
	then
		
		-- C
		local cleartext = string.gsub(arg1, '|c?.+|r?', '')
		local Arg2 = arg2
		local chch
		
		-- Channel Names
		if event ~= 'CHAT_MSG_WHISPER' and event ~= 'CHAT_MSG_SAY' and event ~= 'CHAT_MSG_YELL' and event ~= 'CHAT_MSG_WHISPER_INFORM' then
			
			-- Shorten
			text = string.gsub(text, '[%.%s0-9a-zA-Z]*%]', string.sub(text, 2,2)..']', 1)
			
			-- Colored if Guild member
			if event == 'CHAT_MSG_CHANNEL' and ds_chat.guild[Arg2] and Arg2 ~= ds_chat.player  then text = string.gsub(text, '^[%[0-9A-Z]*%]', '|cff40fb40[' .. string.sub(text, 2,2)..']|r', 1) end
		end
		
		-- Whispers
		if event == 'CHAT_MSG_WHISPER' or event == 'CHAT_MSG_WHISPER_INFORM' then
			
			-- Reform message ( If done in one go tends to break link )
			if event == 'CHAT_MSG_WHISPER' then
				text = string.gsub(text, ' whispers', '', 1)
				text = string.gsub(text, '%['..Arg2..'%]', '[W From] ['..Arg2..']', 1)
			else
				text = string.gsub(text, 'To ', '', 1)
				text = string.gsub(text, '%['..Arg2..'%]', '[W To] ['..Arg2..']', 1)
				
				-- Add To W DB
				ds_chat.whisp[Arg2] = true
			end
			
			-- Extra tag for guildies/friends
			if ds_chat.guild[Arg2] then
				text = string.gsub(text, '%['..Arg2..'%]', '|cff40fb40[G]|r['..Arg2..']', 1)
			elseif ds_chat.friends[Arg2] then
				text = string.gsub(text, '%['..Arg2..'%]', '|cfface5ee[F]|r['..Arg2..']', 1)
			end
		end
		
		-- Group invite / apply for group
		if Arg2 ~= ds_chat.player and event ~= "CHAT_MSG_RAID" and event ~= "CHAT_MSG_RAID_LEADER" and event ~= "CHAT_MSG_RAID_WARNING" then
			
			-- LFM / LF1M ~
			if string.find(arg1, 'LF%d?M%s') then
				text = text .. " |cff".. ds_chat.conf.GinvColo .."|Happ:" .. Arg2 .. "|h[apply]|h|r"
			
			-- Inv 123 ...
			else
				text = string.gsub(text, "%s+invite.?", " |cff".. ds_chat.conf.GinvColo .."|Hinv:" .. Arg2 .. "|h[inv]|h|r",1)
				text = string.gsub(text, "%s+inv.?", 	" |cff".. ds_chat.conf.GinvColo .."|Hinv:" .. Arg2 .. "|h[inv]|h|r",1)
				text = string.gsub(text, "%s+123.?", 	" |cff".. ds_chat.conf.GinvColo .."|Hinv:" .. Arg2 .. "|h[123]|h|r",1)
			end
		end
		
		-- Self Highlight
		text = string.gsub(text , "%s+".. ds_chat.player, " |cff".. ds_chat.conf.SelfColo .."".. ds_chat.player .."|r",1)
		
		-- Hyperlinks
		if string.find(cleartext, '[0-9a-z]%.[a-z][a-z]') then
			
			-- Match against pattern              http/s    //   domain     . domain       .com (2)   /sub.html?w=1       :12323
			chch = string.match(cleartext,'[htps]-%:?/?/?[0-9a-z%-]+[%.[0-9a-z%-]+]-%.[a-z]+[/[0-9a-zA-Z%-%.%?=&]+]-:?%d?%d?%d?%d?%d?')
			
			-- If Link
			if chch ~= nil then
				
				-- Gsub becomes unreliable if it contains ? or - character and escape % is not working 100% of the time
				text = string.gsub(text, "?", "$1")
				text = string.gsub(text, "-", "$2")
				chch = string.gsub(chch, "?", "$1")
				chch = string.gsub(chch, "-", "$2")
				
				-- Add Hyperlink
				text = string.gsub(text, chch, "|cff".. ds_chat.conf.HlinColo .."|Href:|h["..chch.."]|h|r")
				
				-- Add them back
				text = string.gsub(text, "$1", "?")
				text = string.gsub(text, "$2", "-")
			end
		end
		
		-- Emote Code
		for emoji in string.gmatch(cleartext, "%b::") do
			if ( ds_chat.ecode[emoji] ) then text = string.gsub(text, emoji, ds_chat.ecode[emoji] .. ":"..ds_chat.conf.EmojiPix.."|t") end
		end
		
		-- Emote Plain
		for k,v in pairs(ds_chat.emote) do 
			text = string.gsub(text, k, v .. ":".. ds_chat.conf.EmojiPix .."|t") 
		end
		
		-- Emoji Plain
		for k,v in pairs(ds_chat.emoji) do 
			text = string.gsub(text, k, v .. ":".. ds_chat.conf.EmojiPix-6 .."|t") 
		end
		
		-- Class Color / Filter ( Data Querries )
		if ds_chat.conf.NameColo == 1 or ds_chat.conf.MsgLevel > 1 then
		
			-- Que Watcher
			if ds_chat.query and GetTime() > ds_chat.queryTimeOut then ds_chat_queryAddMessages() end
		
			-- Have
			if db_snap[Arg2] then
			
				-- Filter
				if ds_chat.conf.MsgLevel > 1 and ds_chat_filter(Arg2,db_snap[Arg2]["level"],event) then return end
		
				-- Name Color
				if ds_chat.conf.NameColo == 1 then text = string.gsub(text, '%['.. Arg2 ..'%]', '[|cff' .. ds_chat.classColor[db_snap[Arg2]["class"]] .. '' .. Arg2 ..'|r]', 1) end
			
			-- If not then Quee
			elseif not ds_chat.queue[Arg2] then
				
				-- Add
				ds_chat.queue[Arg2] = {[1] = {["text"] = text, ["r"] = r, ["g"] = g, ["b"] = b, ["frame"] = frame, ["Type"] = event}}
				
				-- If no query
				if ds_chat.query == nil and not ds_chat.whoOpen then ds_chat_que() end
				
				-- Done
				return
			
			-- Message while waiting ? -> Stack Up
			elseif ds_chat.queue[Arg2] then
				
				-- Add extras
				ds_chat.queue[Arg2][#ds_chat.queue[Arg2]+1] = {["text"] = text, ["r"] = r, ["g"] = g, ["b"] = b, ["frame"] = frame, ["Type"] = event}
				
				-- Done
				return
			end
		end
		
	-- SyS messages
	elseif	event == 'CHAT_MSG_SYSTEM' then
		
		-- Filter Who Player / Invite
		if string.sub(text, 0,9) == "|Hplayer:" then
			
			-- Group
			if(string.sub(text, -6) == "group.") then
				
				-- Name is always 3rd find
				local who = string.match(text, "[A-Z][a-z]+",3)
				
				-- Extra tag for guildies/friends
				if ds_chat.guild[who] then
					text = string.gsub(text, '%['..who..'%]', '|cff40fb40[G]|r['..who..']', 1)
				elseif ds_chat.friends[who] then
					text = string.gsub(text, '%['..who..'%]', '|cfface5ee[F]|r['..who..']', 1)
				end
				
			-- Chat Query
			elseif ds_chat.query then return end
		end
		
		-- Who Player Count Messages
		if(string.sub(text, -5) == "total") and ds_chat.query then
			
			-- C
			local numres = GetNumWhoResults()
			
			-- DB Update
			for i = 1, numres do
				
				-- C2
				local name, _, level, _, _, _, class = GetWhoInfo(i)
				
				-- DB / Add
				if not db_snap[name] then
					db_snap[name] = {["class"] = class,["level"] = level,["faction"] = ds_chat.faction,["stamp"] = ds_chat.stamp}
					
				-- DB / Update level
				elseif level < 70 then
					db_snap[name] = {["class"] = class,["level"] = level,["faction"] = ds_chat.faction,["stamp"] = ds_chat.stamp}
				end
			end
			
			-- Got now Add This
			ds_chat_queryAddMessages()
			
			-- Done
			return
			
		-- A Normal Message ( User )
		elseif(string.sub(text, -5) == "total")	then
			
			-- Queee
			ds_chat_que()
		end
	end
	
	-- TimeStamps
	if ( ds_chat.conf.TimeStmp ~= "Not" ) then text = "|cff".. ds_chat.conf.TimeColo .. date(ds_chat.conf.TimeStmp) .."|r "..text end
	
	-- To Chat
	ds_chat.oaddm(frame,text,r,g,b)
end


local function ds_chat_onEvent(self, event, arg, ...)
	
	-- Friends Upd
	if event == "FRIENDLIST_UPDATE" then
		
		-- C
		local name
		self.friends = {}
		
		-- Frendies List
		for i = 1, GetNumFriends() do
			
			-- If offline name is nil
			name = GetFriendInfo(i)
			if name ~= nil then self.friends[name] = true end
		end
		return
		
	-- Guild Updates
	elseif event == "GUILD_ROSTER_UPDATE" then
		
		-- Count
		local count, name = GetNumGuildMembers(true) , nil
		
		-- Case 0 Rip
		if count == 0 then return
		
		-- If Needs Then Update
		elseif count ~= self.cguild then
			
			-- R & A
			self.guild = {}
			for i = 1, count do self.guild[GetGuildRosterInfo(i)] = true end
		end
		return
		
	-- Save config to global db
	elseif event == "PLAYER_LOGOUT" then
		
		ds_glob_conf.chat = self.conf
		return
		
	-- Query from from who update
	elseif event == "WHO_LIST_UPDATE" and ds_chat.query then
		
		-- Got now Add This
		if db_snap[ds_chat.query] then ds_chat_queryAddMessages() end
		return
		
	-- Do We Have LibWho
	elseif event == "MINIMAP_UPDATE_ZOOM" then
		
		if LibStub then
			
			-- Wholib 2
			if LibStub.libs["LibWho-2.0"] then
				ds_chat.L = LibStub.libs["LibWho-2.0"]
				
			-- Wholib 1
			elseif LibStub.libs["WhoLib-1.0"] then
				ds_chat.L = LibStub.libs["WhoLib-1.0"]
			end
		end
		
		-- Remove Event & D
		ds_chat:UnregisterEvent("MINIMAP_UPDATE_ZOOM")
		return
	end
end


local function ds_chat_skinTab(tab)
	
	-- Stuff
	local reg0, reg1, reg2, text = tab:GetRegions()
	local reg6 = _G[tab:GetName().."Flash"]
	local reg3 = tab:GetHighlightTexture()
	if tab.fullText == nil then tab.fullText = tab:GetText() end
	
	-- Reset Bg
	ds_chat_tabBgRev(tab)
	ds_chat_tabBg(tab,true)
	
	-- Text Default Pos ( dockupdate for specific chages )
	text:ClearAllPoints()
	text:SetText(tab.fullText)
	text:SetPoint("CENTER", tab, "CENTER", 0,-6)
	text:SetFont(ds_chat.conf.TabFoFam, ds_chat.conf.TabFoSiz)
	text:SetShadowOffset(ds_chat.conf.TabFoShd,-ds_chat.conf.TabFoShd)
	
	-- Bg for lrbg & color bg
	if tab.bg == nil then tab.bg = tab:CreateTexture(nil,"BACKGROUND") tab.bg:Hide() end
	tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -11)
	tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
	tab.bg:Hide()
	
	-- Flash
	reg6:ClearAllPoints()
	reg6:SetWidth(0)
	reg6:SetHeight(16)
	reg6tex = reg6:GetRegions()
	reg6tex:SetTexture(ds_chat.conf.TabHighL)
	reg6tex:SetVertexColor(ds_chat.conf.AlphaC4)
	
	-- Top
	if ds_chat.conf.TabDockP == "TOP" then
		reg6:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 5, 0)
		reg6:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 3, 0)
		reg3:Show()
		
	-- Right
	elseif ds_chat.conf.TabDockP == "RIGHT"  then
		reg6:SetWidth(16)
		reg6:SetHeight(0)
		reg6:SetPoint("TOPLEFT", tab, "TOPLEFT", 3, 0)
		reg6:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 3, -2)
		reg3:Hide()
		
	-- Bottom
	elseif ds_chat.conf.TabDockP == "BOTTOM" then
		reg6:SetPoint("TOPLEFT", tab, "TOPLEFT", 5, 0)
		reg6:SetPoint("TOPRIGHT", tab, "TOPRIGHT", 3, 0)
		reg3:Show()
		
	-- Left Side
	else
		reg6:SetWidth(16)
		reg6:SetHeight(0)
		reg6:SetPoint("TOPRIGHT", tab, "TOPRIGHT", 3, 0)
		reg6:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 3, -2)
		reg3:Hide()
	end
	
	-- Bg Is Color
	if ds_chat.conf.TabBgsTx == "Color" then
		tab.bg:Show()
		tab.bg:SetTexture(ds_chat.conf.TabBgsTs.Color.r, ds_chat.conf.TabBgsTs.Color.g, ds_chat.conf.TabBgsTs.Color.b, ds_chat.conf.TabBgsTs.Color.a)
		ds_chat_tabBg(tab)
		
	-- Bg Is A texture
	else
		reg6 = ds_chat.conf.TabBgsTs[ds_chat.conf.TabBgsTx]
		reg0:SetTexture(reg6.txl)   -- Bg L
		reg1:SetTexture(reg6.txm)   -- Bg M
		reg2:SetTexture(reg6.txr)   -- Bg R
		tab.bg:SetTexture(reg6.txs) -- Bg LR
		
		-- Vertex Fix
		reg0:SetVertexColor(1,1,1,1)
		reg1:SetVertexColor(1,1,1,1)
		reg2:SetVertexColor(1,1,1,1)
	end
end


function ds_chat_skinChat()
	
	-- C
	local editBg 	= ds_chat.conf.EditBgTs[ds_chat.conf.EditBgTx]
	local editPt 	= editBg.pdt
	local editPb 	= editBg.pdb
	local editBox 	= _G["ChatFrameEditBox"]
	local editBoxH 	= _G["ChatFrameEditBoxHeader"]
	local _, _, _, _, _, editBoxL, editBoxR, editBoxM = editBox:GetRegions()
	local frameName, chatFrame, chatBtns, chatBg, tab, tabText, reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, regX
	
	-- Dock
	ds_chat.dock:ClearAllPoints()
	
	if ds_chat.conf.TabDockP == "TOP" then
		ds_chat.dock:SetWidth(0)
		ds_chat.dock:SetHeight(32)
		ds_chat.dock:SetPoint("BOTTOMLEFT", ChatFrame1Background, "TOPLEFT", ds_chat.conf.TabDPadL, ds_chat.conf.TabDPadT)
		ds_chat.dock:SetPoint("BOTTOMRIGHT", ChatFrame1Background, "TOPRIGHT", ds_chat.conf.TabDPadR, ds_chat.conf.TabDPadT)
		
	elseif ds_chat.conf.TabDockP == "RIGHT" then
		ds_chat.dock:SetPoint("TOPLEFT", ChatFrame1Background, "TOPRIGHT", ds_chat.conf.TabDPadR, ds_chat.conf.TabSvpad)
		ds_chat.dock:SetWidth(100)
		ds_chat.dock:SetHeight(ChatFrame1:GetHeight())
		
	elseif ds_chat.conf.TabDockP == "BOTTOM" then
		ds_chat.dock:SetWidth(0)
		ds_chat.dock:SetHeight(32)
		ds_chat.dock:SetPoint("TOPLEFT", ChatFrame1Background, "BOTTOMLEFT", ds_chat.conf.TabDPadL, ds_chat.conf.TabDPadB)
		ds_chat.dock:SetPoint("TOPRIGHT", ChatFrame1Background, "BOTTOMRIGHT", ds_chat.conf.TabDPadR, ds_chat.conf.TabDPadB)
	else
		ds_chat.dock:SetPoint("TOPRIGHT", ChatFrame1Background, "TOPLEFT", ds_chat.conf.TabDPadL, ds_chat.conf.TabSvpad)
		ds_chat.dock:SetWidth(100)
		ds_chat.dock:SetHeight(ChatFrame1:GetHeight())
	end
	
	-- Chat Frames
	for i = 1, ds_chat.numWindows do
		
		-- Stuff
		frameName	= "ChatFrame"..i
		chatFrame	= _G[frameName]
		chatBtns	= _G[frameName.."ButtonFrame"]
		chatBg		=  ds_chat.conf.ChatBgTs[ds_chat.conf.ChatBgCh[i]]
		tab			= _G[frameName.."Tab"]
		tabText		= _G[frameName.."TabText"]
		reg0		=  chatFrame:GetRegions()
		reg1		= _G[frameName.."ResizeTopLeft"]
		reg2		= _G[frameName.."ResizeBottomLeft"]
		reg3		= _G[frameName.."ResizeTopRight"]
		reg4		= _G[frameName.."ResizeBottomRight"]
		reg5		= _G[frameName.."ResizeLeft"]
		reg6		= _G[frameName.."ResizeRight"]
		reg7		= _G[frameName.."ResizeBottom"]
		reg8		= _G[frameName.."ResizeTop"]
		
		-- Scrolling
		chatFrame:EnableMouseWheel(true)
		chatFrame:SetScript("OnMouseWheel", function(this,value) if value < 0 then this:ScrollDown() else this:ScrollUp() end end)
		
		-- Font / Font Shadow
		if ( not IsCombatLog(chatFrame) ) then
			chatFrame:SetFont(ds_chat.conf.ChatFont, ds_chat.conf.ChatSize)
			chatFrame:SetShadowOffset(ds_chat.conf.ChatShad, -ds_chat.conf.ChatShad)
		end
		
		-- Bg is None
		if ds_chat.conf.ChatBgCh[i] == "None" then
			reg1:Hide()reg2:Hide()reg3:Hide()reg4:Hide()reg5:Hide()reg6:Hide()reg7:Hide()reg8:Hide()reg0:Hide()
			
		-- Bg is a Texture
		else
			-- Top Left corner
			reg1:ClearAllPoints()
			reg1:SetWidth(chatBg.tls)
			reg1:SetHeight(chatBg.tls)
			reg1:SetPoint("TOPLEFT", reg0 ,"TOPLEFT", chatBg.tlh, chatBg.tlv)
			
			regX = reg1:GetRegions()
			regX:SetWidth(chatBg.tls)
			regX:SetHeight(chatBg.tls)
			regX:SetTexCoord(0,1,0,1)
			regX:SetTexture(chatBg.tlb)
			
			-- Top Border
			reg8:ClearAllPoints()
			reg8:SetHeight(chatBg.tms)
			reg8:SetPoint("TOPLEFT", reg1 ,"TOPRIGHT", chatBg.tmh, chatBg.tmv)
			reg8:SetPoint("TOPRIGHT", reg3 ,"TOPLEFT", -chatBg.tmh, chatBg.tmv)
			
			regX = reg8:GetRegions()
			regX:SetHeight(chatBg.tms)
			regX:SetTexCoord(0,1,0,1)
			regX:SetTexture(chatBg.tmb)
			
			-- Top Right corner
			reg3:ClearAllPoints()
			reg3:SetWidth(chatBg.trs)
			reg3:SetHeight(chatBg.trs)
			reg3:SetPoint("TOPRIGHT", reg0 ,"TOPRIGHT", chatBg.trh, chatBg.trv)
			
			regX = reg3:GetRegions()
			regX:SetWidth(chatBg.trs)
			regX:SetHeight(chatBg.trs)
			regX:SetTexCoord(0,1,0,1)
			regX:SetTexture(chatBg.trb)
			
			-- Left Border
			reg5:ClearAllPoints()
			reg5:SetWidth(chatBg.lbs)
			reg5:SetPoint("TOPLEFT", reg1 ,"BOTTOMLEFT", chatBg.lbh, chatBg.lbv)
			reg5:SetPoint("BOTTOMLEFT", reg2 ,"TOPLEFT", chatBg.lbh, chatBg.lbv)
			
			regX = reg5:GetRegions()
			regX:SetWidth(chatBg.lbs)
			regX:SetTexCoord(0,1,0,1)
			regX:SetTexture(chatBg.lbb)
			
			-- Right Border
			reg6:ClearAllPoints()
			reg6:SetWidth(chatBg.rbs)
			reg6:SetPoint("TOPRIGHT", reg3 ,"BOTTOMRIGHT", chatBg.rbh, chatBg.rbv)
			reg6:SetPoint("BOTTOMRIGHT", reg4 ,"TOPRIGHT", chatBg.rbh, chatBg.rbv)
			
			regX = reg6:GetRegions()
			regX:SetWidth(chatBg.rbs)
			regX:SetTexCoord(0,1,0,1)
			regX:SetTexture(chatBg.rbb)
			
			-- Bottom Left corner
			reg2:ClearAllPoints()
			reg2:SetWidth(chatBg.bls)
			reg2:SetHeight(chatBg.bls)
			reg2:SetPoint("BOTTOMLEFT", reg0 ,"BOTTOMLEFT", chatBg.blh, chatBg.blv)
			
			regX = reg2:GetRegions()
			regX:SetWidth(chatBg.bls)
			regX:SetHeight(chatBg.bls)
			regX:SetTexCoord(0,1,0,1)
			regX:SetTexture(chatBg.blb)
			
			-- Bottom Right corner
			reg4:ClearAllPoints()
			reg4:SetWidth(chatBg.brs)
			reg4:SetHeight(chatBg.brs)
			reg4:SetPoint("BOTTOMRIGHT", reg0 ,"BOTTOMRIGHT", chatBg.brh, chatBg.brv)
			
			regX = reg4:GetRegions()
			regX:SetWidth(chatBg.brs)
			regX:SetHeight(chatBg.brs)
			regX:SetTexCoord(0,1,0,1)
			regX:SetTexture(chatBg.brb)
			
			-- Bottom Border
			reg7:ClearAllPoints()
			reg7:SetHeight(chatBg.bms)
			reg7:SetPoint("BOTTOMLEFT", reg2 ,"BOTTOMRIGHT", chatBg.bmh, chatBg.bmv)
			reg7:SetPoint("BOTTOMRIGHT", reg4 ,"BOTTOMLEFT", -chatBg.bmh, chatBg.bmv)
			
			regX = reg7:GetRegions()
			regX:SetHeight(chatBg.bms)
			regX:SetTexCoord(0,1,0,1)
			regX:SetTexture(chatBg.bmb)
			
			-- Background
			reg0:ClearAllPoints()
			reg0:SetPoint("TOPLEFT", chatFrame ,"TOPLEFT", chatBg.bgH, chatBg.bgV)
			reg0:SetPoint("BOTTOMRIGHT", chatFrame ,"BOTTOMRIGHT", chatBg.bgh, chatBg.bgv)
			reg0:SetTexCoord(0,1,0,1)
			reg0:SetTexture(chatBg.bgg)
			
			-- Show All Regions
			reg0:Show()reg1:Show()reg2:Show()reg3:Show()reg4:Show()reg5:Show()reg6:Show()reg7:Show()reg8:Show()
		end
		
		-- Blizard Skin Fix
		if ds_chat.conf.SkinName == "Blizzard" then
			
			regX = reg1:GetRegions()
			regX:SetTexCoord(0,0.25,0,0.125)
			regX = reg8:GetRegions()
			regX:SetTexCoord(0.25,0.75,0,0.125)
			regX = reg3:GetRegions()
			regX:SetTexCoord(0.75,1,0,0.125)
			regX = reg5:GetRegions()
			regX:SetTexCoord(0,0.25,0.125,0.7265625)
			regX = reg6:GetRegions()
			regX:SetTexCoord(0.75,1,0.125,0.7265625)
			regX = reg2:GetRegions()
			regX:SetTexCoord(0,0.25,0.7265625,0.8515625)
			regX = reg4:GetRegions()
			regX:SetTexCoord(0.75,1,0.7265625,0.8515625)
			regX = reg7:GetRegions()
			regX:SetTexCoord(0.25,0.75,0.7265625,0.8515625)
			tab:GetHighlightTexture():SetVertexColor(1,1,1)
		
		-- Normal Skins
		else
			tab:GetHighlightTexture():SetVertexColor(0,0,0)
		end
		
		-- Skin Tab
		ds_chat_skinTab(tab)
		
		-- Tab Text & Bg & Docktype
		if ds_chat.conf.TabDockP == "LEFT" or ds_chat.conf.TabDockP == "RIGHT" then
			if chatFrame.isDocked then
				tabText:SetText(string.upper(string.sub(tab.fullText, 1,1)))
				tabText:SetFont(ds_chat.conf.TabFoFam, ds_chat.conf.TabFoSiz+4)
				ds_chat_tabBg(tab)
			end
		end
		
		-- Undockd Tab Position & Text
		if not chatFrame.isDocked then
			ds_chat_tabPosition(chatFrame, 0)
			tabText:SetTextColor(ds_chat.conf.TabFoCol.r,ds_chat.conf.TabFoCol.g,ds_chat.conf.TabFoCol.b,ds_chat.conf.TabFoCol.a)
		end
		
		-- Invarse bottom + Tab Bg
		if ds_chat.conf.TabDockP == "BOTTOM" and chatFrame.isDocked then
			ds_chat_tabBgRev(tab, true)
			tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, 0)
			tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 11)
		end
		
		-- Tab on LR
		if ds_chat.conf.TabDockP == "LEFT" and chatFrame.isDocked then
			tab.bg:Show()
			tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, 0)
			tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
			tab.bg:SetTexCoord(0,1,0,1)
		end
		
		if ds_chat.conf.TabDockP == "RIGHT" and chatFrame.isDocked then
			tab.bg:Show()
			tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, 0)
			tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
			tab.bg:SetTexCoord(1,0,1,0)
		end
		
		-- Tab Alphas
		CHAT_FRAME_BUTTON_MIN_ALPHA	= ds_chat.conf.TabAlph1
		CHAT_FRAME_BUTTON_MAX_ALPHA	= ds_chat.conf.TabAlph2
		
		-- Tab Alpha
		if not ds_chat.conf.TabScrol then tab:Hide() end
		
		-- Chat Buttons
		if not ds_chat.conf.ChatBtns or ds_chat.conf.TabDockP == "LEFT" then
			_G[frameName.."UpButton"]:SetScript("OnShow", function (self) self:Hide() end)
			_G[frameName.."UpButton"]:Hide()
			_G[frameName.."DownButton"]:SetScript("OnShow", function (self) self:Hide() end)
			_G[frameName.."DownButton"]:Hide()
			_G[frameName.."BottomButton"]:SetScript("OnShow", function (self) self:Hide() end)
			_G[frameName.."BottomButton"]:Hide()
		else
			_G[frameName.."UpButton"]:SetScript("OnShow", nil)
			_G[frameName.."UpButton"]:Show()
			_G[frameName.."DownButton"]:SetScript("OnShow", nil)
			_G[frameName.."DownButton"]:Show()
			_G[frameName.."BottomButton"]:SetScript("OnShow", nil)
			_G[frameName.."BottomButton"]:Show()
		end
		
		-- So chat frame can be partially dragged out
		chatFrame:SetClampedToScreen(false)
	end
	
	-- Edit Box Skin
	editBoxL:SetWidth(editBg.txw)
	editBoxL:SetHeight(editBg.txh)
	editBoxL:SetTexture(editBg.txl)
	editBoxM:SetHeight(editBg.txh)
	editBoxM:SetTexture(editBg.txm)
	editBoxR:SetWidth(editBg.txw)
	editBoxR:SetHeight(editBg.txh)
	editBoxR:SetTexture(editBg.txr)
	editBoxH:ClearAllPoints()
	editBoxH:SetPoint("LEFT", editBox, "LEFT", editBg.ins, 0)
	
	-- Color and Reset
	if ds_chat.conf.EditBgTx == "Color" then
		editBoxL:SetVertexColor(editBg.col.r,editBg.col.g,editBg.col.b,editBg.col.a)
		editBoxM:SetVertexColor(editBg.col.r,editBg.col.g,editBg.col.b,editBg.col.a)
		editBoxR:SetVertexColor(editBg.col.r,editBg.col.g,editBg.col.b,editBg.col.a)
		ds_chat.box.bgl:SetVertexColor(editBg.col.r,editBg.col.g,editBg.col.b,editBg.col.a)
		ds_chat.box.bgm:SetVertexColor(editBg.col.r,editBg.col.g,editBg.col.b,editBg.col.a)
		ds_chat.box.bgr:SetVertexColor(editBg.col.r,editBg.col.g,editBg.col.b,editBg.col.a)
	else
		editBoxL:SetVertexColor(1,1,1,1)
		editBoxM:SetVertexColor(1,1,1,1)
		editBoxR:SetVertexColor(1,1,1,1)
		ds_chat.box.bgl:SetVertexColor(1,1,1,1)
		ds_chat.box.bgm:SetVertexColor(1,1,1,1)
		ds_chat.box.bgr:SetVertexColor(1,1,1,1)
	end
	
	-- Edit Box Font
	editBox:SetFont(ds_chat.conf.EditFont, ds_chat.conf.EditSize)
	editBox:SetShadowOffset(ds_chat.conf.EditShad, -ds_chat.conf.EditShad)
	editBoxH:SetFont(ds_chat.conf.EditFont, ds_chat.conf.EditSize)
	editBoxH:SetShadowOffset(ds_chat.conf.EditShad, -ds_chat.conf.EditShad)
	
	-- Edit / Href Box New Positions
	editBox:ClearAllPoints()
	
	if ds_chat.conf.EditPosx == "TOP" then
		if ds_chat.conf.TabDockP == "TOP" then editPt = editPt + editBg.dmh end
		editBox:SetPoint("BOTTOMLEFT", "ChatFrame1" , "TOPLEFT", -editBg.lpd, editPt)
		editBox:SetPoint("BOTTOMRIGHT", "ChatFrame1" , "TOPRIGHT", editBg.rpd, editPt)
		
		ds_chat.box:SetPoint("BOTTOMLEFT", "ChatFrame1" ,"TOPLEFT", -editBg.lpd, ds_chat.conf.EditPdLn + editPt)
		ds_chat.box:SetPoint("BOTTOMRIGHT", "ChatFrame1" ,"TOPRIGHT", editBg.rpd, ds_chat.conf.EditPdLn + editPt)
	else
		if ds_chat.conf.TabDockP == "BOTTOM" then editPb = editPb + editBg.dmh end
		editBox:SetPoint("TOPLEFT", "ChatFrame1" , "BOTTOMLEFT", -editBg.lpd, -editPb )
		editBox:SetPoint("TOPRIGHT", "ChatFrame1" , "BOTTOMRIGHT", editBg.rpd, -editPb )
		
		-- Href Box is still on Top
		if ds_chat.conf.TabDockP == "TOP" then editPt = editBg.pdt + editBg.dmh end
		ds_chat.box:SetPoint("BOTTOMLEFT", "ChatFrame1" ,"TOPLEFT", -editBg.lpd, editPt)
		ds_chat.box:SetPoint("BOTTOMRIGHT", "ChatFrame1" ,"TOPRIGHT", editBg.rpd, editPt)
	end
	
	-- Href Box
	ds_chat.box:SetHeight(ChatFrameEditBox:GetHeight())
	ds_chat.box:SetTextInsets(editBg.ins, editBg.ins, 0, 0)
	ds_chat.box:SetFont(ds_chat.conf.EditFont, ds_chat.conf.EditSize)
	ds_chat.box:SetShadowOffset(ds_chat.conf.EditShad, -ds_chat.conf.EditShad)
	ds_chat.box.bgl:SetWidth(editBg.txw)
	ds_chat.box.bgl:SetHeight(editBg.txh)
	ds_chat.box.bgl:SetTexture(editBg.txl)
	ds_chat.box.bgm:SetHeight(editBg.txh)
	ds_chat.box.bgm:SetTexture(editBg.txm)
	ds_chat.box.bgr:SetWidth(editBg.txw)
	ds_chat.box.bgr:SetHeight(editBg.txh)
	ds_chat.box.bgr:SetTexture(editBg.txr)
	
	-- Edit / Href Box Blizard Fix
	if ds_chat.conf.EditBgTx == "Blizzard" then
		editBoxL:SetWidth(256)
		editBoxM:SetTexCoord(0,0.9375,0,1)
		editBoxR:SetTexCoord(0.9375,1,0,1)
		ds_chat.box.bgl:SetWidth(256)
		ds_chat.box.bgm:SetTexCoord(0,0.9375,0,1)
		ds_chat.box.bgr:SetTexCoord(0.9375,1,0,1)
	else
		editBoxM:SetTexCoord(0,1,0,1)
		editBoxR:SetTexCoord(0,1,0,1)
		ds_chat.box.bgm:SetTexCoord(0,1,0,1)
		ds_chat.box.bgr:SetTexCoord(0,1,0,1)
	end
	
	-- Chat Menu Button
	if not ds_chat.conf.ChatBtns or ds_chat.conf.TabDockP == "LEFT" then
		_G["ChatFrameMenuButton"]:SetScript("OnShow", function (self) self:Hide() end)
		_G["ChatFrameMenuButton"]:Hide()
	else
		_G["ChatFrameMenuButton"]:SetScript("OnShow", nil)
		_G["ChatFrameMenuButton"]:Show()
	end
	
	-- Def Alpha
	DEFAULT_CHATFRAME_ALPHA = ds_chat.conf.ChatBase
	
	-- Salt
	FCF_DockUpdate()
	ds_chat_dockUpdate()
end


function ds_chat_init()
	
	-- Snap
	db_snap = ds_db
	
	-- Conf
	if ds_conf.chat == nil then
		
		-- New Char
		if ds_glob_conf.chat ~= nil then
			ds_conf.cver = 1.02
			ds_conf.chat = ds_glob_conf.chat
			
		-- Fresh Conf
		else
			ds_conf.cver = 1.02
			ds_conf.chat = TableDeepCopy(DSC_TEMPLATE)
			for k, v in pairs(DSC_SKINS_LIST["Simple"]) do ds_conf.chat[k] = v end
		end
		
		-- Reset alpha
		for i = 1, NUM_CHAT_WINDOWS do FCF_SetWindowAlpha(_G["ChatFrame"..i], ds_conf.chat.ChatBase) end
	end	
	
	-- Version Control
	if ds_conf.cver < 1.02 then
		
		-- Copy & Overwrite
		local tempconf = TableDeepCopy(ds_conf.chat)
		ds_conf.cver = 1.02
		ds_conf.chat = TableDeepCopy(DSC_TEMPLATE)
		for k, v in pairs(tempconf) do ds_conf.chat[k] = v end
	end
	
	-- Setup
	ds_chat = CreateFrame("Frame")
	ds_chat.conf = ds_conf.chat
	ds_chat.queue = {}
	ds_chat.query = nil
	ds_chat.queryTime = 0
	ds_chat.emoji = DSC_EMOJI_LIST
	ds_chat.emote = DSC_EMOTE_LIST
	ds_chat.ecode = DSC_EMOTE_CODES
	ds_chat.stamp = date("%y%m%d")
	ds_chat.whisp = {}
	ds_chat.guild = {}
	ds_chat.guildies = 0
	ds_chat.player = UnitName("player")
	ds_chat.friends = {}
	ds_chat.faction = UnitFactionGroup("player")
	ds_chat.numWindows = NUM_CHAT_WINDOWS
	ds_chat.classColor = DSC_CLASS_COLORS
	
	-- Dock
	ds_chat.dock = CreateFrame("Frame", nil, UIParent)
	
	-- Hyperlink Copy Box
	ds_chat.box = CreateFrame("EditBox", nil, UIParent)
	ds_chat.box:SetAutoFocus(false)
	ds_chat.box:SetScript("OnEscapePressed", function(self) self:Hide() end)
	ds_chat.box:SetShadowColor(0,0,0,1)
	ds_chat.box:SetFrameStrata("TOOLTIP")
	ds_chat.box:Hide()
	
	-- Box BG
	ds_chat.box.bgl = ds_chat.box:CreateTexture(nil, "BACKGROUND")
	ds_chat.box.bgm = ds_chat.box:CreateTexture(nil, "BACKGROUND")
	ds_chat.box.bgr = ds_chat.box:CreateTexture(nil, "BACKGROUND")
	ds_chat.box.bgl:SetAlpha(0.5)
	ds_chat.box.bgm:SetAlpha(0.5)
	ds_chat.box.bgr:SetAlpha(0.5)
	ds_chat.box.bgl:SetPoint("LEFT", ds_chat.box ,"LEFT", 0, 0)
	ds_chat.box.bgm:SetPoint("LEFT", ds_chat.box.bgl ,"RIGHT", 0, 0)
	ds_chat.box.bgm:SetPoint("RIGHT", ds_chat.box.bgr ,"LEFT", 0, 0)
	ds_chat.box.bgr:SetPoint("RIGHT", ds_chat.box ,"RIGHT", 0, 0)
	
	-- Store OrgFx
	ds_chat.oaddm = ChatFrame1.AddMessage
	ds_chat.sendWho = SendWho
	ds_chat.ofriends = FriendsFrame_OnEvent
	
	-- Hook New
	ChatFrame_OnHyperlinkShow = ds_chat_onItemRef
	FriendsFrame_OnEvent = ds_chat_FriendsFrame_OnEvent
	SendWho = ds_chat_SendWho
	
	-- Add DS Chat Message Handler
	for i = 1, ds_chat.numWindows do
		
		-- Except Combat Log
		if not IsCombatLog(_G["ChatFrame"..i]) then _G["ChatFrame"..i].AddMessage = ds_chat_onAddMessage end
		
		-- More Text
		_G["ChatFrame"..i]:SetMaxLines(1500)
	end
	
	-- Events
	ds_chat:RegisterEvent("MINIMAP_UPDATE_ZOOM")
	ds_chat:RegisterEvent("GUILD_ROSTER_UPDATE")
	ds_chat:RegisterEvent("FRIENDLIST_UPDATE")
	ds_chat:RegisterEvent("WHO_LIST_UPDATE")
	ds_chat:RegisterEvent("PLAYER_LOGOUT")
	ds_chat:SetScript("OnEvent", ds_chat_onEvent)
	
	-- Opts & Skin
	ds_chat_options()
	ds_chat_skinChat()
	
	-- HoooKs
	hooksecurefunc("FCF_DockUpdate", ds_chat_dockUpdate)
	hooksecurefunc("FCF_SetTabPosition", ds_chat_tabPosition)
	hooksecurefunc("FCF_UnDockFrame", ds_chat_dockUndock)
	hooksecurefunc("FCF_DockFrame", ds_chat_dockDock)
	hooksecurefunc("FCF_Close", ds_chat_dockUpdate)
	hooksecurefunc("FCF_SetWindowName", ds_chat_onWindowName)
	hooksecurefunc("ChatEdit_UpdateHeader", ds_chat_onHeaderUpdate)
	hooksecurefunc("ChatEdit_OnEscapePressed",function(ceb) ceb:Hide() end)
	hooksecurefunc("ChatEdit_SendText",ds_chat_onSendText)
	hooksecurefunc(WhoFrame, "Hide", ds_chat_onWho)
	hooksecurefunc(WhoFrame, "Show", ds_chat_onWho)
	
	-- MEME
	DEFAULT_CHAT_FRAME:AddMessage("Type /dsc for chat options",0.74,0.02,0.02)
end

	-- Register
	table.insert(ds.modules, "ds_chat_init")