--[[
Addon: DarkShift UI
Module: Core
Developed by: ©Devrak 2k18
]]--


function ds_options()
	
	-- C
	ds.opt = CreateFrame("Frame", nil, UIParent)
	ds.opt.name = "DarkShift"
	
	ds_BigTitleString(ds.opt.name,ds.opt,15,14,true)
	ds_DescString("Developed by: Devrak 2k18",ds.opt,15,55)
	
	-- Git
	ds.opt.git = CreateFrame("EditBox", nil, ds.opt)
	ds.opt.git:SetWidth(230)
	ds.opt.git:SetHeight(30)
	ds.opt.git:SetPoint('TOPLEFT', ds.opt, 10, -68)
	ds.opt.git:SetFontObject("GameFontNormalSmall")
	ds.opt.git:SetTextInsets(5,0,0,15)
	ds.opt.git:SetTextColor(1,1,1,0.6)
	ds.opt.git:SetAutoFocus(false)
	ds.opt.git:EnableKeyboard(true)
	ds.opt.git:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:HighlightText(0,0) end)
	ds.opt.git:SetScript("OnShow", function(self) self:SetText("https://github.com/Devrak/TBC-DarkShift") end)
	
	ds.opt:EnableMouse(true)
	ds.opt:HookScript("OnMouseDown", function() ds.opt.git:ClearFocus() ds.opt.git:HighlightText(0,0) end)
	
	-- Pop
	InterfaceOptions_AddCategory(ds.opt)
	
	-- GUI Reload
	SLASH_DS1 = "/rl"
	SlashCmdList["DS"] = function() ReloadUI(); end
	
end