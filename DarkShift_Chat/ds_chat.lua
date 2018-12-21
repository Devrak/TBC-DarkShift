--[[
Addon: DarkShift UI
Module: Chat
Developed by: ©Devrak 2k18
]]--


function ds_chat_init()
	
	-- C
	ds_chat = CreateFrame("Frame")
	ds_chat:RegisterEvent("GUILD_ROSTER_UPDATE")
	ds_chat:RegisterEvent("FRIENDLIST_UPDATE")
	ds_chat:RegisterEvent("PLAYER_LOGOUT")
	ds_chat:SetScript("OnEvent", ds_chat_onEvent)
	
	-- MEME
	DEFAULT_CHAT_FRAME:AddMessage("Type /dsc for chat options",0.74,0.02,0.02)
	
	-- Hyperlink Copy Box
	ds_chat.box = CreateFrame("EditBox", nil, UIParent)
	ds_chat.box:SetAutoFocus(false)
	ds_chat.box:SetScript("OnEscapePressed", function(self) self:Hide() end)
	ds_chat.box:SetShadowColor(0,0,0,1)
	ds_chat.box:SetFrameStrata("TOOLTIP")
	ds_chat.box:Hide()
	
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
	
	-- Dock Manager
	GeneralDockManager = CreateFrame("Frame", "GeneralDockManager", UIParent)
	
	-- Chatlink Handling
	ChatFrame_OnHyperlinkShow = ds_chat_onItemRef
	
	-- Message Sending
	-- ChatEdit_OnEnterPressed = ds_chat_editOnEnterPressed
	
	-- Store Org Addmsg
	ds_chat.oaddm = ChatFrame1.AddMessage
	
	-- Add DS Chat Message Handler ( Minus Combat Log )
	for i=1, NUM_CHAT_WINDOWS do if not IsCombatLog(_G["ChatFrame"..i]) then _G["ChatFrame"..i].AddMessage = ds_chat_onAddMessage end end
	
	-- Conf / New
	if ds_conf.chat == nil then
		
		-- Link global config
		if ds_glob_conf.chat ~= nil then
			ds_conf.chat = ds_glob_conf.chat
			ds_conf.chat.applyGrp = ""
		else
			ds_conf.chat = DSC_SKINS_LIST["Simple"]
			ds_conf.chat.applyGrp = ""
			ds_conf.chat.stickChn = ""
		end
		
		-- Reset alpha
		for i=1, NUM_CHAT_WINDOWS do FCF_SetWindowAlpha(_G["ChatFrame"..i], ds_conf.chat.ChatBase) end	
	end	
	
	-- Version Control
	if not ds_conf.cver or ds_conf.cver < 1.01 then
		
		local tempconf = TableDeepCopy(ds_conf.chat)
		ds_conf.chat = DSC_TEMPLATE
		ds_conf.cver = 1.01
		
		for k, v in pairs(tempconf) do ds_conf.chat[k] = v end
	end
	
	-- Chat options
	ds_chat_options()
	
	-- Skin it
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
	hooksecurefunc("ChatEdit_SendText",function() ChatFrameEditBox:SetAttribute("stickyType", this:GetAttribute("chatType")) end)
end

function ds_chat_skinChat()
	
	-- Stuff
	local editBg 	= ds_conf.chat.EditBgTs[ds_conf.chat.EditBgTx]
	local editPt 	= editBg.pdt
	local editPb 	= editBg.pdb
	local editBox 	= _G["ChatFrameEditBox"]
	local editBoxH 	= _G["ChatFrameEditBoxHeader"]
	local _, _, _, _, _, editBoxL, editBoxR, editBoxM = editBox:GetRegions()
	
	-- Dock
	GeneralDockManager:ClearAllPoints()
	
	if ds_conf.chat.TabDockP == "TOP" then
		GeneralDockManager:SetWidth(0)
		GeneralDockManager:SetHeight(32)
		GeneralDockManager:SetPoint("BOTTOMLEFT", ChatFrame1Background, "TOPLEFT", ds_conf.chat.TabDPadL, ds_conf.chat.TabDPadT)
		GeneralDockManager:SetPoint("BOTTOMRIGHT", ChatFrame1Background, "TOPRIGHT", ds_conf.chat.TabDPadR, ds_conf.chat.TabDPadT)
		
	elseif ds_conf.chat.TabDockP == "RIGHT" then
		GeneralDockManager:SetPoint("TOPLEFT", ChatFrame1Background, "TOPRIGHT", ds_conf.chat.TabDPadR, ds_conf.chat.TabSvpad)
		GeneralDockManager:SetWidth(100)
		GeneralDockManager:SetHeight(ChatFrame1:GetHeight())
		
	elseif ds_conf.chat.TabDockP == "BOTTOM" then
		GeneralDockManager:SetWidth(0)
		GeneralDockManager:SetHeight(32)
		GeneralDockManager:SetPoint("TOPLEFT", ChatFrame1Background, "BOTTOMLEFT", ds_conf.chat.TabDPadL, ds_conf.chat.TabDPadB)
		GeneralDockManager:SetPoint("TOPRIGHT", ChatFrame1Background, "BOTTOMRIGHT", ds_conf.chat.TabDPadR, ds_conf.chat.TabDPadB)
	else 
		GeneralDockManager:SetPoint("TOPRIGHT", ChatFrame1Background, "TOPLEFT", ds_conf.chat.TabDPadL, ds_conf.chat.TabSvpad)
		GeneralDockManager:SetWidth(100)
		GeneralDockManager:SetHeight(ChatFrame1:GetHeight())
	end	
	
	-- Chat Frames
	for i=1, NUM_CHAT_WINDOWS do	
		
		-- Stuff
		local frameName = "ChatFrame"..i
		local chatFrame = _G[frameName]
		local chatBtns	= _G[frameName.."ButtonFrame"]
		local chatBg 	=  ds_conf.chat.ChatBgTs[ds_conf.chat.ChatBgCh[i]]
		local tab		= _G[frameName.."Tab"]
		local tabText   = _G[frameName.."TabText"]
		local reg0 , _ 	=  chatFrame:GetRegions()	
		local reg1 		= _G[frameName.."ResizeTopLeft"]
		local reg2		= _G[frameName.."ResizeBottomLeft"]
		local reg3		= _G[frameName.."ResizeTopRight"]
		local reg4 		= _G[frameName.."ResizeBottomRight"]
		local reg5 		= _G[frameName.."ResizeLeft"]
		local reg6 		= _G[frameName.."ResizeRight"]
		local reg7 		= _G[frameName.."ResizeBottom"]
		local reg8 		= _G[frameName.."ResizeTop"]
		local regX
		
		-- Scrolling
		chatFrame:EnableMouseWheel(true)
		chatFrame:SetScript("OnMouseWheel", function(this,value) if value < 0 then this:ScrollDown() else this:ScrollUp() end end)
		
		-- Font / Font Shadow
		if ( not IsCombatLog(chatFrame) ) then
			chatFrame:SetFont(ds_conf.chat.ChatFont, ds_conf.chat.ChatSize)
			chatFrame:SetShadowOffset(ds_conf.chat.ChatShad, -ds_conf.chat.ChatShad)
		end
		
		-- Bg is None
		if ds_conf.chat.ChatBgCh[i] == "None" then
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
			
			-- Show
			reg0:Show()reg1:Show()reg2:Show()reg3:Show()reg4:Show()reg5:Show()reg6:Show()reg7:Show()reg8:Show()
		end
		
		-- Blizard Skin Fix
		if ds_conf.chat.SkinName == "Blizzard" then 
			
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
		else
			tab:GetHighlightTexture():SetVertexColor(0,0,0)
		end
		
		-- Skin Tab
		ds_chat_skinTab(tab)
		
		-- Tab Text & Bg & Docktype
		if ds_conf.chat.TabDockP == "LEFT" or ds_conf.chat.TabDockP == "RIGHT" then
			if chatFrame.isDocked then
				tabText:SetText(string.upper(string.sub(tab.fullText, 1,1)))
				tabText:SetFont(ds_conf.chat.TabFoFam, ds_conf.chat.TabFoSiz+4)
				ds_chat_tabBg(tab)
			end
		end
		
		-- Undockd Tab Position & Text
		if not chatFrame.isDocked then
			ds_chat_tabPosition(chatFrame, 0)
			tabText:SetTextColor(ds_conf.chat.TabFoCol.r,ds_conf.chat.TabFoCol.g,ds_conf.chat.TabFoCol.b,ds_conf.chat.TabFoCol.a)
		end
		
		-- Invarse bottom + Tab Bg
		if ds_conf.chat.TabDockP == "BOTTOM" and chatFrame.isDocked then
			ds_chat_tabBgRev(tab, true)
			tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, 0)
			tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 11)
		end
		
		-- Tab on LR
		if ds_conf.chat.TabDockP == "LEFT" and chatFrame.isDocked then
			tab.bg:Show()
			tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, 0)
			tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
			tab.bg:SetTexCoord(0,1,0,1)
		end
		
		if ds_conf.chat.TabDockP == "RIGHT" and chatFrame.isDocked then
			tab.bg:Show()
			tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, 0)
			tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
			tab.bg:SetTexCoord(1,0,1,0)
		end
		
		-- Tab Alphas
		CHAT_FRAME_BUTTON_MIN_ALPHA	= ds_conf.chat.TabAlph1
		CHAT_FRAME_BUTTON_MAX_ALPHA	= ds_conf.chat.TabAlph2
		
		-- Tab Alpha
		if not ds_conf.chat.TabScrol then
			tab:Hide()
		end
		
		-- Chat Buttons
		if not ds_conf.chat.ChatBtns or ds_conf.chat.TabDockP == "LEFT" then
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
		
		-- Misc
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
	
	-- Edit / Href Box Color
	if ds_conf.chat.EditBgTx == "Color" then
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
	editBox:SetFont(ds_conf.chat.EditFont, ds_conf.chat.EditSize)
	editBox:SetShadowOffset(ds_conf.chat.EditShad, -ds_conf.chat.EditShad)
	editBoxH:SetFont(ds_conf.chat.EditFont, ds_conf.chat.EditSize)
	editBoxH:SetShadowOffset(ds_conf.chat.EditShad, -ds_conf.chat.EditShad)
	
	-- Edit / Href Box Position
	editBox:ClearAllPoints()
	
	if ds_conf.chat.EditPosx == "TOP" then
		if ds_conf.chat.TabDockP == "TOP" then editPt = editPt + editBg.dmh end
		editBox:SetPoint("BOTTOMLEFT", "ChatFrame1" , "TOPLEFT", -editBg.lpd, editPt)
		editBox:SetPoint("BOTTOMRIGHT", "ChatFrame1" , "TOPRIGHT", editBg.rpd, editPt)
		
		ds_chat.box:SetPoint("BOTTOMLEFT", "ChatFrame1" ,"TOPLEFT", -editBg.lpd, ds_conf.chat.EditPdLn + editPt)
		ds_chat.box:SetPoint("BOTTOMRIGHT", "ChatFrame1" ,"TOPRIGHT", editBg.rpd, ds_conf.chat.EditPdLn + editPt)
	else
		if ds_conf.chat.TabDockP == "BOTTOM" then editPb = editPb + editBg.dmh end
		editBox:SetPoint("TOPLEFT", "ChatFrame1" , "BOTTOMLEFT", -editBg.lpd, -editPb )
		editBox:SetPoint("TOPRIGHT", "ChatFrame1" , "BOTTOMRIGHT", editBg.rpd, -editPb )
		
		if ds_conf.chat.TabDockP == "TOP" then editPt = editBg.pdt + editBg.dmh end
		ds_chat.box:SetPoint("BOTTOMLEFT", "ChatFrame1" ,"TOPLEFT", -editBg.lpd, editPt)
		ds_chat.box:SetPoint("BOTTOMRIGHT", "ChatFrame1" ,"TOPRIGHT", editBg.rpd, editPt)
	end
	
	-- Href Frame
	ds_chat.box:SetHeight(ChatFrameEditBox:GetHeight())
	ds_chat.box:SetTextInsets(editBg.ins, editBg.ins, 0, 0)
	ds_chat.box:SetFont(ds_conf.chat.EditFont, ds_conf.chat.EditSize)
	ds_chat.box:SetShadowOffset(ds_conf.chat.EditShad, -ds_conf.chat.EditShad)
	ds_chat.box.bgl:SetWidth(editBg.txw)
	ds_chat.box.bgl:SetHeight(editBg.txh)
	ds_chat.box.bgl:SetTexture(editBg.txl)
	ds_chat.box.bgm:SetHeight(editBg.txh)
	ds_chat.box.bgm:SetTexture(editBg.txm)
	ds_chat.box.bgr:SetWidth(editBg.txw)
	ds_chat.box.bgr:SetHeight(editBg.txh)
	ds_chat.box.bgr:SetTexture(editBg.txr)
	
	-- Edit / Href Box Blizard Fix
	if ds_conf.chat.EditBgTx == "Blizzard" then
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
	if not ds_conf.chat.ChatBtns or ds_conf.chat.TabDockP == "LEFT" then
		_G["ChatFrameMenuButton"]:SetScript("OnShow", function (self) self:Hide() end)
		_G["ChatFrameMenuButton"]:Hide()
	else
		_G["ChatFrameMenuButton"]:SetScript("OnShow", nil)
		_G["ChatFrameMenuButton"]:Show()
	end
	
	-- Def Alpha
	DEFAULT_CHATFRAME_ALPHA = ds_conf.chat.ChatBase
	
	-- Salt
	FCF_DockUpdate()
	ds_chat_dockUpdate()
end

function ds_chat_skinTab(tab)
	
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
	text:SetFont(ds_conf.chat.TabFoFam, ds_conf.chat.TabFoSiz)
	text:SetShadowOffset(ds_conf.chat.TabFoShd,-ds_conf.chat.TabFoShd)
	
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
	reg6tex:SetTexture(ds_conf.chat.TabHighL)
	reg6tex:SetVertexColor(ds_conf.chat.AlphaC4)
	
	-- Top
	if ds_conf.chat.TabDockP == "TOP" then
		reg6:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 5, 0)
		reg6:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 3, 0)
		reg3:Show()
		
	-- Right
	elseif ds_conf.chat.TabDockP == "RIGHT"  then
		reg6:SetWidth(16)
		reg6:SetHeight(0)
		reg6:SetPoint("TOPLEFT", tab, "TOPLEFT", 3, 0)
		reg6:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 3, -2)
		reg3:Hide()
		
	-- Bottom
	elseif ds_conf.chat.TabDockP == "BOTTOM" then
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
	if ds_conf.chat.TabBgsTx == "Color" then
		tab.bg:Show()
		tab.bg:SetTexture(ds_conf.chat.TabBgsTs.Color.r, ds_conf.chat.TabBgsTs.Color.g, ds_conf.chat.TabBgsTs.Color.b, ds_conf.chat.TabBgsTs.Color.a)
		ds_chat_tabBg(tab)
	
	-- Bg Is A texture
	else
		local skin = ds_conf.chat.TabBgsTs[ds_conf.chat.TabBgsTx]
		reg0:SetTexture(skin.txl)   -- Bg L
		reg1:SetTexture(skin.txm)   -- Bg M
		reg2:SetTexture(skin.txr)   -- Bg R
		tab.bg:SetTexture(skin.txs) -- Bg LR
		
		reg0:SetVertexColor(1,1,1,1)
		reg1:SetVertexColor(1,1,1,1)
		reg2:SetVertexColor(1,1,1,1)
	end
end

function ds_chat_tabBgRev(tab, rew)
	
	-- Stuff
	local reg0, reg1, reg2, text = tab:GetRegions()
	local reg3 = tab:GetHighlightTexture()
	
	if rew then
		if ds_conf.chat.SkinName == "Blizzard" then
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
		if ds_conf.chat.SkinName == "Blizzard" then
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

function ds_chat_tabBg(tab, show)

	-- Stuff
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

function ds_chat_combatLogFix()
	
	-- Stuff
	local pad = CombatLogQuickButtonFrame_Custom:GetHeight()
	local ski = ds_conf.chat.ChatBgTs[ds_conf.chat.ChatBgCh[2]]
	local cbg = _G[COMBATLOG:GetName().."Background"]
	
	-- Combat Log Bg
	cbg:ClearAllPoints()
	cbg:SetPoint("TOPLEFT", COMBATLOG ,"TOPLEFT", ski.bgH, ski.bgV+pad)
	cbg:SetPoint("BOTTOMRIGHT", COMBATLOG ,"BOTTOMRIGHT", ski.bgh, ski.bgv)
end

function ds_chat_onWindowName(frame)
	
	-- Rename / New window Update
	local tab = _G[frame:GetName().."Tab"]
	tab.fullText = tab:GetText()
	
	if frame.isDocked and ds_conf.chat.TabDockP == "RIGHT" or frame.isDocked and ds_conf.chat.TabDockP == "LEFT" then
		tab:SetText(string.upper(string.sub(tab.fullText, 1,1)))
	end
end

function ds_chat_dockUpdate()
	
	-- Stuff
	local dock = GeneralDockManager
	local last = nil
	local maxv = math.ceil((ChatFrame1:GetHeight()+16) / 32) if maxv < 6 then maxv = 6 end
	local dockReg, dockHig, chatTab, tabText
	
	for index, chatFrame in ipairs(DOCKED_CHAT_FRAMES) do
		
		dockReg = _G[chatFrame:GetName().."TabDockRegion"]
		dockHig = _G[chatFrame:GetName().."TabDockRegionHighlight"]
		chatTab = _G[chatFrame:GetName().."Tab"]
		tabText = _G[chatFrame:GetName().."TabText"]
		
		-- Positioning of docked frames
		if ds_conf.chat.TabDockP == "RIGHT" then
			
			-- Position based on last Tab
			chatTab:ClearAllPoints()
			
			if last then
				if index ~= maxv then
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
		end
		
		-- Positioning of skinned frames
		if ds_conf.chat.TabDockP == "LEFT" then
			
			-- Position based on last Tab
			chatTab:ClearAllPoints()
			
			if last then
				if index ~= maxv then
					chatTab:SetPoint("TOPRIGHT", last, "BOTTOMRIGHT", 0, 0)
					chatTab:SetWidth(32)
				else
					-- Next Row
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
		end
		
		if ds_conf.chat.TabDockP == "TOP"  then
			
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
		end
		
		if ds_conf.chat.TabDockP == "BOTTOM"  then
			
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
		tabText:SetTextColor(ds_conf.chat.TabFoCol.r,ds_conf.chat.TabFoCol.g,ds_conf.chat.TabFoCol.b,ds_conf.chat.TabFoCol.a)
		
		-- Tab Alphas
		if ds_conf.chat.TabScrol then
			chatTab:Show()
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

function ds_chat_dockUndock(frame)
	
	-- Stuff
	local text = _G[frame:GetName().."TabText"]
	local reg0 = _G[frame:GetName().."TabLeft"]
	local reg1 = _G[frame:GetName().."TabMiddle"]
	local tab  = _G[frame:GetName().."Tab"]
	
	-- Text
	if ds_conf.chat.TabDockP == "RIGHT" or ds_conf.chat.TabDockP == "LEFT" then
		text:SetText(tab.fullText)
		text:SetFont(ds_conf.chat.TabFoFam, ds_conf.chat.TabFoSiz)
	end
	
	text:ClearAllPoints()
	text:SetPoint("BOTTOMLEFT", reg0, "BOTTOMRIGHT", 0,7)
	text:SetTextColor(ds_conf.chat.TabFoCol.r,ds_conf.chat.TabFoCol.g,ds_conf.chat.TabFoCol.b,ds_conf.chat.TabFoCol.a)
	
	-- Invarse bottom
	if ds_conf.chat.TabDockP == "BOTTOM" then ds_chat_tabBgRev(tab) end
	
	-- Square Bg
	if ds_conf.chat.TabBgsTx ~= "Color" then tab.bg:Hide() end
	tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -11) 
	tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
	
	-- Show Bg
	ds_chat_tabBg(tab,true)
	
	-- Force Update
	FCF_DockUpdate()
end

function ds_chat_dockDock(frame)
	
	-- Stuff
	local text = _G[frame:GetName().."TabText"]
	local reg0 = _G[frame:GetName().."TabLeft"]
	local tab  = _G[frame:GetName().."Tab"]
	
	-- Text
	if ds_conf.chat.TabDockP == "RIGHT" or  ds_conf.chat.TabDockP == "LEFT" then
		text:SetText(string.upper(string.sub(tab.fullText, 1,1)))
		text:SetFont(ds_conf.chat.TabFoFam, ds_conf.chat.TabFoSiz+4)
		
		-- Hide Bg
		ds_chat_tabBg(tab)
		
		-- Square BG
		tab.bg:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, 0)
		tab.bg:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", 0, 0)
	end
	
	if ds_conf.chat.TabDockP == "BOTTOM" then
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

function ds_chat_tabPosition(chatFrame, x)
	
	-- Tabs not docked position
	local chatTab = _G[chatFrame:GetName().."Tab"]
	chatTab:ClearAllPoints()
	chatTab:SetPoint("BOTTOMLEFT", chatFrame:GetName().."Background", "TOPLEFT", x+2, ds_conf.chat.TabDPadT)
end

function ds_chat_onHeaderUpdate(box)
	
	-- If correct Box set header Insets
	if box:GetName() ~= "MacroEditBox" then
		box:SetTextInsets(-2 + ds_conf.chat.EditBgTs[ds_conf.chat.EditBgTx].ins + _G[box:GetName().."Header"]:GetWidth(), 14, 0, 0)
	end
end

function ds_chat_onAddMessage(self,text,r,g,b)
	
	-- Filter
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
		
		-- Channel Name
		if event ~= 'CHAT_MSG_WHISPER' and event ~= 'CHAT_MSG_SAY' and event ~= 'CHAT_MSG_YELL' and event ~= 'CHAT_MSG_WHISPER_INFORM' then
			chch = string.find(text, '[%.%s0-9a-zA-Z]*%]')
			text = string.gsub(text, '[%.%s0-9a-zA-Z]*%]', string.sub(text, chch,chch)..']', 1)
		end
		
		-- Whispers
		if event == 'CHAT_MSG_WHISPER' or event == 'CHAT_MSG_WHISPER_INFORM' then
			
			-- Reform message
			if string.find(text, 'whispers:') then
				text = string.gsub(text, ' whispers', '', 1)
				text = string.gsub(text, '%['..arg2..'%]', '[W From] ['..arg2..']', 1)
			else
				text = string.gsub(text, 'To ', '', 1)
				text = string.gsub(text, '%['..arg2..'%]', '[W To] ['..arg2..']', 1)
			end
			
			-- Extra tag for guildies/friends
			if GUILD_LIST[arg2] then
				text = string.gsub(text, '%['..arg2..'%]', '|cff40fb40[G]|r['..arg2..']', 1)
			elseif FREND_LIST[arg2] then
				text = string.gsub(text, '%['..arg2..'%]', '|cfface5ee[F]|r['..arg2..']', 1)
			end
		end
		
		-- Group invite / apply for group
		if arg2 ~= UnitName("player") and event ~= "CHAT_MSG_RAID" and event ~= "CHAT_MSG_RAID_LEADER" and event ~= "CHAT_MSG_RAID_WARNING" then
			if string.find(arg1, 'LF%d?M%s') then
				text = text .. " |cff".. ds_conf.chat.GinvColo .."|Happ:" .. arg2 .. "|h[apply]|h|r"
			else
				text = string.gsub(text, "%s+invite.?", " |cff".. ds_conf.chat.GinvColo .."|Hinv:" .. arg2 .. "|h[inv]|h|r",1)
				text = string.gsub(text, "%s+inv.?", 	" |cff".. ds_conf.chat.GinvColo .."|Hinv:" .. arg2 .. "|h[inv]|h|r",1)
				text = string.gsub(text, "%s+123.?", 	" |cff".. ds_conf.chat.GinvColo .."|Hinv:" .. arg2 .. "|h[123]|h|r",1)
			end
		end
		
		-- Self Highlight
		text = string.gsub(text, "%s+"..UnitName("player"), " |cff".. ds_conf.chat.SelfColo ..""..UnitName("player").."|r",1)
		
		-- Plain Text
		local ClearText = string.gsub(arg1, '|c?.+|r?', '')
		
		-- Hyperlinks
		if string.find(ClearText, '[0-9a-z]%.[a-z][a-z]') then
			
			-- Match against pattern              http/s    //   domain     . domain       .com (2)   /sub.html?w=1       :12323
			local hlin = string.match(ClearText,'[htps]-%:?/?/?[0-9a-z%-]+[%.[0-9a-z%-]+]-%.[a-z]+[/[0-9a-zA-Z%-%.%?=&]+]-:?%d?%d?%d?%d?%d?')
			
			if hlin ~= nil then
				
				-- Gsub becomes unreliable if it contains ? or - character and escape % is not working 100% of the time
				text = string.gsub(text, "?", "$1")
				text = string.gsub(text, "-", "$2")
				hlin = string.gsub(hlin, "?", "$1")
				hlin = string.gsub(hlin, "-", "$2")
				
				-- Add Hyperlink
				text = string.gsub(text, hlin, "|cff".. ds_conf.chat.HlinColo .."|Href:|h["..hlin.."]|h|r")
				
				-- Add them back
				text = string.gsub(text, "$1", "?")
				text = string.gsub(text, "$2", "-")
			end
		end
		
		-- Emote Tags
		for emoji in string.gmatch(ClearText, "%b::") do
			if ( EMOJI_LIST[emoji] ) then
				text = string.gsub(text, emoji, EMOJI_LIST[emoji] .. ":"..ds_conf.chat.EmojiPix.."|t")
			end
		end
		
		-- Emotes without tags
		for k,v in pairs(EMOTE_LIST) do
			text = string.gsub(text, k, v .. ":"..ds_conf.chat.EmojiPix.."|t")
		end
	end
	
	-- TimeStamps
	if ( ds_conf.chat.TimeStmp ~= "Not" ) then text = "|cff".. ds_conf.chat.TimeColo .. date(ds_conf.chat.TimeStmp) .."|r "..text end
	
	-- To Chat
	ds_chat.oaddm(self,text,r,g,b)
end

function ds_chat_onItemRef(link, text, button)
	
	local type = string.sub(text, 13 , 15)
	
	-- If its Hyperlink
	if ( type == "ref" ) then
		ds_chat.box:Show()
		ds_chat.box:SetText(string.sub(text,20,-6))
		ds_chat.box:SetAutoFocus(true)
		return
	end
	
	-- If its Group invite
	if ( type == "inv") then
		InviteUnit(string.sub(text, 17 , -12))
		return
	end
	
	-- If its Apply for group
	if ( type == "app") then
		ChatFrame_OpenChat("/w ".. string.sub(text, 17 , -14) .." ".. ds_conf.chat.applyGrp)
		return
	end
	
	-- Org itemRef
	SetItemRef(link, text, button)
end

function ds_chat_editOnEnterPressed()
	
	-- For Sticky Channels
	ChatEdit_SendText(this, 1)
	this:SetAttribute("stickyType", this:GetAttribute("chatType"))
	ChatEdit_OnEscapePressed(this)
end

function ds_chat_onEvent(self, event , ...)
	
	if event == "GUILD_ROSTER_UPDATE" or event == "FRIENDLIST_UPDATE" then
		
		GUILD_LIST = {}
		FREND_LIST = {}
		
		-- Guildies List
		for i=1, GetNumGuildMembers(), 1 do
			local name,_ = GetGuildRosterInfo(i)
			if name ~= nil then GUILD_LIST[name] = true end
		end
		
		-- Frendies List
		for i=1, GetNumFriends(), 1 do
			local name,_ = GetFriendInfo(i)
			if name ~= nil then FREND_LIST[name] = true end
		end
		return
	end
	
	-- Save config to global db
	if event == "PLAYER_LOGOUT" then
		ds_glob_conf.chat = ds_conf.chat
	end
end

function ds_chat_activeFrames()
	
	-- Returns active chat windows
	local chatFrames = {}
	
	for i=1, FCF_GetNumActiveChatFrames() do	
		local tab = _G["ChatFrame"..i.."Tab"]
		local txt = tab:GetText()
		
		if tab.fullText ~= nil
			then txt = tab.fullText
		end
		
		chatFrames[i] = txt
	end
	return chatFrames
end

	-- Register
	table.insert(ds.modules, "ds_chat_init")
