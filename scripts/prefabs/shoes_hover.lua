local assets =
{
	Asset("ANIM", "anim/swap_shoes_hover.zip"),
}

local function LightsOff(inst)
	inst.Light:SetFalloff(0)
	inst.Light:SetIntensity(0)
	inst.Light:SetRadius(0)
	inst.Light:SetColour(0/255,0/255,0/255)
	inst.Light:Enable(false)
end

local function LightsOn(inst)
	inst.Light:SetFalloff(.9)
	inst.Light:SetIntensity(.3)
	inst.Light:SetRadius(.7)
	inst.Light:SetColour(0/255,255/255,255/255)
	inst.Light:Enable(true)
end

local function OnEquip(inst, owner)	
	inst._hovering = false
	Shoes_OnEquip(inst, owner)
	owner:RemoveTag("hovershoed")
	owner.components.locomotor.fasteroncreep = false
	owner.components.locomotor:SetTriggersCreep(true)
	inst.components.equippable.walkspeedmult = 1
	
	inst:ListenForEvent("onattackother", inst.SpeedAttack, owner, inst)
	
	if inst.components.fueled and inst.components.equippable:IsEquipped() then
			inst.components.fueled:StopConsuming()
	end	
	
	
end

local function OnUnequip(inst, owner)	
	inst._hovering = false
	owner:RemoveTag("hovershoed")
	owner.sg:GoToState("idle")
	owner.components.locomotor.fasteroncreep = false
	owner.components.locomotor:SetTriggersCreep(true)
	LightsOff(inst)
	
	inst:RemoveEventCallback("onattackother", inst.SpeedAttack, owner, inst)
		
	Shoes_OnUnequip(inst, owner)
end

local function Speed_Penalty(inst)
	local speed = TUNING.SHOES_HOVER_SPEED or 1
	local new
	
	if inst.components.timer then
		local t = inst.components.timer:GetTimeLeft("shoesspeed_penalty") or 0
		new = math.max(1, Lerp(speed, 1, t * 0.5))
	end
	
	if new and new < speed then
		inst.components.equippable.walkspeedmult = math.min(speed, RoundBiasedUp(new, 2))
	else
		inst.components.equippable.walkspeedmult = speed
		inst._shoespenaltytask:Cancel()
		inst._shoespenaltytask = nil
	end
end

local function Speed_Attack(inst, owner, data)
	if inst.components.timer then
		local time = TUNING.HOVER_COMBAT_TIME or 5
		if inst.components.timer:TimerExists("shoesspeed_penalty") then
			inst.components.timer:SetTimeLeft("shoesspeed_penalty", time)
		else
			inst.components.timer:StartTimer("shoesspeed_penalty", time)
		end
	end
	
	if inst._shoespenaltytask == nil and inst.components.equippable.walkspeedmult > 1 then
		inst._shoespenaltytask = inst:DoPeriodicTask(0.1, Speed_Penalty)
	end
end
	
local function Hover_OnUse(inst, owner, item)    
    local owner = inst.components.inventoryitem.owner    
    inst._hovering = not inst._hovering        
    	
    if inst._hovering then  
    owner.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
    if owner then
    if owner.components.carefulwalker and owner.components.carefulwalker:IsCarefulWalking() then
        owner.components.carefulwalker:ToggleCareful(false)
    end
    inst._hovering = true
    owner:AddTag("hovershoed")
    owner.sg:GoToState("hover_stop")
    owner.components.locomotor.fasteroncreep = true
    owner.components.locomotor:SetTriggersCreep(false)
    inst.components.equippable.walkspeedmult = TUNING.SHOES_HOVER_SPEED
    LightsOn(inst)
    end
    if inst.components.fueled and inst.components.equippable:IsEquipped() then
            inst.components.fueled:StartConsuming()
        end
    elseif not inst._hovering then	
        inst._hovering = false
        owner.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
        owner:RemoveTag("hovershoed")
        owner.sg:GoToState("idle_hover_stop")
        owner.components.locomotor.fasteroncreep = false
        owner.components.locomotor:SetTriggersCreep(true)
        inst.components.equippable.walkspeedmult = 1
        LightsOff(inst)
    if inst.components.fueled and inst.components.equippable:IsEquipped() then
            inst.components.fueled:StopConsuming()
        end    
    end
    if inst.fx then
        inst.fx:PlayShoesAnim(inst.shoesanim..(inst._hovering and "_boost" or ""), inst._hovering)
    end
    
    inst:DoTaskInTime(0.1, function() inst.components.useableitem.inuse = false end)
	end


local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	MakeInventoryFloatable(inst, "small", 0, {0.85, 0.6, 0.85})
	
	LightsOff(inst)

	inst:AddTag("light")
	
	inst:AddTag("shoes")
	inst:AddTag("waterproofer")
	
	inst.AnimState:SetBank("swap_shoes_hover")
	inst.AnimState:SetBuild("swap_shoes_hover")
	inst.AnimState:PlayAnimation("idle_hover")
	
	inst.shoesanim = "hover"
	
	inst.AnimState:SetSymbolBloom("flame")
	inst.AnimState:SetSymbolLightOverride("flame", .5)
	inst.AnimState:SetLightOverride(.1)

	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._hidefeet = true
	
	inst:AddComponent("timer")
	
	inst.SpeedAttack = function(owner, data) Speed_Attack(inst, owner, data) end
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "shoes_hover"
    inst.components.inventoryitem.atlasname = "images/rnc_inventoryimages.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.SHOES
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(TUNING.MINERHAT_LIGHTTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	
	inst:AddComponent("useableitem")
	inst.components.useableitem:SetOnUseFn(Hover_OnUse)

	
	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)

	
	inst:AddComponent("inspectable")
	
	MakeHauntableLaunch(inst)
	
	
	return inst
end

return Prefab("shoes_hover", fn, assets)
