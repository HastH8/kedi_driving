local maxRpm = Config.vehicle.maxRpm
local maxSpeed = Config.vehicle.maxSpeed
local throttleControlEnabled = Config.vehicle.defaultSmoothingEnabled
local allowedClasses = Config.allowedVehicleClasses

CreateThread(function()
    local usedForce = 0
    local rollbackConfig = Config.features.rollback
    local handbrakeConfig = Config.features.handbrake

    while true do
        local sleep = 3000
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed) then
            local veh = GetVehiclePedIsIn(playerPed)
            
            -- Check if player is driver
            if GetPedInVehicleSeat(veh, -1) == playerPed then
                sleep = 250
                local speed = GetEntitySpeedVector(veh, true).y
                
                if speed < 20 then
                    sleep = 100
                    local throttle = GetVehicleThrottleOffset(veh)

                    -- Enhanced rollback system
                    if speed < 0 and (throttle == 0.0 or usedForce > 0) then
                        if rollbackConfig.enabled then
                            SetVehicleClutch(veh, 1.0)

                            if usedForce < rollbackConfig.duration then
                                usedForce = usedForce + 1
                                ApplyForceToEntity(veh, 0, 
                                    vector3(0, math.max(-6, speed * rollbackConfig.strength), 0), 
                                    0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 0)
                            end
                            sleep = 1
                        end
                    else
                        -- Enhanced handbrake turns
                        if handbrakeConfig.enabled then
                            if throttle == 0.0 and speed < 15 and speed > 2 
                                and GetVehicleHandbrake(veh) 
                                and math.abs(GetVehicleSteeringAngle(veh)) > 0.5 then
                                
                                ApplyForceToEntity(veh, 1, 
                                    vector3(GetVehicleSteeringAngle(veh) * speed * handbrakeConfig.strength, 0.0, 0), 
                                    0.0, -3.0, 0, 0, 1, 1, 0, 0)
                            end
                        end
                        
                        -- Reset used force
                        if usedForce > 0 then
                            usedForce = math.max(0, usedForce - 10)
                        end
                    end
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Throttle control system
local function ManageThrottleControl()
    if not throttleControlEnabled then return end
    
    CreateThread(function()
        while throttleControlEnabled do
            local sleep = 50
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if vehicle and DoesEntityExist(vehicle) then
                local vehicleClass = GetVehicleClass(vehicle)
                
                if allowedClasses[vehicleClass] then
                    local vehicleSpeed = GetEntitySpeed(vehicle) * 3.6
                    local throttleOffset = math.abs(GetVehicleThrottleOffset(vehicle))
                    
                    if throttleOffset > 0.3 and vehicleSpeed <= maxSpeed then
                        sleep = 1
                        local currentRpm = GetVehicleCurrentRpm(vehicle)
                        if currentRpm > maxRpm then
                            SetVehicleCurrentRpm(vehicle, maxRpm)
                        end
                    end
                end
            end
            
            Wait(sleep)
        end
    end)
end

-- Register commands for throttle control
RegisterCommand('+throttlecontrol', function()
    throttleControlEnabled = not Config.vehicle.defaultSmoothingEnabled
    ManageThrottleControl()
end, false)

RegisterCommand('-throttlecontrol', function()
    throttleControlEnabled = Config.vehicle.defaultSmoothingEnabled
    ManageThrottleControl()
end, false)

-- Key mapping
RegisterKeyMapping('+throttlecontrol', 
    Config.controls.throttleControl.label, 
    'keyboard', 
    Config.controls.throttleControl.key)