local assets =
{
    Asset("ANIM", "anim/air_spin_loop.zip"),
}

local qigong_prefabs =
{
    "superjump_fx",
}

local function OnHitAir(inst, owner, target)
    -- if target:IsValid() and target.SoundEmitter then
    --     local fx = SpawnPrefab("superjump_fx")
    --     fx.Transform:SetPosition(target.Transform:GetWorldPosition())
    --     target.SoundEmitter:PlaySound("dontstarve/wilson/torch_swing", 2)
    -- end
    inst:Remove()
end

local function common(anim, bloom, lightoverride)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("air_spin_loop")
    inst.AnimState:SetBuild("air_spin_loop")
    inst.AnimState:PlayAnimation(anim, true)
    if bloom ~= nil then
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
	if lightoverride ~= nil then
		inst.AnimState:SetLightOverride(lightoverride)
	end

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(40)
    inst.components.projectile:SetOnHitFn(inst.Remove)
    inst.components.projectile:SetOnMissFn(inst.Remove)

    return inst
end

local function air()
    local inst = common("air_spin_loop")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.projectile:SetOnHitFn(OnHitAir)

    return inst
end

return Prefab("qigong_base_projectile", air, assets, qigong_prefabs)