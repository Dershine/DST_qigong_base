--本文件的代码与装备吞噬格有关

local containers = require "containers"

--容器判定，为空时不可按下吞噬按钮
local function containerLevelUpValidFn(inst)
	return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()--容器不为空
end

-- --可吞噬的物品
-- local swallowItemPrefab = { "antlionhat", "alterguardianhat" }

-- --吞噬格ui组件
-- local params = containers.params
-- params.swallow =
-- {
--     widget =
--     {
--         slotpos = {
--             Vector3(0, 34, 0),
--         },
--         slotbg =
--         {
--             -- { image = "turf_slot.tex", atlas = "images/hud2.xml" },
--         },
--         animbank = "ui_cookpot_1x2",
--         animbuild = "ui_cookpot_1x2",
--         pos = Vector3(-2, 40, 0),
--     },
--     type = "hand_inv",
--     excludefromcrafting = true,
--     --判定是否能放入吞噬格
--     itemtestfn = function(inst, item, slot) -- 容器里可以装的物品的条件
--         return table.contains(swallowItemPrefab, item.prefab)
--     end
-- }


--打开技能选择页面
local function switch_qigong_level_up_widget()
    local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
    -- End if we can't find the screen name (e.g. asleep)
    if not screen or not screen.name then return true end
    -- If the hud exists, open the UI
    if screen.name == "HUD" and screen.qigong_level_up_widget then
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


--吞噬按钮触发的函数
local btnfn = function (inst, doer)
    if inst.components.container then
        -- if item ~= nil then
        --     print(item.prefab)
        -- end

        --打开技能选择界面
        local switch_widget = switch_qigong_level_up_widget()

        --删除进阶物品
        local item = inst.components.container:RemoveItemBySlot(1)
        item:Remove()
        --吞噬完成后自动关闭吞噬格
        inst.components.container:Close(doer)
        inst.components.container.canbeopened = false

        --关闭进阶状态
        inst.components.move_attack.leveluping = false
    end
end


-- --吞噬按钮
-- params.swallow.widget.buttoninfo = {
-- 	text = STRINGS.SWALLOW,
-- 	position = Vector3(0, -30, 0),
-- 	fn = function (inst, doer)
-- 		if inst.components.container ~= nil and containerLevelUpValidFn(inst) then
-- 			btnfn(inst, doer)
-- 		elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
-- 			SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
-- 		end
-- 	end,
-- }

