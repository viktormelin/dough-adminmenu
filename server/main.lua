local QBCore = exports['qbr-core']:GetCoreObject()

local permissions = {
  ['kill'] = 'god',
  ['ban'] = 'admin',
  ['noclip'] = 'admin',
  ['kickall'] = 'admin',
  ['kick'] = 'admin',
  ['time'] = 'god',
  ['weather'] = 'god',
  ['showcoords'] = 'admin',
}

QBCore.Functions.CreateCallback('admin:server:hasperms', function(source, cb, action)
  local src = source
  if QBCore.Functions.HasPermission(src, permissions[action]) or IsPlayerAceAllowed(src, 'command') then
      cb(true)
  else
      cb(false)
  end
end)

QBCore.Functions.CreateCallback('admin:server:getplayers', function(source, cb)
  local src = source
  local players = {}
  for k,v in pairs(QBCore.Functions.GetPlayers()) do 
    local target = GetPlayerPed(v)
    local ped = QBCore.Functions.GetPlayer(v)
    players[#players + 1] = {
      name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | (' .. GetPlayerName(v) .. ')',
      id = v,
      coords = GetEntityCoords(target),
      citizenid = ped.PlayerData.citizenid,
      sources = GetPlayerPed(ped.PlayerData.source),
      sourceplayer = ped.PlayerData.source 
    }
  end

  table.sort(players, function(a, b)
    return a.id < b.id
  end)

  cb(players)
end)

RegisterNetEvent('admin:server:getPlayersForBlips', function()
  local src = source
  local players = {}
  for k,v in pairs(QBCore.Functions.GetPlayers()) do 
    local target = GetPlayerPed(v)
    local ped = QBCore.Functions.GetPlayer(v)
    players[#players + 1] = {
      name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | ' .. GetPlayerName(v),
      id = v,
      coords = GetEntityCoords(target),
      citizenid = ped.PlayerData.citizenid,
      sources = GetPlayerPed(ped.PlayerData.source),
      sourceplayer = ped.PlayerData.source 
    }
  end

  TriggerClientEvent('admin:client:show', src, players)
end)