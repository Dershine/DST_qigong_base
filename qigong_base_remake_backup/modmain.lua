GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})


local _g = GLOBAL
local require = _g.require
local qigong_level_up = require("widgets/qigong_level_up")
local qigong_container = require("widgets/qigong_container")
local containers = require("containers")

-- env.RECIPETABS = GLOBAL.RECIPETABS
-- env.TECH = GLOBAL.TECH
-- env.STRINGS = GLOBAL.STRINGS

PrefabFiles = {
    "qigong_base",
    "qigong_base_projectile",
}

Assets = {
	Asset("ATLAS", "images/hud/qigong_skill_bg.xml"), 
	Asset("IMAGE", "images/hud/qigong_skill_bg.tex")
}

local recipe_name = "qigong_base"
local ingredients = {Ingredient("cutgrass", 1), Ingredient("twigs", 1)}
local tech = TECH.NONE --所需科技，必须使用常量表TECH的值
local config = {
    atlas = "images/inventoryimages/qigong_base.xml",
}
AddRecipe2(recipe_name, ingredients, tech, config)

-- STRINGS.SWALLOW = "吞噬"
STRINGS.NAMES.QIGONG_BASE = "气功基础"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.QIGONG_BASE = "这是所有气功的基础"
STRINGS.RECIPE_DESC.QIGONG_BASE = "气功，从入门到入土" -- 制作栏描述

--打开技能选择页面
-- local function switch_qigong_level_up_widget()
--     print("enter switch_qigong_level_up_widget")
--     local screen = TheFrontEnd:GetActiveScreen()
--     print(screen)
--     -- End if we can't find the screen name (e.g. asleep)
--     if not screen or not screen.name then return true end
--     -- If the hud exists, open the UI
--     if screen.name == "HUD" and screen.qigong_level_up_widget then
--         if not screen.qigong_level_up_widget.visiable then
--             -- We want to pass in the (clientside) player entity
--             -- TheFrontEnd:PushScreen(require("screens/qigong_level_up")(_g.ThePlayer))
--             screen.qigong_level_up_widget:Show()
--             screen.qigong_level_up_widget.visiable = true
--             return true
--         else
--             -- If the screen is already open, close it
--             screen.qigong_level_up_widget:Hide()
--             screen.qigong_level_up_widget.visiable = false
--             return true
--         end
--     end
-- end

AddReplicableComponent("move_attack")

AddClassPostConstruct("screens/playerhud", function(self)
    self.qigong_level_up_widget = self:AddChild(qigong_level_up())
	self.qigong_level_up_widget:Hide()
end)

-- AddClientModRPCHandler("qigong_base", "leveluppage", function(player)
--     -- 显示按钮
--     player.HUD.qigong_level_up_widget:Show()
-- end)

-- AddPlayerPostInit(function(inst)
--     -- 判断当前机器是不是服务端，不是的话就返回，不往下执行监听死亡事件的代码
--     if not _g.TheWorld.ismastersim then return inst end
--     -- 监听打开进阶页面事件
--     inst:ListenForEvent("switch_qigong_level_up_widget", function(inst)
--         -- 监听到玩家死亡时，同样的使用rpc通知客机，让客机收到rpc事件后，将按钮显示出来
--         SendModRPCToClient(CLIENT_MOD_RPC["modmain"]["leveluppage"], inst.userid, inst)
--     end)
-- end)


AddSimPostInit(function()
	_g.TheInput:AddKeyHandler(
	function(key, down)
        -- Only trigger on key down
		if not down then return end
		-- Push our screen
		if key == _g.KEY_H then
			local screen = TheFrontEnd:GetActiveScreen()
			-- End if we can't find the screen name (e.g. asleep)
			if not screen or not screen.name then return true end
			-- If the hud exists, open the UI
			if screen.name == "HUD" then
				if not screen.qigong_level_up_widget.visiable then
					-- We want to pass in the (clientside) player entity
					-- TheFrontEnd:PushScreen(require("screens/qigong_level_up")(_g.ThePlayer))
					screen.qigong_level_up_widget:Show()
					screen.qigong_level_up_widget.visiable = true
					return true
				else
					-- If the screen is already open, close it
					screen.qigong_level_up_widget:Hide()
					screen.qigong_level_up_widget.visiable = false
					return true
				end
			end
		end
		-- Require CTRL for any debug keybinds
		if _g.TheInput:IsKeyDown(_g.KEY_CTRL) then
			 -- Load latest save and run latest scripts
			if key == _g.KEY_R then
				if _g.TheWorld.ismastersim then
					_g.c_reset()
				else
					_g.TheNet:SendRemoteExecute("c_reset()")
				end
			end
		end
	end)
end)

modimport("scripts/qigong_actions.lua")
modimport("scripts/widgets/qigong_level_up_popup.lua")
modimport("scripts/qigong_modframework.lua")--框架，集成合成栏、动作等