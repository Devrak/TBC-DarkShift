--[[
Addon: DarkShift UI
Module: Core , Stuff( Stuff is stuff its mine and some from public domain )
Developed by: ©Devrak 2k19
]]--

-- Blizzard Dropdown SetVal Fix
function SetDropDownValue(dropdown,value)
	ToggleDropDownMenu(1,value,dropdown)
	UIDropDownMenu_SetSelectedValue(dropdown, value)
	CloseDropDownMenus()
end

-- Copying Tables In Lua
function TableDeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[TableDeepCopy(orig_key)] = TableDeepCopy(orig_value)
        end
        setmetatable(copy, TableDeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- Array by keys
function PairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      			-- iterator variable
	local iter = function ()	-- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

-- Toggle color picker
function ShowColorPicker(r, g, b, a, changedCallback)
	ColorPickerFrame:SetColorRGB(r,g,b);
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
	ColorPickerFrame.previousValues = {r,g,b,a};
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end

-- Decimal color to Hex color
function colorToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

-- Hex Color To Decimals
function colorToRGB(hex)
	local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
	return tonumber(rhex, 16)/255, tonumber(ghex, 16)/255, tonumber(bhex, 16)/255
end

-- Title With Custom Font
function ds_BigTitleString(text,frame,offsetx,offsety,white)
	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", frame, "TOPLEFT", offsetx, -offsety)
	title:SetFont(DS_FONTS_LIST["Balthazar"], 24)
	title:SetText(text)
	title:SetJustifyH("LEFT")
	if white then title:SetTextColor(1,1,1,0.9) end
end

-- Title With Custom Font
function ds_TitleString(text,frame,offsetx,offsety)
	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	title:SetPoint("TOPLEFT", frame, "TOPLEFT", offsetx, -offsety)
	title:SetText(text)
	title:SetJustifyH("LEFT")
end

-- Description String
function ds_DescString(text,frame,offsetx,offsety,fontSize)
	local desc = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	desc:SetPoint("TOPLEFT", frame, "TOPLEFT", offsetx, -offsety)
	desc:SetText(text)
	desc:SetTextColor(1,1,1,0.95)
	desc:SetJustifyH("LEFT")
	if fontSize then desc:SetFont("Fonts\\FRIZQT__.TTF", fontSize) end
end

-- Color Selector
function ds_ColorSelector(frame,globaName,offsetx,offsety)
	local ColorSel = CreateFrame("Button", globaName, frame)
	ColorSel:SetPoint("TOPLEFT", frame, "TOPLEFT", offsetx , -offsety)
	ColorSel:SetWidth(32)
	ColorSel:SetHeight(32)
	ColorSel:SetFrameLevel(2)
	ColorSel.bg = ColorSel:CreateTexture(nil, "OVERLAY")
	ColorSel.bg:SetTexture("Interface\\AddOns\\DarkShift\\lib\\img\\ds_colorboxbg")
	ColorSel.bg:SetAllPoints(ColorSel)
	ColorSel.sw = ColorSel:CreateTexture(nil, "BACKGROUND")
	ColorSel.sw:SetWidth(18)
	ColorSel.sw:SetHeight(18)
	ColorSel.sw:SetPoint("CENTER", ColorSel, "CENTER")
	ColorSel.sw:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	ColorSel.sw:SetVertexColor(1,1,1)
	ColorSel:EnableMouse(true)
	return ColorSel
end

-- Slider
function ds_Slider(frame,globaName,offsetx,offsety)
	local slider = CreateFrame("Slider", globaName, frame, "OptionsSliderTemplate")
	slider:SetPoint("TOPLEFT", frame, "TOPLEFT", offsetx, -offsety)
	slider:SetOrientation('HORIZONTAL')
	slider:SetMinMaxValues(0, 100)
	slider:SetValueStep(5)
	_G[globaName.."High"]:SetText("100")
	_G[globaName.."Low"]:SetText("0")
	return slider
end

-- EditBox
function ds_editBox(frame,globaName,text,width,offsetx,offsety)
	local editBox = CreateFrame("Editbox", globaName, UIParent, "InputBoxTemplate")
	editBox:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 100)
	editBox:SetHeight(20)
	editBox:SetWidth(width)
	editBox:SetAutoFocus(0)
	editBox:SetScript("OnEnterPressed", function() this:ClearFocus() this:HighlightText(0,0) end)
	editBox:SetScript("OnEscapePressed", function() this:ClearFocus() this:HighlightText(0,0) end)
	editBox:SetText(text)
	editBox:SetParent(frame)
	editBox:SetPoint("TOPLEFT", frame, "TOPLEFT", offsetx, -offsety)
	return editBox
end

-- Bcakground For Opts
function ds_CustomBg(frame,width,height,offsetx,offsety)
	local optbg = CreateFrame("Frame", "glob", frame)
	optbg:SetPoint("TOPLEFT", frame, "TOPLEFT", offsetx, -offsety)
	optbg:SetFrameStrata("BACKGROUND")
	optbg:SetFrameLevel(0)
	optbg:SetWidth(width)
	optbg:SetHeight(height)
	optbg:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }})
	optbg:SetBackdropBorderColor(0.4, 0.4, 0.4)
	optbg:SetBackdropColor(0, 0, 0,0.2)
	return optbg
end

-- Fonts
DS_FONTS_LIST =
{
	["ABeeZee"]	 	= "Interface\\AddOns\\DarkShift\\lib\\fonts\\ABeeZee.ttf",
	["ARIALN"]	 	= "Fonts\\ARIALN.TTF",
	["Aleo"]	 	= "Interface\\AddOns\\DarkShift\\lib\\fonts\\Aleo.ttf",
	["Almendra"] 	= "Interface\\AddOns\\DarkShift\\lib\\fonts\\Almendra.ttf",
	["Balthazar"]	= "Interface\\AddOns\\DarkShift\\lib\\fonts\\Balthazar.ttf",
	["Cmu"] 		= "Interface\\AddOns\\DarkShift\\lib\\fonts\\CmuTypewriter.ttf",
	["FRIZQT"]	 	= "Fonts\\FRIZQT__.TTF",
	["LibSansNarr"]	= "Interface\\AddOns\\DarkShift\\lib\\fonts\\LiberationSansNarrow.ttf",
	["Mops"]		= "Interface\\AddOns\\DarkShift\\lib\\fonts\\Mops.ttf",
	["NotoSans"]	= "Interface\\AddOns\\DarkShift\\lib\\fonts\\NotoSansSC.ttf",
	["Oswald"]	 	= "Interface\\AddOns\\DarkShift\\lib\\fonts\\Oswald.ttf",
	["Rajdhani"] 	= "Interface\\AddOns\\DarkShift\\lib\\fonts\\Rajdhani.ttf",
	["Unique"]		= "Interface\\AddOns\\DarkShift\\lib\\fonts\\Unique.ttf",
	["Yantramanav"]	= "Interface\\AddOns\\DarkShift\\lib\\fonts\\Yantramanav.ttf",
}