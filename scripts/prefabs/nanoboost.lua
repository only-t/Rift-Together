local assets =
{
	Asset("ANIM", "anim/nanoboost.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nanoboost")
    inst.AnimState:SetBuild("nanoboost")
    inst.AnimState:PlayAnimation("anim")
	
	--inst:AddTag("rejuvenation")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/rnc_inventoryimages.xml"

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()	

	inst:AddComponent("edible")
    inst.components.edible.healthvalue = 5
    inst.components.edible.radiationvalue = -100
    inst.components.edible.hungervalue = 20
    inst.components.edible.sanityvalue = 30		
    inst.components.edible.foodtype = FOODTYPE.GENERIC

    inst:AddComponent("inspectable")
	
	--inst:AddComponent("radiation")
	--inst.components.radiation:Dodelta(-100)
	
    return inst
end

return Prefab("nanoboost", fn, assets)