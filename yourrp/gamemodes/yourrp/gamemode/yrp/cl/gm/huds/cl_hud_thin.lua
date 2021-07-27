--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local icons = {}
icons["RA"] = "64_radiation"
icons["HP"] = "64_heart"
icons["AR"] = "64_shield-alt"
icons["MO"] = "64_money-bill"
icons["SA"] = "64_money-bill-alt"
icons["ST"] = "64_running"
icons["HU"] = "64_hamburger"
icons["TH"] = "64_glass-cheers"
icons["AL"] = "64_wine-bottle"
icons["CA"] = "64_magic"
icons["AB"] = "64_tint"
icons["BA"] = "64_battery-full"
icons["ID"] = "64_address-card"
icons["CR"] = "64_clock"
icons["RO"] = "64_user-graduate"
icons["NA"] = "64_user"
icons["HY"] = "hygiene"
icons["PE"] = "64_window-restore"
icons["NE"] = "wifi"
icons["XP"] = "64_atom"
icons["WP"] = "bullet"
icons["WS"] = "bullet_secondary"

local HUD_THIN = {}
local function YRPDrawThin(tab)
	local lply = LocalPlayer()

	local name = tab.name

	HUD_THIN[name] = HUD_THIN[name] or {}
	
	if lply:GetNW2Int("hud_version", -1) != HUD_THIN[name]["version"] then
		HUD_THIN[name]["version"] = lply:GetNW2Int("hud_version", -1)

		HUD_THIN[name].x = lply:HudValue(name, "POSI_X")
		HUD_THIN[name].y = lply:HudValue(name, "POSI_Y")
		HUD_THIN[name].w = lply:HudValue(name, "SIZE_W")
		HUD_THIN[name].h = lply:HudValue(name, "SIZE_H")

		HUD_THIN[name].icon = icons[name]
		HUD_THIN[name].ix = HUD_THIN[name].x + HUD_THIN[name].h * 0.2
		HUD_THIN[name].iy = HUD_THIN[name].y + HUD_THIN[name].h * 0.2
		HUD_THIN[name].ih = HUD_THIN[name].h * 0.6

		if tab.valuetext then
			HUD_THIN[name].ts = math.Clamp(HUD_THIN[name].h * 0.6, 6, 100)
		else
			HUD_THIN[name].ts = math.Clamp(math.Round(HUD_THIN[name].h * 0.5, 0), 6, 100)
		end

		HUD_THIN[name].text = tab.text
		if HUD_THIN[name].icon then
			HUD_THIN[name].tx = HUD_THIN[name].x + HUD_THIN[name].h
			HUD_THIN[name].ty = HUD_THIN[name].y + HUD_THIN[name].h * 0.2
		else
			HUD_THIN[name].tx = HUD_THIN[name].x + HUD_THIN[name].w / 2
			HUD_THIN[name].ty = HUD_THIN[name].y + HUD_THIN[name].h / 2
		end

		if HUD_THIN[name].text then
			HUD_THIN[name].tvx = HUD_THIN[name].x + HUD_THIN[name].w - HUD_THIN[name].h * 0.2
			HUD_THIN[name].tvy = HUD_THIN[name].y + HUD_THIN[name].h * 0.2
			HUD_THIN[name].tvax = TEXT_ALIGN_RIGHT
			HUD_THIN[name].tvay = TEXT_ALIGN_TOP
		else
			HUD_THIN[name].tvx = HUD_THIN[name].x + HUD_THIN[name].w / 2
			HUD_THIN[name].tvy = HUD_THIN[name].y + HUD_THIN[name].h / 2
			HUD_THIN[name].tvax = TEXT_ALIGN_CENTER
			HUD_THIN[name].tvay = TEXT_ALIGN_CENTER
		end

		HUD_THIN[name].vx = HUD_THIN[name].x + HUD_THIN[name].h
		HUD_THIN[name].vy = HUD_THIN[name].y + HUD_THIN[name].h * 0.8
		HUD_THIN[name].vw = HUD_THIN[name].w - HUD_THIN[name].h * 1.2
		HUD_THIN[name].vh = HUD_THIN[name].h * 0.1

		HUD_THIN[name].loaded = true
	end

	if HUD_THIN[name].loaded and lply:HudElementVisible(name) then
		-- Background
		draw.RoundedBox(0, HUD_THIN[name].x, HUD_THIN[name].y, HUD_THIN[name].w, HUD_THIN[name].h, Color(0, 0, 0, 100))

		-- Icon
		if HUD_THIN[name].icon then
			local icon = YRP.GetDesignIcon(HUD_THIN[name].icon)
			if icon then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(icon)
				surface.DrawTexturedRect(HUD_THIN[name].ix, HUD_THIN[name].iy, HUD_THIN[name].ih, HUD_THIN[name].ih)
			end
		end

		-- Text
		if HUD_THIN[name].text then
			if HUD_THIN[name].icon then
				draw.SimpleText(YRP.lang_string(HUD_THIN[name].text), "Y_" .. HUD_THIN[name].ts .. "_500", HUD_THIN[name].tx, HUD_THIN[name].ty, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			else
				draw.SimpleText(YRP.lang_string(HUD_THIN[name].text), "Y_" .. HUD_THIN[name].ts .. "_500", HUD_THIN[name].tx, HUD_THIN[name].ty, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		-- Value
		if tab.valuetext then
			draw.SimpleText(tab.valuetext, "Y_" .. HUD_THIN[name].ts .. "_500", HUD_THIN[name].tvx, HUD_THIN[name].tvy, Color(255, 255, 255), HUD_THIN[name].tvax, HUD_THIN[name].tvay)	
		elseif tab.cur then
			draw.SimpleText(tab.cur, "Y_" .. HUD_THIN[name].ts .. "_500", HUD_THIN[name].tvx, HUD_THIN[name].tvy, Color(255, 255, 255), HUD_THIN[name].tvax, HUD_THIN[name].tvay)
		end

		-- BAR
		if tab.cur and tab.max then
			draw.RoundedBox(0, HUD_THIN[name].vx, HUD_THIN[name].vy, HUD_THIN[name].vw, 2, Color(0, 0, 0, 100))
			draw.RoundedBox(0, HUD_THIN[name].vx, HUD_THIN[name].vy, HUD_THIN[name].vw * tab.cur / tab.max, 2, Color(255, 255, 255, 255))
		end
	end
end

function YRPHUDThin()
	local lply = LocalPlayer()

	if YRP and YRP.GetDesignIcon and lply:LoadedGamemode() and !IsScoreboardVisible() then
		if GetGlobalBool("bool_yrp_hud", false) and lply:GetNW2String("string_hud_design") == "Thin" then
			local HP = {}
			HP.name = "HP"
			HP.text = "LID_health"
			HP.cur = lply:Health()
			HP.max = lply:GetMaxHealth()
			YRPDrawThin(HP)

			local AR = {}
			AR.name = "AR"
			AR.text = "LID_armor"
			AR.cur = lply:Armor()
			AR.max = lply:GetMaxArmor()
			YRPDrawThin(AR)

			local HU = {}
			HU.name = "HU"
			HU.text = "LID_hunger"
			HU.cur = lply:Hunger()
			HU.max = lply:GetMaxHunger()
			YRPDrawThin(HU)

			local TH = {}
			TH.name = "TH"
			TH.text = "LID_thirst"
			TH.cur = lply:Thirst()
			TH.max = lply:GetMaxThirst()
			YRPDrawThin(TH)

			local ST = {}
			ST.name = "ST"
			ST.text = "LID_stamina"
			ST.cur = lply:Stamina()
			ST.max = lply:GetMaxStamina()
			YRPDrawThin(ST)

			local PE = {}
			PE.name = "PE"
			PE.text = "LID_fps"
			PE.cur = math.Clamp(GetFPS(), 0, 144)
			PE.max = 144
			YRPDrawThin(PE)

			local NE = {}
			NE.name = "NE"
			NE.text = "LID_ping"
			NE.cur = math.Clamp(lply:Ping(), 0, 200)
			NE.max = 200
			YRPDrawThin(NE)

			local XP = {}
			XP.name = "XP"
			XP.text = "LID_xp"
			XP.cur = lply:XP()
			XP.max = lply:GetMaxXP()
			YRPDrawThin(XP)

			local BA = {}
			BA.name = "BA"
			BA.text = "LID_battery"
			BA.cur = system.BatteryPower()
			BA.max = 100
			YRPDrawThin(BA)
			
			local weapon = lply:GetActiveWeapon()
			if IsValid(weapon) then
				local clip1 = weapon:Clip1()
				local clip1max = weapon:GetMaxClip1()
				local ammo1 = lply:GetAmmoCount(weapon:GetPrimaryAmmoType())

				local clip2 = weapon:Clip2()
				local clip2max = weapon:GetMaxClip2()
				local ammo2 = lply:GetAmmoCount(weapon:GetSecondaryAmmoType())
				
				local wpammo = ""
				if clip1 >= 0 and clip1max >= 0 then
					wpammo = wpammo .. clip1 .. "/" .. clip1max
				end
				if ammo1 >= 0 then
					if !strEmpty(wpammo) then
						wpammo = wpammo .. " | " .. ammo1
					else
						wpammo = wpammo .. ammo1
					end
				end

				local WP = {}
				WP.name = "WP"
				WP.text = "LID_ammo"
				WP.cur = clip1
				WP.max = clip1max
				WP.valuetext = wpammo
				YRPDrawThin(WP)

				local wsammo = ""
				if clip2 >= 0 and clip2max >= 0 then
					wsammo = wsammo .. clip2 .. "/" .. clip2max
				end
				if ammo2 >= 0 then
					if !strEmpty(wsammo) then
						wsammo = wsammo .. " | " .. ammo2
					else
						wsammo = wsammo .. ammo2
					end
				end

				local WS = {}
				WS.name = "WS"
				WS.text = "LID_ammo"
				WS.cur = clip2
				WS.max = clip2
				WS.valuetext = wsammo
				YRPDrawThin(WS)
			end

			


			local NA = {}
			NA.name = "NA"
			NA.text = "LID_name"
			YRPDrawThin(NA)

			local RO = {}
			RO.name = "RO"
			RO.text = lply:RPName()
			YRPDrawThin(RO)

			local ID = {}
			ID.name = "ID"
			ID.text = lply:IDCardID()
			YRPDrawThin(ID)

			local SN = {}
			SN.name = "SN"
			SN.valuetext = YRPGetHostName()
			YRPDrawThin(SN)

			local MO = {}
			MO.name = "MO"
			MO.text = "LID_money"
			MO.valuetext = lply:FormattedMoneyRounded(1)
			YRPDrawThin(MO)

			local SA = {}
			SA.name = "SA"
			SA.text = "LID_salary"
			SA.valuetext = "+" .. lply:FormattedSalaryRounded(1)
			YRPDrawThin(SA)

			local CON = {}
			CON.name = "CON"
			CON.valuetext = lply:Condition()
			YRPDrawThin(CON)

			if lply:GetActiveWeapon() and lply:GetActiveWeapon().GetPrintName then
				local WN = {}
				WN.name = "WN"
				WN.valuetext = lply:GetActiveWeapon():GetPrintName()
				YRPDrawThin(WN)
			end

			local CR = {}
			CR.name = "CR"
			CR.text = "LID_clock"
			CR.cur = os.date("%H" , os.time()) * 60 * 60 + os.date("%M" , os.time()) * 60
			CR.max = 60 * 60 * 24
			CR.valuetext = os.date("%H:%M" , os.time())
			YRPDrawThin(CR)

			local LO = {}
			LO.name = "LO"
			LO.valuetext = "[" .. GTS("lockdown") .. "] " .. lply:LockdownText()
			YRPDrawThin(LO)

			HUDSimpleCompass()
		end
	end
end
hook.Remove("HUDPaint", "yrp_hud_design_Thin")
hook.Add("HUDPaint", "yrp_hud_design_Thin", YRPHUDThin)
