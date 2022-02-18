local QBCore = exports['qbr-core']:GetCoreObject()
local ShowBlips = false
local ShowNames = false
local NetCheck1 = false
local NetCheck2 = false

CreateThread(function()
  while true do
      Wait(1000)
      if NetCheck1 or NetCheck2 then
        TriggerServerEvent('admin:server:GetPlayersForBlips')
      end
  end
end)

RegisterNetEvent('admin:client:toggleNames', function()
  if not ShowNames then
    ShowNames = true
    NetCheck2 = true
    QBCore.Functions.Notify(Lang:t("success.names_activated"), "success")
  else
    ShowNames = false
    QBCore.Functions.Notify(Lang:t("error.names_deactivated"), "error")
  end
end)

RegisterNetEvent('admin:client:show', function(players)
  for k,v in pairs(players) do 
    local playeridx = GetPlayerFromServerId(v.id)
    local ped = GetPlayerPed(playeridx)
    local blip = GetBlipFromEntity(ped)
    local name = 'ID: ' .. v.id .. ' | ' .. v.name 

    local Tag = CreateFakeMpGamerTag(ped, name, false, false, "", false)
    SetMpGamerTagAlpha(Tag, 0, 255) 
    SetMpGamerTagAlpha(Tag, 2, 255) 
    SetMpGamerTagAlpha(Tag, 4, 255)
    SetMpGamerTagAlpha(Tag, 6, 255)
    SetMpGamerTagHealthBarColour(Tag, 25)

    if ShowNames then 
      SetMpGamerTagVisibility(Tag, 0, true) -- Activates the player ID Char name and FiveM name
      SetMpGamerTagVisibility(Tag, 2, true) -- Activates the health (and armor if they have it on) bar below the player names
      if NetworkIsPlayerTalking(playeridx) then
        SetMpGamerTagVisibility(Tag, 4, true) -- If player is talking a voice icon will show up on the left side of the name
      else
        SetMpGamerTagVisibility(Tag, 4, false)
      end
      if GetPlayerInvincible(playeridx) then
        SetMpGamerTagVisibility(Tag, 6, true) -- If player is in godmode a circle with a line through it will show up
      else
        SetMpGamerTagVisibility(Tag, 6, false)
      end
    else
      SetMpGamerTagVisibility(Tag, 0, false)
      SetMpGamerTagVisibility(Tag, 2, false)
      SetMpGamerTagVisibility(Tag, 4, false)
      SetMpGamerTagVisibility(Tag, 6, false)
      RemoveMpGamerTag(Tag) -- Unloads the tags till you activate it again
      NetCheck2 = false
    end
  end 
end)