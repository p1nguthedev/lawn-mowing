local inMission = nil
local lawnConfig = nil

lib.requestModel(Config.JobStart.ped, 500)
local ped = CreatePed(4, Config.JobStart.ped, Config.JobStart.coords.x, Config.JobStart.coords.y, Config.JobStart.coords.z, Config.JobStart.coords.w, false, false)
FreezeEntityPosition(ped, true)
SetEntityCanBeDamaged(ped, false)
SetBlockingOfNonTemporaryEvents(ped, true)
SetPedDiesWhenInjured(ped, false)
SetPedCanPlayAmbientAnims(ped, true)
SetPedCanRagdollFromPlayerImpact(ped, false)
SetEntityInvincible(ped, true)

target(false, 'p1ngu_lawnmoving', Config.Locales['start_talking'], 'E', 'p-jobs:lawnmower:client:start', 'client', Config.JobStart.coords)

RegisterNetEvent("p-jobs:lawnmower:client:start", function()
    lib.registerContext({
        id = 'lawnmoving_menu',
        title = 'Lawn Moving Job',
        menu = 'lawnmoving_menu',
        options = {
          {
            title = 'Start job',
            icon = 'fa fa-sign-in',
            description = 'Start lawn moving job. You earn around 500€',
            onSelect = function()
                if inMission then
                    Notify('You are in task already', 'Complete this one first to get paid!', 'error')
                    return
                end
            
                local answer = lib.callback.await('p1ngu_lawnmoving_getLawns', false)
                if not answer then
                    print("not jobs")
                    return
                end
            
                if Config.UseCarRentPayment then
                    local carRentPayment = lib.callback.await('p1ngu_lawnmoving_makeCarPayment', false)
                    if carRentPayment then
                        Notify('Payment failed', 'You dont have enough money!', 'error')
                        return
                    end
                end

                inMission = true
                spawnVehicles()
                setJobCoords(answer)
            end,
          }
        }
    })

    lib.showContext('lawnmoving_menu')
end)

RegisterNetEvent('p-jobs:lawnmower:client:mowerCoords', function()
    DetachEntity(mower, true, true)
    SetEntityCoords(mower, vector3(878.9641, -506.1289, 57.5049))
    SetEntityHeading(mower, 310.5745)
    target(true, targerMowerId)
    RemoveBlip(blipToCustomer)
end)

RegisterNetEvent('p1ngu_lawnmoving:returnEquiment', function()
    targetSetOnTrailer = "lawnmower" .. tostring(math.random(1, 8899923123131))
    target(true, targerPayoutId)
    target(false, targetSetOnTrailer, Config.Locales['set_mower_on_trailer'], 'E', 'p1ngu_lawnmoving:setOnTrailer', 'client', lawnConfig.lawnMover.targetCoords)
end)

RegisterNetEvent('p1ngu_lawnmoving:setOnTrailer', function()
    AttachMowerToTrailer(trailer, mower)
    target(true, targetSetOnTrailer)
    returnEquiment()
end)

RegisterNetEvent('p1ngu_lawnmoving:endTasks', function()
    DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
    target(true, deleteEquipment)
    lawnConfig = nil
    inMission = false
    RemoveBlip(blipBackToStart)
    ClearPedTasks(PlayerPedId())
end)

function returnEquiment()
    blipBackToStart = AddBlipForCoord(Config.JobStart.deleteVehicleCoords)
    SetBlipSprite(blipBackToStart, 1)
    SetBlipColour(blipBackToStart, 63)
    SetBlipRoute(blipBackToStart, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Locales['blip_return'])
    EndTextCommandSetBlipName(blipBackToStart)

    deleteEquipment = "lawnmower" .. tostring(math.random(1, 8899923123131))
    target(false, deleteEquipment, Config.Locales['end_job'], 'E', 'p1ngu_lawnmoving:endTasks', 'client', Config.JobStart.deleteVehicleCoords)
end

function spawnVehicles()
    local vehicleCoords = Config.JobStart.vehicleCoords
    local trailerCoords = Config.JobStart.trailerCoords
    local mowerCoords = Config.JobStart.mowerCoords

    lib.requestModel('bison', 200)
    veh = CreateVehicle('bison', vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, vehicleCoords.w, true, false)

    lib.requestModel('boattrailer', 200)
    trailer = CreateVehicle('boattrailer', trailerCoords.x, trailerCoords.y, trailerCoords.z, trailerCoords.w, true, false)
    AttachVehicleToTrailer(veh, trailer)

    lib.requestModel('mower', 200)
    mower = CreateVehicle('mower', mowerCoords.x, mowerCoords.y, mowerCoords.z, mowerCoords.w, true, false)

    AttachMowerToTrailer(trailer, mower)
end

function AttachMowerToTrailer(trailer, mower)
    local trailerPos = GetEntityCoords(trailer)
    local trailerHeading = GetEntityHeading(trailer)
    local mowerPos = vector3(trailerPos.x, trailerPos.y, trailerPos.z + 1.0)

    SetEntityCoords(mower, mowerPos.x, mowerPos.y, mowerPos.z, false, false, false, true)
    SetEntityHeading(mower, trailerHeading)
    AttachEntityToEntity(mower, trailer, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
end

function setJobCoords(data)
    local cfg = Config.Lawns[data.index]
    local propertyOwnerCoords = cfg.propertyOwner.coords

    blipToCustomer = AddBlipForCoord(propertyOwnerCoords.x, propertyOwnerCoords.y, propertyOwnerCoords.z)
    SetBlipSprite(blipToCustomer, 1)
    SetBlipColour(blipToCustomer, 63)
    SetBlipRoute(blipToCustomer, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Locales['blip'])
    EndTextCommandSetBlipName(blipToCustomer)

    spawnPropertyOwner(propertyOwnerCoords, cfg)
    lawnMovingLogic(data.index)
end

function spawnPropertyOwner(coords, cfg)
    lib.requestModel(cfg.propertyOwner.ped, 500)
    propertyOwnerPed = CreatePed(4, cfg.propertyOwner.ped, coords.x, coords.y, coords.z, coords.w, false, false)
    FreezeEntityPosition(propertyOwnerPed, true)
    SetEntityCanBeDamaged(propertyOwnerPed, false)
    SetBlockingOfNonTemporaryEvents(propertyOwnerPed, true)
    SetPedDiesWhenInjured(propertyOwnerPed, false)
    SetPedCanPlayAmbientAnims(propertyOwnerPed, true)
    SetPedCanRagdollFromPlayerImpact(propertyOwnerPed, false)
    SetEntityInvincible(propertyOwnerPed, true)
end

function getPayment(lawnConfig)
    if inMission then
        targerPayoutId = "lawnmower" .. tostring(math.random(1, 88999231231312312))
        local coords = lawnConfig.propertyOwner.coords
        target(false, targerPayoutId, Config.Locales["collect_rewards"], 'E', 'give', 'server', coords)
    end
end

function removeCloseProps(props, lawnConfig)
    mowed = false
    local playerPed = PlayerPedId()

    for i = #props, 1, -1 do
        local prop = props[i]
        local propCoords = GetEntityCoords(prop)
        local playerCoords = GetEntityCoords(playerPed)
        local dist = #(propCoords - playerCoords)

        if IsPedInAnyVehicle(playerPed, false) and dist < 1.0 then
            DeleteObject(prop)
            SetEntityAsNoLongerNeeded(prop)
            table.remove(props, i)
        end
    end

    if #props == 0 then
        mowed = true
        getPayment(lawnConfig)
    end
end

function lawnMovingLogic(lawnId)
    local lawnIndex = lawnId
    lawnConfig = Config.Lawns[lawnIndex] 
    spawnedProps = {}
    targerMowerId = "lawnmower" .. tostring(math.random(1, 8899923123131))

    target(false, targerMowerId, Config.Locales['drive'], 'E', 'p-jobs:lawnmower:client:mowerCoords', 'client', lawnConfig.lawnMover.targetCoords)

    for _, coords in ipairs(lawnConfig.propCoords) do
        local x, y, z = coords.x, coords.y, coords.z

        lib.requestModel("prop_bush_med_05", 500)

        local prop = CreateObject(GetHashKey("prop_bush_med_05"), x, y, z, false, false, false)
        if DoesEntityExist(prop) then
            PlaceObjectOnGroundProperly(prop)
            table.insert(spawnedProps, prop)
        end
    end

    while #spawnedProps > 0 do
        Wait(500)
        removeCloseProps(spawnedProps, lawnConfig)
    end
end