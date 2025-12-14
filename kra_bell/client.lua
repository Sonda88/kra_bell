local BELLS = (Config and Config.BELLS) or {}
local keyR = 0xE30CD707 -- R
local keyG = 0x760A9C6F -- G
local promptDist = 3.0
local cooldownMs = 4000
local cd = {}

local TIP_SCUOLA   = "The school bell is ringing..."
local TIP_ALLARME  = "City alert!"

CreateThread(function()
    for id,_ in pairs(BELLS) do cd[id] = 0 end

    while true do
        local ped = PlayerPedId()
        local p = GetEntityCoords(ped)
        local now = GetGameTimer()

        for id,b in pairs(BELLS) do
            local dist = #(p - b.coords)
            if dist <= promptDist then
                if now >= (cd[id] or 0) then
                    DrawText3D(b.coords.x, b.coords.y, b.coords.z + 1.0, "[R] School Bell  |  [G] Alarm Bell")
                    if IsControlJustPressed(0, keyR) then
                        cd[id] = now + cooldownMs
                        TriggerServerEvent("campana:ringBell", id, "campana")
                    elseif IsControlJustPressed(0, keyG) then
                        cd[id] = now + cooldownMs
                        TriggerServerEvent("campana:ringBell", id, "campana2")
                    end
                else
                    DrawText3D(b.coords.x, b.coords.y, b.coords.z + 1.0, "The bell is ringing...")
                end
            end
        end

        Wait(0)
    end
end)

RegisterNetEvent("campana:play")
AddEventHandler("campana:play", function(coords, bellType)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local dist = #(playerCoords - coords)
    if dist <= 300.0 then
        local range = 300.0
        local t = dist / range
        local attenuation = (1.0 - t) * (1.0 - t)

        local baseVol = 0.3
        if bellType == "campana2" then baseVol = 0.5 end

        local vol = baseVol * attenuation

        SendNUIMessage({
            action = (bellType == "campana2") and "playDirect2" or "playDirect",
            volume = vol,
            offset = 0
        })

        if bellType == "campana2" then
            TriggerEvent("vorp:TipRight", TIP_ALLARME, 4000)
        else
            TriggerEvent("vorp:TipRight", TIP_SCUOLA, 4000)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    if not onScreen then return end
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    SetTextCentre(true)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), _x, _y)
end
