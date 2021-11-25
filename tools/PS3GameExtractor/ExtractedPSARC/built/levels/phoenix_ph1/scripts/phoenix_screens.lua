prt("----> LOADED phoenix_screens SCRIPT")
global_phoenixNumDisplayUp = 0
function KillScreens()
  hide_all_weapon_lockers()
  kill_armor_upgrade_message()
  kill_armor_upgrade()
end
function getNumWithPromoAvail()
  local heroes = {
    get_ratchet(),
    get_clank(),
    get_qwark()
  }
  local numHeroesWithPromo = 0
  local i
  for i = 1, 3 do
    if is_armor_upgrade_available(heroes[i]) then
      numHeroesWithPromo = numHeroesWithPromo + 1
    end
  end
  return numHeroesWithPromo
end
function PhoenixDisplayOff()
  global_phoenixNumDisplayUp = global_phoenixNumDisplayUp - 1
  if global_phoenixNumDisplayUp < 0 then
    global_phoenixNumDisplayUp = 0
  end
end
function ShowPromoStationIntro(heroWhoUsed)
  local cams = {
    camFollowPath_promoStationIntro_ratchet,
    camFollowPath_promoStationIntro_clank,
    camFollowPath_promoStationIntro_qwark
  }
  local camToUse
  local heroes = {
    get_ratchet(),
    get_clank(),
    get_qwark()
  }
  local i
  for i = 1, 3 do
    if heroWhoUsed == heroes[i] then
      camToUse = cams[i]
      break
    end
  end
  if camToUse == nil then
    return
  end
  StoreAndSave_GaveHelp_PromoStation()
  DisableHeroes()
  fade_to_black(0.5)
  on_elapsed(0.5, function()
    KillScreens()
    start_cine()
    ActivateCamera(camToUse)
    fade_from_black(3)
    on_elapsed(1.75, function()
      set_holo_hero(armorHoloHeroes, heroWhoUsed)
    end)
    on_elapsed(3.5, function()
      on_generic_event(GEN_EVENT_TUTORIAL_MESSAGE_CLOSE, function()
        hide_tutorial_message()
        on_elapsed(1, function()
          fade_to_black(2)
          on_elapsed(2, function()
            DeactivateCamera(camToUse)
            end_cine()
            fade_from_black(1)
            on_elapsed(1, function()
              PhoenixDisplayOff()
              if RestoreHelpMsg ~= nil then
                RestoreHelpMsg()
              end
              activate(invisiPrompt_armorScreen)
              on_elapsed(1, function()
                activate(invisiPrompt_armorScreen)
              end)
            end)
          end)
        end)
        unset_event()
      end)
      show_tutorial_message("HUD_PROMOTION_INTRO", 0.25)
    end)
  end)
end
function checkToPlayPromoStationIntro()
  if get_team_rank(HERO.HERO_TEAM_NONE) > 0 or checkSave_GaveHelp_PromoStation() then
    return false
  else
    return true
  end
end
local heroDisplayOn = false
local heroDisplay_hero
function UpdateHeroDisplay(hero)
  if not heroDisplayOn then
    heroDisplayOn = true
    heroDisplay_hero = hero
    set_holo_hero(armorHoloHeroes, hero)
  end
end
function ResetHeroDisplay()
  reset_holo_hero(armorHoloHeroes)
  heroDisplayOn = false
end
function SetupHoloHeroDisplay()
  on_enter(get_ratchet(), volDetect_heroAtArmorPad, function()
    UpdateHeroDisplay(get_ratchet())
  end)
  on_enter(get_clank(), volDetect_heroAtArmorPad, function()
    UpdateHeroDisplay(get_clank())
  end)
  on_enter(get_qwark(), volDetect_heroAtArmorPad, function()
    UpdateHeroDisplay(get_qwark())
  end)
  on_all_hero_exit(volDetect_heroAtArmorPad, function()
    ResetHeroDisplay()
  end)
end
SetupHoloHeroDisplay()
function SetPromoStationToHeroWithPromotion(do2ndPlayer, dontDoRatchetCam)
  do2ndPlayer = do2ndPlayer or false
  dontDoRatchetCam = dontDoRatchetCam or false
  local heroes = {
    get_ratchet(),
    get_clank(),
    get_qwark()
  }
  local i
  for i = 1, #heroes do
    if is_armor_upgrade_available(heroes[i]) then
      if not do2ndPlayer then
        UpdateHeroDisplay(heroes[i])
        if i == 1 and not dontDoRatchetCam then
          move_vol(vol_armorUpgradeLookAt, 0, 2.8, -150.59511, 0, 0, 0, 1, 1, 1)
        end
        break
      else
        do2ndPlayer = false
      end
    end
  end
end
function CheckIfPromotionAvailable(callback)
  if is_armor_upgrade_available() then
    do
      local numHeroesWithPromoAvail = getNumWithPromoAvail()
      SetPromoStationToHeroWithPromotion(false, 1 < numHeroesWithPromoAvail)
      deactivate(invisiPrompt_armorScreen)
      start_cine()
      ActivateCamera(camFixed_upgradeArea)
      on_elapsed(3, function()
        if 1 < numHeroesWithPromoAvail then
          heroDisplayOn = false
          SetPromoStationToHeroWithPromotion(true)
        end
        activate(invisiPrompt_armorScreen)
        on_elapsed(2.5, function()
          if callback ~= nil then
            callback(camOpeningView_aimAtPromotionArea)
            ResetHeroDisplay()
          end
        end)
      end)
    end
  elseif callback ~= nil then
    callback()
  end
end
function Setup_TriPrompt_ArmorScreen()
  on_generic_event(invisiPrompt_armorScreen, GEN_EVENT_BUTTON_PRESS, function()
    global_phoenixNumDisplayUp = global_phoenixNumDisplayUp + 1
    kill_training_message()
    deactivate(invisiPrompt_armorScreen)
    local heroWhoUsed = who_used_actionable(invisiPrompt_armorScreen, 0)
    if is_armor_upgrade_available(heroWhoUsed) then
      show_armor_upgrade(heroWhoUsed)
      on_generic_event(GEN_EVENT_ARMOR_UPGRADE_CLOSE, function()
        if heroDisplayOn then
          set_holo_hero(armorHoloHeroes, heroWhoUsed)
        end
        PhoenixDisplayOff()
        if RestoreHelpMsg ~= nil then
          RestoreHelpMsg()
        end
        on_elapsed(1, function()
          activate(invisiPrompt_armorScreen)
          on_elapsed(1, function()
            activate(invisiPrompt_armorScreen)
          end)
        end)
        unset_event()
      end)
    elseif checkToPlayPromoStationIntro() then
      ShowPromoStationIntro(heroWhoUsed)
    else
      activate_cam(heroWhoUsed, camFixed_promProgScreen)
      show_armor_upgrade_message(heroWhoUsed)
      on_generic_event(heroWhoUsed, GEN_EVENT_ARMOR_UPGRADE_MESSAGE_CLOSE, function()
        deactivate_cam(heroWhoUsed, camFixed_promProgScreen)
        PhoenixDisplayOff()
        if RestoreHelpMsg ~= nil then
          RestoreHelpMsg()
        end
        on_elapsed(1, function()
          activate(invisiPrompt_armorScreen)
          on_elapsed(1, function()
            activate(invisiPrompt_armorScreen)
          end)
        end)
        unset_event()
      end)
    end
  end)
end
Setup_TriPrompt_ArmorScreen()
local weaponScreenPrompts = {
  invisiPrompt_weaponScreen_1,
  invisiPrompt_weaponScreen_2,
  invisiPrompt_weaponScreen_3,
  invisiPrompt_weaponScreen_4
}
local weaponScreenCams = {
  camFixed_weaponScreen_1,
  camFixed_weaponScreen_2,
  camFixed_weaponScreen_3,
  camFixed_weaponScreen_4
}
local weaponSplitScreenCams = {
  camFixed_weaponScreen_splitscreen_1,
  camFixed_weaponScreen_splitscreen_2,
  camFixed_weaponScreen_splitscreen_3,
  camFixed_weaponScreen_splitscreen_4
}
local weaponScreen_wpnType = {
  {
    WPN_FLAMETHROWER,
    WPN_ICE_BEAM,
    WPN_GRENADE_LAUNCHER
  },
  {
    WPN_ZURKON,
    WPN_SUBWOOFER,
    WPN_THUNDERSTRIKE
  },
  {
    WPN_COMBUSTER,
    WPN_GROOVITRON,
    WPN_ROCKET_LAUNCHER
  },
  {
    WPN_SWINGSHOT,
    WPN_BUZZ_BLADES,
    WPN_DECOY
  }
}
function Setup_TriPrompt_WeaponScreens()
  local i
  for i = 1, 4 do
    on_generic_event(weaponScreenPrompts[i], GEN_EVENT_BUTTON_PRESS, function()
      global_phoenixNumDisplayUp = global_phoenixNumDisplayUp + 1
      kill_training_message()
      deactivate(weaponScreenPrompts[i])
      local heroWhoUsed = who_used_actionable(weaponScreenPrompts[i], 0)
      protagonist_force_stand(heroWhoUsed, true)
      if 1 < get_num_active_players() and not is_online_game() then
        activate_cam(heroWhoUsed, weaponSplitScreenCams[i])
      else
        activate_cam(heroWhoUsed, weaponScreenCams[i])
      end
      on_elapsed(1, function()
        show_weapon_locker(heroWhoUsed, weaponScreen_wpnType[i][1], weaponScreen_wpnType[i][2], weaponScreen_wpnType[i][3])
        on_generic_event(heroWhoUsed, GEN_EVENT_WEAPON_LOCKER_CLOSE, function()
          deactivate_cam(heroWhoUsed, weaponSplitScreenCams[i])
          deactivate_cam(heroWhoUsed, weaponScreenCams[i])
          PhoenixDisplayOff()
          if RestoreHelpMsg ~= nil then
            RestoreHelpMsg()
          end
          on_elapsed(1, function()
            activate(weaponScreenPrompts[i])
            on_elapsed(1, function()
              activate(weaponScreenPrompts[i])
            end)
          end)
          unset_event()
        end)
      end)
    end)
  end
end
Setup_TriPrompt_WeaponScreens()
