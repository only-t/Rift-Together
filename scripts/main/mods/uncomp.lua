--- Setting radiation value for UM characters
local characters = {
    "winky",
    "wathom",
    "wixie"
}

for i, prefab in ipairs(characters) do
    AddPrefabPostInit(prefab, function(inst)
        if not _G.TheWorld.ismastersim then
            return
        end

        inst.components.radiation:SetMax(TUNING.CHARACTERS_MAX_RADIATION[string.upper(prefab)])
    end)
end

--- Adding radiation to Uncomp
AddPrefabPostInit("moonmaw_dragonfly", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end
            
    inst.inflictvictim = function(inst, attacker)
        if attacker and attacker.components.health and not attacker.components.health:IsDead() then
            _G.SpawnPrefab("radiation_clouds"):AlignToTarget(inst, attacker, true)					
        end
    end	 	
    
    inst:ListenForEvent("onattackother", function(inst, data)
        if math.random() <= 0.75 and data.target and data.target.components.radiation then
            inst:inflictvictim(data.target)
            data.target.components.radiation:DoDelta(25)
        end
    end)
end)

AddPrefabPostInit("moonmaw_larvae", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end
            
    --- radiation damage 
    inst.inflictvictim = function(inst, attacker)
        if attacker and attacker.components.health and not attacker.components.health:IsDead() then
            _G.SpawnPrefab("radiation_clouds"):AlignToTarget(inst, attacker, true)					
        end
    end
    
    inst:ListenForEvent("onattackother", function(inst, data)
        if math.random() <= 0.9 and data.target and data.target.components.radiation then
            inst:inflictvictim(data.target)
            data.target.components.radiation:DoDelta(10)
        end
    end)
end)

AddPrefabPostInit("moonmaw_glass", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("radiationsource")
    inst.components.radiationsource:SetRadius(4)
    inst.components.radiationsource:SetContaminationAmount(0.5)
    inst.components.radiationsource:SetRadiationAmount(6)
end)

AddPrefabPostInit("moonmaw_trap", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("radiationsource")
    inst.components.radiationsource:SetRadius(4)
    inst.components.radiationsource:SetContaminationAmount(0.5)
    inst.components.radiationsource:SetRadiationAmount(6)
end)

AddPrefabPostInit("moonmaw_glasshards", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end
    
    inst.inflictvictim = function(inst, attacker)
        if attacker and attacker.components.health and not attacker.components.health:IsDead() then
            _G.SpawnPrefab("radiation_clouds"):AlignToTarget(inst, attacker, true)					
        end
    end
    
    inst:ListenForEvent("onattackother", function(inst, data)
        if math.random() <= 0.9 and data.target and data.target.components.radiation then
            inst:inflictvictim(data.target)
            data.target.components.radiation:DoDelta(1)
        end
    end)
end)

AddPrefabPostInit("hound", function(inst)
    if inst:HasTag("horrorhound") then	
        inst.inflictvictim = function(inst, attacker)
            if attacker and attacker.components.health and not attacker.components.health:IsDead() then
                _G.SpawnPrefab("radiation_clouds"):AlignToTarget(inst, attacker, true)					
            end
        end
        
        inst:ListenForEvent("onattackother", function(inst, data)
            if math.random() <= 0.9 and data.target and data.target.components.radiation then
                inst:inflictvictim(data.target)
                data.target.components.radiation:DoDelta(10)
            end
        end)
    end
end)

--- Adding Armored Mobs to Uncomp

AddPrefabPostInit("knook", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("armoredbody")

end)

AddPrefabPostInit("bight", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("armoredbody")

end)

AddPrefabPostInit("roship", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("armoredbody")

end)

AddPrefabPostInit("um_pawn", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("armoredbody")

end)

AddPrefabPostInit("um_pawn_nightmare", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("armoredbody")

end)

AddPrefabPostInit("hound_magma", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("armoredbody")

end)

--- food

AddPrefabPostInit("honey_log", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end
    inst.components.edible.radiationvalue = -15
end)	

AddPrefabPostInit("armor_glassmail", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end
    inst.components.equippable:SetRadiationProtectPercent(0.15)
end)