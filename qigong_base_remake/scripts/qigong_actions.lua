STRINGS.LEVELUPTAG = "升级页面"

local actions = {
    {
		id = "TOUCHQIGONG",
		str = STRINGS.LEVELUPTAG,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="qigong_base" and act.invobject:HasTag("leveluppage") then
				act.doer:ShowPopUp(POPUPS.LEVELUPPAGE, true ,act.invobject)
				return true
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
			mount_valid=true,
		},
	},
}

--动作与组件绑定
local component_actions = {
	{
		type = "INVENTORY",
		component = "inventoryitem",
		tests = {
			{
				action = "TOUCHQIGONG",--摸气功
				testfn = function(inst,doer,actions,right)
                    -- function参数，inst这里是物品A,doer是动作执行者，这里是一般为玩家，target动作执行对象，actions，可触发的动作列表。right=true，是否是右键动作。
                    -- if
                    -- inst.replica.move_attack.leveluping ~= false -- 在进阶期间
                    -- then
                    --     return doer and inst.prefab=="qigong_base" and inst:HasTag("leveluppage")
                    -- else
                    --     print("没通过判定")
                    -- end
                    -- doer:ShowPopUp(POPUPS.LEVELUPPAGE, true)
                    return doer and inst.prefab=="qigong_base" and inst:HasTag("leveluppage")
				end,
			},
		},
	},
}


return {
	actions = actions,
    component_actions = component_actions,
}