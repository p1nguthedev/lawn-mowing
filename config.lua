Config = {}

Config.UseCarRentPayment = false
Config.Target = 'p1ngu'
Config.MoneyAmount = math.random(300, 1000)

Config.JobStart = {
    ped = 'a_m_m_farmer_01',
    coords = vector4(-643.3781, -1227.9087, 10.5476, 308.1917),
    vehicleCoords = vector4(-639.1299, -1223.5825, 11.5268, 117.0427),
    trailerCoords = vector4(-634.5522, -1221.2506, 12.0433, 117.6323),
    mowerCoords = vector4(-632.2238, -1219.7700, 12.8932, 19.6116),
    deleteVehicleCoords = vector3(-645.3220, -1214.5380, 11.3532)
}

Config.Lawns = {
    [1] = { 
        propertyOwner = {
            coords = vector4(877.6001, -505.6854, 56.4925, 227.1398),
            ped = 'a_m_m_farmer_01'
        },
        lawnMover = {
            setOnLawnCoords = vector4(879.3566, -506.2141, 56.4864, 303.1594),
            targetCoords = vector3(877.5884, -507.3121, 57.4340)
        },
        inProgress = false,
        propCoords = {
            vector3(881.1562, -504.9047, 56.4524),
            vector3(882.3958, -503.7226, 56.4623),
            vector3(883.7775, -504.2050, 56.4811),
            vector3(884.3104, -503.2042, 56.5132),
            vector3(883.5337, -501.9886, 56.5152),
            vector3(884.2996, -500.4169, 56.5684),
            vector3(885.5294, -501.0966, 56.5975),
            vector3(886.7278, -502.5226, 56.5565),
            vector3(888.3235, -501.9505, 56.6085),
            vector3(887.7683, -500.3767, 56.6583),
            vector3(886.8579, -499.3337, 56.6515),
            vector3(886.5735, -497.5571, 56.6664),
            vector3(888.8856, -499.3672, 56.6977),
            vector3(890.2365, -500.7107, 56.6994),
            vector3(892.1236, -501.1064, 56.7795),
            vector3(891.9719, -499.1978, 56.8027),
            vector3(890.6861, -497.2427, 56.7925),
            vector3(888.9434, -496.5205, 56.7474)
        }
    },
    [2] = { 
        propertyOwner = {
            coords = vector4(877.6001, -505.6854, 56.4925, 227.1398),
            ped = 'a_m_m_farmer_01'
        },
        lawnMover = {
            setOnLawnCoords = vector4(879.3566, -506.2141, 56.4864, 303.1594),
            targetCoords = vector3(877.5884, -507.3121, 57.4340)
        },
        inProgress = false,
        propCoords = {
            vector3(881.1562, -504.9047, 56.4524),
            vector3(882.3958, -503.7226, 56.4623),
            vector3(883.7775, -504.2050, 56.4811),
            vector3(884.3104, -503.2042, 56.5132),
            vector3(883.5337, -501.9886, 56.5152),
            vector3(884.2996, -500.4169, 56.5684),
            vector3(885.5294, -501.0966, 56.5975),
            vector3(886.7278, -502.5226, 56.5565),
            vector3(888.3235, -501.9505, 56.6085),
            vector3(887.7683, -500.3767, 56.6583),
            vector3(886.8579, -499.3337, 56.6515),
            vector3(886.5735, -497.5571, 56.6664),
            vector3(888.8856, -499.3672, 56.6977),
            vector3(890.2365, -500.7107, 56.6994),
            vector3(892.1236, -501.1064, 56.7795),
            vector3(891.9719, -499.1978, 56.8027),
            vector3(890.6861, -497.2427, 56.7925),
            vector3(888.9434, -496.5205, 56.7474)
        }
    }
}

function Notify(title, description, type)
    lib.notify({
        title = title,
        description = description,
        type = type
    })
end

function target(remove, id, text, key, event, eventType, coords, distance, type)
    distance = distance or 3.0
    if not remove then
        exports['p-interaction']:AddInteraction(
            id,
            vector3(coords.x, coords.y, coords.z + 1.0),
            distance,
            eventType,
            event,
            key,
            text
        )
    elseif remove then
        exports['p-interaction']:RemoveInteraction(id)
    end
end




Config.Locales = {
    ['blip'] = "Customer",
    ['blip_return'] = "Return Equipment",
    ['start_talking'] = "Talk",
    ['set_mower_on_trailer'] = "Set On Trailer",
    ['collect_rewards'] = "Collect pay",
    ['drive'] = "Drive",
    ['end_job'] = "Delete and end job"
}