local QBCore = exports['qbr-core']:GetCoreObject()
-- local MenuData = exports['ow-menubase']:GetMenus()

local ShowingCoords = false
local Invisible = false
local Godmode = false

local menuLocation = 'topright'
local menuSize = 'size-125'
local mainMenu = MenuV:CreateMenu(false, Lang:t('menu.admin_menu'), menuLocation, 220, 20, 60, menuSize, 'qbcore', 'menuv', 'test1')
local adminOptions = MenuV:CreateMenu(false, Lang:t('menu.admin_options'), menuLocation, 220, 20, 60, menuSize, 'qbcore', 'menuv', 'test2')
local playerOptions = MenuV:CreateMenu(false, Lang:t('menu.online_players'), menuLocation, 220, 20, 60, menuSize, 'qbcore', 'menuv', 'test3')
local serverOptions = MenuV:CreateMenu(false, Lang:t('menu.manage_server'), menuLocation, 220, 20, 60, menuSize, 'qbcore', 'menuv', 'test4')

local mainMenu_button1 = mainMenu:AddButton({
  icon = '😀',
  label = Lang:t('menu.admin_options'),
  value = adminOptions,
  description = Lang:t('desc.admin_options_desc')
})
local mainMenu_button2 = mainMenu:AddButton({
  icon = '👨‍👩‍👧',
  label = Lang:t('menu.online_players'),
  value = playerOptions,
  description = Lang:t('desc.player_management_desc')
})
local mainMenu_button3 = mainMenu:AddButton({
  icon = '🌍',
  label = Lang:t('menu.manage_server'),
  value = serverOptions,
  description = Lang:t('desc.server_management_desc')
})

adminOptions:On('open', function(menu)
  menu:ClearItems()
  menu:AddButton({
    icon = '🍪',
    label = Lang:t('menu.noclip'),
    select = function()
      TriggerServerEvent('qbr-logs:server:CreateLog', 'admin', 'Admin Options', 'red', GetPlayerName() .. ' toggled > NOCLIP <')
      ToggleNoclip()
    end
  })
  menu:AddButton({
    icon = '🍪',
    label = Lang:t('menu.display_coords'),
    select = function()
      TriggerServerEvent('qbr-logs:server:CreateLog', 'admin', 'Admin Options', 'red', GetPlayerName() .. ' > REVIVED SELF <')
      ToggleShowCoordinates()
    end
  })
  menu:AddButton({
    icon = '🍪',
    label = Lang:t('menu.tpm'),
    select = function()
      TriggerServerEvent('qbr-logs:server:CreateLog', 'admin', 'Admin Options', 'red', GetPlayerName() .. ' > REVIVED SELF <')
      GotoMarker()
    end
  })
  menu:AddButton({
    icon = '🍪',
    label = Lang:t('menu.revive'),
    select = function()
      TriggerServerEvent('qbr-logs:server:CreateLog', 'admin', 'Admin Options', 'red', GetPlayerName() .. ' > REVIVED SELF <')
      RevivePlayer()
    end
  })
  menu:AddButton({
    icon = '🍪',
    label = Lang:t('menu.invisible'),
    select = function()
      TriggerServerEvent('qbr-logs:server:CreateLog', 'admin', 'Admin Options', 'red', GetPlayerName() .. ' toggled > INVISIBILITY <')
      if Invisible then  
        SetEntityVisible(PlayerPedId(), true)
        Invisible = false
      else
        SetEntityVisible(PlayerPedId(), false)
        Invisible = true
      end
    end
  })
  menu:AddButton({
    icon = '🍪',
    label = Lang:t('menu.god'),
    select = function()
      Godmode = not Godmode
      TriggerServerEvent('qbr-logs:server:CreateLog', 'admin', 'Admin Options', 'red', GetPlayerName() .. ' toggled > GODMODE <')
      if Godmode then 
        while Godmode do 
          Wait(0)
          SetPlayerInvincible(PlayerPedId(), true)
        end

        SetPlayerInvincible(PlayerPedId(), false)
      end
    end
  })
  menu:AddButton({
    icon = '🍪',
    label = Lang:t('menu.names'),
    select = function()
      TriggerServerEvent('qbr-logs:server:CreateLog', 'admin', 'Admin Options', 'red', GetPlayerName() .. ' toggled > NOCLIP <')
      ToggleNoclip()
    end
  })
end)

playerOptions:On('open', function(menu)
  menu:ClearItems()
  QBCore.Functions.TriggerCallback('admin:server:getplayers', function(players)
    
  end)
  menu:AddButton({
    icon = '🍪',
    label = Lang:t('menu.noclip'),
    select = function()
      TriggerServerEvent('qbr-logs:server:CreateLog', 'admin', 'Admin Options', 'red', GetPlayerName() .. ' toggled > NOCLIP <')
      ToggleNoclip()
    end
  })
end)

ToggleShowCoordinates = function()
  ShowingCoords = not ShowingCoords
  CreateThread(function()
    while ShowingCoords do 
      local coords = GetEntityCoords(PlayerPedId())
      local heading = GetEntityHeading(PlayerPedId())
      local c = {}
      c.x = round(coords.x, 2)
      c.y = round(coords.y, 2)
      c.z = round(coords.z, 2)
      c.w = round(heading, 2)
      Wait(0)
      DrawScreenText(string.format('~w~COORDS: ~b~vector4(~w~%s~b~, ~w~%s~b~, ~w~%s~b~, ~w~%s~b~)', c.x, c.y, c.z, c.w), 0.4, 0.025, true)
    end
  end)
end

RevivePlayer = function()
  local ped = PlayerPedId()
  local pos = GetEntityCoords(ped)
  print(pos)
  NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, GetEntityHeading(ped), true, false)
  SetEntityInvincible(ped, false)
  SetEntityMaxHealth(ped, 200)
  SetEntityHealth(ped, 200)
  ClearPedBloodDamage(ped)
  TriggerServerEvent('hud:server:RelieveStress', 100)
  QBCore.Functions.Notify(Lang:t('info.health'))
end

ToggleNoclip = function()
  TriggerEvent('admin:client:ToggleNoClip')
end

GotoCoords = function(coords)
  if type(coords) ~= 'vector3' then 
    QBCore.Functions.Notify(Lang:t('error.invalid_coords'))
  end

  local x = coords[1]
  local y = coords[2]
  local z = coords[3]
  local ped = PlayerPedId()

  DoScreenFadeOut(500)
  while not IsScreenFadedOut() do 
    Wait(0)
  end

  SetEntityCoords(ped, x, y, 100.0)
  -- while IsEntityWaitingForWorldCollision(ped) do 
  --   Wait(100)
  -- end

  if z == 0 then 
    local _finalZ
    local delay = 500
    for i = 1, 5 do 
      if _finalZ ~= nil then 
        break 
      end

      _finalZ = findZ(x, y)
      if _z == nil then 
        Wait(delay)
      end
    end

    if _finalZ ~= nil then 
      z = _finalZ
    end
  end

  SetEntityCoords(ped, x, y, z)
  DoScreenFadeIn(500)
  -- SetGameplayCamRelativeHeading(0)
end

GotoMarker = function()
  local waypoint = GetWaypointCoords()
  print(waypoint)
  if waypoint.x ~= 0 and waypoint.y ~= 0 then 
    GotoCoords(vec3(waypoint.x, waypoint.y, 0))
  else
    QBCore.Functions.Notify(Lang:t('error.invalid_coords'))
  end
end

round = function(input, decimalPlaces)
  return tonumber(string.format('%.' .. (decimalPlaces or 0) .. 'f', input))
end

findZ = function(x, y)
  local found = true 
  local start_z = 1500
  local z = start_z

  while found and z > 0 do
    local _found, _z, _normal = GetGroundZAndNormalFor_3dCoord(x, y, z + 0.0)
    if _found then
        z = _z + 0.0
    end
    found = _found
    Wait(0)
  end

  if z == start_z then 
    return nil 
  end

  return z + 0.0
end

DrawScreenText = function(text, x, y, centred)
  SetTextScale(0.35, 0.35)
	SetTextColor(255, 255, 255, 255)
	SetTextCentre(centred)
	SetTextDropshadow(1, 0, 0, 0, 200)
	SetTextFontForCurrentCommand(0)
	DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end

RegisterCommand('admin', function(source, args, rawCommand)
  MenuV:OpenMenu(mainMenu)
end)