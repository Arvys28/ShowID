-- showID.lua

local talkingPlayers = {}

RegisterNetEvent('esx:showID')
AddEventHandler('esx:showID', function(targetPlayer, isTalking)
    if isTalking then
        local targetPed = GetPlayerPed(GetPlayerFromServerId(targetPlayer))

        if DoesEntityExist(targetPed) then
            local x, y, z = table.unpack(GetEntityCoords(targetPed, true))
            local text = '[ID ' .. targetPlayer .. ']'

            DrawText3D(x, y, z + 1.0, text, {0, 0, 255})
        end
    end
end)

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, playerId in ipairs(GetActivePlayers()) do
            local serverId = GetPlayerServerId(playerId)
            local playerPed = GetPlayerPed(playerId)

            if DoesEntityExist(playerPed) then
                local isTalking = NetworkIsPlayerTalking(playerId)
                
                if isTalking then
                    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
                    local text = ' ' .. serverId .. ''

                    DrawText3D(x, y, z + 1.0, text, {18, 90, 203})
                end
            end
        end
    end
end)

RegisterNetEvent('esx:updateTalkingState')
AddEventHandler('esx:updateTalkingState', function(targetPlayer, talkingState)
    talkingPlayers[targetPlayer] = talkingState
    TriggerEvent('esx:showID', targetPlayer, talkingState)
end)
