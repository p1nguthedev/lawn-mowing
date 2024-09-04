local lawns = Config.Lawns

lib.callback.register('p1ngu_lawnmoving_getLawns', function(source)
    local _source = source
    local jobFound = false
    local jobData = nil

    for index, lawn in pairs(lawns) do
        if lawn.inProgress == false then
            lawn.inProgress = true
            jobData = {coords = lawn.propertyOwner.coords, index = index}
            jobFound = true
            break
        end
    end

    if jobFound then
        return jobData
    else
        return false
    end
end)

RegisterNetEvent('give', function(lawn, targetId)
    local src = source
    exports.ox_inventory:AddItem(source, 'money', Config.MoneyAmount)
    TriggerClientEvent('p1ngu_lawnmoving:returnEquiment', src)
end)