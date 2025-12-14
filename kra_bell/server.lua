RegisterNetEvent("campana:ringBell")
AddEventHandler("campana:ringBell", function(bellId, bellType)
    local b = Config.BELLS[bellId]
    if not b then return end
    TriggerClientEvent("campana:play", -1, b.coords, bellType)
end)
