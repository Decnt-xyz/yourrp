--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_charakter.lua

function createMDBox( derma, parent, w, h, x, y, height, color )
  local tmpMD = vgui.Create( derma, parent )
  tmpMD:SetSize( w+height, h+height )
  tmpMD:SetPos( x, y )
  function tmpMD:Paint( pw, ph )
    --shadow
    draw.RoundedBox( 0, height, height, pw-height, ph-height, Color( 0, 0, 0, 100 ) )

    --Box
    draw.RoundedBox( 0, 0, 0, pw-height, ph-height, color )
  end
  return tmpMD
end

colors = {}
colors.selected = Color( 225, 225, 0, 255 )
colors.hovered = Color( 0, 255, 0, 255 )

function createMDPlus( parent, size, x, y, height )
  local w = size
  local h = w
  local tmpMD = vgui.Create( "DButton", parent )
  tmpMD:SetSize( w+height, h+height )
  tmpMD:SetPos( x, y )
  function tmpMD:Paint( pw, ph )
    --shadow
    draw.RoundedBox( pw-height/2, height, height, pw-height, ph-height, Color( 0, 0, 0, 100 ) )

    --Button
    if tmpMD:IsHovered() then
      draw.RoundedBox( pw-height, 0, 0, pw-height, ph-height, yrp.colors.dsecondaryH  )
    else
      draw.RoundedBox( pw-height, 0, 0, pw-height, ph-height, yrp.colors.dsecondary )
    end

    draw.SimpleText( "+", "HudBars", (pw-height)/2, (ph-height)/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  return tmpMD
end

function createMDButton( parent, w, h, x, y, height, text )
  local tmpMD = vgui.Create( "DButton", parent )
  tmpMD:SetText( "" )
  tmpMD:SetSize( w+height, h+height )
  tmpMD:SetPos( x, y )
  function tmpMD:Paint( pw, ph )
    --shadow
    draw.RoundedBox( 0, height, height, pw-height, ph-height, Color( 0, 0, 0, 100 ) )

    --Button
    if tmpMD:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw-height, ph-height, yrp.colors.dsecondary )
    else
      draw.RoundedBox( 0, 0, 0, pw-height, ph-height, yrp.colors.dprimary )
    end

    draw.SimpleText( text, "HudBars", (pw-height)/2, (ph-height)/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  return tmpMD
end

function createMD( derma, parent, w, h, x, y, height )
  local tmpShadow = vgui.Create( "DPanel", parent )
  tmpShadow:SetSize( w, h )
  tmpShadow:SetPos( x+height, y+height )
  function tmpShadow:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 100 ) )
  end

  local tmpD = vgui.Create( derma, parent )
  tmpD:SetSize( w, h )
  tmpD:SetPos( x, y )
  tmpD.shadow = tmpShadow
  return tmpD
end

function createD( derma, parent, w, h, x, y )
  local tmpD = vgui.Create( derma, parent )
  tmpD:SetSize( w, h )
  tmpD:SetPos( x, y )
  return tmpD
end

function paintMD( w, h, string, color )
  if string == nil then
    string = ""
  end
  draw.RoundedBox( 0, 0, 0, w, h, color )
  draw.SimpleText( string, "HudBars", w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

local character = {}
character.amount = 0

function openCharacterCreation()
  _menuIsOpen = 1
  local ply = LocalPlayer()
  character.cause = lang.enteraname
  character.rpname = ""
  character.gender = "male"
  character.groupID = 1
  character.roleID = 1
  character.hp = 0
  character.hpmax = 0
  character.ar = 0
  character.armax = 0
  character.capital = 0
  character.playermodels = {}
  character.playermodelID = 1
  character.skin = 1

  character.description = {}
  for i = 1, 6 do
    character.description[i] = ""
  end

  local frame = createD( "DFrame", nil, ScrW(), ScrH(), 0, 0 )
  frame:SetTitle( "" )
  frame:ShowCloseButton( false )
  frame:SetDraggable( false )
  frame:Center()
  function frame:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 250 ) )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 250 ) )

    draw.SimpleText( lang.charactercreation, "HudHeader", pw/2, ctr( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local identification = createD( "DPanel", frame, ctr( 800 ), ctr( 360 ), ScrW() - ctr( 800 ) - ctr( 100 ), ScrH() - ctr( 400 ) - ctr( 100 ) )
  function identification:Paint( pw, ph )
    draw.RoundedBox( ctr( 15 ), 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )

    draw.SimpleText( lang.identifycard, "charText", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    draw.SimpleText( GetHostName(), "charText", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.SimpleText( ply:SteamID(), "charText", pw - ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

    draw.SimpleText( lang.name, "charText", ctr( 256 + 20 ), ctr( 130 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( character.rpname, "charText", ctr( 256 + 20 ), ctr( 130 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

    draw.SimpleText( lang.gender, "charText", ctr( 256 + 20 ), ctr( 220 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( character.gender, "charText", ctr( 256 + 20 ), ctr( 220 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

  end
  local avatar = createD( "AvatarImage", identification, ctr( 256 ), ctr( 256 ), ctr( 10 ), ctr( 360 - 10 - 256 ) )
  avatar:SetPlayer( ply )

  local border = ctr( 50 )
  local charactersBackground = createMD( "DPanel", frame, ctr( 800 ), ScrH() - (2*border), border, border, ctr( 5 ) )
  function charactersBackground:Paint( pw, ph )
    paintMD( pw, ph, nil, yrp.colors.dprimary )
  end

  border = ctr( 20 )
  local data = {}
  data.w = ctr( 800 ) - 2*border
  data.h = ctr( 200 )
  data.x = border
  data.y = border
  local charactersGender = createMD( "DPanel", charactersBackground, data.w, data.h, data.x, data.y, ctr( 5 ) )
  function charactersGender:Paint( pw, ph )
    paintMD( pw, ph, nil, yrp.colors.dsecondary )
    draw.SimpleText( lang.gender, "HudBars", pw/2, ctr( 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local charactersGenderMale = createMD( "DButton", charactersGender, ctr( 100 ), ctr( 100 ), ctr( (760/2)-105 ), ctr( 70 ), ctr( 5 ) )
  charactersGenderMale:SetText( "" )
  function charactersGenderMale:Paint( pw, ph )
    if self:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, colors.hovered )
    else
      if character.gender == "male" then
        draw.RoundedBox( 0, 0, 0, pw, ph, colors.selected )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.dsecondaryH )
      end
    end
    draw.SimpleText( "♂", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function charactersGenderMale:DoClick()
    character.gender = "male"
  end

  local charactersGenderFemale = createMD( "DButton", charactersGender, ctr( 100 ), ctr( 100 ), ctr( (760/2)+5 ), ctr( 70 ), ctr( 5 ) )
  charactersGenderFemale:SetText( "" )
  function charactersGenderFemale:Paint( pw, ph )
    if self:IsHovered() then
      draw.RoundedBox( 0, 0, 0, pw, ph, colors.hovered )
    else
      if character.gender == "female" then
        draw.RoundedBox( 0, 0, 0, pw, ph, colors.selected )
      else
        draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.dsecondaryH )
      end
    end
    draw.SimpleText( "♀", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function charactersGenderFemale:DoClick()
    character.gender = "female"
  end

  data.x = border
  data.y = data.y + data.h + border
  data.w = ctr( 800 ) - 2*border
  data.h = ctr( 140 )
  local charactersGroup = createMD( "DPanel", charactersBackground, data.w, data.h, data.x, data.y, ctr( 5 ) )
  function charactersGroup:Paint( pw, ph )
    paintMD( pw, ph, nil, yrp.colors.dsecondary )
    draw.SimpleText( lang.group, "HudBars", pw/2, ctr( 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  local charactersGroupCB = createMD( "DComboBox", charactersGroup, ctr( 600 ), ctr( 50 ), ctr( (760-600)/2 ), ctr( 70 ), ctr( 5 ) )
  net.Start( "charGetGroups" )
  net.SendToServer()
  net.Receive( "charGetGroups", function( len )
    local tmpTable = net.ReadTable()
    for k, v in pairs( tmpTable ) do
      local selectChoice = false
      if tonumber( v.uniqueID ) == tonumber( character.groupID ) then
        selectChoice = true
      end
      charactersGroupCB:AddChoice( v.groupID, v.uniqueID, selectChoice )
    end
  end)
  function charactersGroupCB:OnSelect( index, value, data  )
  	character.groupID = tonumber( data )
    net.Start( "charGetRoles" )
      net.WriteString( character.groupID )
    net.SendToServer()
  end

  data.x = border
  data.y = data.y + data.h + border
  data.w = ctr( 800 ) - 2*border
  data.h = ctr( 740 )
  local charactersRole = createMD( "DPanel", charactersBackground, data.w, data.h, data.x, data.y, ctr( 5 ) )
  function charactersRole:Paint( pw, ph )
    paintMD( pw, ph, nil, yrp.colors.dsecondary )
    draw.SimpleText( lang.role, "HudBars", pw/2, ctr( 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( lang.rolehealth .. ": " .. character.hp .. "/" .. character.hpmax, "HudBars", ctr( 10 ), ctr( 160 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( lang.rolearmor .. ": " .. character.ar .. "/" .. character.armax, "HudBars", ctr( 10 ), ctr( 220 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( lang.rolesalary .. ": " .. character.capital, "HudBars", ctr( 10 ), ctr( 280 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( lang.roledescription .. ":", "HudBars", ctr( 10 ), ctr( 340 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( character.description[1], "HudBars", ctr( 10 ), ctr( 400 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( character.description[2] , "HudBars", ctr( 10 ), ctr( 460 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( character.description[3], "HudBars", ctr( 10 ), ctr( 520 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( character.description[4], "HudBars", ctr( 10 ), ctr( 580 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( character.description[5], "HudBars", ctr( 10 ), ctr( 640 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( character.description[6], "HudBars", ctr( 10 ), ctr( 700 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  end

  local characterPlayermodel = createMD( "DModelPanel", frame, ctr( 1600 ), ctr( 2160 ), ScrW2() - ctr( 1600/2 ), ScrH2() - ctr( 2160/2 ), ctr( 5 ) )
  characterPlayermodel.bodygroups = {}
  characterPlayermodel.cache = {}

  data.x = border
  data.y = data.y + data.h + border
  data.w = ctr( 800 ) - 2*border
  data.h = ctr( 740 )
  local charactersBodygroups = createMD( "DPanel", charactersBackground, data.w, data.h, data.x, data.y, ctr( 5 ) )
  function charactersBodygroups:Paint( pw, ph )
    paintMD( pw, ph, nil, yrp.colors.dsecondary )
    draw.SimpleText( lang.appearance, "HudBars", pw/2, ctr( 30 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    if characterPlayermodel.skin != nil then
      draw.SimpleText( lang.skin .. ": " .. characterPlayermodel.skin+1 .. "/" .. characterPlayermodel.skinmax+1, "HudBars", ctr( 80 ), ctr( 110 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end
  end

  character.bg = {}
  for i=1, 6 do
    character.bg[i] = 0
  end

  function characterPlayermodel:UpdateBodyGroups()
    self.skin = 0
    self.skinmax = characterPlayermodel.Entity:SkinCount() - 1
    self.bodygroups = characterPlayermodel.Entity:GetBodyGroups()

    for k, v in pairs( self.cache ) do
      v:Remove()
    end
    for k, v in pairs( self.bodygroups ) do
      if k > 1 then
        self.cache[k] = createD( "DPanel", charactersBodygroups, ctr( 600 ), ctr( 100 ), ctr( 10 ), ctr( 200 + (k-2)*110 ) )
        local tmp = self.cache[k]
        tmp.count = 0
        tmp.countmax = v.num
        function tmp:Paint( pw, ph )
          draw.SimpleText( v.name .. ": " .. self.count+1 .. "/" .. self.countmax, "HudBars", ctr( 80 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end
        local tmpUp = createD( "DButton", tmp, ctr( 50 ), ctr( 50 ), ctr( 0 ), ctr( 0 ) )
        tmpUp:SetText( "" )
        function tmpUp:Paint( pw, ph )
          local color = Color( 100, 100, 100, 100 )
          if tmp.count < tmp.countmax-1 then
            color = Color( 255, 255, 255, 255 )
          end
          draw.RoundedBox( 0, 0, 0, pw, ph, color )
          draw.SimpleText( "↑", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        function tmpUp:DoClick()
          if tmp.count < tmp.countmax-1 then
            tmp.count = tmp.count + 1
          end
          v.value = tmp.count
          characterPlayermodel.bodygroups[v.id] = v.value
          character.bg[k] = v.value
          characterPlayermodel.Entity:SetBodygroup( v.id, v.value )
        end
        local tmpDown = createD( "DButton", tmp, ctr( 50 ), ctr( 50 ), ctr( 0 ), ctr( 50 ) )
        tmpDown:SetText( "" )
        function tmpDown:Paint( pw, ph )
          local color = Color( 100, 100, 100, 100 )
          if tmp.count > 0 then
            color = Color( 255, 255, 255, 255 )
          end
          draw.RoundedBox( 0, 0, 0, pw, ph, color )
          draw.SimpleText( "↓", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        function tmpDown:DoClick()
          if tmp.count > 0 then
            tmp.count = tmp.count - 1
          end
          v.value = tmp.count
          characterPlayermodel.bodygroups[v.id] = v.value
          character.bg[k] = v.value
          characterPlayermodel.Entity:SetBodygroup( v.id, v.value )
        end
      end
    end
  end
  if character.playermodels[tonumber( character.playermodelID )] != nil then
    characterPlayermodel:SetModel( character.playermodels[tonumber( character.playermodelID )] )
    characterPlayermodel:UpdateBodyGroups()
  end
  function characterPlayermodel:LayoutEntity( Entity ) return end

  local turnR = createD( "DButton", frame, ctr( 100 ), ctr( 100 ), ScrW()/2 + ctr( -50 + 150 ), ScrH() - ctr( 300 ) )
  turnR:SetText( "" )
  function turnR:Paint( pw, ph )
    if self:IsHovered() then
      if self:IsDown() then
        if characterPlayermodel.Entity != nil then
          characterPlayermodel.Entity:SetAngles( characterPlayermodel.Entity:GetAngles() + Angle( 0, 1, 0 ) )
        end
      end
      paintMD( pw, ph, "->", yrp.colors.dsecondaryH )
    else
      paintMD( pw, ph, "->", yrp.colors.dsecondary )
    end
  end

  local turnL = createD( "DButton", frame, ctr( 100 ), ctr( 100 ), ScrW()/2 - ctr( 50 + 150 ), ScrH() - ctr( 300 ) )
  turnL:SetText( "" )
  function turnL:Paint( pw, ph )
    if self:IsHovered() then
      if self:IsDown() then
        if characterPlayermodel.Entity != nil then
          characterPlayermodel.Entity:SetAngles( characterPlayermodel.Entity:GetAngles() - Angle( 0, 1, 0 ) )
        end
      end
      paintMD( pw, ph, "<-", yrp.colors.dsecondaryH )
    else
      paintMD( pw, ph, "<-", yrp.colors.dsecondary )
    end
  end

  local prevPM = createD( "DButton", frame, ctr( 100 ), ctr( 1200 ), ScrW()/2 - ctr( 50 + 800 ), ScrH() - ctr( 1800 ) )
  prevPM:SetText( "" )
  function prevPM:Paint( pw, ph )
    if tonumber( character.playermodelID ) > 1 then
      if self:IsHovered() then
        paintMD( pw, ph, "<", yrp.colors.dsecondaryH )
      else
        paintMD( pw, ph, "<", yrp.colors.dsecondary )
      end
    end
  end
  function prevPM:DoClick()
    character.playermodelID = character.playermodelID - 1
    if tonumber( character.playermodelID ) < 1 then
      character.playermodelID = 1
    end
    characterPlayermodel:SetModel( character.playermodels[tonumber( character.playermodelID )] )
    characterPlayermodel:UpdateBodyGroups()
  end

  local nextPM = createD( "DButton", frame, ctr( 100 ), ctr( 1200 ), ScrW()/2 + ctr( -50 + 800 ), ScrH() - ctr( 1800 ) )
  nextPM:SetText( "" )
  function nextPM:Paint( pw, ph )
    if tonumber( character.playermodelID ) < #character.playermodels then
      if self:IsHovered() then
        paintMD( pw, ph, ">", yrp.colors.dsecondaryH )
      else
        paintMD( pw, ph, ">", yrp.colors.dsecondary )
      end
    end
  end
  function nextPM:DoClick()
    character.playermodelID = character.playermodelID + 1
    if tonumber( character.playermodelID ) > #character.playermodels then
      character.playermodelID = #character.playermodels
    end
    characterPlayermodel:SetModel( character.playermodels[tonumber( character.playermodelID )] )
    characterPlayermodel:UpdateBodyGroups()
  end

  local charactersRoleCB = createMD( "DComboBox", charactersRole, ctr( 600 ), ctr( 50 ), ctr( (760-600)/2 ), ctr( 70 ), ctr( 5 ) )
  net.Receive( "charGetRoles", function( len )
    charactersRoleCB:Clear()
    local tmpTable = net.ReadTable()
    for k, v in pairs( tmpTable ) do
      local selectChoice = false
      if tonumber( v.uniqueID ) == tonumber( character.roleID ) then
        selectChoice = true
      end
      charactersRoleCB:AddChoice( v.roleID, v.uniqueID, selectChoice )
    end
  end)
  function charactersRoleCB:OnSelect( index, value, data  )
  	character.roleID = tonumber( data )
    net.Start( "charGetRoleInfo" )
      net.WriteString( character.roleID )
    net.SendToServer()

    net.Receive( "charGetRoleInfo", function( len )
      local tmpTable = net.ReadTable()
      character.hp = tmpTable[1].hp
      character.hpmax = tmpTable[1].hpmax
      character.ar = tmpTable[1].ar
      character.armax = tmpTable[1].armax
      character.capital = tmpTable[1].capital
      character.playermodels = string.Explode( ",", tmpTable[1].playermodels )
      character.playermodelID = 1
      if character.playermodels[tonumber( character.playermodelID )] != nil then
        characterPlayermodel:SetModel( character.playermodels[tonumber( character.playermodelID )] )
        characterPlayermodel:UpdateBodyGroups()
      end
    end)
  end

  local skinUp = createD( "DButton", charactersBodygroups, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 60 ) )
  skinUp:SetText( "↑" )
  function skinUp:Paint( pw, ph )
    local color = Color( 100, 100, 100, 100 )
    if characterPlayermodel.Entity != nil then
      if characterPlayermodel.Entity:SkinCount()-1 > characterPlayermodel.Entity:GetSkin() then
        color = Color( 255, 255, 255, 255 )
      end
    end
    draw.RoundedBox( 0, 0, 0, pw, ph, color )
    draw.SimpleText( "↑", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function skinUp:DoClick()
    if characterPlayermodel.Entity:SkinCount()-1 > characterPlayermodel.Entity:GetSkin() then
      characterPlayermodel.skin = characterPlayermodel.skin + 1
    end
    character.skin = characterPlayermodel.skin
    characterPlayermodel.Entity:SetSkin( characterPlayermodel.skin )
  end

  local skinDo = createD( "DButton", charactersBodygroups, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 110 ) )
  skinDo:SetText( "↓" )
  function skinDo:Paint( pw, ph )
    local color = Color( 100, 100, 100, 100 )
    if characterPlayermodel.Entity != nil then
      if characterPlayermodel.Entity:GetSkin() > 0 then
        color = Color( 255, 255, 255, 255 )
      end
    end
    draw.RoundedBox( 0, 0, 0, pw, ph, color )
    draw.SimpleText( "↓", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function skinDo:DoClick()
    if characterPlayermodel.Entity:GetSkin() > 0 then
      characterPlayermodel.skin = characterPlayermodel.skin - 1
    end
    character.skin = characterPlayermodel.skin
    characterPlayermodel.Entity:SetSkin( characterPlayermodel.skin )
  end

  local charactersNameText = createMD( "DTextEntry", frame, ctr( 600 ), ctr( 100 ), ScrW2() - ctr( 600/2 ), ScrH() - ctr( 100+50 ), ctr( 5 ) )
  charactersNameText:SetText( character.rpname )
  function charactersNameText:OnTextChanged()
    character.rpname = charactersNameText:GetValue()
  end

  ChangeLanguage( frame, ctr( 400 ), ctr( 100 ), ScrW() - ctr( 400 + 100 ), ctr( 100 ) )

  if character.amount > 0 then
    local button = {}
    button.w = ctr( 400 )
    button.h = ctr( 100 )
    button.x = ScrW2() - ctr( 400 + 300 + 50 )
    button.y = ScrH() - ctr( 100+50 )
    local charactersBack = createMD( "DButton", frame, button.w, button.h, button.x, button.y, ctr( 10 ) )
    charactersBack:SetText( "" )
    function charactersBack:Paint( pw, ph )
      paintMD( pw, ph, lang.back, yrp.colors.dsecondary )
    end
    function charactersBack:DoClick()
      openCharacterSelection()
      frame:Close()
    end
  end

  local button = {}
  button.w = ctr( 500 )
  button.h = ctr( 100 )
  button.x = ScrW2() + ctr( 300+50 )
  button.y = ScrH() - ctr( 100+50 )
  local charactersConfirm = createMD( "DButton", frame, button.w, button.h, button.x, button.y, ctr( 10 ) )
  charactersConfirm:SetText( "" )
  function testName()
    if string.len( character.rpname ) >= 3 then
      if string.len( character.rpname ) < 33 then
        character.cause = "OK"
        return true
      else
        character.cause = lang.nameistolong
        return false
      end
    else
      character.cause = lang.nameistoshort
      return false
    end
  end
  function charactersConfirm:Paint( pw, ph )
    local text = "Fill out more"
    local color = Color( 255, 255, 0, 255 )
    if testName() then
      text = lang.confirm
      color = yrp.colors.dprimary
    else
      text = character.cause
    end
    paintMD( pw, ph, text, color )
  end
  function charactersConfirm:DoClick()
    if testName() then
      openCharacterSelection()
      frame:Close()
      net.Start( "CreateCharacter" )
        net.WriteTable( character )
      net.SendToServer()
    end
  end

  charactersNameText:MakePopup()
end

local curChar = "-1"
function openCharacterSelection()
  _menuIsOpen = 1
  local ply = LocalPlayer()

  local cache = {}

  local frame = createD( "DFrame", nil, ScrW(), ScrH(), 0, 0 )
  frame:SetTitle( "" )
  frame:ShowCloseButton( false )
  frame:SetDraggable( false )
  frame:Center()
  function frame:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 250 ) )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 250 ) )

    draw.SimpleText( lang.characterselection, "HudHeader", pw/2, ctr( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  ChangeLanguage( frame, ctr( 400 ), ctr( 100 ), ScrW() - ctr( 400 + 100 ), ctr( 100 ) )

  local border = ctr( 50 )
  local charactersBackground = createD( "DPanel", frame, ctr( 800 ), ScrH() - (2*border), border, border )
  function charactersBackground:Paint( pw, ph )
    paintMD( pw, ph, nil, yrp.colors.dprimary )
  end

  local charplayermodel = createD( "DModelPanel", frame, ScrH() - ctr( 200 ), ScrH() - ctr( 200 ), ScrW2() - ( ScrH() - ctr( 200 ) )/2, 0 )
  charplayermodel:SetModel( "models/player/skeleton.mdl" )
  function charplayermodel:LayoutEntity( Entity ) return end

  local turnR = createD( "DButton", frame, ctr( 100 ), ctr( 100 ), ScrW()/2 + ctr( -50 + 150 ), ScrH() - ctr( 300 ) )
  turnR:SetText( "" )
  function turnR:Paint( pw, ph )
    if self:IsHovered() then
      if self:IsDown() then
        if charplayermodel.Entity != nil then
          charplayermodel.Entity:SetAngles( charplayermodel.Entity:GetAngles() + Angle( 0, 1, 0 ) )
        end
      end
      paintMD( pw, ph, "->", yrp.colors.dsecondaryH )
    else
      paintMD( pw, ph, "->", yrp.colors.dsecondary )
    end
  end

  local turnL = createD( "DButton", frame, ctr( 100 ), ctr( 100 ), ScrW()/2 - ctr( 50 + 150 ), ScrH() - ctr( 300 ) )
  turnL:SetText( "" )
  function turnL:Paint( pw, ph )
    if self:IsHovered() then
      if self:IsDown() then
        if charplayermodel.Entity != nil then
          charplayermodel.Entity:SetAngles( charplayermodel.Entity:GetAngles() - Angle( 0, 1, 0 ) )
        end
      end
      paintMD( pw, ph, "<-", yrp.colors.dsecondaryH )
    else
      paintMD( pw, ph, "<-", yrp.colors.dsecondary )
    end
  end

  local characterList = createD( "DScrollPanel", charactersBackground, ctr( 800 ), ScrH() - (2*border), 0, 0 )
  timer.Simple( 0.1, function()
    net.Start( "charGetCharacters" )
    net.SendToServer()
  end)

  net.Receive( "charGetCharacters", function( len )
    local tmpTable = net.ReadTable()
    character.amount = #tmpTable or 0
    if #tmpTable < 1 then
      openCharacterCreation()
      frame:Close()
      return
    end
    local y = 0
    for k, v in pairs( cache ) do
      if v.tmpChar.shadow != nil then
        v.tmpChar.shadow:Remove()
      end
      v.tmpChar:Remove()
    end
    for i = 1, #tmpTable do
      cache[i] = {}
      cache[i].tmpChar = createMD( "DButton", characterList, ctr( 800-20 ), ctr( 200 ), ctr( 10 ), ctr( 10 ) + y * ctr( 200 ) + y * ctr( 10 ), ctr( 5 ) )
      local tmpChar = cache[i].tmpChar
      tmpChar:SetText( "" )
      tmpChar.charid = tmpTable[i].char.uniqueID
      tmpChar.rpname = tmpTable[i].char.rpname
      tmpChar.roleID = tmpTable[i].role.roleID
      tmpChar.groupID = tmpTable[i].group.groupID
      tmpChar.map = tmpTable[i].char.map
      tmpChar.playermodelID = tmpTable[i].char.playermodelID
      local tmp = string.Explode( ",", tmpTable[i].role.playermodels )
      tmpChar.playermodels = tmp
      tmpChar.skin = tmpTable[i].char.skin
      tmpChar.bg1 = tmpTable[i].char.bg1
      tmpChar.bg2 = tmpTable[i].char.bg2
      tmpChar.bg3 = tmpTable[i].char.bg3
      tmpChar.bg4 = tmpTable[i].char.bg4

      function tmpChar:Paint( pw, ph )
        if tmpChar:IsHovered() or curChar == self.charid then
          paintMD( pw, ph, nil, yrp.colors.dsecondaryH )
        else
          paintMD( pw, ph, nil, yrp.colors.dsecondary )
        end
        draw.SimpleText( lang.name .. ": " .. self.rpname, "HudBars", ctr( 20 ), ctr( 40 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( lang.role .. ": " .. self.groupID .. " " .. self.roleID, "HudBars", ctr( 20 ), ctr( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( lang.map .. ": " .. self.map, "HudBars", ctr( 20 ), ctr( 160 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
      end
      function tmpChar:DoClick()
        curChar = self.charid
        charplayermodel:SetModel( self.playermodels[tonumber( self.playermodelID )] )
        charplayermodel.Entity:SetSkin( self.skin )
        charplayermodel.Entity:SetBodygroup( 1, self.bg1 )
        charplayermodel.Entity:SetBodygroup( 2, self.bg2 )
        charplayermodel.Entity:SetBodygroup( 3, self.bg3 )
        charplayermodel.Entity:SetBodygroup( 4, self.bg4 )
      end
      if i == 1 then
        curChar = tmpChar.charid
        tmpChar:DoClick()
      end
      y = y + 1
    end
  end)

  local deleteChar = createMD( "DButton", frame, ctr( 400 ), ctr( 100 ), ScrW2() - ctr( 400 + 800/2 + 10 ), ScrH() - ctr( 150 ), ctr( 5 ) )
  deleteChar:SetText( "" )
  function deleteChar:Paint( pw, ph )
    if self:IsHovered() then
      paintMD( pw, ph, lang.deletecharacter, Color( 255, 0, 0, 255 ) )
    else
      paintMD( pw, ph, lang.deletecharacter, Color( 100, 0, 0, 255 ) )
    end
  end
  function deleteChar:DoClick()
    local _window = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0 )
    _window:Center()
    _window:SetTitle( lang.areyousure )

    local _yesButton = createVGUI( "DButton", _window, 200, 50, 10, 60 )
    _yesButton:SetText( lang.yes )
    function _yesButton:DoClick()

      net.Start( "DeleteCharacter" )
        net.WriteString( curChar )
      net.SendToServer()
      timer.Simple( 0.1, function()
        net.Start( "charGetCharacters" )
        net.SendToServer()
      end)

      _window:Close()
    end

    local _noButton = createVGUI( "DButton", _window, 200, 50, 10 + 200 + 10, 60 )
    _noButton:SetText( lang.no )
    function _noButton:DoClick()
      _window:Close()
    end
  end

  local backB = createMD( "DButton", frame, ctr( 400 ), ctr( 100 ), ScrW2() + ctr( 800/2 + 10 ), ScrH() - ctr( 150 ), ctr( 5 ) )
  backB:SetText( "" )
  function backB:Paint( pw, ph )
    if self:IsHovered() then
      paintMD( pw, ph, lang.back, yrp.colors.dsecondaryH )
    else
      paintMD( pw, ph, lang.back, yrp.colors.dsecondary )
    end
  end
  function backB:DoClick()
    if curChar != "-1" then
      _menuIsOpen = 0
      frame:Close()
    end
  end

  local button = {}
  button.size = ctr( 100 )
  button.x = ctr( 720 )
  button.y = ScrH() - button.size - border - ctr( 30 )
  local charactersCreate = createMDPlus( frame, button.size, button.x, button.y, ctr( 5 ) )
  charactersCreate:SetText( "" )
  function charactersCreate:DoClick()
    openCharacterCreation()
    frame:Close()
  end

  button.w = ctr( 800 )
  button.h = ctr( 100 )
  button.x = ScrW2() - button.w/2
  button.y = ScrH() - button.h - border
  local confirmColor = Color( 255, 0, 0, 255 )
  local charactersEnter = createMDButton( frame, button.w, button.h, button.x, button.y, ctr( 5 ), lang.enterworld )
  charactersEnter:SetText( "" )
  function charactersEnter:DoClick()
    if curChar != "-1" then
      net.Start( "EnterWorld" )
        net.WriteString( curChar )
      net.SendToServer()
      _menuIsOpen = 0
      frame:Close()
    end
  end

  charactersCreate:MakePopup()
end

net.Receive( "openCharacterMenu", function( len, ply )
  _menuIsOpen = 1
  local tmpTable = net.ReadTable()
  openCharacterSelection()
end)
