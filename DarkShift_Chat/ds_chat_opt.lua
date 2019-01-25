--[[
Addon: DarkShift UI
Module: Chat , Opts
Developed by: ©Devrak 2k19
]]--


local ds_chat_opt

local function ds_chat_activeFrames()
	
	-- Returns active chat windows & titles
	local chatFrames = {}
	
	for i = 1, FCF_GetNumActiveChatFrames() do	
		local tab = _G["ChatFrame"..i.."Tab"]
		local txt = tab:GetText()
		
		if tab.fullText ~= nil
			then txt = tab.fullText
		end
		
		chatFrames[i] = txt
	end
	return chatFrames
end


local function ds_chat_optionsPosUpd()
	
	-- Update Chat x y w h
	local _, _, _, x, y = ChatFrame1:GetPoint()
	dsc_o5s5:SetText(math.floor(x*10+0.5)/10)
	dsc_o5s6:SetText(math.floor(y*10+0.5)/10)
	dsc_o5s7:SetText(math.floor(ChatFrame1:GetWidth()*10+0.5)/10)
	dsc_o5s8:SetText(math.floor(ChatFrame1:GetHeight()*10+0.5)/10)
end


local function ds_chat_optionsSet()
	
	-- Stuff
	local r , g , b , a;
	
	-- Chat Frame
	SetDropDownValue(dsc_o1s1,ds_conf.chat.SkinName)
	SetDropDownValue(dsc_o2s1,ds_conf.chat.ChatFont)
	SetDropDownValue(dsc_o2s2,ds_conf.chat.ChatSize)
	SetDropDownValue(dsc_o2s3,ds_conf.chat.ChatShad)				
	
	UIDropDownMenu_Initialize(dsc_o2s4, function()
		local info={}
		for k,v in pairs(ds_chat_activeFrames()) do
			info.text	= v
			info.value	= k
			info.func	= function ()
				
				-- Stuff
				local _, _, r, g, b, a = GetChatWindowInfo(this.value)
				
				UIDropDownMenu_SetSelectedValue(dsc_o2s4,this.value)
				if ds_conf.chat.ChatBgCh[this.value] == "None" then dsc_o2s6:Hide() else
					dsc_o2s6.sw:SetVertexColor(r, g, b, a)
					dsc_o2s6:Show()
				end
				
				dsc_o2s6.Frame = this.value
				SetDropDownValue(dsc_o2s5,ds_conf.chat.ChatBgCh[this.value])
			end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	SetDropDownValue(dsc_o2s4,1)
	
	UIDropDownMenu_Initialize(dsc_o2s5, function()
		local info={}
		for k,v in PairsByKeys(DSC_SKINS_LIST[ds_conf.chat.SkinName].ChatBgTs) do
			info.text	= k
			info.value	= k
			info.func	= function ()
				
				-- Stuff
				local frame = UIDropDownMenu_GetSelectedValue(dsc_o2s4)
				local _, _, r, g, b, a = GetChatWindowInfo(frame)
				
				UIDropDownMenu_SetSelectedValue(dsc_o2s5,this.value)
				if this.value == "None" then dsc_o2s6:Hide() else
					dsc_o2s6.sw:SetVertexColor(r, g, b, a)
					dsc_o2s6:Show()
				end
				
				ds_conf.chat.ChatBgCh[frame] = this.value
				ds_chat_skinChat()
			end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	UIDropDownMenu_SetSelectedValue(dsc_o2s5,ds_conf.chat.ChatBgCh[1])
	
	if ds_conf.chat.ChatBgCh[1] == "None" then dsc_o2s6:Hide() else
		_, _, r, g, b, a = GetChatWindowInfo(1)
		dsc_o2s6.sw:SetVertexColor(r, g, b, a)
		dsc_o2s6.Frame = 1
	end
	
	-- Tabs
	SetDropDownValue(dsc_o3s1,ds_conf.chat.TabFoFam)
	SetDropDownValue(dsc_o3s2,ds_conf.chat.TabFoSiz)
	SetDropDownValue(dsc_o3s3,ds_conf.chat.TabFoShd)			
	dsc_o3s4.sw:SetVertexColor(ds_conf.chat.TabFoCol.r, ds_conf.chat.TabFoCol.g, ds_conf.chat.TabFoCol.b, ds_conf.chat.TabFoCol.a)
	SetDropDownValue(dsc_o3s5,ds_conf.chat.TabDockP)
	
	UIDropDownMenu_Initialize(dsc_o3s6, function()
		local info={}
		for k,v in PairsByKeys(DSC_SKINS_LIST[ds_conf.chat.SkinName].TabBgsTs) do
			info.text	= k
			info.value	= k
			info.func	= function ()
				
				-- Stuff
				ds_conf.chat.TabBgsTx = this.value
				UIDropDownMenu_SetSelectedValue(dsc_o3s6,ds_conf.chat.TabBgsTx)
				
				if this.value == "None" then dsc_o3s7:Hide() else
					dsc_o3s7:Show()
					dsc_o3s7.sw:SetVertexColor(ds_conf.chat.TabBgsTs.Color.r, ds_conf.chat.TabBgsTs.Color.g, ds_conf.chat.TabBgsTs.Color.b, ds_conf.chat.TabBgsTs.Color.a)
				end
				
				ds_chat_skinChat()
			end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	SetDropDownValue(dsc_o3s6,ds_conf.chat.TabBgsTx)
	
	if ds_conf.chat.TabBgsTx ~= "Color" then dsc_o3s7:Hide() else
		dsc_o3s7.sw:SetVertexColor(ds_conf.chat.TabBgsTs.Color.r, ds_conf.chat.TabBgsTs.Color.g, ds_conf.chat.TabBgsTs.Color.b, ds_conf.chat.TabBgsTs.Color.a)
	end
	
	dsc_o3s8:SetValue(ds_conf.chat.TabAlph1*100)
	dsc_o3s9:SetValue(ds_conf.chat.TabAlph2*100)
	dsc_o3sA:SetChecked(ds_conf.chat.TabScrol)
	
	-- Input Frame
	SetDropDownValue(dsc_o4s1,ds_conf.chat.EditFont)
	SetDropDownValue(dsc_o4s2,ds_conf.chat.EditSize)
	SetDropDownValue(dsc_o4s3,ds_conf.chat.EditShad)
	SetDropDownValue(dsc_o4s4,ds_conf.chat.EditPosx)
	
	UIDropDownMenu_Initialize(dsc_o4s5, function()
		local info={}
		for k,v in pairs(ds_conf.chat.EditBgTs) do
			info.text	= k
			info.value	= k
			info.func	= function ()
				
				-- Stuff
				ds_conf.chat.EditBgTx = this.value
				UIDropDownMenu_SetSelectedValue(dsc_o4s5,this.value)
				
				if this.value ~= "Color" then  dsc_o4s6:Hide() else
					dsc_o4s6:Show()
					dsc_o4s6.sw:SetVertexColor(ds_conf.chat.EditBgTs.Color.col.r, ds_conf.chat.EditBgTs.Color.col.g, ds_conf.chat.EditBgTs.Color.col.b, ds_conf.chat.EditBgTs.Color.col.a)
				end
				
				ds_chat_skinChat()
			end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	SetDropDownValue(dsc_o4s5,ds_conf.chat.EditBgTx)
	
	if ds_conf.chat.EditBgTx ~= "Color" then dsc_o4s6:Hide() else
		_, _, r, g, b, a = GetChatWindowInfo(1)
		dsc_o4s6.sw:SetVertexColor(ds_conf.chat.EditBgTs.Color.col.r, ds_conf.chat.EditBgTs.Color.col.g, ds_conf.chat.EditBgTs.Color.col.b, ds_conf.chat.EditBgTs.Color.col.a)
	end
	
	-- Other
	SetDropDownValue(dsc_o5s1,ds_conf.chat.TimeStmp)
	
	if ds_conf.chat.TimeStmp == "Not" then dsc_o5s2:Hide() else
		r, g, b = colorToRGB(ds_conf.chat.TimeColo)
		dsc_o5s2.sw:SetVertexColor(r, g, b)
	end
	
	-- Colors
	r, g, b = colorToRGB(ds_conf.chat.SelfColo)
	dsc_o5s8.sw:SetVertexColor(r, g, b)
	
	r, g, b = colorToRGB(ds_conf.chat.HlinColo)
	dsc_o5s9.sw:SetVertexColor(r, g, b)
	
	r, g, b = colorToRGB(ds_conf.chat.GinvColo)
	dsc_o5sA.sw:SetVertexColor(r, g, b)	

	dsc_o5sC:SetChecked(ds_conf.chat.NameColo)
	
	-- Ignores
	dsc_o5sD:SetText(ds_conf.chat.MsgLevel)
	dsc_o5sE:SetChecked(ds_conf.chat.MsgChans)
	
	-- Emoji
	SetDropDownValue(dsc_o6s1,ds_conf.chat.EmojiPix)
end


local function ds_chat_optionsReset()
	
	-- Reset
	for k, v in pairs(TableDeepCopy(DSC_TEMPLATE)) do ds_conf.chat[k] = v end
	for k, v in pairs(TableDeepCopy(DSC_SKINS_LIST["Simple"])) do ds_conf.chat[k] = v end
	
	-- Reset Color / Alphas
	for i=1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame"..i]	
		FCF_SetWindowColor(chatFrame, DEFAULT_CHATFRAME_COLOR.r, DEFAULT_CHATFRAME_COLOR.g, DEFAULT_CHATFRAME_COLOR.b)
		FCF_SetWindowAlpha(chatFrame, ds_conf.chat.ChatBase)
	end
	
	-- Set Options
	ds_chat_optionsSet()
	
	-- Chat Position
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, 95)
	ChatFrame1:SetWidth(430)
	ChatFrame1:SetHeight(120)
	
	ds_chat_skinChat()
end


local function ds_chat_optionsBuild()

	-- C
	local opt, builder 
	
	-- Scroll Frame
	ds_chat_opt.sf = CreateFrame("ScrollFrame", nil, ds_chat_opt)
	ds_chat_opt.sf:SetWidth(376)
	ds_chat_opt.sf:SetHeight(398)
	ds_chat_opt.sf:EnableMouseWheel(true)
	ds_chat_opt.sf:SetPoint("TOPLEFT", ds_chat_opt, "TOPLEFT", 5, -5)
	ds_chat_opt.sf:SetScript("OnMouseWheel", function()
		local scrmax = this:GetVerticalScrollRange()
		local scroll = this:GetVerticalScroll()
		local scrupd = (scroll - (26*arg1))
		local script = ds_chat_opt.sl:GetScript("OnValueChanged")
		
		if scrupd < 0 then
			this:SetVerticalScroll(0)
		elseif scrupd > scrmax then
			this:SetVerticalScroll(scrmax)
		else
			this:SetVerticalScroll(scrupd)
		end
		
		ds_chat_opt.sl:SetScript("OnValueChanged", nil)
		ds_chat_opt.sl:SetValue(scrupd/scrmax)
		ds_chat_opt.sl:SetScript("OnValueChanged", script)
	end)
	
	-- Slider
	ds_chat_opt.sl = CreateFrame("Slider", nil, ds_chat_opt.sf)
	ds_chat_opt.sl:SetOrientation("VERTICAL")
	ds_chat_opt.sl:SetPoint("TOPRIGHT", ds_chat_opt.sf, "TOPRIGHT", 0, 8)
	ds_chat_opt.sl:SetBackdropColor(0,0,0,0.5)
	ds_chat_opt.sl:SetMinMaxValues(0,1)
	ds_chat_opt.sl:SetHeight(415)
	ds_chat_opt.sl:SetWidth(18)
	ds_chat_opt.sl:SetValue(0)
	ds_chat_opt.sl.ScrollFrame = ds_chat_opt.sf
	ds_chat_opt.sl:SetScript("OnValueChanged", function() ds_chat_opt.sf:SetVerticalScroll(ds_chat_opt.sf:GetVerticalScrollRange()*this:GetValue())end)
	
	-- Slider bg
	builder = ds_chat_opt.sl:CreateTexture(nil,"BACKGROUND")
	builder:SetWidth(19)
	builder:SetHeight(398)
	builder:SetPoint("TOPLEFT",ds_chat_opt.sl,-1,-8)
	builder:SetTexture(0, 0, 0, 0.3)
	
	-- Thumb
	builder = ds_chat_opt.sl:CreateTexture(nil,"BACKGROUND")
	builder:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	ds_chat_opt.sl:SetThumbTexture(builder)
	
	-- The Real Options Frame
	opt = CreateFrame("Frame", nil, UIParent)
	opt:SetWidth(389)
	opt:SetHeight(1710)
	ds_BigTitleString("Chat Options",opt,10,9)
	
	-- Skin Selection
	ds_TitleString("Skin",opt,12,50)
	opt.o1s = CreateFrame("Button", "dsc_o1s1", opt, "UIDropDownMenuTemplate")
	opt.o1s:SetPoint("TOPLEFT", opt, "TOPLEFT", -6 , -65)
	
	UIDropDownMenu_SetWidth(105,opt.o1s)
	UIDropDownMenu_JustifyText("LEFT",opt.o1s)
	UIDropDownMenu_Initialize(opt.o1s, function()
		local info={}
		for k,v in pairs(DSC_SKINS_LIST) do
			info.text	= k
			info.value	= k
			info.func	= function()
				
				-- Apply
				local tempconf = TableDeepCopy(DSC_SKINS_LIST[k])
				for k, v in pairs(tempconf) do ds_conf.chat[k] = v end
				
				-- Reset Color / Alphas
				for i=1, NUM_CHAT_WINDOWS do
					local chatFrame = _G["ChatFrame"..i]
					FCF_SetWindowColor(chatFrame, DEFAULT_CHATFRAME_COLOR.r, DEFAULT_CHATFRAME_COLOR.g, DEFAULT_CHATFRAME_COLOR.b)
					FCF_SetWindowAlpha(chatFrame, ds_conf.chat.ChatBase)
				end
				
				-- Set Options
				ds_chat_optionsSet()
			end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	UIDropDownMenu_SetSelectedValue(opt.o1s,ds_conf.chat.SkinName)
	ds_DescString("Changes skin but will reset other things",opt,146, 74,9)
	
	--[[ Chat Frame ]]---
	
	ds_TitleString("Chat Frame",opt,12,110)
	opt.o2 = ds_CustomBg(opt,336,126,10,125)
	
	-- Chat Font
	ds_TitleString("Font",opt.o2,16,14)
	opt.o2s1 = CreateFrame("Button", "dsc_o2s1", opt, "UIDropDownMenuTemplate")
	opt.o2s1:SetPoint("TOPLEFT", opt.o2, "TOPLEFT", -1 , -29)
	
	UIDropDownMenu_SetWidth(105,opt.o2s1)
	UIDropDownMenu_JustifyText("LEFT",opt.o2s1)
	UIDropDownMenu_Initialize(opt.o2s1, function()
		local info={}
		for k,v in PairsByKeys(DS_FONTS_LIST) do
			info.text	= k
			info.value	= v
			info.func	= function () ds_conf.chat.ChatFont = this.value;UIDropDownMenu_SetSelectedValue(opt.o2s1,ds_conf.chat.ChatFont);ds_chat_skinChat() end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Chat Font Size
	ds_TitleString("Size",opt.o2,152,14)
	opt.o2s2 = CreateFrame("Button", "dsc_o2s2", opt, "UIDropDownMenuTemplate")
	opt.o2s2:SetPoint("TOPLEFT", opt.o2, "TOPLEFT", 134 , -29)
	
	UIDropDownMenu_SetWidth(62,opt.o2s2)
	UIDropDownMenu_JustifyText("LEFT",opt.o2s2)
	UIDropDownMenu_Initialize(opt.o2s2, function()
		local info={}
		for k,v in ipairs({8,9,10,11,12,13,14,15,16,17,18}) do
			info.text	= v
			info.value	= v
			info.func	= function () ds_conf.chat.ChatSize = this.value;UIDropDownMenu_SetSelectedValue(opt.o2s2,ds_conf.chat.ChatSize);ds_chat_skinChat() end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Chat Font Shadow
	ds_TitleString("Shadow",opt.o2,243,14)
	opt.o2s3 = CreateFrame("Button", "dsc_o2s3", opt, "UIDropDownMenuTemplate")
	opt.o2s3:SetPoint("TOPLEFT", opt.o2, "TOPLEFT", 225 , -29)
	
	UIDropDownMenu_SetWidth(62,opt.o2s3)
	UIDropDownMenu_JustifyText("LEFT",opt.o2s3)
	UIDropDownMenu_Initialize(opt.o2s3, function()
		local info={}
		for k,v in ipairs({0,0.5,1,1.5}) do
			info.text	= v
			info.value	= v
			info.func	= function ()
				ds_conf.chat.ChatShad = this.value
				UIDropDownMenu_SetSelectedValue(opt.o2s3,ds_conf.chat.ChatShad)
				ds_chat_skinChat()
			end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Chat Frame Background
	ds_TitleString("Frame",opt.o2,16,69)
	opt.o2s4 = CreateFrame("Button", "dsc_o2s4", opt, "UIDropDownMenuTemplate")
	opt.o2s4:SetPoint("TOPLEFT", opt.o2, "TOPLEFT", -1 , -85)
	UIDropDownMenu_SetWidth(105,opt.o2s4)
	UIDropDownMenu_JustifyText("LEFT",opt.o2s4)
	
	-- Background Selection
	ds_TitleString("Background",opt.o2,152,69)
	opt.o2s5 = CreateFrame("Button", "dsc_o2s5", opt, "UIDropDownMenuTemplate")
	opt.o2s5:SetPoint("TOPLEFT", opt.o2, "TOPLEFT", 134 , -85)
	UIDropDownMenu_SetWidth(115,opt.o2s5)
	UIDropDownMenu_JustifyText("LEFT",opt.o2s5)
	
	-- Background Color Selection
	opt.o2s6 = ds_ColorSelector(opt,"dsc_o2s6",301,208)
	opt.o2s6:SetScript("OnClick", function() local r, g, b, a = this.sw:GetVertexColor() ShowColorPicker(r,g,b,1-a, this.Callback) end)
	opt.o2s6.Callback = function(cancel)
		if not ColorPickerFrame:IsVisible() then
			
			-- Stuff
			ColorPickerFrame.func = nil
			if cancel then return end
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = 1-OpacitySliderFrame:GetValue()
			local f = _G["ChatFrame"..dsc_o2s6.Frame]
			
			dsc_o2s6.sw:SetVertexColor(r, g, b, a)
			FCF_SetWindowColor(f, r, g, b)
			FCF_SetWindowAlpha(f, a)
		end
	end
	
	--[[ Tabs ]]--
	
	ds_TitleString("Tabs",opt,12,266)
	opt.o3 = ds_CustomBg(opt,336,232,10,281)
	
	-- Tab Font
	ds_TitleString("Font",opt.o3,16,14)
	opt.o3s1 = CreateFrame("Button", "dsc_o3s1", opt, "UIDropDownMenuTemplate")
	opt.o3s1:SetPoint("TOPLEFT", opt.o3, "TOPLEFT", -1 , -29)
	
	UIDropDownMenu_SetWidth(105,opt.o3s1)
	UIDropDownMenu_JustifyText("LEFT",opt.o3s1)
	UIDropDownMenu_Initialize(opt.o3s1, function()
		local info={}
		for k,v in PairsByKeys(DS_FONTS_LIST) do
			info.text	= k
			info.value	= v
			info.func	= function () ds_conf.chat.TabFoFam = this.value;UIDropDownMenu_SetSelectedValue(opt.o3s1,ds_conf.chat.TabFoFam);ds_chat_skinChat() end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Tab Font Size
	ds_TitleString("Size",opt.o3,152,14)
	opt.o3s2 = CreateFrame("Button", "dsc_o3s2", opt, "UIDropDownMenuTemplate")
	opt.o3s2:SetPoint("TOPLEFT", opt.o3, "TOPLEFT", 134 , -29)
	
	UIDropDownMenu_SetWidth(42,opt.o3s2)
	UIDropDownMenu_JustifyText("LEFT",opt.o3s2)
	UIDropDownMenu_Initialize(opt.o3s2, function()
		local info={}
		for k,v in ipairs({8,9,10,11,12,13,14,15,16,17,18}) do
			info.text	= v
			info.value	= v
			info.func	= function () ds_conf.chat.TabFoSiz = this.value;UIDropDownMenu_SetSelectedValue(opt.o3s2,ds_conf.chat.TabFoSiz);ds_chat_skinChat() end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Tab Font Shadow
	ds_TitleString("Shadow",opt.o3,225,14)
	opt.o3s3 = CreateFrame("Button", "dsc_o3s3", opt, "UIDropDownMenuTemplate")
	opt.o3s3:SetPoint("TOPLEFT", opt.o3, "TOPLEFT", 207 , -29)
	
	UIDropDownMenu_SetWidth(42,opt.o3s3)
	UIDropDownMenu_JustifyText("LEFT",opt.o3s3)
	UIDropDownMenu_Initialize(opt.o3s3, function()
		local info={}
		for k,v in ipairs({0,0.5,1,1.5}) do
			info.text	= v
			info.value	= v
			info.func	= function () ds_conf.chat.TabFoShd = v;UIDropDownMenu_SetSelectedValue(opt.o3s3,ds_conf.chat.TabFoShd);ds_chat_skinChat() end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Tab Font Color
	ds_TitleString("Color",opt.o3,290,14)
	opt.o3s4 = ds_ColorSelector(opt,"dsc_o3s4",301,308)
	opt.o3s4:SetScript("OnClick", function() local r, g, b, a = this.sw:GetVertexColor() ShowColorPicker(r,g,b,1-a, this.Callback) end)
	opt.o3s4.Callback = function(cancel)
		if not ColorPickerFrame:IsVisible() then
			
			-- Stuff
			ColorPickerFrame.func = nil
			if cancel then return end
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = 1-OpacitySliderFrame:GetValue()
			
			ds_conf.chat.TabFoCol.r = r
			ds_conf.chat.TabFoCol.g = g
			ds_conf.chat.TabFoCol.b = b
			ds_conf.chat.TabFoCol.a = a
			dsc_o3s4.sw:SetVertexColor(r, g, b, a)
			ds_chat_skinChat()
		end
	end
	
	-- Tab Position
	ds_TitleString("Tab Position",opt.o3,16,69)
	opt.o3s5 = CreateFrame("Button", "dsc_o3s5", opt, "UIDropDownMenuTemplate")
	opt.o3s5:SetPoint("TOPLEFT", opt.o3, "TOPLEFT", -1 , -85)
	
	UIDropDownMenu_SetWidth(105,opt.o3s5)
	UIDropDownMenu_JustifyText("LEFT",opt.o3s5)
	UIDropDownMenu_Initialize(opt.o3s5, function()
		local info={}
		for k,v in pairs({["Top"] = "TOP",["Right"] = "RIGHT",["Bottom"] = "BOTTOM",["Left"] = "LEFT"}) do
			info.text	= k
			info.value	= v
			info.func	= function() ds_conf.chat.TabDockP = this.value;UIDropDownMenu_SetSelectedValue(dsc_o3s5,ds_conf.chat.TabDockP)ds_chat_skinChat() end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Tab Background
	ds_TitleString("Tab Background",opt.o3,152,69)
	opt.o3s6 = CreateFrame("Button", "dsc_o3s6", opt, "UIDropDownMenuTemplate")
	opt.o3s6:SetPoint("TOPLEFT", opt.o3, "TOPLEFT", 134 , -85)
	
	UIDropDownMenu_SetWidth(115,opt.o3s6)
	UIDropDownMenu_JustifyText("LEFT",opt.o3s6)
	
	-- Tab Background Color
	opt.o3s7 = ds_ColorSelector(opt,"dsc_o3s7",301,364)
	opt.o3s7:SetScript("OnClick", function() local r, g, b, a = this.sw:GetVertexColor() ShowColorPicker(r,g,b,1-a, this.Callback) end)
	opt.o3s7.Callback = function(cancel)
		if not ColorPickerFrame:IsVisible() then
			
			-- Stuff
			ColorPickerFrame.func = nil
			if cancel then return end
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = 1-OpacitySliderFrame:GetValue()
			
			ds_conf.chat.TabBgsTs.Color.r = r
			ds_conf.chat.TabBgsTs.Color.g = g
			ds_conf.chat.TabBgsTs.Color.b = b
			ds_conf.chat.TabBgsTs.Color.a = a
			dsc_o3s7.sw:SetVertexColor(r, g, b, a)
			ds_chat_skinChat()
		end
	end
	
	-- Alpha 1 Slider
	ds_TitleString("Tab alpha",opt.o3,178,124)
	opt.o3s8 = ds_Slider(opt,"dsc_o3s8",192,426)
	opt.o3s8:SetScript("OnValueChanged", function(self,value) ds_conf.chat.TabAlph1 = dsc_o3s8:GetValue()/100 ds_chat_skinChat() end)
	
	-- Alpha 2 Slider
	ds_TitleString("Active Tab alpha",opt.o3,17,124)	
	opt.o3s9 = ds_Slider(opt,"dsc_o3s9",32,426)
 	opt.o3s9:SetScript("OnValueChanged", function(self,value) ds_conf.chat.TabAlph2 = dsc_o3s9:GetValue()/100 ds_chat_skinChat() end)
	
	-- Force Static ( Tab )
	ds_TitleString("Force Static",opt.o3,16,179)
	opt.o3sA = CreateFrame("CheckButton", "dsc_o3sA", opt, "UICheckButtonTemplate")
	opt.o3sA:SetPoint("TOPLEFT", opt, "TOPLEFT", 22, -474)
	opt.o3sA:SetScript("OnClick", function() ds_conf.chat.TabScrol = dsc_o3sA:GetChecked() ds_chat_skinChat() end)
	ds_DescString("Disables tab auto fadeing",opt.o3,46, 204,9)
	
	--[[ Edit Box (Input Frame / Href Frame)]]--
	
	ds_TitleString("Input Frame",opt,12,528)
	opt.o4 = ds_CustomBg(opt,336,126,10,543)
	
	-- Edit Font
	ds_TitleString("Font",opt.o4,16,14)
	opt.o4s1 = CreateFrame("Button", "dsc_o4s1", opt, "UIDropDownMenuTemplate")
	opt.o4s1:SetPoint("TOPLEFT", opt.o4, "TOPLEFT", -1 , -29)
	
	UIDropDownMenu_SetWidth(105,opt.o4s1)
	UIDropDownMenu_JustifyText("LEFT",opt.o4s1)
	UIDropDownMenu_Initialize(opt.o4s1, function()
		local info={}
		for k,v in PairsByKeys(DS_FONTS_LIST) do
			info.text	= k
			info.value	= v
			info.func	= function () ds_conf.chat.EditFont = this.value;UIDropDownMenu_SetSelectedValue(opt.o4s1,ds_conf.chat.EditFont);ds_chat_skinChat() end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Edit Font Size
	ds_TitleString("Size",opt.o4,152,14)
	opt.o4s2 = CreateFrame("Button", "dsc_o4s2", opt, "UIDropDownMenuTemplate")
	opt.o4s2:SetPoint("TOPLEFT", opt.o4, "TOPLEFT", 134 , -29)
	
	UIDropDownMenu_SetWidth(62,opt.o4s2)
	UIDropDownMenu_JustifyText("LEFT",opt.o4s2)
	UIDropDownMenu_Initialize(opt.o4s2, function()
		local info={}
		for k,v in ipairs({10,11,12,13,14,15}) do
			info.text	= v
			info.value	= v
			info.func	= function () ds_conf.chat.EditSize = this.value;UIDropDownMenu_SetSelectedValue(opt.o4s2,ds_conf.chat.EditSize);ds_chat_skinChat() end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Edit Font Shadow
	ds_TitleString("Shadow",opt.o4,243,14)
	opt.o4s3 = CreateFrame("Button", "dsc_o4s3", opt, "UIDropDownMenuTemplate")
	opt.o4s3:SetPoint("TOPLEFT", opt.o4, "TOPLEFT", 225 , -29)
	
	UIDropDownMenu_SetWidth(62,opt.o4s3)
	UIDropDownMenu_JustifyText("LEFT",opt.o4s3)
	UIDropDownMenu_Initialize(opt.o4s3, function()
		local info={}
		for k,v in ipairs({0,0.5,1,1.5}) do
			info.text	= v
			info.value	= v
			info.func	= function () ds_conf.chat.EditShad = v;UIDropDownMenu_SetSelectedValue(opt.o4s3,ds_conf.chat.EditShad);ds_chat_skinChat() end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Edit Location
	ds_TitleString("Frame Position",opt.o4,16,69)
	opt.o4s4 = CreateFrame("Button", "dsc_o4s4", opt, "UIDropDownMenuTemplate")
	opt.o4s4:SetPoint("TOPLEFT", opt.o4, "TOPLEFT", -1 , -85)
	
	UIDropDownMenu_SetWidth(105,opt.o4s4)
	UIDropDownMenu_JustifyText("LEFT",opt.o4s4)
	UIDropDownMenu_Initialize(opt.o4s4, function()
		local info={}
		for k,v in pairs({["Top"] = "TOP",["Bottom"] = "BOTTOM"}) do
			info.text	= k
			info.value	= v
			info.func	= function ()
				
				-- Stuff
				ds_conf.chat.EditPosx = this.value
				UIDropDownMenu_SetSelectedValue(opt.o4s4,this.value)
				ds_chat_skinChat()
			end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Edit Background
	ds_TitleString("Frame Background",opt.o4,152,69)
	opt.o4s5 = CreateFrame("Button", "dsc_o4s5", opt, "UIDropDownMenuTemplate")
	opt.o4s5:SetPoint("TOPLEFT", opt.o4, "TOPLEFT", 134 , -85)
	
	UIDropDownMenu_SetWidth(115,opt.o4s5)
	UIDropDownMenu_JustifyText("LEFT",opt.o4s5)
	
	-- Edit Background Color
	opt.o4s6 = ds_ColorSelector(opt,"dsc_o4s6",301,626)
	opt.o4s6:SetScript("OnClick", function() local r, g, b, a = this.sw:GetVertexColor() ShowColorPicker(r,g,b,1-a, this.Callback) end)
	opt.o4s6.Callback = function(cancel)
		if not ColorPickerFrame:IsVisible() then
			
			-- Stuff
			ColorPickerFrame.func = nil
			if cancel then return end
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = 1-OpacitySliderFrame:GetValue()
			
			dsc_o4s6.sw:SetVertexColor(r, g, b, a)
			ds_conf.chat.EditBgTs.Color.col.r = r
			ds_conf.chat.EditBgTs.Color.col.g = g
			ds_conf.chat.EditBgTs.Color.col.b = b
			ds_conf.chat.EditBgTs.Color.col.a = a
			ds_chat_skinChat()
		end
	end
	
	--[[ Other ]]--
	
	ds_TitleString("Other",opt,12,684)
	opt.o5 = ds_CustomBg(opt,336,372,10,699)
	
	-- Timestamp Format
	ds_TitleString("Timestamps",opt.o5,16,14)
	opt.o5s1 = CreateFrame("Button", "dsc_o5s1", opt, "UIDropDownMenuTemplate")
	opt.o5s1:SetPoint("TOPLEFT", opt.o5, "TOPLEFT", -1 , -29)
	
	UIDropDownMenu_SetWidth(110,opt.o5s1)
	UIDropDownMenu_JustifyText("LEFT",opt.o5s1)
	UIDropDownMenu_Initialize(opt.o5s1, function()
		local info={}
		for k,v in pairs({["None"] = "Not",["HH:MM"] = "%H:%M",["HH:MM:SS"] = "%H:%M:%S"}) do
			info.text	= k
			info.value	= v
			info.func	= function ()

				if this.value ~= "Not" then dsc_o5s2:Show() else dsc_o5s2:Hide() end
				ds_conf.chat.TimeStmp = this.value
				UIDropDownMenu_SetSelectedValue(opt.o5s1,ds_conf.chat.TimeStmp)
			end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Timestamp Color
	opt.o5s2 = ds_ColorSelector(opt,"dsc_o5s2",172 , 727)
	opt.o5s2:SetScript("OnClick", function () local r, g, b = this.sw:GetVertexColor() ShowColorPicker(r,g,b,1, this.Callback) OpacitySliderFrame:Hide() end)
	opt.o5s2.Callback = function(cancel)
		if not ColorPickerFrame:IsVisible() then
			
			-- Stuff
			ColorPickerFrame.func = nil
			if cancel then return end
			local r, g, b = ColorPickerFrame:GetColorRGB()
			ds_conf.chat.TimeColo = colorToHex(r, g, b)
			dsc_o5s2.sw:SetVertexColor(r, g, b)
		end
	end
	
	-- Apply For Group prefill
	ds_TitleString("Apply for group pre-fill text",opt.o5,16,69)
	opt.o5s3 = ds_editBox(opt,"dsc_o5s3",ds_conf.chat.applyGrp or "",190,32,788)
	opt.o5s3:SetScript("OnTextChanged" , function() ds_conf.chat.applyGrp = opt.o5s3:GetText() end)
	
	-- Position
	ds_TitleString("Chat Position and Size",opt.o5,16,124)
	
	local _, _, _, x, y = ChatFrame1:GetPoint()
	ds_DescString("X padd",opt.o5,90,150,9)
	opt.o5s4 = ds_editBox(opt,"dsc_o5s4",math.floor(x*10)/10,60,32,843)
	opt.o5s4:SetScript("OnEnterPressed", function()
		
		-- X
		local q, u, w = ChatFrame1:GetPoint()
		ChatFrame1:SetPoint(q, u, w, dsc_o5s4:GetText(), dsc_o5s5:GetText())
		this:ClearFocus()
	end)
	
	ds_DescString("Y padd",opt.o5,220,150,9)
	opt.o5s5 = ds_editBox(opt,"dsc_o5s5",math.floor(y*10)/10,60,162,843)
	opt.o5s5:SetScript("OnEnterPressed", function()
		
		-- Y
		local q, u, w = ChatFrame1:GetPoint()
		ChatFrame1:SetPoint(q, u, w, dsc_o5s4:GetText(), dsc_o5s5:GetText())
		this:ClearFocus()
	end)
	
	ds_DescString("Width",opt.o5,90,180,9)
	opt.o5s6 = ds_editBox(opt,"dsc_o5s6",math.floor(ChatFrame1:GetWidth()*10+0.5)/10,60,32,873)
	opt.o5s6:SetScript("OnEnterPressed", function()
		
		-- W
		ChatFrame1:SetWidth(tonumber(dsc_o5s6:GetText()) or 300 )
		this:ClearFocus()
	end)
	
	ds_DescString("Height",opt.o5,220,180,9)
	opt.o5s7 = ds_editBox(opt,"dsc_o5s7",math.floor(ChatFrame1:GetHeight()*10+0.5)/10,60,162,873)
	opt.o5s7:SetScript("OnEnterPressed", function()
		
		-- H
		ChatFrame1:SetHeight(tonumber(dsc_o5s7:GetText()) or 160 )
		this:ClearFocus()
	end)
	
	-- Update
	hooksecurefunc("FCF_StopResize", ds_chat_optionsPosUpd)
	hooksecurefunc("FCF_StopDragging", ds_chat_optionsPosUpd)
	
	-- Self Highlight Color
	ds_TitleString("Highlight Color",opt.o5,16,209)
	opt.o5s8 = ds_ColorSelector(opt,"dsc_o5s8",22 , 922)
	opt.o5s8:SetScript("OnClick", function () local r, g, b = this.sw:GetVertexColor() ShowColorPicker(r,g,b,1, this.Callback) OpacitySliderFrame:Hide() end)
	opt.o5s8.Callback = function(cancel)
		if not ColorPickerFrame:IsVisible() then
			
			-- Stuff
			ColorPickerFrame.func = nil
			if cancel then return end
			local r, g, b = ColorPickerFrame:GetColorRGB()
			ds_conf.chat.SelfColo = colorToHex(r, g, b)
			dsc_o5s8.sw:SetVertexColor(r, g, b)
		end
	end
	
	-- Hyperlink color
	ds_TitleString("Hyperlink color",opt.o5,123,209)
	opt.o5s9 = ds_ColorSelector(opt,"dsc_o5s9",128,922)
	opt.o5s9:SetScript("OnClick", function () local r, g, b = this.sw:GetVertexColor() ShowColorPicker(r,g,b,1, this.Callback) OpacitySliderFrame:Hide() end)
	opt.o5s9.Callback = function(cancel)
		if not ColorPickerFrame:IsVisible() then
			
			-- Stuff
			ColorPickerFrame.func = nil
			if cancel then return end
			local r, g, b = ColorPickerFrame:GetColorRGB()
			ds_conf.chat.HlinColo = colorToHex(r, g, b)
			dsc_o5s9.sw:SetVertexColor(r, g, b)
		end
	end
	
	-- Grouplink color
	ds_TitleString("Grouplink color",opt.o5,229,209)
	opt.o5sA = ds_ColorSelector(opt,"dsc_o5sA",234,922)
	opt.o5sA:SetScript("OnClick", function () local r, g, b = this.sw:GetVertexColor() ShowColorPicker(r,g,b,1, this.Callback) OpacitySliderFrame:Hide() end)
	opt.o5sA.Callback = function(cancel)
		if not ColorPickerFrame:IsVisible() then
			
			-- Stuff
			ColorPickerFrame.func = nil
			if cancel then return end
			local r, g, b = ColorPickerFrame:GetColorRGB()
			ds_conf.chat.GinvColo = colorToHex(r, g, b)
			dsc_o5sA.sw:SetVertexColor(r, g, b)
		end
	end

	-- Reset Button
	ds_TitleString("Reset Chat Position",opt.o5,206,14)
	opt.o5sB = CreateFrame("Button", "dsc_o5sB", opt, "UIPanelButtonTemplate")
	opt.o5sB:SetPoint("TOPLEFT", opt, "TOPLEFT", 231, -730)
	opt.o5sB:SetHeight(23)
	opt.o5sB:SetWidth(100)
	opt.o5sB:SetText("Reset")
	opt.o5sB:SetScript("OnClick", function ()
		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, 95)
		ChatFrame1:SetWidth(430)
		ChatFrame1:SetHeight(120)
	end)
	
	-- Clas Colors in Chat
	ds_TitleString("Use Class Colors in Chat",opt.o5,16,264)
	opt.o5sC = CreateFrame("CheckButton", "dsc_o5sC", opt, "UICheckButtonTemplate")
	opt.o5sC:SetPoint("TOPLEFT", opt, "TOPLEFT", 22, -980)
	opt.o5sC:SetScript("OnClick", function() ds_conf.chat.NameColo = opt.o5sC:GetChecked() end)
	
	-- Level Based Ignore
	ds_TitleString("Ignore whispers bellow level",opt.o5,16,319)
	builder = ds_editBox(opt,"dsc_o5sD",ds_conf.chat.MsgLevel or "",60,32,1037)
	builder:SetScript("OnTextChanged" , function() ds_conf.chat.MsgLevel = tonumber(dsc_o5sD:GetText()) or 0 end)
	
	-- Extended ignore
	ds_DescString("Extend to chat channels and say / yell",opt.o5,114,343,9)
	builder = CreateFrame("CheckButton", "dsc_o5sE", opt, "UICheckButtonTemplate")
	builder:SetPoint("TOPLEFT", opt, "TOPLEFT", 302, -1031)
	builder:SetScript("OnClick", function() ds_conf.chat.MsgChans = dsc_o5sE:GetChecked() end)
	
	--[[ Emotes ]]--
	
	ds_TitleString("Emoji",opt,12,1089)
	opt.o6 = ds_CustomBg(opt,336,765,10,1104)
	
	ds_DescString("Emoji are client side implementation therefore only thouse with this",opt.o6,15,14,9)
	ds_DescString("or simular addon will see them as images the rest will see only text",opt.o6,15,24,9)
	
	-- Emoji Size
	ds_TitleString("Emoji Size",opt.o6,16,44)
	opt.o6s1 = CreateFrame("Button", "dsc_o6s1", opt, "UIDropDownMenuTemplate")
	opt.o6s1:SetPoint("TOPLEFT", opt.o6, "TOPLEFT", -1 , -59)
	
	UIDropDownMenu_SetWidth(110,opt.o6s1)
	UIDropDownMenu_JustifyText("LEFT",opt.o6s1)
	UIDropDownMenu_Initialize(opt.o6s1, function()
		local info={}
		for k,v in ipairs({32,33,34,35,36,37,38,39,40,41,42,43,44,45,46}) do
			info.text	= v
			info.value	= v
			info.func	= function () ds_conf.chat.EmojiPix = this.value;UIDropDownMenu_SetSelectedValue(opt.o6s1,ds_conf.chat.EmojiPix) end
			info.checked = nil
			info.checkable = nil
			UIDropDownMenu_AddButton(info, 1)
		end
	end)
	
	-- Emoji
	ds_DescString("seemsgoodman / sgman",opt.o6,15,99,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -110)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\SeemsGoodMan.tga")
	
	ds_DescString("feelsgoodman / fgman",opt.o6,115,99,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -112)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\FeelsGoodMan.tga")
	
	ds_DescString("feelsbadmn / fbman",opt.o6,225,99,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -112)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\FeelsBadMan.tga")
	
	ds_DescString("Ree / REE",opt.o6,15,154,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -165)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Ree.tga")
	
	ds_DescString("LUL / lul",opt.o6,115,154,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -165)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\lul.tga")
	
	ds_DescString("OMEGALUL / omegalul",opt.o6,225,154,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -165)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Omega.tga")
	
	ds_DescString("MonkaS / monkas",opt.o6,15,209,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -220)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\MonkaS.tga")
	
	ds_DescString("WeSmart / wesmart",opt.o6,115,209,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -220)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\WeSmart.tga")
	
	ds_DescString("PogChamp / pogchamp",opt.o6,225,209,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -220)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\PogChamp.tga")
	
	ds_DescString("PEP",opt.o6,15,264,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -275)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Pep.tga")
	
	ds_DescString("Poggers / poggers",opt.o6,115,264,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -275)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Poggers.tga")
	
	ds_DescString("PepeHands / pepehands",opt.o6,225,264,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -275)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\PepeHands.tga")
	
	ds_DescString("AYY / ayy",opt.o6,15,319,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -330)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\ayy.tga")
	
	ds_DescString("NotLikeThis / notlikethis",opt.o6,115,319,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -330)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\NotLikeThis.tga")
	
	ds_DescString("Kappa / kappa",opt.o6,225,319,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -330)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Kappa.tga")
	
	ds_DescString("CmonBruh / cmonbruh",opt.o6,15,374,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -385)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\CmonBruh.tga")
	
	ds_DescString("Thonk / thonk",opt.o6,115,374,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -385)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Thonk.tga")
	
	ds_DescString("Wwow / wwow",opt.o6,225,374,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -385)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Wwow.tga")
	
	ds_DescString("Jebaited / jebaited",opt.o6,15,429,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -440)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Jebaited.tga")
	
	ds_DescString("MonkaT / monkat",opt.o6,115,429,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -440)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\MonkaT.tga")
	
	ds_DescString("Wwoke / wwoke",opt.o6,225,429,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -440)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Wwoke.tga")	
	
	ds_DescString("FeelsBruh / feelsbruh",opt.o6,15,484,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -495)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\FeelsBruh.tga")
	
	ds_DescString("LULW / lulw",opt.o6,115,484,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -495)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\lulw.tga")
	
	ds_DescString("GachiGasm / gachigasm",opt.o6,225,484,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -495)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\GachiGasm.tga")	
	
	ds_DescString("PepeEz / pepeez",opt.o6,15,539,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -550)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\PepeEz.tga")
	
	ds_DescString("PepeGa / pepega",opt.o6,115,539,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -550)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\PepeGa.tga")
	
	ds_DescString("Facepalm / facepalm",opt.o6,225,539,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -550)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Facepalm.tga")	
	
	ds_DescString("MonkaSSS / monkaSSS",opt.o6,15,594,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -605)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\MonkaSSS.tga")
	
	ds_DescString("CLAP",opt.o6,115,594,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -605)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\CLAP.tga")
	
	ds_DescString("PepePains / pepepains",opt.o6,225,594,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -605)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\PepePains.tga")	
	
	ds_DescString("POG",opt.o6,15,649,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -660)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\POG.tga")
	
	ds_DescString("MonkaThink / monkathink",opt.o6,115,649,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -660)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\MonkaThink.tga")
	
	ds_DescString("MonkaOMEGA / mOMEGA",opt.o6,225,649,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -660)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\MonkaOMEGA.tga")	

	ds_DescString("Hypers / hypers",opt.o6,15,704,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 20, -715)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\Hypers.tga")
	
	ds_DescString("PepeComfy / pepecomfy",opt.o6,115,704,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 120, -715)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\PepeComfy.tga")
	
	ds_DescString("flman",opt.o6,225,704,7)
	builder = opt.o6:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"TOPLEFT", 230, -715)
	builder:SetWidth(30)
	builder:SetHeight(30)
	builder:SetTexture("Interface\\AddOns\\DarkShift_Chat\\lib\\emotes\\FeelsLoveMan.tga")	
	
	builder = opt:CreateTexture(nil, "BACKGROUND")
	builder:SetPoint("TOPLEFT", opt.o6 ,"BOTTOMLEFT", 0, 0)
	builder:SetWidth(8)
	builder:SetHeight(8)
	
	-- Opt Clear Focuz
	opt:EnableMouse(true)
	opt:HookScript("OnMouseDown", function(self, button) dsc_o5s4:ClearFocus() dsc_o5s5:ClearFocus() dsc_o5s6:ClearFocus() end)
	
	-- Set values
	ds_chat_optionsSet()
	
	-- Add OF for scrolling
	ds_chat_opt.sf:SetScrollChild(opt)
end


function ds_chat_options()
	
	-- Options Frame
	ds_chat_opt = CreateFrame("ScrollFrame", "ds_chat_opt", ds.options)
	ds_chat_opt.parent = ds.opt.name
	ds_chat_opt.name = "Chat Options"
	ds_chat_opt.default = ds_chat_optionsReset
	ds_chat_opt:SetWidth(376)
	ds_chat_opt:SetHeight(398)
	ds_chat_opt:EnableMouseWheel(true)
	
	-- Build
	ds_chat_opt:SetScript("OnShow", function ()
		ds_chat_optionsBuild()
		ds_chat_opt:SetScript("OnShow",nil)
	end)
	
	-- Add to interface menu
	InterfaceOptions_AddCategory(ds_chat_opt)
	
	-- Chat slash command
	SLASH_DSC1 = "/dsc"
	SlashCmdList["DSC"] = function() InterfaceOptionsFrame_OpenToFrame(ds_chat_opt) end
end