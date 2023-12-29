AddClassPostConstruct("screens/playerhud",function(self, anim, owner)
	--添加皮肤界面
	self.ShowLevelUpPage = function()
		if self.qigong_level_up_widget ~= nil then
			self.qigong_level_up_widget:Show()
		end
        -- self:OpenScreenUnderPause(self.medalskinpopupscreen)
        return self.qigong_level_up_widget
	end

	self.CloseLevelUpPage = function(_)
		if self.qigong_level_up_widget ~= nil then
            if self.qigong_level_up_widget.visiable == true then
                self.qigong_level_up_widget:Hide()
            end
            -- self.medalskinpopupscreen = nil
        end
	end
end)

AddPopup("LEVELUPPAGE")
POPUPS.LEVELUPPAGE.fn = function(inst, show)
    if inst.HUD then
        if not show then
            inst.HUD:CloseLevelUpPage()
        elseif not inst.HUD:ShowLevelUpPage() then
            POPUPS.LEVELUPPAGE:Close(inst)
        end
    end
end