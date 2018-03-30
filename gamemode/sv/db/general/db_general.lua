--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString( "db_update_hunger" )
util.AddNetworkString( "db_update_thirst" )
util.AddNetworkString( "db_update_stamina" )
util.AddNetworkString( "db_update_hud" )
util.AddNetworkString( "db_update_inventory" )
util.AddNetworkString( "db_update_clearinventoryondead" )
util.AddNetworkString( "db_update_graffiti" )
util.AddNetworkString( "dbUpdateNWBool2" )
util.AddNetworkString( "db_update_view_distance" )
util.AddNetworkString( "db_update_realistic_damage" )
util.AddNetworkString( "db_update_realistic_falldamage" )
util.AddNetworkString( "db_update_smartphone" )
util.AddNetworkString( "db_update_dealer_immortal" )
util.AddNetworkString( "db_update_weapon_lowering" )
util.AddNetworkString( "db_update_crosshair" )
util.AddNetworkString( "db_update_anti_bhop" )

util.AddNetworkString( "db_update_noclip_crow" )
util.AddNetworkString( "db_update_noclip_tags" )
util.AddNetworkString( "db_update_noclip_stealth" )
util.AddNetworkString( "db_update_noclip_effect" )

util.AddNetworkString( "db_update_collection" )

local _db_name = "yrp_general"

SQL_ADD_COLUMN( _db_name, "name_gamemode", "TEXT DEFAULT 'YourRP'" )
SQL_ADD_COLUMN( _db_name, "name_advert", "TEXT DEFAULT 'Advert'" )
SQL_ADD_COLUMN( _db_name, "time_restart", "TEXT DEFAULT '10'" )
SQL_ADD_COLUMN( _db_name, "access_jail", "TEXT DEFAULT -1" )

SQL_ADD_COLUMN( _db_name, "toggle_metabolism", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_building", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_hunger", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_thirst", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_stamina", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_hud", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_inventory", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_clearinventoryondead", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_graffiti", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "view_distance", "INT DEFAULT 200" )
SQL_ADD_COLUMN( _db_name, "toggle_realistic_damage", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_realistic_falldamage", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "toggle_smartphone", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_dealer_immortal", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "toggle_weapon_lowering", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_crosshair", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_anti_bhop", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "toggle_noclip_crow", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_noclip_stealth", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "toggle_noclip_tags", "INT DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "toggle_noclip_effect", "INT DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "collection", "INT DEFAULT 0" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

if SQL_SELECT( _db_name, "*", "uniqueID = 1" ) == nil then
  SQL_INSERT_INTO_DEFAULTVALUES( _db_name )
end

local _name_advert = ""
function get_advert_name()
  local _tmp = SQL_SELECT( _db_name, "name_advert", nil )
  if _tmp != nil then
    _tmp = _tmp[1]
    _name_advert = _tmp.value
  end
end
get_advert_name()

local yrp_general = {}

local _init_general = SQL_SELECT( _db_name, "*", nil )
if _init_general != false and _init_general != nil then
  yrp_general = _init_general[1]
end

function ServerCollection()
  return tobool( yrp_general.collection )
end

function IsWeaponLoweringEnabled()
  return tobool( yrp_general.toggle_weapon_lowering or false )
end

function IsDealerImmortal()
  return tobool( yrp_general.toggle_dealer_immortal )
end

function IsNoClipEffectEnabled()
  return tobool( yrp_general.toggle_noclip_effect )
end

function IsNoClipStealthEnabled()
  return tobool( yrp_general.toggle_noclip_stealth )
end

function IsNoClipTagsEnabled()
  return tobool( yrp_general.toggle_noclip_tags )
end

function IsNoClipCrowEnabled()
  return tobool( yrp_general.toggle_noclip_crow )
end

function IsRealisticFallDamageEnabled()
  return tobool( yrp_general.toggle_realistic_falldamage )
end

function IsRealisticDamageEnabled()
  return tobool( yrp_general.toggle_realistic_damage )
end

net.Receive( "db_update_anti_bhop", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_anti_bhop = _nw
    SQL_UPDATE( "yrp_general", "toggle_anti_bhop = " .. yrp_general.toggle_anti_bhop, nil )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "anti_bhop", tobool(_nw) )
  end
end)

net.Receive( "db_update_collection", function( len, ply )
  local _nw = tonumber( net.ReadString() )
  if isnumber( _nw ) then
    yrp_general.collection = _nw
    SQL_UPDATE( "yrp_general", "collection = " .. yrp_general.collection, nil )
  end
end)

net.Receive( "db_update_crosshair", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_crosshair = _nw
    SQL_UPDATE( "yrp_general", "toggle_crosshair = " .. yrp_general.toggle_crosshair, nil )
  end
  for i, p in pairs( player.GetAll() ) do
    p:SetNWBool( "yrp_crosshair", tobool(_nw) )
  end
end)

net.Receive( "db_update_weapon_lowering", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_weapon_lowering = _nw
    SQL_UPDATE( "yrp_general", "toggle_weapon_lowering = " .. yrp_general.toggle_weapon_lowering, nil )
  end
end)

net.Receive( "db_update_dealer_immortal", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_dealer_immortal = _nw
    SQL_UPDATE( "yrp_general", "toggle_dealer_immortal = " .. yrp_general.toggle_dealer_immortal, nil )
  end
end)

net.Receive( "db_update_noclip_effect", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_noclip_effect = _nw
    SQL_UPDATE( "yrp_general", "toggle_noclip_effect = " .. yrp_general.toggle_noclip_effect, nil )
  end
end)

net.Receive( "db_update_noclip_crow", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_noclip_crow = _nw
    SQL_UPDATE( "yrp_general", "toggle_noclip_crow = " .. yrp_general.toggle_noclip_crow, nil )
  end
end)

net.Receive( "db_update_noclip_tags", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_noclip_tags = _nw
    SQL_UPDATE( "yrp_general", "toggle_noclip_tags = " .. yrp_general.toggle_noclip_tags, nil )
  end
  for i, ply in pairs( player.GetAll() ) do
    ply:SetNWBool( "show_tags", yrp_general.toggle_noclip_tags )
  end
end)

net.Receive( "db_update_noclip_stealth", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_noclip_stealth = _nw
    SQL_UPDATE( "yrp_general", "toggle_noclip_stealth = " .. yrp_general.toggle_noclip_stealth, nil )
  end
end)

net.Receive( "db_update_smartphone", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_smartphone = _nw
    SQL_UPDATE( "yrp_general", "toggle_smartphone = " .. yrp_general.toggle_smartphone, nil )
  end
  for i, ply in pairs( player.GetAll() ) do
    ply:SetNWBool( "toggle_smartphone", yrp_general.toggle_smartphone )
  end
end)

net.Receive( "db_update_realistic_damage", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_realistic_damage = _nw
    SQL_UPDATE( "yrp_general", "toggle_realistic_damage = " .. yrp_general.toggle_realistic_damage, nil )
  end
end)

net.Receive( "db_update_realistic_falldamage", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    yrp_general.toggle_realistic_falldamage = _nw
    SQL_UPDATE( "yrp_general", "toggle_realistic_falldamage = " .. yrp_general.toggle_realistic_falldamage, nil )
  end
end)

net.Receive( "db_update_graffiti", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_graffiti = " .. _nw_bool, nil )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_graffiti", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_clearinventoryondead", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_clearinventoryondead = " .. _nw_bool, nil )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_clearinventoryondead", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_inventory", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_inventory = " .. 0, nil ) -- LATER _nw_bool, nil )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_inventory", tobool( false ) ) -- LATER _nw_bool ) )
  end
end)

net.Receive( "db_update_hunger", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_hunger = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_hunger", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_thirst", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_thirst = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_thirst", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_stamina", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_stamina = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_stamina", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_hud", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_hud = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_hud", tobool( _nw_bool ) )
  end
end)

net.Receive( "dbUpdateNWBool2", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  SQL_UPDATE( "yrp_general", "toggle_building = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_building", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_view_distance", function( len, ply )
  local _nw_int = tonumber( net.ReadInt( 16 ) )
  SQL_UPDATE( "yrp_general", "view_distance = " .. _nw_int, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. tostring( _nw_int ) )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWInt( "view_distance", _nw_int )
  end
end)

concommand.Add( "yrp_restart", function( ply, cmd, args )
	if ply:IsPlayer() then
		if ply:HasAccess() then
	    printGM( "note", "RESTARTING SERVER by " .. ply:Nick() )
      game.ConsoleCommand( "changelevel " .. db_sql_str2( string.lower( game.GetMap() ) ) .. "\n" )
		else
	    printGM( "note", ply:Nick() .. " tried to restart server!" )
	  end
	else
    printGM( "note", "RESTARTING SERVER by [CONSOLE]" )
    game.ConsoleCommand( "changelevel " .. db_sql_str2( string.lower( game.GetMap() ) ) .. "\n" )
  end
end )

util.AddNetworkString( "updateGeneral" )
util.AddNetworkString( "updateAdvert" )

net.Receive( "updateAdvert", function( len, ply )
  _name_advert = net.ReadString()
  SQL_UPDATE( "yrp_general", "name_advert = '" .. _name_advert .. "'", nil )
  for i, p in pairs( player.GetAll() ) do
    p:SetNWString( "channel_advert", _name_advert )
  end
end)

net.Receive( "getGamemodename", function( len, ply )
  net.Start( "getGamemodename" )
    net.WriteString( GAMEMODE.BaseName )
  net.Send( ply )
end)

net.Receive( "dbGetGeneral", function( len, ply )
  local _tmp = SQL_SELECT( "yrp_general", "*", nil )
  if worked( _tmp, "yrp_general failed @1" ) then
    _tmp = _tmp[1]
    net.Start( "dbGetGeneral" )
      net.WriteTable( _tmp )
    net.Send( ply )
  end
end)

net.Receive( "updateGeneral", function( len, ply )
  local _str = net.ReadString()

  local _result = SQL_UPDATE( "yrp_general", "time_restart = '" .. _str .. "'", nil )
end)
