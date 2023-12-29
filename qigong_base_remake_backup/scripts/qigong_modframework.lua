local pcall = GLOBAL.pcall
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

local actions_status,actions_data = pcall(require,"qigong_actions")
if actions_status then
    -- 导入自定义动作
    if actions_data.actions then
        for _,act in pairs(actions_data.actions) do
            local action = AddAction(act.id,act.str,act.fn)
            if act.actiondata then
                for k,data in pairs(act.actiondata) do
                    action[k] = data
                end
            end
            AddStategraphActionHandler("wilson",GLOBAL.ActionHandler(action, act.state))
            AddStategraphActionHandler("wilson_client",GLOBAL.ActionHandler(action,act.state))
        end
    end
    -- 导入动作与组件的绑定
    if actions_data.component_actions then
        for _,v in pairs(actions_data.component_actions) do
            local testfn = function(...)
                local actions = GLOBAL.select (-2,...)
                for _,data in pairs(v.tests) do
                    if data and data.testfn and data.testfn(...) then
                        data.action = string.upper( data.action )
                        table.insert( actions, GLOBAL.ACTIONS[data.action] )
                    end
                end
            end
            AddComponentAction(v.type, v.component, testfn)
        end
    end
end