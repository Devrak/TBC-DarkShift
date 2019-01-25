--[[
Addon: DarkShift UI
Module: Chat & Docking Override & Fix
Developed by: ©Devrak 2k19
]]--


function FCF_OnUpdate(elapsed)

	-- Need to draw the dock regions for a frame to define their rects
	if ( not ChatFrame1.init ) then
		for i=1, NUM_CHAT_WINDOWS do
			getglobal("ChatFrame"..i.."TabDockRegion"):Show();
			FCF_UpdateButtonSide(getglobal("ChatFrame"..i));
		end
		ChatFrame1.init = 1;
		return;
	elseif ( ChatFrame1.init == 1  ) then
		for i=1, NUM_CHAT_WINDOWS do
			getglobal("ChatFrame"..i.."TabDockRegion"):Hide();
		end
		ChatFrame1.init = 2;
	end

	-- Detect if mouse is over any chat frames and if so show their tabs, if not hide them
	local chatFrame, chatTab;

	if ( MOVING_CHATFRAME ) then
		-- Set buttons to the left or right side of the frame
		-- If the the side of the buttons changes and the frame is the default frame, then set every docked frames buttons to the same side
		local updateAllButtons = nil;
		if (FCF_UpdateButtonSide(MOVING_CHATFRAME) and MOVING_CHATFRAME == DEFAULT_CHAT_FRAME ) then
			updateAllButtons = 1;
		end
		local dockRegion;
		for index, value in pairs(DOCKED_CHAT_FRAMES) do
			if ( updateAllButtons ) then
				FCF_UpdateButtonSide(value);
			end
			
			dockRegion = getglobal(value:GetName().."TabDockRegion");
			if ( MouseIsOver(dockRegion) and MOVING_CHATFRAME ~= DEFAULT_CHAT_FRAME and not InterfaceOptionsFrame:IsShown() ) then
				dockRegion:Show();
			else
				dockRegion:Hide();
			end
		end
	end
	
	-- Handle hiding and showing chat tabs
	local showAllDockTabs = nil;
	local hideAnyDockTabs = nil;
	local xPos, yPos = GetCursorPosition();
	for j=1, NUM_CHAT_WINDOWS do
		chatFrame = getglobal("ChatFrame"..j);
		chatTab = getglobal("ChatFrame"..j.."Tab");
		
		-- New version of the crazy function
		if ( FCF_IsValidChatFrame(chatFrame) ) then
			--Tab height
			local yOffset = 45;
			if ( IsCombatLog(chatFrame) ) then
				yOffset = yOffset + CombatLogQuickButtonFrame_Custom:GetHeight();				
			end
			if ( (MouseIsOver(chatFrame, yOffset, -35, -55, 55) or chatFrame.resizing) ) then
				-- If mouse is hovering don't show the tab until the elapsed time reaches the tab show delay
				if ( chatFrame.hover ) then
					if ( (chatFrame.oldX == xPos and chatFrame.oldy == yPos) or REMOVE_CHAT_DELAY == "1" ) then
						chatFrame.hoverTime = chatFrame.hoverTime + elapsed;
					else
						chatFrame.hoverTime = 0;
						chatFrame.oldX = xPos;
						chatFrame.oldy = yPos;
					end
					-- If the hover delay has been reached or the user is dragging a chat frame over the dock show the tab
					if ( (chatFrame.hoverTime > CHAT_TAB_SHOW_DELAY) or (MOVING_CHATFRAME and (chatFrame == DEFAULT_CHAT_FRAME)) ) then
						-- If the chatframe's alpha is less than the current default, then fade it in 
						chatTab:Show();
						if ( not chatFrame.hasBeenFaded and (chatFrame.oldAlpha and chatFrame.oldAlpha < DEFAULT_CHATFRAME_ALPHA) and ds_conf.chat.SkinName == "Blizzard") then
							
							for index, value in pairs(CHAT_FRAME_TEXTURES) do
								UIFrameFadeIn(getglobal(chatFrame:GetName()..value), CHAT_FRAME_FADE_TIME, chatFrame.oldAlpha, DEFAULT_CHATFRAME_ALPHA);
							end
							
							if ( IsCombatLog(chatFrame) ) then
								-- Fade in quick button frame
								UIFrameFadeIn(CombatLogQuickButtonFrame, CHAT_FRAME_FADE_TIME, chatFrame.oldAlpha, 1.0);
							end

							-- Set the fact that the chatFrame has been faded so we don't try to fade it again
							chatFrame.hasBeenFaded = 1;
						end
						-- Fadein to different values depending on the selected tab
						-- Also Force Static
						if ( not chatTab.hasBeenFaded and not ds_conf.chat.TabScrol) then
							if ( SELECTED_DOCK_FRAME:GetID() == chatTab:GetID() or not chatFrame.isDocked) then
								UIFrameFadeIn(chatTab, CHAT_FRAME_FADE_TIME, 0, CHAT_FRAME_BUTTON_MAX_ALPHA);
								chatTab.oldAlpha = CHAT_FRAME_BUTTON_MAX_ALPHA;
							else
								UIFrameFadeIn(chatTab, CHAT_FRAME_FADE_TIME, 0, CHAT_FRAME_BUTTON_MIN_ALPHA);
								chatTab.oldAlpha = CHAT_FRAME_BUTTON_MIN_ALPHA;
							end

							chatTab.hasBeenFaded = 1;

							-- If this is the default chat tab fading in then fade in all the docked tabs
							if ( chatFrame == DEFAULT_CHAT_FRAME ) then
								showAllDockTabs = 1;
							end
						end
						
					end
				else
					-- Start hovering counter
					chatFrame.hover = 1;
					chatFrame.hoverTime = 0;
					chatFrame.hasBeenFaded = nil;
					chatTab.hasBeenFaded = nil;
					CURSOR_OLD_X, CURSOR_OLD_Y = GetCursorPosition();
					-- Remember the oldAlpha so we can return to it later
					if ( not chatFrame.oldAlpha ) then
						chatFrame.oldAlpha = getglobal(chatFrame:GetName().."Background"):GetAlpha();
					end
				end
			else
				-- If the chatframe's alpha was less than the current default, then fade it back out to the oldAlpha
				if ( chatFrame.hasBeenFaded and chatFrame.oldAlpha and chatFrame.oldAlpha < DEFAULT_CHATFRAME_ALPHA and ds_conf.chat.SkinName == "Blizzard" ) then
					for index, value in pairs(CHAT_FRAME_TEXTURES) do
						UIFrameFadeOut(getglobal(chatFrame:GetName()..value), CHAT_FRAME_FADE_TIME, DEFAULT_CHATFRAME_ALPHA, chatFrame.oldAlpha);
					end
					
					if ( IsCombatLog(chatFrame) ) then
						-- Fade out quick button frame
						UIFrameFadeOut(CombatLogQuickButtonFrame, CHAT_FRAME_FADE_TIME, DEFAULT_CHATFRAME_ALPHA, chatFrame.oldAlpha);
					end

					chatFrame.hover = nil;
					chatFrame.hasBeenFaded = nil;
				end
				if ( chatTab.hasBeenFaded ) then
					if (chatFrame.isDocked) then
						hideAnyDockTabs = true;
						chatTab.needsHide = true;
					else
						local fadeInfo = {};
						fadeInfo.mode = "OUT";
						fadeInfo.startAlpha = chatTab.oldAlpha;
						fadeInfo.timeToFade = CHAT_FRAME_FADE_TIME;
						fadeInfo.finishedArg1 = chatTab;
						fadeInfo.finishedArg2 = getglobal("ChatFrame"..chatTab:GetID());
						fadeInfo.finishedFunc = FCF_ChatTabFadeFinished;
						UIFrameFade(chatTab, fadeInfo);

						chatFrame.hover = nil;
						chatTab.hasBeenFaded = nil;
					end
				end
				chatFrame.hover = nil;
				chatFrame.hoverTime = 0;
			end	
		end
		
		-- See if any of the tabs are flashing
		if ( UIFrameIsFlashing(getglobal("ChatFrame"..j.."TabFlash")) and chatFrame.isDocked ) then
			showAllDockTabs = 1;
		end
	end
	-- If one tab is flashing, show all the docked tabs
	if ( showAllDockTabs ) then
		for index, value in pairs(DOCKED_CHAT_FRAMES) do
			chatTab = getglobal(value:GetName().."Tab");
			chatTab.needsHide = nil;
			if ( not chatTab.hasBeenFaded ) then
				if ( SELECTED_DOCK_FRAME:GetID() == chatTab:GetID() ) then
					UIFrameFadeIn(chatTab, CHAT_FRAME_FADE_TIME, 0, CHAT_FRAME_BUTTON_MAX_ALPHA);
					chatTab.oldAlpha = CHAT_FRAME_BUTTON_MAX_ALPHA;
				else
					UIFrameFadeIn(chatTab, CHAT_FRAME_FADE_TIME, 0, CHAT_FRAME_BUTTON_MIN_ALPHA);
					chatTab.oldAlpha = CHAT_FRAME_BUTTON_MIN_ALPHA;
				end
				chatTab.hasBeenFaded = 1;
			end
		end
	elseif ( hideAnyDockTabs) then
		for index, value in pairs(DOCKED_CHAT_FRAMES) do
			chatTab = getglobal(value:GetName().."Tab");
			if ( chatTab.needsHide ) then
				local fadeInfo = {};
				fadeInfo.mode = "OUT";
				fadeInfo.startAlpha = chatTab.oldAlpha;
				fadeInfo.timeToFade = CHAT_FRAME_FADE_TIME;
				fadeInfo.finishedArg1 = chatTab;
				fadeInfo.finishedArg2 = getglobal("ChatFrame"..chatTab:GetID());
				fadeInfo.finishedFunc = FCF_ChatTabFadeFinished;
				
				-- Force Static
				if not ds_conf.chat.TabScrol then
					UIFrameFade(chatTab, fadeInfo);
				end
				
				chatFrame.hover = nil;
				chatTab.hasBeenFaded = nil;
				chatTab.needsHide = nil;
			end 
		end
	end
	
	-- If the default chat frame is resizing, then resize the dock
	if ( DEFAULT_CHAT_FRAME.resizing ) then
		FCF_DockUpdate();
	end
	if ( ChatFrame2.resizing ) then
		Blizzard_CombatLog_Update_QuickButtons();
	end
end