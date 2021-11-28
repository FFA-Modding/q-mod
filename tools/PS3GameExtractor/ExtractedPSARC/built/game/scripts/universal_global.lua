-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --
-- //                       PATCH UNIVERSAL GLOBAL      	             	\\ --
-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

prt("----> LOADED universal global SCRIPT")

enable_end_game = false -- -- whether we are ready to end the current level
global_cameFromPhoenix = false -- whether the last load was from the phoenix
PvPLevelCheck = false -- whether the current level is a PVP level
pvp_global_forfeit = false -- whether the destruction of generators is due to a forfeit (for VO)

-- ======================================================================= --
-- ======                           LEVEL                           ====== --
-- ======================================================================= --

-- --------------------------- getPhoenixPhase --------------------------- --
function getPhoenixPhase()
--/ Returns the name of the phoenix level that corresponds to the correct 
--/ current phase. 

  local numLevelsCompleted = get_qf_levels_completed()
  prt("Getting the correct phoenix phase with the player having completed " .. numLevelsCompleted .. " levels.")
  if (numLevelsCompleted < 2) then 
    return ("phoenix_ph1") 
  elseif (numLevelsCompleted < 3) then 
    return ("phoenix_ph2")
  else
    return ("phoenix_ph3") 
  end 
  
end -- end getPhoenixPhase

-- ---------------------------- SetCameFromPhoenix ----------------------- --
function SetCameFromPhoenix()
--/ Sets the global global_cameFromPhoenix if the phoenix flag is true (and then 
--/ resets the phoenix flag so further loads will not have it set). 
--/ Call this function for every non-cp_default checkpoint 

  if (get_phoenix_flag()) then 
    global_cameFromPhoenix = true 
    set_phoenix_flag(false) -- reset the flag 
  end 
  
  -- restore the level timer as it was broken by going to the phoenix (actually, because we reloaded a checkpoint)
  RestoreLastSavedLevelTime() -- don't need a save-data delay as it access SAVE directly
  
end -- end SetCameFromPhoenix

-- ======================================================================= --
-- ======                           CAMERA/HEROES                   ====== --
-- ======================================================================= --

-- --------------------------- DisableHeroes ----------------------------- --
function DisableHeroes()
  
  --hero_disable_pad()
  protagonist_force_stand_all(true)
  hero_lockout_all(true)
  --set_gameplay_cinematic_active(true)
  
end -- end DisableHeroes

-- --------------------------- EnableHeroes ------------------------------ --
function EnableHeroes(restoreHeroCam, enableEnemies, enableRadar)
	
  if (restoreHeroCam == nil) then 
    restoreHeroCam = true
  end
  
  if (enableRadar == nil) then 
    enableRadar = true 
  end 
  
  if ((global_curLevelPhoenix ~= nil) and (global_curLevelPhoenix)) then 
    enableRadar = false
  end 
  
  if (restoreHeroCam) then 
    activate_hero_cam()
  end
  
  if ((enableEnemies == nil) or (enableEnemies)) then 
    disable_enemy_awareness(false)
    UnPauseInvasion()
  end 
  
  --hero_enable_pad()
  protagonist_force_stand_all(false)
  hero_lockout_all(false)
  set_hud_fader(true)
  --set_gameplay_cinematic_active(false)
  if (enableRadar) then 
    radar_enable()
  end 
  
end -- end EnableHeroes

-- -------------------------- ActivateCamera ----------------------------- --
function ActivateCamera(cam, disableEnemies, disableInvasion, hero)

  if (disableEnemies == nil) then 
    disableEnemies = true 
  end 
  if (disableInvasion == nil) then 
    disableInvasion = disableEnemies
  end
  
  if (disableInvasion) then 
    PauseInvasion()
  end
  disable_enemy_awareness(disableEnemies)
  
  DisableHeroes()
  radar_set_full_screen(false)
  if (cam ~= nil) then
		if hero ~= nil then
			activate_cam(hero, cam)
		else
			activate_cam(cam)
		end
  end
	radar_disable()
  set_hud_fader(false)
  
end -- end ActivateCamera

-- -------------------------- DeactivateCamera --------------------------- --
function DeactivateCamera(cam, enableEnemies)
	
  if (cam == nil) then 
    EnableHeroes(true, enableEnemies) -- will restore the hero camera 
  else
    deactivate_cam(cam)
    EnableHeroes(false, enableEnemies)
  end
  
end -- end DeactivateAllCameras

-- ------------------------------ SetupPlatformingFollowCam ---------------------- --
function SetupPlatformingFollowCam(camAreaArray, camDist, camPitch)
--/ We need to know which hero entered and exited to only affect the camera of the 
--/ person in the platform area. So this function sets up on enters and on exits 
--/ for all the platform areas (passed in)

  if (camDist == nil) then 
    camDist = 14
  end
  if (camPitch == nil) then 
    camPitch = 25
  end 
  
  local heroes = {get_ratchet(), get_ratchet(), get_clank(), get_qwark()}
  local i;
  local j;
  for i = 1, #heroes, 1 do -- Right now it takes the heroes array just over here, so Ratchet, Ratchet, Clank and Qwark
    if (is_hero_active(heroes[i])) then
      for j = 1, #camAreaArray, 1 do
        on_enter(heroes[i], camAreaArray[j], function()
          set_follow_cam(heroes[i], camDist, camPitch) -- platform camera
          on_exit(heroes[i], camAreaArray[j], function()
            reset_follow_cam(heroes[i])
            unset_event()
          end)
        end)
      end
    end
  end 
end -- end SetupPlatformingFollowCam


-- ------------------------- ActivateCameraOnHeroesInVol --------------- --
function ActivateCameraOnHeroesInVol(isInsideArray, inCam, outCam)

  local heroes = {get_ratchet(), get_ratchet(), get_clank(), get_qwark()}
  local i; 
  for i = 1, 4, 1 do -- Same here, it make the event for the 4 players
    if (is_hero_active(heroes[i])) then 
      if (isInsideArray[i]) then 
        activate_cam(heroes[i], inCam)
      else
        activate_cam(heroes[i], outCam)
      end
    end
  end 
  
end -- end ActivateCameraOnHeroesInVol


-- Player 2 Camera for Splitscreen
function ActivateOtherPlayerCam(player_1, player_2_cam)
	-- Returns ref. to player 2
	local heroes = {get_ratchet(), get_clank(), get_qwark()}
	local i;
	for i = 1, 4, 1 do -- Same
		if is_hero_active(heroes[i]) and (heroes[i] ~= player_1) then
			activate_cam(heroes[i], player_2_cam)
			return heroes[i]
		end
	end
end

-- -------------------- heroIsLocal --------------- --
function heroIsLocal(hero) 

  if (hero == nil) then 
    return false;
  end 
  
  local heroes = {get_ratchet(), get_Ratchet(), get_clank(), get_qwark()}
  local heroLocal = {is_ratchet_local(), is_ratchet_local(), is_clank_local(), is_qwark_local()}
  
  local i; 
  for i = 1, 4, 1 do -- Same
    if ((hero == heroes[i]) and heroLocal[i]) then 
      return true;
    end 
  end
  
  return false; 
  
end -- end heroIsLocal

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MUSIC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

--------------------------------Weapon Upgrade Music Cue-------------------------
on_generic_event(GEN_EVENT_RATCHET_WEAPON_UPGRADED, function()
    if ( is_ratchet_local() ) then
	  MusicCheck_upgrade = true
	  prt("MusicCheck weapon upgrade music stinger")
	end
end)

on_generic_event(GEN_EVENT_CLANK_WEAPON_UPGRADED, function()
    if ( is_clank_local() ) then
	  MusicCheck_upgrade = true
	  prt("MusicCheck weapon upgrade music stinger")
	end
end)

on_generic_event(GEN_EVENT_QWARK_WEAPON_UPGRADED, function()
    if ( is_qwark_local() ) then
	  MusicCheck_upgrade = true
	  prt("MusicCheck weapon upgrade music stinger")
	end
end)


-- ======================================================================= --
-- ======                         APHELION                          ====== -- 
-- ======================================================================= --

-- ------------------------ getAphelionDriverAndPass ---------------------------- --
local function getAphelionDriverAndPass()

  -- The driver priority is Ratchet, Qwark, and Clank (i.e., Clank will 
  -- only drive if he is by himself). The second valid hero found in the order 
  -- will be the passenger.
  
  local heroes = {get_ratchet(), get_ratchet(), get_qwark(), get_clank()}
  local heroType = {HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_QWARK, HERO.HERO_TYPE_CLANK}
  local driver = nil 
  local pass = nil
  local i;
  for i = 1, #heroes, 1 do -- Same
    if ((driver ~= nil) and is_hero_active(heroes[i])) then
      pass = heroType[i]
      break; -- we have the driver and the passenger
    end 
    if ((driver == nil) and is_hero_active(heroes[i])) then 
      driver = heroType[i]
    end 
   
  end 
  
  local results = {driver, pass}
  return (results)
  
end -- end getAphelionDriverAndPass

-- ------------------------ getAphelionCam ------------------ --
local function getAphelionCam(actorType, isDriver)

  isDriver = isDriver or false 
  
  local driverCams = global_aphelionDriverCams
  local driverAnimCamMoby = global_aphelionDriverAnimCamMoby
  local passCams = global_aphelionPassCams
  local passAnimCamMoby = global_aphelionPassAnimCamMoby
  
  local camArray = driverCams 
  local animCamMobyArray = driverAnimCamMoby
  
  if (not isDriver) then 
    camArray = passCams 
    animCamMobyArray = passAnimCamMoby 
  end 
  
  local heroTypes = {HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_QWARK, HERO.HERO_TYPE_CLANK}
  local i; 
  for i = 1, #heroTypes, 1 do -- Same but it takes heroTypes objects, with same characters
    if (heroTypes[i] == actorType) then 
      return ({camArray[i], animCamMobyArray[i]})
    end 
  end 
  
  return ({nil, nil})
  
end -- end getAphelionCam

-- ------------------------ DoHeroesExitAphelion ------------------------- --
function DoHeroesExitAphelion(finCallback, aphelionPos, heroActors, aphelionMoby)

  local drivNPassHeroType = getAphelionDriverAndPass()
  local drivCams = getAphelionCam(drivNPassHeroType[1], true)
  local passCams = getAphelionCam(drivNPassHeroType[2])
  
  local driver1 = nil
  local driver2 = nil 
  local pass1 = nil
  local pass2 = nil 
  local heroTypes  = {HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_QWARK, HERO.HERO_TYPE_CLANK}
  local i; 
  for i = 1, #heroTypes, 1 do -- Same with local heroTypes
    if ((drivNPassHeroType[1] ~= nil) and (drivNPassHeroType[1] == heroTypes[i])) then 
      if (type(heroActors[i]) == "table") then 
        driver1 = heroActors[i][1]
        setup_hero_bangles(driver1, heroTypes[i])

        driver2 = heroActors[i][2]
        if (heroTypes[i] == HERO.HERO_TYPE_CLANK) then
          setup_hero_bangles(driver2, HERO.HERO_TYPE_ALPHA_CLANK)
        else
          setup_hero_bangles(driver2, heroTypes[i])
        end
      else
        driver1 = heroActors[i]
        setup_hero_bangles(driver1, heroTypes[i])
      end
      
    end 
    if ((drivNPassHeroType[2] ~= nil) and (drivNPassHeroType[2] == heroTypes[i])) then
      if (type(heroActors[i]) == "table") then 
        pass1 = heroActors[i][1]
        setup_hero_bangles(pass1, heroTypes[i])
        pass2 = heroActors[i][2]
        if (heroTypes[i] == HERO.HERO_TYPE_CLANK) then
          setup_hero_bangles(pass2, HERO.HERO_TYPE_ALPHA_CLANK)
        else
          setup_hero_bangles(pass2, heroTypes[i])
        end
      else
        pass1 = heroActors[i]
        setup_hero_bangles(pass1, heroTypes[i])
      end
    end 
  end 
  
  -- shouldn't happen, but just to be safe 
  if (driver1 == nil) then 
    return finCallback()
  end 
  
  -- do the driver and passengar animations 
  reveal(driver1)
  warp(driver1, aphelionPos)
  if (driver2 ~= nil) then 
    reveal(driver2) 
    draw_off(driver2)
    warp(driver2, aphelionPos)
  end
  if (pass1 ~= nil) then 
    reveal(pass1)
    warp(pass1, aphelionPos)
    if (pass2 ~= nil) then 
      reveal(pass2)
      draw_off(pass2)
      warp(pass2, aphelionPos)
    end
  end 
  
  play_anim_with_modifier(driver1, AnimQuery.INTRO_CAT, AnimQuery.INTRO_APPEAR, AnimQuery.Modifiers.GROUPINTRO, AnimQuery.GROUP_INTRO_00)
  if (driver2 ~= nil) then 
    play_anim_with_modifier(driver2, AnimQuery.INTRO_CAT, AnimQuery.INTRO_APPEAR, AnimQuery.Modifiers.GROUPINTRO, AnimQuery.GROUP_INTRO_00)
    on_elapsed(3.67, function()
      reveal(driver2)
      draw_off(driver1)
    end)
  end
  -- the passenger anim has a built in wait while the driver animates 
  if (pass1 ~= nil) then 
    play_anim_with_modifier(pass1, AnimQuery.INTRO_CAT, AnimQuery.INTRO_APPEAR, AnimQuery.Modifiers.GROUPINTRO, AnimQuery.GROUP_INTRO_01)
    if (pass2 ~= nil) then 
      play_anim_with_modifier(pass2, AnimQuery.INTRO_CAT, AnimQuery.INTRO_APPEAR, AnimQuery.Modifiers.GROUPINTRO, AnimQuery.GROUP_INTRO_01)
      on_elapsed(7.9, function()
        reveal(pass2)
        draw_off(pass1)
      end)
    end
  end 
  
-- driver cam   
  ActivateCamera(drivCams[1])
  on_generic_event(drivCams[2], GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
    if (pass1 == nil) then
      finCallback()
    else
      ActivateCamera(passCams[1])
      on_generic_event(passCams[2], GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
        finCallback()
        unset_event()
      end)
    end
    unset_event()
  end)
  
end -- end DoHeroesExitAphelion

-- -------------------------- LandingSeq_GoToOpeningViewCam -------------- --
function LandingSeq_GoToOpeningViewCam(p1_index, p2_index, focusPosArray, heroArray, ratchetWrench, 
                      aphelion, openingViewCam, callback, doEnableHeroes, doEndCine, volRadarDisable)

  if (doEnableHeroes == nil) then 
    doEnableHeroes = true 
  end 
  if (doEndCine == nil) then 
    doEndCine = doEnableHeroes
  end
  
  local heroes = {get_ratchet(), get_ratchet(), get_qwark(), get_clank()}
  
  fade_to_black(0.5)
  on_elapsed(0.5, function()
    if (ShowHeroTurrets ~= nil) then 
      ShowHeroTurrets()
    end
    if (doEndCine) then 
      end_cine()
    end
    hide(ratchetWrench)
    local i;
    for i = 1, #heroArray, 1 do 
      hide(heroArray[i])
    end 
    -- bring the heroes into position 
    warp(heroes[p1_index], focusPosArray[1], true, false, false, false)
    if ((p2_index ~= nil) and (p2_index > 0)) then 
      warp(heroes[p2_index], focusPosArray[2], true, false, false, false)
    end
    
		if openingViewCam ~= nil then
			fade_from_black(0.5)
			ActivateCamera(openingViewCam)
		end
    if (doEnableHeroes) then 
      on_elapsed(0.25, function()
        set_hud_fader(true)
        if (volRadarDisable ~= nil) then 
          on_hero_exit(volRadarDisable, function()
            radar_enable()
            DeactivateCamera()
            unset_event()
          end)
          EnableHeroes(false, true, false)
        else
          EnableHeroes(false)
        end
      end)
    end
    if (callback ~= nil) then   
      on_elapsed(0.5, callback)
    end
  end)
end -- end LandingSeq_GoToOpeningViewCam

-- -------------------------------- DoPCHeroFocus ------------------------ --
function DoPCHeroFocus(callback, p1_cams, p1_camMoby, p2_cams, p2_camMoby, focusPosArray, heroArray, 
                  ratchetWrench, aphelion, openingViewCam, doEnableHeroes, doFade, doEndCine, volRadarDisable)
  
  doFade = doFade or false 
  
  local heroTypes = {HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_QWARK, HERO.HERO_TYPE_CLANK, HERO.HERO_TYPE_ALPHA_CLANK}
  local heroes = {get_ratchet(), get_ratchet(), get_qwark(), get_clank()}
  local p1_index = -1
  local p2_index = -1
  local p3_index = -1
  local p4_index = -1
  local i;
  -- Strangely, the players indexes were already here, I maybe added them before (V E L D)
    
  local waitTime = 0 
  if (doFade) then 
    fade_to_black(0.2)
    waitTime = 0.15
  end 
  
  on_elapsed(waitTime, function()
    play_anim_query(aphelion, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
    for i = 1, 4, 1 do -- Do this code for 4 players
      hide(heroArray[i])
      if (is_hero_active(heroes[i])) then 
        if (p1_index == -1) then 
          p1_index = i
        elseif(p2_index == -1) then
          p2_index = i
        elseif(p3_index == -1) then
          p3_index = i
        else
          p4_index = i -- we have 4 players attributed
          break;
        end
      end
    end
    
    prt("P1 = " .. tostring(p1_index) .. ", P2 = " .. tostring(p2_index) .. ", P3 = " .. tostring(p3_index) .. ", P4 = " .. tostring(p4_index))
    if (p1_index == -1) then 
      prt("UniversalGlobal:DoPCHeroFocus - ERROR! No active hero found!")
      return;
    end 
    
    local p1Pos = focusPosArray[1]
    local p2Pos = nil 
    if (p2_index ~= -1) then 
      p2Pos = focusPosArray[2]
    end 
    
    local alphaClank = heroArray[4]
    local alphaClankPos = nil 
    if (p1_index == 3) then 
      alphaClankPos = p1Pos 
    elseif (p2_index == 3) then 
      alphaClankPos = p2Pos
    end 
    
    reveal(heroArray[p1_index])
    warp(heroArray[p1_index], p1Pos)
    if (p1_index == 1) then 
      reveal(ratchetWrench)
      bangle_all_off(ratchetWrench, false)
      bangle_on(ratchetWrench, 0, false)
      bangle_on(ratchetWrench, 1, false)
      warp(ratchetWrench, p1Pos)
    end
    if (alphaClankPos ~= nil) then 
      reveal(alphaClank)
      setup_hero_bangles(alphaClank, HERO.HERO_TYPE_ALPHA_CLANK)
      draw_off(alphaClank)
      warp(alphaClank, alphaClankPos)
    end
    
    if (doFade) then 
      fade_from_black(0.2)
    end
    
    ActivateCamera(p1_cams[p1_index])
    if ((curLevel_jrboss ~= nil) and (curLevel_jrboss)) then 
      -- #MUSIC just for JRBoss play some music during the hero focus 
	  MusicCheck_heroIntro = true
      prt("JRBoss hero focus boogie")
    end 
    
    play_anim_query(heroArray[p1_index], AnimQuery.INTRO_CAT, AnimQuery.INTRO_TITLE)
    if (p1_index == 1) then 
      play_anim_query(ratchetWrench, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_1)
    end
    if (p1_index == 3) then -- clank 
      play_anim_query(alphaClank, AnimQuery.INTRO_CAT, AnimQuery.INTRO_TITLE)
      on_elapsed(0.8, function()
        reveal(alphaClank)
        hide(heroArray[p1_index])
      end)
    end 
    on_generic_event(p1_camMoby, GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
      if (p2_index == -1) then 
        LandingSeq_GoToOpeningViewCam(p1_index, p2_index, focusPosArray, heroArray, ratchetWrench, aphelion, openingViewCam, callback, doEnableHeroes, doEndCine, volRadarDisable)
      else
        reveal(heroArray[p2_index])
        warp(heroArray[p2_index], p2Pos)
        ActivateCamera(p2_cams[p2_index])
        play_anim_query(heroArray[p2_index], AnimQuery.INTRO_CAT, AnimQuery.INTRO_TITLE)
        if (p2_index == 1) then 
          reveal(ratchetWrench)
          bangle_all_off(ratchetWrench, false)
          bangle_on(ratchetWrench, 0, false)
          bangle_on(ratchetWrench, 1, false)
          warp(ratchetWrench, p2Pos)
          play_anim_query(ratchetWrench, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_1)
        end
        if (p2_index == 3) then -- clank 
          play_anim_query(alphaClank, AnimQuery.INTRO_CAT, AnimQuery.INTRO_TITLE)
          on_elapsed(0.8, function()
            reveal(alphaClank)
            hide(heroArray[p2_index])
          end)
        end 
        on_generic_event(p2_camMoby, GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
          LandingSeq_GoToOpeningViewCam(p1_index, p2_index, focusPosArray, heroArray, ratchetWrench, aphelion, openingViewCam, callback, doEnableHeroes, doEndCine, volRadarDisable)
          unset_event()
        end)
      end
      unset_event()
    end)
  end) -- end wait to fade down 
end -- end DoPCHeroFocus

-- -------------------------- DoHeroesJumpOutAphelion -------------------- --
function DoHeroesJumpOutAphelion(callback, exitCam, exitCamMoby, p1_cams, p1_camMoby, 
                                 p2_cams, p2_camMoby, aphelionPos, focusPosArray, heroArray, ratchetWrench,
                                 aphelion, openingViewCam, doFocus, doEnableHeroes, volRadarDisable)

  if (doFocus == nil) then 
    doFocus = true 
  end 
  
  if (doEnableHeroes == nil) then 
    doEnableHeroes = true 
  end
  
  local heroTypes  = {HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_RATCHET, HERO.HERO_TYPE_QWARK, HERO.HERO_TYPE_CLANK, HERO.HERO_TYPE_ALPHA_CLANK}
 
  local i; 
  local lastJumpOutHeroIndex = 3 -- was for gamescom to limit only Ratchet jumping out
  -- bangle up our actors and put them into position 
  for i = 1, lastJumpOutHeroIndex, 1 do -- do nothing with alpha clank at the moment 
    reveal(heroArray[i])
    setup_hero_bangles(heroArray[i], heroTypes[i])
    warp(heroArray[i], aphelionPos)
  end
  
  ActivateCamera(exitCam)
  for i = 1, lastJumpOutHeroIndex, 1 do 
    play_anim_query(heroArray[i], AnimQuery.INTRO_CAT, AnimQuery.INTRO_APPEAR)
  end
  
  on_generic_event(exitCamMoby, GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
    if (doFocus) then 
      DoPCHeroFocus(callback, p1_cams, p1_camMoby, p2_cams, p2_camMoby, focusPosArray, 
                    heroArray, ratchetWrench, aphelion, openingViewCam, doEnableHeroes, true, nil, volRadarDisable)
    elseif (callback ~= nil) then 
      callback()
    else
      activate_hero_cam()
      EnableHeroes()
    end
    unset_event()
  end)
end -- end DoHeroesJumpOutAphelion

-- ======================================================================= --
-- ======                             PDC                           ====== --
-- ======================================================================= --

-- -------------------------- PlayScene_PDCPlugIn ------------------------ --
function PlayScene_PDCPlugIn(actHero, actHeroType, offscreenPosVec, pdc, pdcPanel, pdcVol, heroRotation, camArray, camEntityArray, callback)

  DisableHeroes()
  
  fade_to_black(1)
  on_elapsed(1, function()
    start_cine()
    enable_enemy_wave_bar(false)
    -- store the heroes' current location so we can restore it later
    -- and warp them offscreen
    local heroes = {get_ratchet(), get_clank(), get_qwark()}
    local heroPos = {}
    local heroIndex = {}
    local i; 
    for i = 1, 4, 1 do 
      if (is_hero_active(heroes[i]) and is_alive(heroes[i])) then  -- campaign is_alive is still synced as there is no hero-hero damage
        table.insert(heroIndex, i)
        table.insert(heroPos, get_pos(heroes[i]))
        -- do a warp to a vector lets us preserve orientation
        warp(heroes[i], offscreenPosVec.x + 2*i, offscreenPosVec.y, offscreenPosVec.z, true, false, false, false)
      end 
    end 
    DisableHeroes() -- disable them again in case we warped them to a mid-air position over a death clue (this will freeze them in mid-air)
  
    -- get the pdc panel into position 
    local pdcPanelPos = get_dynamic_joint_pos(pdc, 5)
    local pdcPanelVec = lua_vector:new()
    pdcPanelVec.x = pdcPanelPos.x
    pdcPanelVec.y = pdcPanelPos.y
    pdcPanelVec.z = pdcPanelPos.z
    set_pos(pdcPanel, pdcPanelVec)
    
    -- get the hero into position
    local actHeroPos = get_dynamic_joint_pos(pdc, 4)
    -- in order for the hero to get the correct orientation, we will warp them to the volume
    -- therefor, we will move the volume to the hero-attach joint of the pdc
    move_vol(pdcVol, actHeroPos.x, actHeroPos.y, actHeroPos.z, 0, heroRotation, 0, 1, 1, 1)
    reveal(actHero)
    setup_hero_bangles(actHero, actHeroType)
    warp(actHero, pdcVol)
    fade_from_black(0.75)
    
    -- show the hero use the hand scanner 
    ActivateCamera(camArray[1])
    play_anim_query(actHero, AnimQuery.SCRIPTED_CAT, AnimQuery.SCRIPTED_ACTION1)
    play_anim_query(pdcPanel, AnimQuery.SCRIPTED_CAT, AnimQuery.SCRIPTED_ACTION1)
    play_anim_query(pdc, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CHARGED)
    deactivate(pdc)
    on_generic_event(camEntityArray[1], GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
      -- show close up of the pdc 
      ActivateCamera(camArray[2])
      on_generic_event(camEntityArray[2], GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
        play_anim_query(actHero, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
        -- feet doesn't line up with the ground - amend that
        local pos = get_pos(actHero)
        pos.y = pos.y - 0.2
        set_pos(actHero, pos)
        fade_to_black(0.5)
        on_elapsed(0.5, function()
          fade_from_black(0.5)
        -- show the pdc powering 
          ActivateCamera(camArray[3])
          on_generic_event(camEntityArray[3], GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
            -- scene is done, fade to black, restore hero positions, hide the actor
            fade_to_black(1)
            on_elapsed(0.75, function()
              hide(actHero)
              for i = 1, #heroIndex, 1 do
                warp(heroes[heroIndex[i]], heroPos[i].x, heroPos[i].y, heroPos[i].z, true, false, false, false)
              end
              enable_enemy_wave_bar(true)
              if (callback == nil) then 
                fade_from_black(0.75)
                DeactivateCamera()
                end_cine()
              else
                callback()
              end
            end)
            unset_event()
          end)
        end)
        unset_event()
      end)
      unset_event()
    end)
  end)
end -- end PlayScene_PDCPlugIn

-- ---------------------------- PlayScene_PDCActivate -------------------- --
function PlayScene_PDCActivate(pdc, cam, camEntity, callback)

  DisableHeroes()
  
  fade_to_black(1)
  on_elapsed(1, function()
    ActivateCamera(cam)
    fade_from_black(0.75)
    play_anim_query(pdc, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_ACTIVATE)
    on_generic_event(camEntity, GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
      if (callback == nil) then
        DeactivateCamera()
        end_cine()
      else
        callback()
      end
      unset_event()
    end)
  end)
    
end -- end PlayScene_PDCActivate

-- ======================================================================= --
-- ======                           HEROES                          ====== --
-- ======================================================================= --

-- ----------------------------- ResetHeroBolts -------------------------- --
function ResetHeroBolts()
--/ All heroes get 0 bolts! \-- 
  
  heroes_reset_bolts()
  
end -- end ResetHeroBolts

-- ----------------------------- ResetWeapons ---------------------------- --
function ResetWeapons(runHeroSetup)
--/ Remove all weapons and give the combuster, the starting loadout. \-- 

  runHeroSetup = runHeroSetup or false
  
  hero_take_all_weapons()
  
  if (runHeroSetup) then 
    run_script("herosetup") -- regive the starting loadout 
  end
  
end -- end ResetWeapons 

-- -------------------------- EquipAllHeroes ----------------------------- --
function EquipAllHeroes(weaponTag)

  local heroes = {get_ratchet(), get_ratchet(), get_clank(), get_qwark()}
  local i;
  for i = 1, #heroes, 1 do 
    if (is_hero_active(heroes[i])) then 
      hero_equip(heroes[i], weaponTag)
    end
  end
  
end -- end EquipAllHeroes

global_showingUnSyncHeroMsg_InView = false 

-- ----------------------- DisplayUnSyncHeroMsg_InView ------------------- --
function DisplayUnSyncHeroMsg_InView(viewSensor, message, msgTime)
--/ This IS NOT SYNCED. It will display a message only if the local hero 
--/ sees the view sensor. 
  
  if (in_local_view(viewSensor, true)) then 
    -- splitscreen games should only show the message once, otherwise it will become a blank box 
    if ((global_showingUnSyncHeroMsg_InView and (get_num_active_players() > 1) and not is_online_game())) then 
      -- do nothing 
    else
      global_showingUnSyncHeroMsg_InView = true
      show_training_message(message, msgTime, 0)
    end
  end 
  
end -- end DisplayUnSyncHeroMsg_InView

-- ======================================================================= --
-- =======                          ARRAYS                          ====== --
-- ======================================================================= --

-- ---------------------------- get_value_index -------------------------- --
function get_value_index(value, array)

  if (array == nil) then 
    return (-1)
  end 
  
  local i;
  for i = 1, #array, 1 do 
    if (array[i] == value) then 
      return (i)
    end
  end
  
  return (-1) -- if we get here, we didn't find it 
  
end -- end get_value_index

-- ---------------------- get_value_is_in_index -------------------------- --
function get_value_is_in_index(value, array)

  local i; 
  local internalIndex = -1
  for i = 1, #array, 1 do 
    if (type(array[i] == "table")) then 
      internalIndex = get_value_index(value, array[i])
      -- if the value is a member of this array, return the index of the array 
      if (internalIndex ~= -1) then 
        return(i)
      end
    end
  end
  
  return (-1) -- if we get here, we didn't find it 
  
end -- end get_value_is_in_index

-- ---------------------- get_random_unused_index ------------------------ --
function get_random_unused_index(array, numTries)
-- Array is an array of true/false values which show the index as valid or not. 
-- Returns a random index from this array that is set to false (unused). 
-- Note: This is NOT synced, take care when using it.


  -- we'll only try 30 times to get a valid index randomly
  numTries = numTries or 30
  
  local index = math.random(#array)
  -- if this index is used, try again 
  if (array[index]) then 
    if (numTries <= 0) then -- ran out of attempts to get this randomly, just get the first available index
      local i;
      for i = 1, #array, 1 do 
        if (not array[i]) then 
          return (i);
        end
      end
      return -1 -- there is no valid index
    else -- we've got more attempts we can make 
      return get_random_unused_index(array, numTries - 1) -- tail call
    end -- end if we have more attempts or not
  else -- else it is a good index, return it 
    return (index)
  end -- end if the randomly choosen index was valid or not

end -- end get_random_unused_index

-- -------------------------- getIndexWithExtremeValue -------------------- --
function getIndexWithExtremeValue(array, valueExtreme, allowTies)
--/ Returns an index array of indices with the lowest/highest value in the 
--/ passed in array. 
--/ valueExtreme == "lowest" or "highest"

  -- init
  local extValue = array[1]
  local indexArray = {1}
  allowTies = allowTies or false

  if (valueExtreme == "largest") then 
    valueExtreme = "highest"
  elseif (valueExtreme == "smallest") then 
    valueExtreme = "lowest"
  end
  
  local i;
  for i = 2, #array, 1 do 
    if (allowTies and (array[i] == extValue)) then 
      table.insert(indexArray, i)
    elseif  (((valueExtreme == "lowest") and (array[i] < extValue)) 
      or ((valueExtreme == "highest") and (array[i] > extValue))) then
      indexArray = {i}
      extValue = array[i]
    end
    
  end 
  
  if (allowTies) then 
    return (indexArray);
  else
    return (indexArray[1])
  end
  
end -- end getIndexWithExtremeValue

-- --------------------------- getExtremeValue --------------------------- --
function getExtremeValue (array, getWhichExtreme)
--/ Returns the largest/smallest (based on if largest == true or false) value
--/ in the passed in array.                 

  if (getWhichExtreme == nil) then 
    getWhichExtreme = "largest"
  end
  
  local extremeIndex = getIndexWithExtremeValue(array, getWhichExtreme, false)
  
  return (array[extremeIndex])
  
end -- end getExtremeValue

-- --------------------------- add_to_array ------------------------------ --
function add_to_array(array, addValue)

  -- arrays are passed as references, so changing it here will change it 
  -- outside this function's scope
  table.insert(array, addValue)
  
end -- end add_to_array

-- --------------------------- string_to_array --------------------------- --
function string_to_array(inputString, separator)
--/ Returns an array given by input string \--
  
  local search_string = "([^"..separator.."]*)"
  local outputArray = {}
  local field;
  for field in string.gmatch(inputString, search_string) do 
    -- not sure why, but field can be an empty string
    if (field ~= "") then 
      table.insert(outputArray, field)
    end
  end

  return (outputArray)
  
end -- end string_to_array

-- ----------------------- string_to_num_array --------------------------- --
function string_to_num_array(inputString, separator)

  local stringArray = string_to_array(inputString, separator)
  local numArray = {}
  local i;
  for i = 1, #stringArray, 1 do 
    numArray[i] = tonumber(stringArray[i])
  end 
  
  return (numArray)
  
end -- end string_to_num_array

-- ----------------------- string_to_boolean_array ----------------------- --
function string_to_boolean_array(inputString, separator)

  local stringArray = string_to_array(inputString, separator)
  local boolArray = {}
  local i;
  for i = 1, #stringArray, 1 do 
    if ((stringArray[i] == "true") or (stringArray[i] == 1)) then 
      boolArray[i] = true
    else
      boolArray[i] = false
    end
  end
  
  return (boolArray)
  
end -- end string_to_boolean_array

-- --------------------------- array_to_string --------------------------- --
function array_to_string(inputArray, separator)
--/ Returns a string that is the concatonated input Array (with the given separator). \--

  local stringArray = {}
  local outputString = {}
  if (inputArray == nil) then 
    prt("ERROR in universal_global: inputArray is NIL!")
    return;
  end
  -- this doesn't work for booleans, so test the first index and if it is a boolean, then convert to a string
  if ((tostring(inputArray[1]) == "false") or (tostring(inputArray[1]) == "true")) then
    local i;
    for i = 1, #inputArray, 1 do 
      stringArray[i] = tostring(inputArray[i])
    end
    outputString = table.concat(stringArray, separator)
  else
    outputString = table.concat(inputArray, separator)
  end
  
  return (outputString)
  
end -- end array_to_string

-- ---------------------------- ShuffleArray ---------------------------- --
function ShuffleArray(inputArray)
--/ Shuffles the passed in array (there is no need to return it as
--/ it will change the original array).
--/ Note: This is NOT synced. Take care when using it. 

  local i;
  local j;
  local rndIndex;
  -- to be extra shuffled, we will shuffle the array 10 times
  for i = 1, 10, 1 do 
    for j = #inputArray, 2, -1 do
      rndIndex = math.random(j)
      -- shortcut to swap two indicies
      inputArray[rndIndex], inputArray[j] = inputArray[j], inputArray[rndIndex]
    end
  end
  
end -- end ShuffleArray

-- ------------------------------- ArrayCopy ----------------------------- --
function ArrayCopy(toArray, fromArray)
--/ Copy the indicies of an array, not the reference. \--

  local i;
  for i = 1, #fromArray, 1 do 
    toArray[i] = fromArray[i]
  end

end -- end ArrayCopy


-- ------------------------------ ActivateArray -------------------------- --
function ActivateArray(actArray)

  local i;
  for i = 1, #actArray, 1 do 
    activate(actArray[i])
  end
  
end -- end ActivateArray

-- ------------------------- get_struct_from_idname ---------------------- --
function get_struct_from_idname(dict, name)

  local field;
  local value;
  for field, value in pairs(dict) do 
    if ((value.idName ~= nil) and (value.idName == name)) then 
      return(value)
    end
  end 
  
  return (nil)
  
end -- end get_struct_from_idname

-- ======================================================================= --
-- ======                           POD/SCENT                       ====== --
-- ======================================================================= --

-- ----------------------------- for_each_moby_in_pod -------------------- --
function for_each_moby_in_pod(pod, func) 
--/ This is a tweaked copy of foreach_moby_in_pod, which sadly doesn't work right now.
--[[ Original:
    function foreach_moby_in_pod(pod, func, ...) 
      --local arg = { ... }
      local moby = pod:get_first()
      while is_valid(moby) do
        func(moby, unpack(arg));
        moby = pod:get_next()
      end
    end
--]]

  local moby = pod:get_first()
  while (is_valid(moby)) do 
    func(moby)
    moby = pod:get_next()
  end
  
end -- end for_each_moby_in_pod

-- ------------------------ for_each_clue_in_scent ----------------------- --
function for_each_clue_in_scent(scent, func, arg)
--/ Goes through all the clues in the scent and runs the function with it. 
--/ Note: only 1 additional argument to the function is allowed. 

  local clue = scent:get_first()
  while (is_valid(clue)) do 
    if (arg ~= nil) then 
      func(clue, arg)
    else 
      func(clue)
    end
    clue = scent:get_next()
  end
  
end -- end for_each_clue_in_scent


-- ======================================================================= --
-- =======                          TIMER                           ====== --
-- ======================================================================= -- 

local activeTimers = {}

-- ----------------------------- StopCountdownTimer ------------------------- --
function StopCountdownTimer(name, doCallback)
-- NOTE: Need to remove the time from the table - this keeps it around 

  if (name == nil) then 
    name = "default"
  end 
  doCallback = doCallback or false 

  -- if we have no active timers, do nothing 
  if (#activeTimers == 0) then 
    return;
  end 
  
  local timerInfo = get_struct_from_idname(activeTimers, name)
  if (timerInfo == nil) then 
    prt("UniversalGlobal:StopCountdownTimer - timer " .. name .. " not found. ")
    return;
  end
  
  if (timerInfo.isActive) then 
    hud_stop_general_timer()
    
    if (timerInfo.eventHandle_doCallback ~= nil) then 
      unset_event(timerInfo.eventHandle_doCallback)
      timerInfo.eventHandle_doCallback = nil
    end
    -- run the end function if it was passed in 
    if (doCallback and timerInfo.callback ~= nil) then 
      timerInfo.callback()
    end
  
  end 
  
  timerInfo.isActive = false
  
end -- end StopCountdownTimer

-- ---------------------- StartCountdownTimer --------------- --
function StartCountdownTimer(totalTime, endFunc, name)
--/ Start a countdown timer, and call the passed in function when it ends. \--

  if (name == nil) then 
    name = "default"
  end
  
  local timerInfo = {
    tTime = totalTime, 
    idName = name,
    callback = endFunc,
    isActive = true
  }
  
  timerInfo.eventHandle_doCallback = on_elapsed(totalTime, function()
    timerInfo.eventHandle_doCallback = nil
    if ((timerInfo.callback ~= nil) and (type(timerInfo.callback) == "function")) then 
      timerInfo.callback()
    end
  end)
  
  hud_start_general_timer(totalTime, true)
  
  table.insert(activeTimers, timerInfo)
  
end -- end StartCountdownTimer

-- ======================================================================= --
-- =======                          COUNTER                         ====== --
-- ======================================================================= -- 

local counterUp = false

-- ---------------------------- StartCounter ----------------------------- --
function StartCounter(counterValue, currentValue, useCritterIcon)

  counterUp = true 
  useCritterIcon = useCritterIcon or false
  hud_start_vacu_ball_counter(counterValue, false, useCritterIcon)
  hud_set_vacu_ball_counter(currentValue)
  
end -- end StartCounter 

-- --------------------------- UpdateCounter ----------------------------- --
function UpdateCounter(currentValue)

  if (counterUp) then 
    hud_set_vacu_ball_counter(currentValue)
  end
  
end -- end UpdateCounter

-- ----------------------------- EndCounter ------------------------------ --
function EndCounter()

  hud_stop_vacu_ball_counter()
  counterUp = false 
  
end -- end EndCounter

-- ======================================================================= --
-- ======                      CINEMATICS                           ====== -- 
-- ======================================================================= --

global_cineTable_skippable = {abort = true}

 --[[

LUA::GetTableFieldPod   ( pstate, *table, "hide_pod",       *(u32*)&cp.m_hide_pod );
      LUA::GetTableFieldPod   ( pstate, *table, "reveal_pod",     *(u32*)&cp.m_reveal_pod );
      LUA::GetTableFieldVolume( pstate, *table, "warp_volume",    *(u32*)&cp.m_warp_volume );
      LUA::GetTableFieldEnum  ( pstate, *table, "pre_fade_out",   *(u32*)&cp.m_pre_fade_out );
      LUA::GetTableFieldEnum  ( pstate, *table, "pre_fade_in",    *(u32*)&cp.m_pre_fade_in );
      LUA::GetTableFieldEnum  ( pstate, *table, "post_fade_out",  *(u32*)&cp.m_post_fade_out );
      LUA::GetTableFieldEnum  ( pstate, *table, "post_fade_in",   *(u32*)&cp.m_post_fade_in );
      LUA::GetTableFieldBool  ( pstate, *table, "abort",                  cp.m_abortable );
      LUA::GetTableFieldBool  ( pstate, *table, "letterbox",              cp.m_letterbox );
      LUA::GetTableFieldBool  ( pstate, *table, "nocamwarp",              cp.m_no_cam_warp );

Pre fade in and out doesn't work

--]]


-- ============================================================================= --
-- ============================== onViewTrigger ================================ --
-- ============================================================================= --

-- Similar to the inAreaOnViewTrigger in global_vo but isn't used for conversations,
-- doesn't keep track of who saw the view sensor, and allows for instant repeat. 

onViewTrigger = {
  active = false,
  __doRepeat = false,
  __myLookAtCallbackFunc = nil,
  __myLookAtCallbackFuncParam = nil,
  __myLookAwayCallbackFunc = nil,
  __myLookAwayCallbackFuncParam = nil,
  __myViewSensor = nil,
  __viewSensorInView = false,
  __triggerEnabled = false,
  __cooldownTime = 2,
  __eventHandle_trig_timeOut = nil,
  __eventHandle_trig_lookAt = nil,
  __eventHandle_trig_lookAway = nil
}

-- --------------------- onViewTrigger:new ------------------------------- --
function onViewTrigger:new(viewSensor, callbackLookAt, callbackLookAtParam, 
                           callbackLookAway, callbackLookAwayParam, doRepeat, cooldownTime)
--/ This creates a new listener for a hero entering an area and seeing the view sensor
--/ upon which it will call the callback function. It will re-setup the trigger in repeatTime 
--/ time, unless it is < 0. 
  
  -- make sure we have a valid viewSensor, and callback function 
  if (viewSensor == nil) then 
    prt("ERROR onViewTrigger 'class' - needs a non-nil view sensor!")
    return;
  elseif (callbackLookAt == nil) then 
    prt("ERROR onViewTrigger 'class' - needs a non-nil callback function!")
    return;
  end
  
  -- and lets check the types as well 
  if (type(viewSensor) ~= "moby_handle") then 
    prt("ERROR onViewTrigger 'class' - passed in view sensor isn't a moby and therefore not a view sensor!")
    return;
  elseif (type(callbackLookAt) ~= "function") then 
    prt("ERROR onViewTrigger 'class' - passed in callback function isn't a function!")
    return;
  end

  local myTable = {}
  local i;
  local j;
  for i, j in pairs(self) do 
    myTable[i] = j
  end 
  setmetatable(myTable, self)
  myTable.__myLookAtCallbackFunc = callbackLookAt
  myTable.__myLookAtCallbackFuncParam = callbackLookAtParam
  myTable.__myLookAwayCallbackFunc = callbackLookAway
  myTable.__myLookAwayCallbackFuncParam = callbackLookAwayParam
  myTable.__myViewSensor = viewSensor
  if (doRepeat ~= nil) then 
    myTable.__doRepeat = doRepeat
  end
  if (cooldownTime ~= nil) then 
    myTable.__cooldownTime = cooldownTime
  end
  
  myTable.__eventHandle_trig_timeOut = event_handle:new()
  myTable.__eventHandle_trig_lookAt = event_handle:new()
  myTable.__eventHandle_trig_lookAway = event_handle:new()
  
  myTable.__triggerEnabled = true
  myTable.active = true
  
  myTable:SetupTrigger()
  
  return myTable
  
end -- end onViewTrigger:new

-- --------------------- onViewTrigger:TriggerLookAtCallback --------------------- --
function onViewTrigger:TriggerLookAtCallback() 

  if (self.__myLookAtCallbackFuncParam ~= nil) then 
    self.__myLookAtCallbackFunc(self.__myLookAtCallbackFuncParam)
  else
    self.__myLookAtCallbackFunc()
  end
  
end -- end onViewTrigger:TriggerLookAtCallback

-- ---------------------- onViewTrigger:TriggerLookAwayCallback ------------------ --
function onViewTrigger:TriggerLookAwayCallback() 

  if (self.__myLookAwayCallbackFunc ~= nil) then 
    if (self.__myLookAwayCallbackFuncParam ~= nil) then 
      self.__myLookAwayCallbackFunc(self.__myLookAwayCallbackFuncParam)
    else
      self.__myLookAwayCallbackFunc()
    end
  end
  
end -- end onViewTrigger:TriggerLookAwayCallback

-- ------------------------ onViewTrigger:SetupTrigger -------------------------- --
function onViewTrigger:SetupTrigger()
--/ Note:  Won't trigger if a player is already in the area and looking at the view sensor when this is called

  -- no need to do anything if we are no longer active
  if (not self.active) then 
    return;
  end 
  
  if (self.__eventHandle_trig_lookAt ~= nil) then 
    unset_event(self.__eventHandle_trig_lookAt)
    self.__eventHandle_trig_lookAt = nil
  end
  -- note: the view sensor will not trigger until the heroes are in the area associated with the view sensor 
  -- so we do not need to check anymore that heroes are in the area 
  self.__eventHandle_trig_lookAt = on_generic_event(self.__myViewSensor, GEN_EVENT_IN_VIEW, function()
    self.__viewSensorInView = true
    if (self.__triggerEnabled) then 
      self:TriggerLookAtCallback()
			if (not self.__doRepeat) then 
				self:UnsetTrigger()
			end
    end
  end)
  
  if (self.__eventHandle_trig_lookAway ~= nil) then 
    unset_event(self.__eventHandle_trig_lookAway)
    self.__eventHandle_trig_lookAway = nil
  end 
  self.__eventHandle_trig_lookAway = on_generic_event(self.__myViewSensor, GEN_EVENT_NONE_IN_VIEW, function()
    self.__viewSensorInView = false 
    if (self.__triggerEnabled) then 
      self:TriggerLookAwayCallback()
    end
    self.__triggerEnabled = false -- need a slight cooldown between triggers 
    if (self.__doRepeat) then 
      if (self.__eventHandle_trig_timeOut ~= nil) then 
        unset_event(self.__eventHandle_trig_timeOut)
        self.__eventHandle_trig_timeOut = nil
      end
      self.__eventHandle_trig_timeOut = on_elapsed(self.__cooldownTime, function()
        -- check to see if we've turned to look at it in the meantime 
        if (self.__viewSensorInView) then 
          self:TriggerLookAtCallback()
        end
        self.__triggerEnabled = true 
      end)
    else
			self.__triggerEnabled = true 
		end
  end)
  
end -- end onViewTrigger:SetupTrigger

-- ------------------------ onViewTrigger:UnsetTrigger -------------------------- --
function onViewTrigger:UnsetTrigger()
--/ Stop and unset the trigger logic. \--

  -- if we are already unset, do nothing
  if (not self.active) then 
    return;
  end
  
  self.active = false

  if (self.__eventHandle_trig_timeOut ~= nil) then 
    unset_event(self.__eventHandle_trig_timeOut)
    self.__eventHandle_trig_timeOut = nil
  end 
  
  if (self.__eventHandle_trig_lookAt ~= nil) then 
    unset_event(self.__eventHandle_trig_lookAt)
    self.__eventHandle_trig_lookAt = nil
  end 
  
  if (self.__eventHandle_trig_lookAway ~= nil) then 
    unset_event(self.__eventHandle_trig_lookAway)
    self.__eventHandle_trig_lookAway = nil
  end
  
  deactivate(self.__myViewSensor)
  
end -- end onViewTrigger:UnsetTrigger

-- ---------------------- onViewTrigger:isActive --------------------------------- --
function onViewTrigger:isActive()

  return(self.active)
  
end -- end onViewTrigger:isActive

-- ----------------------- onViewTrigger:inView ---------------------------------- --
function onViewTrigger:inView()
--/ Returns whether or not the view sensor is in view (in the area) of anyone. \--
  
  return (self.__viewSensorInView)
    
end -- end onViewTrigger:inView

-- ======================================================================= --
-- =======                       COMPETITIVE                        ====== --
-- ======================================================================= -- 

local pvpGameOn = true

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PVP LEVEL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

local compPhase = "none"
local numRounds = 0 
forcefields = {}
enemy_purchaser = {}
enemy_purchase_clues = {}
enemy_baseDisplay = {}
pvp_baseGenerators = {}

-- is_inside isn't synced, so we need to just keep track of when 
-- players are at the wrong base for determining when to end the invasion phase 
heroAtWrongBase = {false, false, false, false} -- index is (playerID + 1)
heroIsDead = {false, false, false, false} -- is_alive isn't synced anymore, need a bool flag 
waitForAllHeroesLeaveEnemyBases = false 

local baseArea = {}
local team1_warpVols = {}
local team2_warpVols = {}

FARM_TIME  = 60*2.5
SQUAD_TIME = 60

MAX_NUM_ROUNDS = 6

local maxBaseInv_wave = 1
local STAGE_DELAY = 5 

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PVP HEROES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -- 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

-- ------------------ SetupComp_PlayerAliveMonitor -------------------- --
local function SetupComp_PlayerAliveMonitor(hero, playerID)
  
  local rightBaseArea = baseArea[2]
  if (get_node_team(hero) == HERO.HERO_TEAM_1) then 
    rightBaseArea =  baseArea[1]
  end  
  
  -- is_alive isn't synced, so we need to use on_death to monitor when they are dead
  -- but there is no on_alive, so we will listen to heroes entering their own base to flag them 
  -- as alive (they could be dead at their own base, but as all our checks for when they are dead are 
  -- also looking at heroes at the wrong base, this is okay 
  on_enter(hero, rightBaseArea, function()
    heroIsDead[playerID + 1] = false 
    unset_event()
  end)
  
end -- end SetupComp_PlayerAliveMonitor

-- ---------------------- Comp_SetupPlayingReviveVO_OnHeroDeath ---------------- --
local function Comp_SetupPlayingReviveVO_OnHeroDeath(hero, playerID)
--/ Apparently on_deaths are unset automatically :^/ So we will need to 
--/ reset it ever time the hero dies. 

  on_death(hero, function() 
    heroIsDead[playerID + 1] = true -- the hero entering their own base with throw the flag that they are alive
    SetupComp_PlayerAliveMonitor(hero, playerID) -- add listener for the hero entering their base (done on respawn)
    on_elapsed(2, function()
      PlayVO_Comp_Gen_HeroDown(hero)
    end)
    Comp_SetupPlayingReviveVO_OnHeroDeath(hero, playerID)
    -- don't want to have to wait for an enemy to leave the base via respawn to end the round, if killing someone 
    -- removes everyone from the wrong base we should end the phase now
    if (waitForAllHeroesLeaveEnemyBases) then 
      if (not Comp_isAnyoneAtWrongBase()) then 
        waitForAllHeroesLeaveEnemyBases = false
        invasionPhaseActive = false 
        -- start another round 
        StartCompRound()
      end
    end
    unset_event() -- unnecessary, as it auto unsets, but for clarity
  end)

end -- end Comp_SetupPlayingReviveVO_OnHeroDeath

-- --------------------------- Comp_SetupHeroDownVO --------------------------- --
function Comp_SetupHeroDownVO()
  
  local i;
  local hero;
  for i = 4, 8, 4 do 
    hero = get_hero_at_player_id(i - 1)
    if (is_hero_active(hero)) then 
      Comp_SetupPlayingReviveVO_OnHeroDeath(hero, i-1)
    end
  end
  
end -- end Comp_SetupHeroDownVO

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~ PVP MINION INVASION ~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

invasionPhaseActive = false 
triggeredEndOfMinionInvasion = false
local eventListeners_baseAssaultOver = event_handle:new()

-- north and south invasions are identical, just for each of the bases
baseInvasions = {}

-- brawler, mortar, swarmers, tank1, tank2 (skipping missile minion for now)
local waveTypes = {WPN_BRAWLER, WPN_BOMBER, WPN_SWARMER, WPN_TANK}
local perkEnemyTypes = {PERK_SQUAD_BRAWLER, PERK_SQUAD_BOMBER, PERK_SQUAD_SWARMER, PERK_SQUAD_TANK}
local tankEliteHPIncrease = 200 

baseInvasion_defaultCount = {0, 0, 1, 0, 0}
baseInvasion_defaultDelay = {10, 15, 10, 5, 5}

local all_min_time = 5
local all_next_phase_delay = 10 
local infInvasionActive = false

local comp_purchasePads = {}

local brawlerIndex = 1
local mortarIndex = 2
local swarmerIndex = 3
local tankIndex = 4

-- ------------------------------- getPerkEnemyTypeFromEnemyType ------------- --
local function getPerkEnemyTypeFromEnemyType(enemyType)

  local i; 
  for i = 1, #waveTypes, 1 do 
    if (enemyType == waveTypes[i]) then 
      return (perkEnemyTypes[i])
    end
  end 
  -- if we got here, we found nothing
  return nil;
  
end -- end getPerkEnemyTypeFromEnemyType

-- ------------------------------- InitCompInvData --------------------------- --
local function InitCompInvData()

  baseInvasions = {}
  local i; 
  for i = 1 , #waveTypes, 1 do 
    baseInvasions[i] = {}
    baseInvasions[i].squadClues = {}
    baseInvasions[i].squadWave = {}
    baseInvasions[i].count = {}
    baseInvasions[i].is_tank = {}
    baseInvasions[i].is_drone = {}
    baseInvasions[i].boughtBy = {}
    baseInvasions[i].allow_timer = true -- reset our VO flag
    baseInvasions[i].next_phase_delay = 0
  end
end -- end InitCompInvData

-- --------------------------- ResetBaseInvasionSpawnCounts ------------------ --
function ResetBaseInvasionSpawnCounts()

  local i;
  for i = 1, #baseInvasions, 1 do
    baseInvasions[i].squadClues = {}
    baseInvasions[i].squadWave = {}
    baseInvasions[i].count = {}
    baseInvasions[i].is_tank = {}
    baseInvasions[i].is_drone = {}
    baseInvasions[i].boughtBy = {}
    baseInvasions[i].allow_timer = true -- reset our VO flag
    baseInvasions[i].next_phase_delay = 0
  end
    
end -- end ResetBaseInvasionSpawnCounts

-- -------------------------- UnsetBaseInvasionListeners --------------------------- --
local function UnsetBaseInvasionListeners()

  if (eventListeners_baseAssaultOver ~= nil) then 
    unset_event(eventListeners_baseAssaultOver)
    eventListeners_baseAssaultOver = nil
  end

end -- end UnsetBaseInvasionListeners

-- -------------------------- Comp_BaseInvasionPhaseOver --------------------------- --
function Comp_BaseInvasionPhaseOver(waitForEndOfInv)
  

  -- do nothing if we've already registered the end of the invasion 
  if (triggeredEndOfMinionInvasion) then 
    return;
  end 
  
  if (waitForEndOfInv == nil) then 
    waitForEndOfInv = true 
  end 
  
  -- only end the invasion phase if we are in the invasion phase
  if (not invasionPhaseActive) then 
    return;
  end 
  
  -- if we are supposed to wait for the end of the invasion and the invasion is not over, return 
  if (waitForEndOfInv and global_spec_invasion_active) then 
    return;
  end
  
  -- make sure we run this function only once despite our delay to unseting the listener
  triggeredEndOfMinionInvasion = true 
  -- for some reason, if we do not have a delay here, the next on_elapsed will not trigger :^/
  on_elapsed(0.5, UnsetBaseInvasionListeners)
  
  -- reset our wave counts 
  ResetBaseInvasionSpawnCounts()
  clear_all_purchased_waves()
  
  -- let the PVP script know that the minion invasion is over 
  MinionInvasionOver_Comp() 
  
end -- end Comp_BaseInvasionPhaseOver

--  ----------------------- InvasionPhase_AllSpawned --------------------- --
function InvasionPhase_AllSpawned()

  prt("All invasion dudes spawned")
  --set_enemies_approaching(false) -- just a failsafe that enemies approaching is false so the wave-bar event will trigger
  
end -- end InvasionPhase_AllSpawned

-- --------------------- Comp_ListenForEndOfBaseAttack -------------------------- --
function Comp_ListenForEndOfBaseAttack()  
--/ Listens for the all clear from the enemy wave HUD bar to play the 
--/ assault over VO and the victory stinger. 

  prt("Listening for the invasion hud to go away")
  triggeredEndOfMinionInvasion = false 
  if (eventListeners_baseAssaultOver ~= nil) then 
    unset_event(eventListeners_baseAssaultOver)
    eventListeners_baseAssaultOver = nil
  end 
  eventListeners_baseAssaultOver = on_invasion_over(Comp_BaseInvasionPhaseOver)

end -- end Comp_ListenForEndOfBaseAttack

-- --------------------------- CreateCompWaveData_getClue ------------------ --
local function CreateCompWaveData_getClue(enemyType, team, lane)

  if (enemyType == 0) then
    return -1
  end 
  
  local enemyTypeList = {WPN_SWARMER, WPN_BRAWLER, WPN_BOMBER, WPN_TANK}
  local clueList = minionClues_NB
  if (team == HERO.HERO_TEAM_1) then 
    clueList = minionClues_SB 
  end 
  
  local enemyTypeI = -1 
  local i;
  for i = 1, #enemyTypeList, 1 do 
    if (enemyType == enemyTypeList[i]) then 
      enemyTypeI = i 
      break; 
    end
  end 
  
  if (enemyTypeI == -1) then 
    return (-1) 
  end 
  
  local index = ((enemyTypeI -1) * 2) + (lane)
  return (clueList[index])
  
  
end -- end CreateCompWaveData_getClue

-- ---------------------- Comp_getWreckingDroneClue ------------------------ --
function Comp_getWreckingDroneClue(team, lane)

  local clueList = wreckingDroneClues_NB
  if (team == HERO.HERO_TEAM_1) then 
    clueList = wreckingDroneClues_SB 
  end 
  
  return (clueList[lane])
  
end -- end Comp_getWreckingDroneClue

-- -------------------------- CreateCompWaveData --------------------------- --
local function CreateCompWaveData(waveInfo, team) 

  local i; 
  local j; 
  for i = 1, #waveInfo, 1 do 
    for j = 1, #waveInfo[i], 1 do 
      local enemyType = waveInfo[i][j]
    --  prt("TEAM " .. tostring(team) .. " Wave " .. i .. " lane " .. j .. " is " .. tostring(enemyType))  
      local enemyClue = CreateCompWaveData_getClue(enemyType, team, j)
      local useElites = false 
      -- spawn elites if they've been unlocked
      local perkType = getPerkEnemyTypeFromEnemyType(enemyType)
      if ((perkType ~= nil) and (is_base_perk_purchased(team, perkType))) then 
        useElites = true 
      end
      
      if (type(enemyClue) == "clue_handle") then
        if ((not useElites) or (enemyType ~= WPN_BRAWLER)) then 
          table.insert(baseInvasions[i].squadClues, enemyClue)
        else -- elite brawlers are actually wrecking drones 
          table.insert(baseInvasions[i].squadClues, Comp_getWreckingDroneClue(team, j))
        end
        -- spawn the right wave based on whether to spawn elites or not
        if (not useElites) then 
          table.insert(baseInvasions[i].squadWave, 1) -- regular
        else
          table.insert(baseInvasions[i].squadWave, 2) -- elite
        end
        table.insert(baseInvasions[i].count, 1)
        table.insert(baseInvasions[i].boughtBy, team)
        if (baseInvasions[i].is_tank == nil) then 
          baseInvasions[i].is_tank = {}
        end 
        if (baseInvasions[i].is_drone == nil) then 
          baseInvasions[i].is_drone = {}
        end
        local isTank = false
        local isDrone = false
        if (enemyType == WPN_TANK) then 
          isTank = true
        elseif (useElites and (enemyType == WPN_BRAWLER)) then -- "elite" brawlers are wrecking drones
          isDrone = true 
        end
        table.insert(baseInvasions[i].is_tank, isTank) 
        table.insert(baseInvasions[i].is_drone, isDrone) 

        baseInvasions[i].min_time = all_min_time
        baseInvasions[i].next_phase_delay = all_next_phase_delay
        baseInvasions[i].allow_timer = true
      end
    end
  end 
end -- end CreateCompWaveData

-- -------------------------- CreateCompWaveData_DefaultSpawn -------------- --
local function CreateCompWaveData_DefaultSpawn(curRoundNum)

  -- figure out if the default waves should be elite or not 
  local defaultSquadWaves = {{1, 1, 1, 1}, {1, 1, 1, 1}}
  local useDrones = {false, false}
  local teams = {HERO.HERO_TEAM_1, HERO.HERO_TEAM_2}
  local enemyTypes = {PERK_SQUAD_SWARMER, PERK_SQUAD_BRAWLER}
  local i; 
  local eType; 
  local index;
  for i = 1, 2, 1 do 
    for eType = 1, #enemyTypes, 1 do 
      if (is_base_perk_purchased(teams[i], enemyTypes[eType])) then 
        if (eType == 2) then -- brawler 
          useDrones[i] = true 
        else -- wrecking drones use wave 1, swarmer elites are wave 2
          for index = 2*i - 1, 2*i, 1 do 
            defaultSquadWaves[eType][index] = 2 -- elite wave 
          end
        end
      end 
    end 
  end 
  
  
  -----------------
  -- Swarmers
  -----------------
  
  baseInvasions[5] = {
    squadClues = {CreateCompWaveData_getClue(WPN_SWARMER, HERO.HERO_TEAM_1, 1), 
             CreateCompWaveData_getClue(WPN_SWARMER, HERO.HERO_TEAM_1, 2),
             CreateCompWaveData_getClue(WPN_SWARMER, HERO.HERO_TEAM_2, 1),
             CreateCompWaveData_getClue(WPN_SWARMER, HERO.HERO_TEAM_2, 2)
             }, 
    squadWave = defaultSquadWaves[1],
    count = {1, 1, 1, 1}, 
    boughtBy = {HERO.HERO_TEAM_1, HERO.HERO_TEAM_1,HERO.HERO_TEAM_1, HERO.HERO_TEAM_1, HERO.HERO_TEAM_2, HERO.HERO_TEAM_2, HERO.HERO_TEAM_2, HERO.HERO_TEAM_2},
    min_time = all_min_time,
    next_phase_delay = all_next_phase_delay
  }
  
  ---------------
  -- Brawlers
  ---------------
  
  local defaultRegBrawlerClues = {CreateCompWaveData_getClue(WPN_BRAWLER, HERO.HERO_TEAM_1, 1), 
                                  CreateCompWaveData_getClue(WPN_BRAWLER, HERO.HERO_TEAM_1, 2),
                                  CreateCompWaveData_getClue(WPN_BRAWLER, HERO.HERO_TEAM_2, 1),
                                  CreateCompWaveData_getClue(WPN_BRAWLER, HERO.HERO_TEAM_2, 2)
                                  }
  local defaultDroneClues = { Comp_getWreckingDroneClue(HERO.HERO_TEAM_1, 1), 
                              Comp_getWreckingDroneClue(HERO.HERO_TEAM_1, 2),
                              Comp_getWreckingDroneClue(HERO.HERO_TEAM_2, 1),
                              Comp_getWreckingDroneClue(HERO.HERO_TEAM_2, 2)
                            }
  local isDrone = {false, false, false, false}
  local defaultBrawlerClues = {}
  if (useDrones[1]) then 
    defaultBrawlerClues[1] = defaultDroneClues[1]
    defaultBrawlerClues[2] = defaultDroneClues[2]
    isDrone[1] = true 
    isDrone[2] = true
  else
    defaultBrawlerClues[1] = defaultRegBrawlerClues[1]
    defaultBrawlerClues[2] = defaultRegBrawlerClues[2]
  end
  if (useDrones[2]) then 
    defaultBrawlerClues[3] = defaultDroneClues[3]
    defaultBrawlerClues[4] = defaultDroneClues[4]
    isDrone[3] = true 
    isDrone[4] = true
  else
    defaultBrawlerClues[3] = defaultRegBrawlerClues[3]
    defaultBrawlerClues[4] = defaultRegBrawlerClues[4]
  end
  
  baseInvasions[6] = nil 
  if (curRoundNum >= 2) then 
   baseInvasions[6] = {
    squadClues = defaultBrawlerClues, 
    squadWave = defaultSquadWaves[2],
    count = {1, 1, 1, 1}, 
    boughtBy = {HERO.HERO_TEAM_1, HERO.HERO_TEAM_1,HERO.HERO_TEAM_1, HERO.HERO_TEAM_1, HERO.HERO_TEAM_2, HERO.HERO_TEAM_2, HERO.HERO_TEAM_2, HERO.HERO_TEAM_2},
    is_drone = isDrone,
    min_time = all_min_time,
    next_phase_delay = all_next_phase_delay
  }
  end
  
end -- CreateCompWaveData_DefaultSpawn

-- -------------------------- Comp_StartBaseInvasion ----------------------- --
function Comp_StartBaseInvasion(curRoundNum)
  
  
  local r1 = 0;
  local r2 = 0;
  local r3 = 0;
  local r4 = 0;
  local l1 = 0;
  local l2 = 0;
  local l3 = 0;
  local l4 = 0;
  
  local heroTeams = {HERO.HERO_TEAM_1, HERO.HERO_TEAM_2}

  local i;
  local j;
  for i = 1, 2, 1 do 
    l1 = get_purchased_wave(LEFT_1, heroTeams[i]);
    l2 = get_purchased_wave(LEFT_2, heroTeams[i]);
    l3 = get_purchased_wave(LEFT_3, heroTeams[i]);
    l4 = get_purchased_wave(LEFT_4, heroTeams[i]);
    r1 = get_purchased_wave(RIGHT_1, heroTeams[i]);
    r2 = get_purchased_wave(RIGHT_2, heroTeams[i]);
    r3 = get_purchased_wave(RIGHT_3, heroTeams[i]);
    r4 = get_purchased_wave(RIGHT_4, heroTeams[i]);
    
 --     prt("Purchase = " .. l1 .. ", " .. l2 .. ", " .. l3 .. ", " .. r1 .. ", " .. r2 .. ", " .. r3)
    local waveInfo = {{l1, r1}, {l2, r2}, {l3, r3}, {l4, r4}}
    CreateCompWaveData(waveInfo, heroTeams[i])        
  end 
  
  CreateCompWaveData_DefaultSpawn(curRoundNum)
 
  Comp_ListenForEndOfBaseAttack()
  TriggerSpecificInvasion(baseInvasions, InvasionPhase_AllSpawned, true)
  
  invasionPhaseActive = true 
  
end -- end Comp_StartBaseInvasion

-- ------------------------- SetupPVPTankClueSpawns ---------------------- --
function SetupPVPTankClueSpawns(tankClueArray)
  local teams = {HERO.HERO_TEAM_2, HERO.HERO_TEAM_1}
  local i; 
  local j; 
  for i = 1, 2, 1 do 
    for j = 1, #tankClueArray[i], 1 do 
      on_ai_spawned(tankClueArray[i][j], function()
        local tank = get_moby_handle_from_setup(tankClueArray[i][j])
        -- check if "elite" tanks are purchased
        if (is_base_perk_purchased(teams[i], PERK_SQUAD_TANK)) then 
          set_moby_scale(tank, 0.35) -- 0.38 is the default, but PHPVP has low entrances :^<
          -- set the shader doesn't actually work - code overrides it every frame
          --set_moby_shader(tank, 0) -- yellow. Everyone gets yellow! (can't patch a new texture at this time)
          set_tank_elite_shader(tank)
          local curHealth = enemy_get_health_abs(tank)
          curHealth = curHealth + tankEliteHPIncrease
          enemy_set_health(tank, curHealth, curHealth)
        else
          -- the default scale of 0.38 but we need to go smaller 
          -- to sell the difference between the reg and elite tanks
          -- as the elite tank is actually smaller than the normal tank 
          -- we can't decrease the scale too much or the tank doesn't feel right 
          -- for his scale 
          set_moby_scale(tank, 0.3) 
        end
        -- do not unset 
      end)  
    end -- end for the team's tanks 
  end -- end for the tank array
end -- end SetupPVPTankClueSpawns

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~ PVP ENEMY BASE DISPLAY ~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

local p1_squadPurchased = {{false, false, false, false}, {false, false, false, false}, {false, false, false, false}, {false, false, false, false}}
local p2_squadPurchased = {{false, false, false, false}, {false, false, false, false}, {false, false, false, false}, {false, false, false, false}}
local squadPurchasedTable = {p1_squadPurchased, p2_squadPurchased}

local leftLaneNumPurchase = {0, 0}
local rightLaneNumPurchase = {0, 0}

-- ----------------------- Comp_BaseDisplay_ResetSquadPurchases ---------- --
local function Comp_BaseDisplay_ResetSquadPurchases()
--/ Reset our table that keeps track of pads used for the enemy base display arrows.

  local baseI;
  local sideI;
  local padI;
  for baseI = 1, 2, 1 do 
    -- turn of the arrows
    bangle_off(enemy_baseDisplay[baseI - 1], 0, true)
    bangle_off(enemy_baseDisplay[baseI - 1], 1, true)
    for sideI = 1, 2, 1 do 
      for padI = 1, 4, 1 do 
        squadPurchasedTable[baseI][sideI][padI] = false 
      end 
    end 
  end 
  
end -- end Comp_BaseDisplay_ResetSquadPurchases

-- ----------------------- Comp_Setup_TeamBaseDisplay_Arrow -------------- --
function Comp_Setup_TeamBaseDisplay_Arrow(displayIndex, padSideArray, sidePurCounter, arrowBangleIndex)
  local i; 
  -- listen to purchases and cancels of purchases on the lane 
  -- showing the arrow when there is a purchase on the lane 
  for i = 1, #padSideArray, 1 do 
    on_generic_event(padSideArray[i], GEN_EVENT_PVP_ENEMY_PURCHASE, function()
      if (infInvasionActive) then 
        return Comp_InfInvPhase_DoSquadPurchase(displayIndex, arrowBangleIndex, i)
      end
      if (sidePurCounter[displayIndex + 1] == 0) then 
        bangle_on(enemy_baseDisplay[displayIndex], arrowBangleIndex, true)
      end
      local sideI = arrowBangleIndex + 1 
      local padI = i 
      -- check to see if this is a new purchase, if so increment our counter 
      if (not squadPurchasedTable[displayIndex + 1][sideI][padI]) then 
        squadPurchasedTable[displayIndex + 1][sideI][padI] = true 
        sidePurCounter[displayIndex + 1] = sidePurCounter[displayIndex + 1] + 1
      end
    end)
    on_generic_event(padSideArray[i], GEN_EVENT_PVP_ENEMY_SOLD, function()
      local sideI = arrowBangleIndex + 1 
      local padI = i 
      squadPurchasedTable[displayIndex + 1][sideI][padI] = false
      sidePurCounter[displayIndex + 1] = sidePurCounter[displayIndex + 1] - 1
      if (sidePurCounter[displayIndex + 1] <= 0) then 
        sidePurCounter[displayIndex + 1] = 0 
        bangle_off(enemy_baseDisplay[displayIndex], arrowBangleIndex, true)
      end
    end)
  end 
end -- end Comp_Setup_TeamBaseDisplay_Arrow
  
-- --------------------- Comp_Setup_TeamBaseDisplay_Gens ------------------ --
local function Comp_Setup_TeamBaseDisplay_Gens(displayIndex, genArray) 

  local bangleIndex = {7, 6, 5, 4, 3, 2}
  
  local i; 
  for i = 1, #genArray, 1 do 
    on_death(genArray[i], function()
      bangle_off(enemy_baseDisplay[displayIndex], bangleIndex[i], true)
      unset_event()
    end)
  end 
end -- end Comp_Setup_TeamBaseDisplay_Gens

-- ------------------------ Comp_Setup_TeamBaseDisplay -------------------- --
local function Comp_Setup_TeamBaseDisplay(displayIndex, purchasePadArray, genArray)

  -- start in the closed state 
  play_anim_query(enemy_baseDisplay[displayIndex], AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSED_IDLE)
  deactivate(enemy_baseDisplay[displayIndex])
  
  -- turn off the arrows
  bangle_off(enemy_baseDisplay[displayIndex], 0, true)
  bangle_off(enemy_baseDisplay[displayIndex], 1, true)
  
  Comp_Setup_TeamBaseDisplay_Arrow(displayIndex, purchasePadArray[1], leftLaneNumPurchase, 0)
  Comp_Setup_TeamBaseDisplay_Arrow(displayIndex, purchasePadArray[2], rightLaneNumPurchase, 1)
  
  Comp_Setup_TeamBaseDisplay_Gens(displayIndex, genArray)
  
end -- end Comp_Setup_TeamBaseDisplay

-- ------------------------ Comp_Setup_EnemyBaseDisplays ------------------ --
local function Comp_Setup_EnemyBaseDisplays(purchasePadTable, generatorTable)

  Comp_Setup_TeamBaseDisplay(0, purchasePadTable[1], generatorTable[2])
  Comp_Setup_TeamBaseDisplay(1, purchasePadTable[2], generatorTable[1])
  
end -- end Comp_Setup_EnemyBaseDisplays

-- -------------------------- Comp_EnemyBaseDisplay_Open ----------------- --
local function Comp_EnemyBaseDisplay_Open()

  Comp_BaseDisplay_ResetSquadPurchases()
  
  play_anim_query(enemy_baseDisplay[0], AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN)
  play_anim_query(enemy_baseDisplay[1], AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN)
  activate(enemy_baseDisplay[0])
  activate(enemy_baseDisplay[1])

end -- end Comp_EnemyBaseDisplay_Open

-- -------------------------- Comp_EnemyBaseDisplay_Close ----------------- --
local function Comp_EnemyBaseDisplay_Close()

  play_anim_query(enemy_baseDisplay[0], AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
  play_anim_query(enemy_baseDisplay[1], AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
  deactivate(enemy_baseDisplay[0])
  deactivate(enemy_baseDisplay[1])

end -- end Comp_EnemyBaseDisplay_Close

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SQUAD PADS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

-- -------------------------- Comp_DoTeleEffect -------------------------- --
function Comp_DoTeleEffect(mobyForFX)
  
  trigger_effect_event(EventType.TELEPORTED, mobyForFX)
  
end -- end Comp_DoTeleEffect

-- -------------------------- Comp_HideSquadPads ------------------------- --
function Comp_HideSquadPads()
  
  deactivate(enemy_purchaser[0])
  deactivate(enemy_purchaser[1])
 -- for_each_moby_in_pod(enemy_purchaser[0], Comp_DoTeleEffect)
 -- for_each_moby_in_pod(enemy_purchaser[1], Comp_DoTeleEffect)
  hide(enemy_purchaser[0])
  hide(enemy_purchaser[1])
  deactivate(enemy_purchase_clues[0])
  deactivate(enemy_purchase_clues[1])
  
end -- end Comp_HideSquadPads

-- ------------------------- Comp_RevealSquadPads ------------------------ --
function Comp_RevealSquadPads()

  reveal(enemy_purchaser[0])
  reveal(enemy_purchaser[1])
--  for_each_moby_in_pod(enemy_purchaser[0], Comp_DoTeleEffect)
--  for_each_moby_in_pod(enemy_purchaser[1], Comp_DoTeleEffect)
  activate(enemy_purchaser[0])
  activate(enemy_purchaser[1])
  activate(enemy_purchase_clues[0])
  activate(enemy_purchase_clues[1])
  
end -- end Comp_RevealSquadPads

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HERO BASE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

-- ------------------- Comp_Setup_TeamGenHealthMapIcons ------------------ --
local function Comp_Setup_TeamGenHealthMapIcons(genArray, teamID)

  local i;
  for i = 1, #genArray, 1 do 
    radar_set_generator((i-1), genArray[i], teamID)
  end 
  
end -- end Comp_Setup_TeamGenHealthMapIcons

-- ------------------- Comp_Setup_HeroGenHealthMapIcons ------------------ -- 
local function Comp_Setup_HeroGenHealthMapIcons(generatorTable)

  Comp_Setup_TeamGenHealthMapIcons(generatorTable[1], HERO.HERO_TEAM_1)
  Comp_Setup_TeamGenHealthMapIcons(generatorTable[2], HERO.HERO_TEAM_2)
  
end -- end Comp_Setup_HeroGenHealthMapIcons

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PERK KIOSKS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -- 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -- 

local HEALTHSPAWNTIME_DEFAULT = 30
local HEALTHSPAWNTIME_UPGRADE = 5

-- ---------------------- CompPerkKiosk_BoughtTurrets -------------------- --
function CompPerkKiosk_BoughtTurrets(kioskInfo)

  local i;
  local giveFreebie = is_defense_available(WPN_COMBUSTER);
  -- reveal and enable the "new" turret pads
  for i = 1, #kioskInfo.baseTurretArray, 1 do 
    reveal(kioskInfo.baseTurretArray[i])
    trigger_effect_event(EventType.TELEPORTED, kioskInfo.baseTurretArray[i])
    activate(kioskInfo.baseTurretClueArray[i])
  end
  
  -- grant some free turrets
  if (giveFreebie == true) then
    for i = 1, #kioskInfo.freeTurretArray, 1 do
      -- 0 == combuster
      set_turret_type(kioskInfo.freeTurretArray[i], 0)
    end
    for i = 1, #kioskInfo.freeTurretClueArray, 1 do
      set_purchase_level(kioskInfo.freeTurretClueArray[i], 1)
    end
  end

end -- end CompPerkKiosk_BoughtTurrets

-- ----------------------- CompPerkKiosk_BoughtCrates -------------------- --
function CompPerkKiosk_BoughtCrates(kioskInfo)

  local i; 
  
  -- reveal the missing ammo spawner
  if (kioskInfo.purAmmoSpawner ~= nil) then 
    reveal(kioskInfo.purAmmoSpawner)
  end
  
  -- spawn a new ammo spawner 
  if (kioskInfo.purAmmoSpawnerLoc ~= nil) then 
    spawn_crate_spawner(kioskInfo.purAmmoSpawnerLoc, kioskInfo.kioskTeam)
  end 
  if (kioskInfo.purAmmoSpawnerLocArray ~= nil) then 
    for i = 1, #kioskInfo.purAmmoSpawnerLocArray, 1 do 
      spawn_crate_spawner(kioskInfo.purAmmoSpawnerLocArray[i], kioskInfo.kioskTeam)
    end
  end
  
  -- decrease the spawn time of health crates 
  for i = 1, #kioskInfo.healthSpawnerArray, 1 do 
    set_crate_spawner_time(HEALTHSPAWNTIME_UPGRADE, kioskInfo.healthSpawnerArray[i])
  end
  
end -- end CompPerkKiosk_BoughtCrates

-- --------------------- CompPerkKiosk_BoughtShields --------------------- --
function CompPerkKiosk_BoughtShields(kioskInfo)

  prt("CompPerkKiosk_BoughtShields") 

  local i;
  local giveFreebie = is_defense_available(WPN_WEAK_BARRICADE);
  for i = 1, #kioskInfo.innerShieldMobyArray, 1 do 
    reveal(kioskInfo.innerShieldMobyArray[i])
    prt("reveal") 
    trigger_effect_event(EventType.TELEPORTED, kioskInfo.innerShieldMobyArray[i])
    if (giveFreebie == true) then
      -- grant a free shield
      set_turret_type(kioskInfo.innerShieldMobyArray[i], WPN_WEAK_BARRICADE)
      activate(kioskInfo.innerShieldMobyArray[i])
      prt("giveFreebie") 
    end
  end
  for i = 1, #kioskInfo.innerShieldClueArray, 1 do 
    activate(kioskInfo.innerShieldClueArray[i])
    prt("activate") 
    -- grant a free shield
    if (giveFreebie == true) then
      set_purchase_level(kioskInfo.innerShieldClueArray[i], 1)
      prt("activate") 
    end
  end

end -- end CompPerkKiosk_BoughtShields

-- --------------------- CompPerkKiosk_BoughtWarmongers ------------------ --
function CompPerkKiosk_BoughtWarmongers(kioskInfo)
  local i;
  -- reveal and enable the "new" turret pads
  for i = 1, #kioskInfo.freeWarmongerArray, 1 do 
    reveal(kioskInfo.freeWarmongerArray[i])
    trigger_effect_event(EventType.TELEPORTED, kioskInfo.freeWarmongerArray[i])
    -- 1 == warmonger
    set_turret_type(kioskInfo.freeWarmongerArray[i], 1)
  end
  for i = 1, #kioskInfo.freeWarmongerClueArray, 1 do
    activate(kioskInfo.freeWarmongerClueArray[i])
    set_purchase_level(kioskInfo.freeWarmongerClueArray[i], 1)
  end
  
end -- end CompPerkKiosk_BoughtWarmongers

-- ----------------------- SetupComp_BasePerkKiosk ----------------------- --
local function SetupComp_BasePerkKiosk(kioskInfo)

  local i;
  
  -------------------
  -- Turret Pads 
  -------------------
  
  -- hide the turret pads that we will enable purchase of 
  for i = 1, #kioskInfo.baseTurretArray, 1 do 
    deactivate(kioskInfo.baseTurretArray[i])
    hide(kioskInfo.baseTurretArray[i])
    deactivate(kioskInfo.baseTurretClueArray[i])
  end
  
  on_generic_event(kioskInfo.kioskMoby, GEN_EVENT_BASE_PERK_BUILDPAD, function()
    CompPerkKiosk_BoughtTurrets(kioskInfo)
    unset_event()
  end)
  
  -------------------
  -- Crate Spawners 
  -------------------
  -- no more ammo/health crate perk 
  --[[
  if (kioskInfo.purAmmoSpawner ~= nil) then 
    hide(kioskInfo.purAmmoSpawner)
  end
  
  for i = 1, #kioskInfo.healthSpawnerArray, 1 do 
    set_crate_spawner_time(HEALTHSPAWNTIME_DEFAULT, kioskInfo.healthSpawnerArray[i])
  end
  

  on_generic_event(kioskInfo.kioskMoby, GEN_EVENT_BASE_PERK_CRATES, function()
    CompPerkKiosk_BoughtCrates(kioskInfo)
    unset_event()
  end)
  --]]
  
  -------------------
  -- Inner Shields 
  -------------------
  -- add a hacky delay here so that barriers get a chance to update before hiding, 
  -- this gives them a chance to setup state properly so it doesn't happen after we 
  -- enable them for the perk
  on_elapsed(0.5, function()
    for i = 1, #kioskInfo.innerShieldMobyArray, 1 do 
      hide(kioskInfo.innerShieldMobyArray[i])
    end 
    for i = 1, #kioskInfo.innerShieldClueArray, 1 do 
      deactivate(kioskInfo.innerShieldClueArray[i])
    end
  end)
  
  prt("on_generic_event") 
  on_generic_event(kioskInfo.kioskMoby, GEN_EVENT_BASE_PERK_BARRIERS, function()
    CompPerkKiosk_BoughtShields(kioskInfo)
    unset_event()
  end)

  -------------------
  -- Warmonger Turrets 
  -------------------
  for i = 1, #kioskInfo.freeWarmongerArray, 1 do
    deactivate(kioskInfo.freeWarmongerArray[i])
    hide(kioskInfo.freeWarmongerArray[i])
  end
  for i = 1, #kioskInfo.freeWarmongerClueArray, 1 do 
    deactivate(kioskInfo.freeWarmongerClueArray[i])
  end
  on_generic_event(kioskInfo.kioskMoby, GEN_EVENT_BASE_PERK_ROCKETS, function()
    CompPerkKiosk_BoughtWarmongers(kioskInfo)
    unset_event()
  end)

end -- end SetupComp_BasePerkKiosk

-- ------------------------ SetupComp_PerkKiosks ------------------------- --
local function SetupComp_PerkKiosks(kioskTable)
  -- go through the kiosk table and set up the kiosks
  local i;
  for i = 1, #kioskTable, 1 do 
    reveal(kioskTable[i].kioskMoby)
    set_is_kiosk(true, kioskTable[i].kioskMoby)
    set_kiosk_type(kioskTable[i].kioskType, kioskTable[i].kioskMoby)
    set_kiosk_team(kioskTable[i].kioskTeam, kioskTable[i].kioskMoby)
    if (kioskTable[i].kioskType == PERK_KIOSK_BASE) then 
      SetupComp_BasePerkKiosk(kioskTable[i])
    end
  end
  
end -- end SetupComp_PerkKiosks

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PVP LEVEL INTRO CAM ~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
local gamestart = false
local killgens = false
local killgensloser;
local UberFFA = false;

function Comp_IntroCam()
	local randomPvPCam;
    prt("Intro Cam.") 
    UberFFA = is_ffa_game()
	if global_pvp_introcam == nil then
		if not (is_tutorial()) then
			EnableHeroes()
			fade_from_black(.5)
			on_elapsed(1, function() 
				start_level_timer()
				if ( UberFFA == true ) then
                  StartUberFFA()
				else
  				  StartFarm(get_recon_time_override(FARM_TIME))
				end
			end)
		end
		return;
	end

	-- MUSIC START
	MusicCheck_recon = true
	radar_disable() -- Needed?
	
	if type(global_pvp_introcam) == "table" then
		randomPvPCam = global_pvp_introcam[math.random(1, #global_pvp_introcam)]
	else
		randomPvPCam = global_pvp_introcam
	end
	show_pvp_intro() -- Start Player Screens
	play_explicit_sound_spec(SoundSpecs.hud_qf_pvp_lightning_strike, get_hero())
	on_elapsed(.7, function()
		ActivateCamera(randomPvPCam)
		on_elapsed(8.6, function()
			hide_pvp_intro() -- End Player Screens
		end)
	end)
	
	on_elapsed(9, function()
		fade_to_black(.5)
		on_elapsed(.5, function()
			deactivate_cam(randomPvPCam)
			radar_enable()
			fade_from_black(.5)
			on_elapsed(.6, function()
				show_pvp_countdown(4)
			-- just a small delay for the game to finish loading before we start
				on_elapsed(3, function()
					EnableHeroes()
					on_elapsed(1, function() 
						start_level_timer()
						gamestart = true;
						if( killgens ) then
						  KillAllGenerators(killgensloser)
						else
				          if ( UberFFA == true ) then
                            StartUberFFA()
				          else
  				            StartFarm(get_recon_time_override(FARM_TIME))
				          end
						end
					end)
				end)
			end)
		end)
	end)
	
end

global_amb_qf_pvp_endMatch_wind_loop_handle = nil;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GAME OVER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -- 

-- --------------------------- Comp_GameOver ----------------------------- --
local function Comp_GameOver(winnerID)

  -- if we already ended the game, no need to do it again 
  if (not pvpGameOn) then 
    return;
  end

  pvpGameOn = false 

  help_message_text("", 1) -- clear active help message text so it isn't on top of the upcoming winner banner
  
  -- if the winner is team 1, then the cam to use is for team 2 and vice versa 
  local gameovercam = {global_pvp_baseCam_red, global_pvp_baseCam_blue}
  local gameoverfx = {global_pvp_baseDestFX_red, global_pvp_baseDestFX_blue}
  
  MusicCheck_winMatch = true
  global_amb_qf_pvp_endMatch_wind_loop_handle = play_explicit_sound_spec(SoundSpecs.amb_qf_pvp_endMatch_wind_loop, get_hero())
  show_winner_banner(winnerID)
  prepare_for_game_over(gameovercam[winnerID], global_pvp_gameover_hidePod, gameoverfx[winnerID][1], gameoverfx[winnerID][2], gameoverfx[winnerID][3], gameoverfx[winnerID][4], gameoverfx[winnerID][5], gameoverfx[winnerID][6]);
  PlayVO_Comp_Winner(winnerID, function()
    on_elapsed(1.25, function()
      --if (not is_tutorial()) then
        --show_winner_names()
      --end
      --hide(global_pvp_gameover_hidePod)
      --ActivateCamera(gameovercam[winnerID])
      --ActivateArray(gameoverfx[winnerID])
      --show_hud(false)
      --stop_level_timer()
      if is_tutorial() then
        Tut_PlayerWins()
      end
      -- #MUSIC game is over, we have a winner! 
        
      --on_elapsed(12.5, function() --delay a little before going to the frontend
        --if (not is_tutorial()) then
          --game_over(winnerID)
        --end
      --end)
    end)
  end)

end -- end Comp_GameOver

-- ------------------------------ MakeVulnerable --------------------------- --
function MakeVulnerable(moby)

  if (is_valid(moby) and is_alive(moby)) then 
    health_set_invulnerability(moby, false)
  end
  
end -- end MakeVulnerable

-- ------------------------------ KillAllGenerators ------------------------ --

function KillAllGenerators(loserID)
  
  if  ( gamestart == false ) then 
    killgens = true;
    killgensloser = loserID;
    return;
  end
  
  -- make sure we have a valid loserID
  if ((loserID ~= 1) and (loserID ~= 2)) then 
    return;
  end
  
  pvp_global_forfeit = true
  
  -- just in case the generators are invulnerable, make them vulnerable 
  for_each_moby_in_pod(pvp_baseGenerators[loserID -1], MakeVulnerable)

  -- loserID - 1 for NB and 2 for SB
  damage(pvp_baseGenerators[loserID -1], 1000)
      
end -- end KillAllGenerators

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~ EMERGENCY HIDE GENERATORS BUTTON ~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

local baseGenButtons = {}
local baseGenButtonUsed = {}
local numPanicButtonsHit = 0 

local GEN_HIDE_TIME = 30

-- ---------------------- Comp_SetupBaseGenHideButton ---------------------- --
function Comp_SetupBaseGenHideButton(button, teamGens, teamID)

  deactivate(button)
  baseGenButtons[teamID] = button
  baseGenButtonUsed[teamID] = false 
  
  if (get_panic_button_enabled()) then
    on_generic_event(button, GEN_EVENT_BUTTON_PRESS, function()
      baseGenButtonUsed[teamID] = true
      -- #MUSIC panic button used
      MusicCheck_threatDetected = true
      numPanicButtonsHit = numPanicButtonsHit + 1
      --deactivate(teamGens) -- with no target, enemies don't work right 
      for_each_moby_in_pod(teamGens, Comp_MoveGenDown)
      Comp_TeamShieldUp(teamID)
      Comp_WarpOppositeTeamToBase(teamID)
      on_elapsed(GEN_HIDE_TIME, function()
        --activate(teamGens)
        for_each_moby_in_pod(teamGens, Comp_MoveGenUp)
        if ( (compPhase == "attack") or (compPhase == "UberFFA")) then 
          Comp_TeamShieldDown(teamID)
        end
        deactivate(button)
        numPanicButtonsHit = numPanicButtonsHit - 1
        -- make sure nobody is panicked
        if (numPanicButtonsHit <= 0) then 
          numPanicButtonsHit = 0
          -- #MUSIC panic ended
          if (compPhase == "recon") then 
            -- play recon music 
          elseif (compPhase == "build") then 
            -- play build music 
          else -- must be the attack phase still
            -- play attack music 
          end
        end
      end)
      unset_event()
    end)
  else
    baseGenButtonUsed[teamID] = true 
  end
  
end -- end Comp_SetupBaseGenHideButton

-- ----------------------- Comp_DeactivateBaseButtons ---------------------- --
function Comp_DeactivateBaseButtons()

  local i; 
  for i = 0, 1, 1 do 
    if ((baseGenButtons[i] ~= nil) and (not baseGenButtonUsed[i])) then 
      deactivate(baseGenButtons[i])
    end
  end 
end -- end Comp_DeactivateBaseButtons

-- ----------------------- Comp_ActivateBaseButtons ---------------------- --
function Comp_ActivateBaseButtons()

  local i; 
  for i = 0, 1, 1 do 
    if ((baseGenButtons[i] ~= nil) and (not baseGenButtonUsed[i])) then 
      activate(baseGenButtons[i])
    end
  end 
  
end -- end Comp_ActivateBaseButtons

-- -------------------------- Comp_MoveGenDown ----------------------------- -- 
function Comp_MoveGenDown(gen)

  -- can't deactivate the generators (which will animate them down) as they 
  -- must remain valid targets for enemies to continue to path correctly to the base
  health_set_invulnerability(gen, true)
  on_elapsed(0.5, function() -- need to give time for a current hit react to not override our anim call
    play_anim_query(gen, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
  end)
  

end -- end Comp_MoveGenDown

-- --------------------------- Comp_MoveGenUp ------------------------------ --
function Comp_MoveGenUp(gen)
  
  play_anim_query(gen, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN)
  on_anim_percentage(gen, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN, 1, function()
    health_set_invulnerability(gen, false)
    play_anim_query(gen, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN_IDLE)
    unset_event()
  end)
    
end -- end Comp_MoveGenUp

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SHIELDS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

-- -------------------------- Comp_ShieldUp -------------------------------- --
function Comp_ShieldUp(shieldMoby)

  reveal(shieldMoby)
  play_anim_query(shieldMoby, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
  on_anim_percentage(shieldMoby, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE, 1, function()
    play_anim_query(shieldMoby, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSED_IDLE)
    unset_event()
  end)
 
  
end -- end Comp_ShieldUp

-- -------------------------- Comp_ShieldDown ------------------------------ --
function Comp_ShieldDown(shieldMoby)

  play_anim_query(shieldMoby, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN) 
  on_anim_percentage(shieldMoby, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN, 1, function()
    hide(shieldMoby)
    unset_event()
  end)
  
end -- end Comp_ShieldDown

-- -------------------------- Comp_TeamShieldUp ---------------------------- --
function Comp_TeamShieldUp(teamIndex) 
  
  local shields = forcefields[teamIndex]
  for_each_moby_in_pod(shields, Comp_ShieldUp)
  -- if we have an array of mobys that go with the shield, turn its collision on 
  -- now that the shields are up 
  if ((global_pvp_addlShieldInvisiColl ~= nil) and (type(global_pvp_addlShieldInvisiColl) == "table")
    and (global_pvp_addlShieldInvisiColl[teamIndex + 1] ~= nil) 
    and (type(global_pvp_addlShieldInvisiColl[teamIndex + 1]) == "table")) then 
    local i; 
    for i = 1, #global_pvp_addlShieldInvisiColl[teamIndex + 1], 1 do 
      coll_on(global_pvp_addlShieldInvisiColl[teamIndex + 1][i])
    end
  end
end -- end Comp_TeamShieldUp

-- -------------------------- Comp_TeamShieldDown ---------------------------- --
function Comp_TeamShieldDown(teamIndex) 

  local shields = forcefields[teamIndex]
  for_each_moby_in_pod(shields, Comp_ShieldDown)
  -- if we have an array of mobys that go with the shield, turn off its collision
  -- now that the shields are down 
  if ((global_pvp_addlShieldInvisiColl ~= nil) and (type(global_pvp_addlShieldInvisiColl) == "table")
    and (global_pvp_addlShieldInvisiColl[teamIndex + 1] ~= nil) 
    and (type(global_pvp_addlShieldInvisiColl[teamIndex + 1]) == "table")) then 
    local i; 
    for i = 1, #global_pvp_addlShieldInvisiColl[teamIndex + 1], 1 do 
      coll_off(global_pvp_addlShieldInvisiColl[teamIndex + 1][i])
    end
  end
end -- end Comp_TeamShieldDown

-- -------------------------- Comp_AllShieldUp ---------------------------- --
function Comp_AllShieldUp() 

  Comp_TeamShieldUp(0)
  Comp_TeamShieldUp(1)
  
end -- end Comp_AllShieldUp

-- -------------------------- Comp_AllShieldDown ---------------------------- --
function Comp_AllShieldDown() 

  Comp_TeamShieldDown(0)
  Comp_TeamShieldDown(1)
  
end -- end Comp_AllShieldDown

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~  INFINITE INVASION PHASE ~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

-- -------------------------- RemoveUnusedDefense -------------------------- --
function RemoveUnusedDefense(defMoby)

  if (not is_activated(defMoby)) then 
    trigger_effect_event(EventType.TELEPORTED, defMoby)
    hide(defMoby)
  else
    local isMine = (get_update_class(defMoby) == BaseDefenseMine_CLASS)
    -- only need to listen for the death of turrets and mines to hide their bases 
    if ((get_update_class(defMoby) == EnemyPickNBomb_CLASS) or  
        (get_update_class(defMoby) == BaseDefenseMine_CLASS) or 
        (get_update_class(defMoby) == BaseDefenseBarrier_CLASS)) then 
      on_death(defMoby, function()
        -- need to wait for the mine attack to complete 
        if (isMine) then 
          on_generic_event(defMoby, GEN_EVENT_RESET, function() -- not really dead, will send an event
            on_elapsed(1, function() 
              trigger_effect_event(EventType.TELEPORTED, defMoby)
              hide(defMoby)
            end)
            unset_event()
          end)
        else
          on_elapsed(0.5, function()
            trigger_effect_event(EventType.TELEPORTED, defMoby)
            hide(defMoby)
          end)
        end
        unset_event()
      end)
    end
  end
  
end -- end RemoveUnusedDefense

-- ------------------------ RemoveBarrierPurPads --------------------------- --
function RemoveBarrierPurPads(padMoby)

  trigger_effect_event(EventType.TELEPORTED, padMoby)
  hide(padMoby)
    
end -- end RemoveBarrierPurPads

-- ---------------------- Comp_InfInvPhase_DoSquadPurchase ----------------- --
function Comp_InfInvPhase_DoSquadPurchase(teamIndex, sideIndex, padIndex)

  --prt("INFINV Squad purchase - Team: " .. teamIndex .. ", side = " .. sideIndex .. ", padIndex = " .. padIndex)
  
  local leftPads = {LEFT_1, LEFT_2, LEFT_3, LEFT_4}
  local rightPads = {RIGHT_1, RIGHT_2, RIGHT_3, RIGHT_4}
  
  local teamEnum = HERO.HERO_TEAM_1
  if (teamIndex == 1) then 
    teamEnum = HERO.HERO_TEAM_2
  end 
  
  local padArray = leftPads 
  if (sideIndex == 1) then 
    padArray = rightPads 
  end 
  local enemyType = get_purchased_wave(padArray[padIndex], teamEnum)
  local perkType = getPerkEnemyTypeFromEnemyType(enemyType)
 -- prt("Is elite? " .. tostring(is_base_perk_purchased(teamEnum, perkType)))
  delete_squad_builder_guys(false) -- do not close the purchase UI but delete the hologram dudes
 -- prt("EnemyType = " .. tostring(enemyType))
  local dirClue;
  local useDrone = false
  if ((enemyType == WPN_BRAWLER) and (is_base_perk_purchased(teamEnum, PERK_SQUAD_BRAWLER))) then -- elite brawlers are swapped out with wrecking drones
    dirClue = Comp_getWreckingDroneClue(teamEnum, sideIndex + 1)
    useDrone = true
  else
    dirClue = CreateCompWaveData_getClue(enemyType, teamEnum, sideIndex + 1)
  end 
  if (type(dirClue) == "number") then 
    prt("ERRRRRRRROOOOORRRR: Comp_InfInvPhase_DoSquadPurchase got an invalid enemy type")
  else
    local waveNum = 1
    if ((not useDrone) and is_base_perk_purchased(teamEnum, perkType)) then 
      waveNum = 2 -- elites (except for the wrecking drone) are on wave #2
    end
    trigger_squad(dirClue, waveNum, true, true)
  end
  if (enemyType == WPN_TANK) then 
    PlayVO_PVP_IncomingTank(teamEnum)
  elseif (useDrone) then 
    PlayVO_PVP_IncomingDrone(teamEnum)
  end
  
  -- clear the purchase from the pad 
  clear_purchased_wave(padArray[padIndex], teamEnum)
  
end -- end Comp_InfInvPhase_DoSquadPurchase

-- ---------------------- Comp_InfInvPhase_SetupSquadBuilder --------------- --
function Comp_InfInvPhase_SetupSquadBuilder()
  
  Comp_EnemyBaseDisplay_Open()
  -- only reveal and activate the top two pads
  reveal(comp_purchasePads[1][1][1])
  activate(comp_purchasePads[1][1][1])
  enable_base_offense_cooldown(comp_purchasePads[1][1][1])
--  Comp_DoTeleEffect(comp_purchasePads[1][1][1])
  reveal(comp_purchasePads[1][2][1])
  activate(comp_purchasePads[1][2][1])
  enable_base_offense_cooldown(comp_purchasePads[1][2][1])
--  Comp_DoTeleEffect(comp_purchasePads[1][2][1])
  reveal(comp_purchasePads[2][1][1])
  activate(comp_purchasePads[2][1][1])
  enable_base_offense_cooldown(comp_purchasePads[2][1][1])
--  Comp_DoTeleEffect(comp_purchasePads[2][1][1])
  reveal(comp_purchasePads[2][2][1])
  activate(comp_purchasePads[2][2][1])
  enable_base_offense_cooldown(comp_purchasePads[2][2][1])
--  Comp_DoTeleEffect(comp_purchasePads[2][2][1])
  -- can activate all clues, they won't be usable unless the purchase pad is activated
  activate(enemy_purchase_clues[0])
  activate(enemy_purchase_clues[1])
  
  -- play_line(DialogueSpecs.PVP_COMP_PA_MISC035) -- vo about purchasing squads [can't use, mentions buying defenses]
  
end -- end Comp_InfInvPhase_SetupSquadBuilder


-- ---------------------- Comp_StartInfiniteInvasionPhase ------------------ --
function Comp_StartInfiniteInvasionPhase()

  -- do not change phases when the game is over 
  if (not pvpGameOn) then 
    return;
  end 
  
  -- tutorial doesn't get the inf invasion wave
  if (is_tutorial()) then 
    return;
  end 
  
  infInvasionActive = true
  
  -- start the squad phase so that we can see holograms again
  start_squad_phase()
  
  if (compPhase ~= "UberFFA") then
    -- do not allow the base perk station to allow the purchase of more turrets or barriers 
    disable_base_building_perks()
    
    if (global_pvp_infInvHidePod ~= nil) then 
      for_each_moby_in_pod(global_pvp_infInvHidePod, RemoveBarrierPurPads)
    end 
    deactivate(global_pvp_allBaseDefenseScent)
    
    for_each_moby_in_pod(global_pvp_allBaseDefensePod, RemoveUnusedDefense)
  end

  on_elapsed(2, function()
    if (pvpGameOn) then -- make sure the game is still going on before we display the message
      help_message_text("PVP_STAGE_INFINV_START")
    end
  end)
  
  Comp_InfInvPhase_SetupSquadBuilder()
  comp_full_frontal_assault_started()
  

end -- end Comp_StartInfiniteInvasionPhase

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ COMP: Nodes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

local compNodes = {}
local compNodes_inUse = {} -- boolean array on whether or not someone is currently using the node

-- ------------------------------ KillAllNodeGuards ------------------------ --
function KillAllNodeGuards(dirClue, maxWave, defensesPod)
  
  local nodePod;
  local i;
  for i = 1, maxWave, 1 do 
    nodePod = get_pod_from_wave(dirClue, (i - 1)) -- get_pod_from_wave waves start at 0 
    if ((nodePod ~= nil) and (get_num_alive(nodePod) > 0)) then 
      damage(nodePod, 1000)
    end
  end
  if ((defensesPod ~= nil) and (get_num_alive(defensesPod) > 0)) then 
    damage(defensesPod, 1000)
  end
end -- end KillAllNodeGuards

-- --------------------------- DeleteEnemy --------------------------- --
function DeleteEnemy(enemy)
  if (is_valid(enemy) and is_alive(enemy)) then 
    delete(enemy)
  end
end -- end DeleteEnemy 

function DeleteAllNodeGuards(dirClue, maxWave)
  
  local nodePod;
  local i;
  for i = 1, maxWave, 1 do 
    nodePod = get_pod_from_wave(dirClue, (i - 1)) -- get_pod_from_wave waves start at 0 
    if ((nodePod ~= nil) and (get_num_alive(nodePod) > 0)) then 
      for_each_moby_in_pod(nodePod, DeleteEnemy)
    end
  end
      
end -- end DeleteAllNodeGuards

-- ------------------------------ InitAllNodeEnemies ----------------------- --
function InitAllNodeEnemies(node_dirClues, index)
  
  if (index > #node_dirClues) then 
    return;
  end
   if (not is_tutorial()) then
	  wave_num = 1
	else
	  wave_num = 3
	end
  trigger_wave(node_dirClues[index], wave_num) -- init the dudes (do need to be in a spawn pod, we use get_pod_from_wave)
  
  -- 1s delay to help with network traffic with spawning the dudes and braining them
  on_elapsed(1, function() InitAllNodeEnemies(node_dirClues, index + 1) end)
  
end -- end InitAllNodeEnemies

-- ------------------------------ SetupCompNodes --------------------------- --
function SetupCompNodes(nodeData)

  compNodes = {}
  local node_dirClues = {}
  
  disable_defense_purchases(nodeData[1].node) -- no defense purchases for the major node
  
  local i; 
  for i = 1, #nodeData, 1 do   
    table.insert(compNodes, nodeData[i].node)
    table.insert(node_dirClues, nodeData[i].dirClue)
    compNodes_inUse[i] = false
    -- turn on the number of the node
    if (i <= 8) then 
      bangle_off(nodeData[i].node, 0, false)
      bangle_on(nodeData[i].node, (i - 1), false)
    end 
    -- make the barrier purchase bangle be off 
    bangle_on(nodeData[i].node, 9, false)
    bangle_off(nodeData[i].node, 8, false)

    on_generic_event(nodeData[i].node, GEN_EVENT_UNLOCKED, function()
      -- #MUSIC node is captured 
      MusicCheck_captureNode = true
      on_elapsed(4, function() MusicCheck_stopMusic1 = true end)
      -- kill any living dudes (could swap their target type though instead, but 
      -- this will probably read clearer)
      local maxWave = 1 
      if (nodeData[i].guardWaveNum ~= nil) then 
        maxWave = nodeData[i].guardWaveNum
      end
      KillAllNodeGuards(nodeData[i].dirClue, maxWave, nodeData[i].defensesPod)
      local nodeTeam = get_node_team(nodeData[i].node)
      if (nodeTeam == HERO.HERO_TEAM_1) then 
        set_clue_target_scent(nodeData[i].waveScent, TRG.TT_PLAYER_TEAM_2)
        PlayVO_Comp_CapturedNode(HERO.HERO_TEAM_1, i)
        set_moby_shader(nodeData[i].node, 2)
        deactivate(nodeData[i].FXNeutral)
        deactivate(nodeData[i].FXRed)
        activate(nodeData[i].FXBlue)
        -- Seaside major node captured function
        if ((i == 1) and (blue_team_owns_major ~= nil)) then 
          blue_team_owns_major()
        end
      else 
        set_clue_target_scent(nodeData[i].waveScent, TRG.TT_PLAYER_TEAM_1)
        PlayVO_Comp_CapturedNode(HERO.HERO_TEAM_2, i)
        set_moby_shader(nodeData[i].node, 1)
        deactivate(nodeData[i].FXNeutral)
        deactivate(nodeData[i].FXBlue)
        activate(nodeData[i].FXRed)
        -- Seaside major node captured function
        if ((i == 1) and (red_team_owns_major ~= nil)) then 
          red_team_owns_major()
        end
      end
	  
      on_elapsed(1, function() 
        -- stupid turrets that are down are invulnerable to damage, so once we tried to kill everyone, 
        -- do another pass to delete everyone left
        DeleteAllNodeGuards(nodeData[i].dirClue, maxWave)
        if (nodeData[i].guardWaveNum == nil) then 
          trigger_wave(nodeData[i].dirClue, 1)
        else
          trigger_wave(nodeData[i].dirClue, nodeData[i].guardWaveNum)
        end
      end)
      
      -- only allow 1 purchase of a barrier 
      -- put the node in "barrier purchase active" mode (bangle)
      if (i ~= 1) then -- major node does not have shield purchasing 
        bangle_on(nodeData[i].node, 8, false)
        bangle_off(nodeData[i].node, 9, false)
        activate(nodeData[i].barrierClue)
        if (not get_node_barrier_rebuy_enabled()) then
          on_generic_event(nodeData[i].barrierGen, GEN_EVENT_PURCHASED, function()
            -- put the node in "barrier purchase inactive" mode
            bangle_on(nodeData[i].node, 9, false)
            bangle_off(nodeData[i].node, 8, false)
            deactivate(nodeData[i].barrierClue)
            unset_event()
          end)
        end
      end
      -- do not unset, the node will go through several captures
    end)
    -- monitor whether the nodes are in use or not 
    on_generic_event(nodeData[i].node, GEN_EVENT_ACTIVATED, function() 
      -- attached
      compNodes_inUse[i] = true
      on_generic_event(nodeData[i].node, GEN_EVENT_DETACH, function()
        -- detached 
        compNodes_inUse[i] = false 
        
        -- check our stage, if it isn't recon, deactivate the node 
        if ( ( compPhase ~= "recon") and (compPhase ~= "UberFFA")) then 
          deactivate(compNodes[i])
          bangle_on(nodeData[i].node, 10, false)
        end
        unset_event()
      end)
      -- do not unset, node can be attached to multiple times
    end)
  end 
  
  InitAllNodeEnemies(node_dirClues, 1)
  
end -- end SetupCompNodes

-- ------------------ CompNodes_Deactivate ------------------ --
local function CompNodes_Deactivate()

  local i;
  for i = 1, #compNodes, 1 do 
    if (not compNodes_inUse[i]) then 
      deactivate(compNodes[i])
      bangle_on(compNodes[i], 10, false)
    end
  end 
end -- end CompNodes_Deactivate

-- ------------------ CompNodes_Activate -------------------- --
local function CompNodes_Activate()

  local i;
  for i = 1, #compNodes, 1 do 
    activate(compNodes[i])
    bangle_off(compNodes[i], 10, false)
  end
  
end -- end CompNodes_Activate

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

-- --------------------- Comp_SetupNonAssaultWrongBaseWarp ------------ --
function Comp_SetupNonAssaultWrongBaseWarp()

  -- make sure we have areas
  if (global_pvp_baseWarpArea_blue == nil) or (global_pvp_baseWarpArea_red == nil) then 
    prt("Comp_SetupNonAssaultWrongBaseWarp: No wrong base warp areas for the blue and/or red bases.");
    return;
  end
  
  local i;
  local team;
  local warp_area;
  for i = 4, 8, 4 do 
    local hero = get_hero_at_player_id(i)
    team = get_node_team(hero)
    if (team == HERO.HERO_TEAM_1) then -- blue 
      warp_area = global_pvp_baseWarpArea_red
    else -- red
      warp_area = global_pvp_baseWarpArea_blue 
    end
    if (is_hero_active(hero)) then 
      on_enter(hero, warp_area, function()
        -- only warp them if the phase is not assault
        if ((compPhase ~= "attack") and (compPhase ~= "UberFFA") and not heroIsDead[i+1]) then 
          pvp_panic_warp(hero)
        end
        -- do not unset
      end)
    end
  end
  
end -- end Comp_SetupNonAssaultWrongBaseWarp

-- --------------------- Comp_WarpOppositeTeamToBase ------------------ --
function Comp_WarpOppositeTeamToBase(teamID)

  local i; 
  local heroID;
  local hero;
  local teamWarpVolIndex = 1
  local oppHeroTeam = HERO.HERO_TEAM_1
  local teamWarpVols = team1_warpVols;
  if (teamID == 0) then  -- if team is 1, then opp team is 2 
    teamWarpVols = team2_warpVols
    oppHeroTeam = HERO.HERO_TEAM_2
  end 
  
  for i = 4, 8, 4 do
    heroID = i - 1 -- 0-7
    hero = get_hero_at_player_id(heroID)
    if (is_hero_active(hero) and not heroIsDead[i]) then 
      if ((get_node_team(hero) == oppHeroTeam) and heroAtWrongBase[i]) then  
        pvp_panic_warp(hero)
        teamWarpVolIndex = teamWarpVolIndex + 1
      end
    end
  end 

end -- end Comp_WarpOppositeTeamToBase

-- ------------------- Comp_isAnyoneAtWrongBase ----------------------- --
function Comp_isAnyoneAtWrongBase()

  local i;
  for i = 1, #heroAtWrongBase, 1 do 
    if (heroAtWrongBase[i] and not heroIsDead[i]) then 
      return true;
    end
  end
  
  return false;
  
end -- end Comp_isAnyoneAtWrongBase

-- ------------------ SetupComp_PlayerAtWrongBaseMonitor -------------- --
local function SetupComp_PlayerAtWrongBaseMonitor(hero, playerID)

  local wrongBaseArea =  baseArea[1]
  if (get_node_team(hero) == HERO.HERO_TEAM_1) then 
    wrongBaseArea =  baseArea[2]
  end 
  
  on_enter(hero, wrongBaseArea, function()
--    prt("Hero " .. playerID .. " entered the enemy base. They are dead? " .. tostring(heroIsDead[playerID + 1]))
    heroAtWrongBase[playerID + 1] = true 
    on_exit(hero, wrongBaseArea, function()
     -- prt("Player " .. (playerID + 1) .. " left the wrong base")
      heroAtWrongBase[playerID + 1] = false 
      if (waitForAllHeroesLeaveEnemyBases) then 
        if (not Comp_isAnyoneAtWrongBase()) then 
          waitForAllHeroesLeaveEnemyBases = false
          invasionPhaseActive = false 
          -- start another round 
          StartCompRound()
        end
      end
      unset_event()
    end)
    -- do not unset 
  end)
  
end -- end SetupComp_PlayerAtWrongBaseMonitor

-- ---------------------- MinionInvasionOver_Comp ------------------------ --
function MinionInvasionOver_Comp()
--/ The minion invasion is over, but the invasion phase is not over until no 
--/ hero is in the opposite base. 

  -- when enough rounds go by, do not end the invasion phase (FFA phase)
  if (numRounds >= MAX_NUM_ROUNDS) then 
    return Comp_StartInfiniteInvasionPhase()
  end
  
  local anyHeroAssaultingBase = Comp_isAnyoneAtWrongBase()
  
  -- if no heroes are at the wrong base, then the invasion phase is over 
  if (not anyHeroAssaultingBase) then 
   -- prt("MinionInvasionOver_Comp: Heroes not in the wrong bases. Go to recon.") 
    
    invasionPhaseActive = false 

    -- start another round 
    StartCompRound()
  else -- else we need to wait for them to leave 
  --  prt("MinionInvasionOver_Comp: Someone in the wrong base.")
    -- throw a flag for the enemy base hero exit listener to handle switching the phase when all heroes are out
    waitForAllHeroesLeaveEnemyBases = true
  end 
  
end -- end MinionInvasionOver_Comp
  
function StartAttack()

  -- do not change phases when the game is over 
  if (not pvpGameOn) then 
    return;
  end
    
  if (StageChangeCallback_Attack ~= nil) then 
    StageChangeCallback_Attack()
  end

  delete_squad_builder_guys()
  -- let code know this phase is over
  end_squad_phase() -- this isn't in devel (in patch)

  Comp_HideSquadPads()
 
  PlayVO_Comp_Stage_BuildOver()
  help_message_text("PVP_STAGE_SQUAD_OVER", STAGE_DELAY - 0.5)
  -- #MUSIC build stage over 
  MusicCheck_buildOver = true
  
  on_elapsed(STAGE_DELAY, function()
    -- do not change phases when the game is over 
    if (not pvpGameOn) then 
      return;
    end
    
    help_message_text("PVP_STAGE_INV_START")
    Comp_AllShieldDown()
    Comp_ActivateBaseButtons()
    -- #MUSIC invasion stage start
    MusicCheck_assault = true
    compPhase = "attack"
    set_comp_stage(HERO.COMP_STAGE_ATTACK)
    PlayVO_Comp_Stage_InvasionStart()
    Comp_StartBaseInvasion(maxBaseInv_wave) -- will call MinionInvasionOver_Comp when the invasion is finished
    maxBaseInv_wave = maxBaseInv_wave + 1
  end)
end

function StartBuild(length) 
  
  -- do not change phases when the game is over 
  if (not pvpGameOn) then 
    return;
  end 

  PlayVO_Comp_Stage_ReconOver()
  help_message_text("PVP_STAGE_RECON_OVER", STAGE_DELAY - 0.5)
  -- #MUSIC recon stage over 
  MusicCheck_reconOver = true
  
  on_elapsed(STAGE_DELAY, function()
    -- do not change phases when the game is over 
    if (not pvpGameOn) then 
      return;
    end 
  
    compPhase = "build"
    set_comp_stage(HERO.COMP_STAGE_BUILD)

    help_message_text("PVP_STAGE_SQUAD_START")
    PlayVO_Comp_Stage_BuildStart()
    -- #MUSIC build stage start
		MusicCheck_build = true
    
    CompNodes_Deactivate()
  
   -- warp_to_base();
    if (StageChangeCallback_Build ~= nil) then 
      StageChangeCallback_Build()
    end 
    
    --Comp_AllShieldUp() (already up)
    Comp_RevealSquadPads()
    Comp_EnemyBaseDisplay_Open()

    if(not is_tutorial()) then
      hud_start_general_timer(length, true)
      on_elapsed(length, StartAttack)
    else

    end

    -- let code know we are in this phase
    start_squad_phase() -- isn't in devel, in patch
  end)
end

function StartFarm(length)
  prt("MinionInvasionOver_Comp: Heroes not in the wrong bases. Go to recon.") 
  -- do not change phases when the game is over 
  if (not pvpGameOn) then 
    return;
  end 
  
  compPhase = "recon"
  set_comp_stage(HERO.COMP_STAGE_RECON)  
  add_comp_round()
  numRounds = numRounds + 1 
  
  PlayVO_Comp_Stage_ReconStart()
  help_message_text("PVP_STAGE_RECON_START")
  -- #MUSIC recon stage start
  MusicCheck_recon = true
  if (StageChangeCallback_Recon ~= nil) then 
    StageChangeCallback_Recon()
  end
  
  -- Comp_AllShieldUp() -- already up
  Comp_HideSquadPads()
  
  -- do not play the close anim on the first recon phase as it is already down
  if (numRounds > 1) then 
    Comp_EnemyBaseDisplay_Close()
  end
  
  CompNodes_Activate() 
  if(not is_tutorial()) then
    hud_start_general_timer(length, true)
    on_elapsed(length, function() StartBuild(SQUAD_TIME) end)
  end
end

function StartUberFFA()  
  prt("StartUberFFA.") 
  if (not pvpGameOn) then 
    return;
  end 
  
  compPhase = "UberFFA"
  add_comp_round()
  add_comp_round()
  add_comp_round()
  add_comp_round()
  add_comp_round()
  add_comp_round()
  numRounds = 6
  
  Comp_AllShieldDown()
  Comp_ActivateBaseButtons()
  -- #MUSIC invasion stage start
  MusicCheck_assault = true
  set_comp_stage(HERO.COMP_STAGE_ATTACK)
  PlayVO_Comp_Stage_InvasionStart()
  maxBaseInv_wave = maxBaseInv_wave + 1
  build_all_the_things(true)
  CompNodes_Activate() 
  
  on_elapsed(5.0, function()
    MinionInvasionOver_Comp()
    build_all_the_things(false)
  end)
end

-- ----------------------- StartCompRound ------------------- --
function StartCompRound()

  -- do not change phases when the game is over 
  if (not pvpGameOn) then 
    return;
  end 
  
  -- as there are now several ways to end the assault phase, we want to make sure 
  -- this function is only called once (in case, somehow, 2 ways to end the phase are called 
  -- at the same time. Near impossible, but better safe than sorry. 
  if (compPhase ~= "attack") then 
    return;
  end
  
  compPhase = "none"
  waitForAllHeroesLeaveEnemyBases = false -- just a failsafe, to make sure this is false outside of attack phase
  
  -- keep players from re-entering the enemy base during the phase delay between attack and recon
  Comp_AllShieldUp()
  
  Comp_DeactivateBaseButtons()
  
  PlayVO_Comp_Stage_InvasionOver()
  help_message_text("PVP_STAGE_INV_OVER", STAGE_DELAY - 0.5)
  -- #MUSIC invasion stage over
  MusicCheck_assaultOver = true
  
  -- right now, the round starts with StartFarm 
  on_elapsed(STAGE_DELAY, function()
    StartFarm(get_recon_time_override(FARM_TIME))
  end)
  
end -- end StartCompRound

function SetupCompetitive(warp_t1_array, warp_t2_array, pod_Generators_p1, pod_Generators_p2, pod_Turrets_p1, pod_Turrets_p2, 
                          forcefield_p1, forcefield_p2, enemyBaseDisplay_p1, enemyBaseDisplay_p2, 
                          enemyVendor_pod_p1, enemyVendor_pod_p2, enemyPClues_1, enemyPClues_2,
                          purchasePadTable, generatorTable, 
                          northBaseArea, southBaseArea, health_p1, health_p2, northBaseGens, southBaseGens, 
                          northBaseGenButton, southBaseGenButton,
                          kioskTable, tankSpawnClueArray)

	PvPLevelCheck = true
	
  enable_enemy_wave_bar(true)
  
  InitCompInvData()
  ResetWeapons(false)
  hero_give_weapon(WPN_COMBUSTER)
  hero_give_weapon(WPN_SWINGSHOT)
  last_team_number = HERO.HERO_TEAM_2
  generators = pod_Generators_p2
  turrets = pod_Turrets_p2
  forcefield = forcefield_p2
  health_crates = health_p2
  target_type = TRG.TT_PLAYER_TEAM_1
  
  forcefields[0] = forcefield_p1
  forcefields[1] = forcefield_p2
  Comp_AllShieldUp()
  enemy_baseDisplay[0] = enemyBaseDisplay_p1
  enemy_baseDisplay[1] = enemyBaseDisplay_p2
  enemy_purchaser[0] = enemyVendor_pod_p1
  enemy_purchaser[1] = enemyVendor_pod_p2
  enemy_purchase_clues[0] = enemyPClues_1
  enemy_purchase_clues[1] = enemyPClues_2
  baseArea[1] = northBaseArea
  baseArea[2] = southBaseArea
  radar_set_base_areas(northBaseArea, southBaseArea)
  
  comp_purchasePads = purchasePadTable
  Comp_Setup_EnemyBaseDisplays(purchasePadTable, generatorTable)
  Comp_Setup_HeroGenHealthMapIcons(generatorTable)
  
  team1_warpVols = warp_t1_array
  team2_warpVols = warp_t2_array
  
  local warpIndex_t1 = 1
  local warpIndex_t2 = 1
  
  for i = 4, 8, 4 do
    team_number = get_team_at_player_id( i ) 
    if  ( team_number == HERO.HERO_TEAM_NONE ) then 
      if ( get_team_at_player_id( 0 ) == HERO.HERO_TEAM_1 ) then
        team_number = HERO.HERO_TEAM_2
      else 
        team_number = HERO.HERO_TEAM_1
      end
    end
    
    hero = get_hero_at_player_id( i )  
     
    if(is_valid(hero)) then
      if(team_number == HERO.HERO_TEAM_1) then
        vol_dest = warp_t1_array[warpIndex_t1]
        warpIndex_t1 = warpIndex_t1 + 1
        generators = pod_Generators_p1
        turrets = pod_Turrets_p1
        forcefield = forcefield_p1
        health_crates = health_p1
        target_type = TRG.TT_PLAYER_TEAM_2
      else
        vol_dest = warp_t2_array[warpIndex_t2]
        warpIndex_t2 = warpIndex_t2 + 1
        generators = pod_Generators_p2
        turrets = pod_Turrets_p2
        forcefield = forcefield_p2
        health_crates = health_p2
        target_type = TRG.TT_PLAYER_TEAM_1
      end
    end
    
    if(is_valid(hero)) then
      set_team_number(hero, team_number)  
       
      warp(hero, vol_dest)  
      set_hero_respawn(hero, vol_dest)
      set_generator_owner(generators, hero)
      set_turret_team(turrets, team_number)
      set_forcefield_pod(hero, forcefield)
      set_awareness_type(turrets, target_type)
      SetupComp_PlayerAtWrongBaseMonitor(hero, i)
      
      set_owner(health_crates, hero)
    elseif(i == 1) then
      if( is_tutorial() ) then
        turrets = pod_Turrets_p2
        generators = pod_Generators_p2

        set_team_number(hero, team_number)
        set_turret_team(turrets, team_number)
        set_turret_team(generators, team_number)
      end
    end
    
    last_team_number = team_number;
  end

  -- set the teams of the generator pods (in case there isn't a hero)
  set_generator_team(pod_Generators_p1, HERO.HERO_TEAM_1)
  set_generator_team(pod_Generators_p2, HERO.HERO_TEAM_2)

  pvp_baseGenerators[0] = northBaseGens
  pvp_baseGenerators[1] = southBaseGens
  -- set the shaders of the base generators to the team colors
  set_moby_shader(northBaseGens, 3)
  set_moby_shader(southBaseGens, 2)
  
  if ((northBaseGenButton ~= nil) and (southBaseGenButton ~= nil)) then   
    Comp_SetupBaseGenHideButton(northBaseGenButton, northBaseGens, 0)
    Comp_SetupBaseGenHideButton(southBaseGenButton, southBaseGens, 1)
  end
  
  Comp_SetupHeroDownVO()
  SetupVO_Comp_Generators(northBaseGens, 1)
  SetupVO_Comp_Generators(southBaseGens, 2)
  
  -- Setup Game Over Listeners
  on_num_alive(northBaseGens, 0, function()
    Comp_GameOver(2) -- P1 out of gens, P2 wins
    unset_event()
  end)

  on_num_alive(southBaseGens, 0, function()
    Comp_GameOver(1) -- P2 out of gens, P1 wins
    unset_event()
  end)
  
  numRounds = 0
	on_elapsed(.10, function()
		fade_to_black(0)
	end)
	on_elapsed(.25, function()
		fade_from_black(.5)
		Comp_IntroCam()
	end)

  -- the game currently always displays this objective if it is the first objective since loading the game 
  -- so commenting it out for now as we don't want to pop up objectives in PVP 
  set_major_objective("PVP_OBJ_MAIN", true) -- add the "destroy opposing team's generators" to the start menu list of objs 
  
  if (kioskTable ~= nil) then 
    SetupComp_PerkKiosks(kioskTable)
  end
  if (tankSpawnClueArray ~= nil) then 
    SetupPVPTankClueSpawns(tankSpawnClueArray)
  end
  
  Comp_SetupNonAssaultWrongBaseWarp()
  
end
