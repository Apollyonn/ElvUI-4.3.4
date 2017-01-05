local E, L, V, P, G = unpack(select(2, ...));
local S = E:GetModule("Skins");

local _G = _G;
local unpack = unpack;

local function LoadSkin()
	if(E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.watchframe ~= true) then return end

	WatchFrameCollapseExpandButton:StripTextures();
	S:HandleCloseButton(WatchFrameCollapseExpandButton);
	WatchFrameCollapseExpandButton.backdrop:SetAllPoints();
	WatchFrameCollapseExpandButton:Size(16);
	WatchFrameCollapseExpandButton.text:SetText("-");
	WatchFrameCollapseExpandButton.text:Point("CENTER")
	WatchFrameCollapseExpandButton:SetFrameStrata("MEDIUM");

	hooksecurefunc("WatchFrame_Expand", function()
		WatchFrameCollapseExpandButton.text:SetText("-");
	end)

	hooksecurefunc("WatchFrame_Collapse", function()
		WatchFrameCollapseExpandButton.text:SetText("+");
	end)

	local function SkinWatchFramePopUp()
		if(WatchFrameAutoQuestPopUp1) then
			WatchFrameLines:StripTextures();
			WatchFrameAutoQuestPopUp1ScrollChildBg:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildQuestIconBg:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildFlash:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildShine:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildIconShine:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildFlashIconFlash:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildBorderBotLeft:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildBorderBotRight:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildBorderBottom:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildBorderLeft:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildBorderRight:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildBorderTop:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildBorderTopLeft:Kill();
			WatchFrameAutoQuestPopUp1ScrollChildBorderTopRight:Kill();

			WatchFrameAutoQuestPopUp1:CreateBackdrop("Transparent", true, true);
			WatchFrameAutoQuestPopUp1.backdrop:SetBackdropBorderColor(0, 0.44, 0.87, 1);
			WatchFrameAutoQuestPopUp1.backdrop:CreateShadow();
		end
	end
	WatchFrame:HookScript("OnEvent", SkinWatchFramePopUp)

	hooksecurefunc("WatchFrame_Update", function()
		local questIndex;
		local numQuestWatches = GetNumQuestWatches();

		for i = 1, numQuestWatches do
			questIndex = GetQuestIndexForWatch(i);
			if(questIndex) then
				local title, level = GetQuestLogTitle(questIndex);
				local color = GetQuestDifficultyColor(level);

				for j = 1, #WATCHFRAME_QUESTLINES do
					if(WATCHFRAME_QUESTLINES[j].text:GetText() == title) then
						WATCHFRAME_QUESTLINES[j].text:SetTextColor(color.r, color.g, color.b);
						WATCHFRAME_QUESTLINES[j].color = color;
					end
				end
			end
		end

		for i = 1, WATCHFRAME_NUM_ITEMS do
			local button = _G["WatchFrameItem"..i];
			local icon = _G["WatchFrameItem"..i.."IconTexture"];
			local normal = _G["WatchFrameItem"..i.."NormalTexture"];
			local cooldown = _G["WatchFrameItem"..i.."Cooldown"];
			if(not button.skinned) then
				button:CreateBackdrop();
				button.backdrop:SetAllPoints();
				button:StyleButton();
				button:Size(25)

				normal:SetAlpha(0);
				icon:SetInside();
				icon:SetTexCoord(unpack(E.TexCoords));

				E:RegisterCooldown(cooldown);
				button.skinned = true;
			end
		end
	end)

	hooksecurefunc("WatchFrameLinkButtonTemplate_Highlight", function(self, onEnter)
		for i = self.startLine, self.lastLine do
			if(not self.lines[i]) then return; end
			if(self.lines[i].color) then
				if(onEnter) then
					self.lines[i].text:SetTextColor(1, 0.80, 0.10);
				else
					self.lines[i].text:SetTextColor(self.lines[i].color.r, self.lines[i].color.g, self.lines[i].color.b);
				end
			end
		end
	end)
end

S:AddCallback("WatchFrame", LoadSkin)