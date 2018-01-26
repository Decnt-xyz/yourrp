--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local Player = FindMetaTable( "Player" )

function Player:GetPlyTab()
  if SERVER then
    if tostring( self ) != "Player [NULL]" then
      if worked( self:SteamID(), "SteamID fail", true ) then
        local yrp_players = db_select( "yrp_players", "*", "SteamID = '" .. self:SteamID() .. "'" )
        if worked( yrp_players, "GetPlyTab fail", true ) then
          self.plytab = yrp_players[1]
          return self.plytab
        end
      end
    end
  end
  return nil
end

function Player:HasCharacterSelected()
  if SERVER then
    local _ply_tab = self:GetPlyTab()
    if _ply_tab != nil then
      if tostring( _ply_tab.CurrentCharacter ) == "NULL" or _ply_tab.CurrentCharacter == NULL then
        if self.opencharacter == nil then
          open_character_selection( self )
          self.opencharacter = true
        end
        return false
      else
        return true
      end
    end
  end
  return false
end

function Player:GetChaTab()
  if SERVER then
    local _tmp = self:GetPlyTab()
    if self:HasCharacterSelected() then
      local yrp_characters = db_select( "yrp_characters", "*", "uniqueID = " .. _tmp.CurrentCharacter )
      if worked( yrp_characters, "yrp_characters GetChaTab", true ) then
        self.chatab = yrp_characters[1]
        return self.chatab
      end
    end
  end
  if self.chatab != nil then
    return self.chatab
  else
    return nil
  end
end

function Player:GetRolTab()
  if SERVER then
    if self:HasCharacterSelected() then
      local yrp_characters = self:GetChaTab()
      if worked( yrp_characters, "yrp_characters in GetRolTab", true ) then
        if worked( yrp_characters.roleID, "yrp_characters.roleID in GetRolTab", true ) then
          local yrp_roles = db_select( "yrp_roles", "*", "uniqueID = " .. yrp_characters.roleID )
          if worked( yrp_roles, "yrp_roles GetRolTab", true ) then
            self.roltab = yrp_roles[1]
            return self.roltab
          end
        end
      end
    end
  end
  return nil
end

function Player:GetGroTab()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters in GetGroTab", true ) then
      if worked( yrp_characters.groupID, "yrp_characters.groupID in GetGroTab", true ) then
        local yrp_groups = db_select( "yrp_groups", "*", "uniqueID = " .. yrp_characters.groupID )
        if worked( yrp_groups, "yrp_groups GetGroTab", true ) then
          self.grotab = yrp_groups[1]
          return self.grotab
        end
      end
    end
  end
  if self.grotab != nil then
    return self.grotab
  else
    return nil
  end
end

function Player:CharID()
  if SERVER then
    local char = self:GetChaTab()
    if worked( char, "char CharID", true ) then
      self.charid = char.uniqueID
      return self.charid
    end
  end
  if self.charid != nil then
    return self.charid
  else
    return nil
  end
end

function Player:CheckMoney()
  if SERVER then
    timer.Simple( 4, function()
      local _m = self:GetNWString( "money", 0 )
      local _money = tonumber( _m )
      if worked( _money, "ply:money CheckMoney", true ) and self:CharID() != nil then
        db_update( "yrp_characters", "money = '" .. _money .. "'", "uniqueID = " .. self:CharID() ) --attempt to nil value
      end
      _mb = self:GetNWString( "moneybank", 0 )
      local _moneybank = tonumber( _mb )
      if worked( _moneybank, "ply:moneybank CheckMoney", true ) and self:CharID() != nil then
        db_update( "yrp_characters", "moneybank = '" .. _moneybank .. "'", "uniqueID = " .. self:CharID() )
      end
    end)
  end
end

function Player:UpdateMoney()
  if SERVER then
    local money = tonumber( self:GetNWString( "money", 0 ) )
    if worked( money, "ply:money UpdateMoney", true ) then
      db_update( "yrp_characters", "money = '" .. money .. "'", "uniqueID = " .. self:CharID() )
    end
    local moneybank = tonumber( self:GetNWString( "moneybank", 0 ) )
    if worked( moneybank, "ply:moneybank UpdateMoney", true ) then
      db_update( "yrp_characters", "moneybank = '" .. moneybank .. "'", "uniqueID = " .. self:CharID() )
    end
  end
end

function Player:GetPlayerModel()
  if SERVER then
    local yrp_characters = self:GetChaTab()
    if worked( yrp_characters, "yrp_characters (GetPlayerModel)", true ) then
      local pmID = tonumber( yrp_characters.playermodelID )
      local yrp_role = self:GetRolTab()
      local tmp = string.Explode( ",", yrp_role.playermodels )
      local pm = tmp[pmID]

      if pm == "" then
        self.pm = "models/player/skeleton.mdl"
      elseif pm != "" then
        self.pm = pm
      end
      return self.pm
    end
  end
  return nil
end

if SERVER then
  function Player:updateMoney( money )
    self:UpdateMoney()
  end

  function Player:updateMoneyBank( money )
    self:UpdateMoney()
  end

  function Player:addMoney( money )
    if isnumber( money ) then
      self:SetNWString( "money", tonumber( self:GetNWString( "money" ) ) + math.Round( money, 2 ) )
      self:UpdateMoney()
    end
  end

  function Player:SetMoney( money )
    if isnumber( money ) then
      self:SetNWString( "money", math.Round( money, 2 ) )
      self:UpdateMoney()
    end
  end

  function Player:addMoneyBank( money )
    if isnumber( money ) then
      self:SetNWString( "moneybank", tonumber( self:GetNWString( "moneybank" ) ) + math.Round( money, 2 ) )
      self:UpdateMoney()
    end
  end

  function Player:resetUptimeCurrent()
    local _res = db_update( "yrp_players", "uptime_current = " .. 0, "SteamID = '" .. self:SteamID() .. "'" )
  end

  function Player:getuptimecurrent()
    local _ret = db_select( "yrp_players", "uptime_current", "SteamID = '" .. self:SteamID() .. "'" )
    if _ret != nil then
      return tonumber( _ret[1].uptime_current )
    end
    return 0
  end

  function Player:getuptimetotal()
    local _ret = db_select( "yrp_players", "uptime_total", "SteamID = '" .. self:SteamID() .. "'" )
    if _ret != nil then
      return tonumber( _ret[1].uptime_total )
    end
    return 0
  end

  function Player:addSecond()
    local _sec_total = self:getuptimetotal()
    local _sec_current = self:getuptimecurrent()
    if _sec_current != nil and _sec_total != nil then
      local _res = db_update( "yrp_players", "uptime_total = " .. _sec_total + 1 .. ", uptime_current = " .. _sec_current + 1, "SteamID = '" .. self:SteamID() .. "'" )
    end
  end

  function Player:CheckHeal()
    if self:Health() > self:GetNWInt( "preHealth", 0 ) + 5 then
      self:StopBleeding()
    end
    self:SetNWInt( "preHealth", self:Health() )
  end

  function Player:Heal( amount )
    self:SetHealth( self:Health() + amount )
    if self:Health() > self:GetMaxHealth() then
      self:SetHealth( self:GetMaxHealth() )
    end
  end

  function Player:StartBleeding()
    self:SetNWBool( "isbleeding", true )
  end

  function Player:StopBleeding()
    self:SetNWBool( "isbleeding", false )
  end

  function Player:SetBleedingPosition( pos )
    self:SetNWVector( "bleedingpos", pos )
  end
end

function Player:GetBleedingPosition()
  return self:GetNWVector( "bleedingpos", Vector( 0, 0, 0 ) )
end

function Player:IsBleeding()
  return self:GetNWBool( "isbleeding", false )
end

function Player:canAfford( money )
  local _tmpMoney = tonumber( money )
  if isnumber( _tmpMoney ) and self:GetNWString( "money" ) != nil then
    if tonumber( self:GetNWString( "money" ) ) >= math.abs( _tmpMoney ) then
      return true
    else
      return false
    end
  else
    return false
  end
end

function Player:canAffordBank( money )
  local _tmpMoney = tonumber( money )
  if isnumber( _tmpMoney ) then
    if tonumber( self:GetNWString( "moneybank" ) ) >= math.abs( _tmpMoney ) then
      return true
    else
      return false
    end
  end
end

function Player:SteamName()
  return self:GetName()
end

function Player:RPName()
  return self:GetNWString( "rpname", "" )
end

function Player:Nick()
  return self:RPName()
end

function Player:Team()
  return tonumber( self:GetNWString( "groupUniqueID", "-1" ) )
end

timer.Simple( 10, function()
  function team.GetName( index )
    for k, v in pairs( player.GetAll() ) do
      if v:Team() == index then
        return v:GetNWString( "groupName", "NO TEAM" )
      end
    end
    return "FAIL"
  end

  function team.GetColor( index )
    for k, v in pairs( player.GetAll() ) do
      if v:Team() == index then
        local _color = v:GetNWString( "groupColor", "255,0,0" )
        _color = string.Explode( ",", _color )
        return Color( _color[1], _color[2], _color[3] )
      end
      return Color( 255, 0, 0 )
    end
  end
end)

function Player:GetRoleName()
  local _rn = self:GetNWString( "roleName" )
  if _rn != "" then
    return _rn
  else
    return nil
  end
end
