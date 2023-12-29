GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

PrefabFiles = {
    "qigong_base",
    "qigong_base_projectile",
}

Assets = {
	Asset("ATLAS", "images/hud/qigong_skill_bg.xml"), 
	Asset("IMAGE", "images/hud/qigong_skill_bg.tex")
}

env.RECIPETABS = GLOBAL.RECIPETABS
env.TECH = GLOBAL.TECH

local recipe_name = "qigong_base"
local ingredients = {Ingredient("cutgrass", 1), Ingredient("twigs", 1)}
local tech = TECH.NONE --所需科技，必须使用常量表TECH的值
local config = {
    atlas = "images/inventoryimages/qigong_base.xml",
}
AddRecipe2(recipe_name, ingredients, tech, config)

env.STRINGS = GLOBAL.STRINGS
STRINGS.SWALLOW = "吞噬"
STRINGS.NAMES.QIGONG_BASE = "气功基础"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.QIGONG_BASE = "这是所有气功的基础"
STRINGS.RECIPE_DESC.QIGONG_BASE = "气功，从入门到入土" -- 制作栏描述

local _g = GLOBAL
local require = _g.require
local qigong_level_up = require("widgets/qigong_level_up")
local containers = require("containers")


--可吞噬的物品
local swallowItemPrefab = { "antlionhat", "alterguardianhat" }

--吞噬格ui组件
local params = containers.params
params.swallow =
{
    widget =
    {
        slotpos = {
            Vector3(0, 34, 0),
        },
        slotbg =
        {
            -- { image = "turf_slot.tex", atlas = "images/hud2.xml" },
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(-2, 40, 0),
    },
    type = "hand_inv",
    excludefromcrafting = true,
    --判定是否能放入吞噬格
    itemtestfn = function(inst, item, slot) -- 容器里可以装的物品的条件
        return table.contains(swallowItemPrefab, item.prefab)
    end
}

--吞噬按钮
params.swallow.widget.buttoninfo = {
	text = STRINGS.SWALLOW,
	position = Vector3(0, -30, 0),
	fn = function (inst, doer)
		if inst.components.container ~= nil and containerLevelUpValidFn(inst) then
			btnfn(inst, doer)
		elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
			SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
		end
	end,
}

AddClassPostConstruct("screens/playerhud", function(self)
    self.qigong_level_up_widget = self:AddChild(qigong_level_up())
	self.qigong_level_up_widget:Hide()
end)

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

