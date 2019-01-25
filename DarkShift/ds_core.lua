--[[
Addon: DarkShift UI
Module: Core
Developed by: ©Devrak 2k19
]]--


local function ds_init()

	-- Per Character
	if ds_conf == nil then ds_conf = {} end
	
	-- Global Config
	if ds_glob_conf == nil then ds_glob_conf = {} end
	
	-- MEME
	DEFAULT_CHAT_FRAME:AddMessage("DarkShift : v1.01",0.74,0.02,0.02)
	
	-- Options Frame
	ds_options()
	
	-- Database & Data Gatherer for modules
	ds_database()
	
	-- Module Init
	for _,m in ipairs(ds.modules) do _G[m]() end
end

local function ds_onEvent(self, event , ...)
	
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		ds_init()
	end
end

	ds = CreateFrame("Frame")
	ds:RegisterEvent("PLAYER_ENTERING_WORLD")
	ds:SetScript("OnEvent", ds_onEvent)
	ds.modules = {}