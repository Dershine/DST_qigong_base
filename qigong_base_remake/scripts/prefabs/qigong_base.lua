local swallow = require "widgets/qigong_container"

local assets = 
{
    Asset("ANIM","anim/qigong_base.zip"),
    Asset("ANIM","anim/qigong_hand_anim.zip"),
    Asset("ATLAS","images/inventoryimages/qigong_base.xml"),
}

local prefabs =
{
    blue =
    {
        "ice_projectile",
    },
    air = 
    {
        "qigong_base_projectile",
    }
}

--这里设置了一些常量，以供后续使用
--初始走A步数
local MOVE_INITSTEP = 0
--初始最大走A步数
local MOVE_INITMAXSTEP = 11
--达到第一个强化阶段所需走A步数
local FIRST_STAGE = 5
--达到第二个强化阶段所需走A步数
local SECOND_STAGE = 10
--可攻击的标签
local TARGET_MUST_TAGS = { "_combat" }
--不可攻击的标签
local TARGET_CANT_TAGS = { "INLIMBO", "companion", "wall", "abigail", "shadowminion" }

--获得人物的位置
local function giveposition(owner)
    local px, pz, py = owner.Transform:GetWorldPosition()
    local data = {
        x = px,
        y = py,
    }
    return data
end

--增加走A次数的判断方法
local function incrstep(inst, owner)
    --加载上一次平A的位置
    local position1 = inst.components.move_attack:OnSavePosition()
    --加载当前平A的位置
    local position2 = giveposition(owner)
    --计算两次平A之间的距离
    local result = DistXYSq(position1, position2)
    --将新的平A位置保存下来
    inst.components.move_attack:OnLoadPosition(position2)
    if result ~= nil and result > 0 and result <= 49 then
        --两次走A在一定距离内，则走A步数加一
        inst.components.move_attack:IncrStep(1)
    else
        --走A超过一定范围或原地攻击，则清空走A步数
        inst.components.move_attack:ResetStep()
    end
end

--根据走A次数判断是否增加伤害
local function incrdamage(inst)
    --从组件中获取当前的走A步数
    local step = inst.components.move_attack:OnSaveStep().step
    --如果走A步数未达到第一个强化阶段，则伤害为50
    if step ~= nil and step >= 0 and step < FIRST_STAGE then
        inst.components.weapon:SetDamage(50)
    --如果走A步数达到第一个强化阶段，而没达到第二个强化阶段，则伤害提高至65
    elseif step ~= nil and step >= FIRST_STAGE and step < SECOND_STAGE then
        inst.components.weapon:SetDamage(65)
    --如果以上两个条件都未满足，则达到第二个强化阶段，伤害提高至75
    else
        inst.components.weapon:SetDamage(75)
    end
    --将当前走A步数返回给调用这个函数的地方，以供后续使用，防止重复查询，增加服务器负担
    return step
end

local function onattack_qigong_base(inst, attacker, target)
    --增加走A次数
    incrstep(inst, attacker)
    --根据走A次数判断是否增加伤害
    local step = incrdamage(inst)

    --判断是否处于进阶状态，如果不处于进阶状态，则执行以下代码
    -- if not inst.components.move_attack.leveluping then
    --     --增加攻击总次数，用于后续判断进阶路线
    --     inst.components.move_attack:IncrSumAttack(1)
    --     --判断是否达到进阶要求，如果达到，则开启进阶
    --     judgelevelup(inst, attacker)
    -- end

    local sumstep = inst.components.move_attack.sumstep
    local sumattack = inst.components.move_attack.sumattack
    -- print("第三阶段步数:"..sumstep.."  攻击总次数:"..sumattack)

    if target.components.combat ~= nil and target.components.combat.hiteffectsymbol and attacker.SoundEmitter then
        --如果走A次数处于第一阶段，则执行以下特效
        if step ~= nil and step < FIRST_STAGE then
            -- 下两行加入击中敌人的特效
            local hit_fx = SpawnPrefab("lavaarena_firebomb_proc_fx")
            hit_fx.Transform:SetPosition(target.Transform:GetWorldPosition())
            -- 下一行加入角色发出攻击时的音效
            inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_swing", 1)
        --如果走A次数处于第二阶段，则执行以下特效
        elseif step ~= nil and step >= FIRST_STAGE and step < SECOND_STAGE then
            -- 下两行加入击中敌人的特效
            local hit_fx1 = SpawnPrefab("superjump_fx")
            hit_fx1.Transform:SetPosition(target.Transform:GetWorldPosition())
            -- 下一行加入角色发出攻击时的音效
            inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_swing", 1)
        --如果走A次数处于第三阶段，则执行以下特效
        else
            -- 下两行加入击中敌人的特效
            local hit_fx2 = SpawnPrefab("moonpulse_fx")
            hit_fx2.Transform:SetPosition(target.Transform:GetWorldPosition())
            -- 下一行加入角色发出攻击时的音效
            inst.SoundEmitter:PlaySound("rifts/portal/rift_explode")
        end
    end

    --获取攻击目标的位置坐标
    local x, y, z = target.Transform:GetWorldPosition()
    --搜寻坐标内5格范围的实体，并进行tag的匹配，获取有TARGET_MUST_TAGS的实体，排除有TARGET_CANT_TAGS的实体，记录到ents这个表中
    local ents = TheSim:FindEntities(x, y, z, 5, TARGET_MUST_TAGS, TARGET_CANT_TAGS)
    --先使攻击目标受到伤害，并且获取当前的武器伤害，存入damage变量，下面的遍历会用到
    local damage = inst.components.weapon:GetDamage(attacker, target)
    --遍历ents这个表，使其中所有的项目受到伤害
    for i, v in ipairs(ents) do
        if v:IsValid() and not v:IsInLimbo() then
            if v.components.combat ~= nil and v.components.combat.hiteffectsymbol then
                --要排除攻击目标本身，不然就相当于造成了两次伤害
                if v ~= target and v ~= attacker then
                    -- 推送事件给服务器来计算其它实体的血量以及通知其它玩家，当前多少实体正在被攻击
                    attacker:PushEvent("onareaattackother", { target = v, weapon = inst, stimuli = nil })
                    -- 给予实体伤害
                    v.components.combat:GetAttacked(attacker, damage, inst, nil)
                end
            end
        end
    end
end

--装备气功基础时，触发onequip函数
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "qigong_hand_anim", "qigong_hand_anim")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:Show("ARM_carry")
    -- 初始化当前走A步数和最大走A步数
    local data1 = {
        step = MOVE_INITSTEP,
        maxstep = MOVE_INITMAXSTEP,
    }
    --将人物的位置存入表中
    local data2 = giveposition(owner)
    --载入走A次数和人物位置到组件中
    inst.components.move_attack:OnLoadStep(data1)
    inst.components.move_attack:OnLoadPosition(data2)
end

--脱下气功基础时，触发onunequip函数
local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function qigong_onuse(inst)
    local owner = inst.components.inventoryitem.owner
    if owner then
        if not CanEntitySeeTarget(owner, inst) then return false end
        owner.sg:GoToState("plantregistry_open")
        owner:ShowPopUp(POPUPS.LEVELUPPAGE, true)
    end
end

local function commonfn(colour, tags)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("qigong_base")
    inst.AnimState:SetBuild("qigong_base")
    inst.AnimState:PlayAnimation("idle")

    --遍历tags，将其中的所有tags添加到inst上
    if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end

    --加上这个语句，可以让气功基础浮在水面上
    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("swallow")  --为客机注册
        end
        return inst
    end

    --给气功基础加上“可以被检查”的组件
    inst:AddComponent("inspectable")

    --加上这个语句，使气功基础可以被放入物品栏，并且显示对应图标
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/qigong_base.xml"

    --可以将气功基础与猪王交易
    inst:AddComponent("tradable")

    --给气功基础加上“可装备”的组件，并分别设置装备与脱下时的回调函数
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    --给气功基础加上“容器”组件，用来吞噬物品进阶功法
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("swallow")

    --添加该组件，使气功基础可以在物品栏被右键交互
    -- inst:AddComponent("useableitem")
    -- inst.components.useableitem:SetOnUseFn(qigong_onuse)

    --给气功基础加上“走A”组件，该组件为本模组私有组件
    inst:AddComponent("move_attack")

    return inst
end

local function base()
	-- local inst = commonfn("base", { "weapon" , "jab", "leveluppage"})
	local inst = commonfn("base", { "weapon", "jab",})

    inst.projectiledelay = FRAMES

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(50)
    inst.components.weapon:SetRange(10, 12)
    inst.components.weapon:SetOnAttack(onattack_qigong_base)
    inst.components.weapon:SetProjectile("qigong_base_projectile")

    MakeHauntableLaunch(inst)
    -- AddHauntableCustomReaction(inst, onhauntblue, true, false, true)

    return inst
end


return Prefab("qigong_base", base, assets, prefabs.air)