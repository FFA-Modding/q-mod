prt("Start zone_gameplay_01.lua")
run_script("general_herobase")
ammo_crate_16 = moby_handle:new(1870, 57718, 31565, 30084)
ammo_spawner_campaign7 = moby_handle:new(24094, 57672, 44163, 18232)
ammo_spawner_leftLane_3 = moby_handle:new(16264, 57673, 13722, 59424)
global_doIntros = true
if get_qf_levels_completed() >= 3 then
  global_doIntros = false
end
on_hero_enter(gp1_volume_carSpawner_1, function()
  activate(CarSpawner_CBelt_Clockwise)
  on_all_hero_exit(gp1_volume_carSpawner_1, function()
    deactivate(CarSpawner_CBelt_Clockwise)
    unset_event()
  end)
end)
hide(leftIsland_crates)
hide(majorWeaponCrateStacks)
hide(rampCrateStacks)
hide(gp2_invisible_wall_barge)
hide(ammo_crate_16)
hide(ammo_spawner_campaign7)
if get_num_active_players() > 1 then
  hide(ammo_spawner_leftLane_3)
end
hide(all_gp1_grindhazards)
on_hero_enter(all_volumes_gp1_grindhazards, function()
  reveal(all_gp1_grindhazards)
  on_all_hero_exit(all_volumes_gp1_grindhazards, function()
    hide(all_gp1_grindhazards)
  end)
end)
set_jump_boost(gp1_ClueHoverbootJump_1, 1.5, 45, 25)
set_jump_boost(gp1_ClueHoverbootJump_2, 1.5, 45, 12.5)
set_jump_boost(gp1_ClueHoverbootJump_3, 1.5, 45, 12.5)
set_jump_boost(gp1_ClueHoverbootJump_5, 1.5, 45, 22)
set_jump_boost(gp1_ClueHoverbootJump_6, 1.5, 45, 22)
on_elapsed(1, function()
  deactivate(gp1_springshot_training1)
  hide(gp1_springshot_training1)
end)
local aphelionHeroFocusCam_P1 = {
  camAnim_aphLand_focus_p1_ratchet,
  camAnim_aphLand_focus_p1_qwark,
  camAnim_aphLand_focus_p1_clank
}
local aphelionHeroFocusAnimCamMoby_P1 = animCamEntity_aphelionLand_focus_p1
local aphelionHeroFocusCam_P2 = {
  camAnim_aphLand_focus_p2_ratchet,
  camAnim_aphLand_focus_p2_qwark,
  camAnim_aphLand_focus_p2_clank
}
local aphelionHeroFocusAnimCamMoby_P2 = animCamEntity_aphelionLand_focus_p2
local saveFlags = {
  "PHP_TankDead_1",
  "PHP_TankDead_2",
  "PHP_TankDead_3"
}
local tankStartIdle = {
  false,
  true,
  true
}
local tankHealth = 300
local eventHandle_spawnTank1 = event_handle:new()
tankClues = {
  ClueEnemy_tank_1,
  ClueEnemy_tank_3,
  ClueEnemy_tank_2
}
tankActive = {
  false,
  false,
  false
}
tankTimerActive = false
whichTankHasDisplayTimer = {
  false,
  false,
  false
}
tankTime = {
  300,
  240,
  180
}
tankTriggerTime = {
  0,
  0,
  0
}
tankStartPausedTime = {
  0,
  0,
  0
}
tankEndPausedTime = {
  0,
  0,
  0
}
tankPausedTime = {
  0,
  0,
  0
}
local tankspeed = {
  1.85,
  2,
  1.75
}
tankAlive = {
  true,
  true,
  true
}
function getTankTimeRemaining(tankID)
  local curTime = get_level_timer_seconds()
  local timeElapsed = curTime - tankTriggerTime[tankID] + tankPausedTime[tankID]
  local timeLeft = tankTime[tankID] - timeElapsed
  return timeLeft
end
function StartNewTankTimer(tankID)
  tankTriggerTime[tankID] = get_level_timer_seconds()
  if not tankTimerActive then
    hud_set_general_timer_paused(false)
    hud_start_general_timer(tankTime[tankID], true)
    tankTimerActive = true
    whichTankHasDisplayTimer[tankID] = true
  end
end
function DisplayInProgTankTimer(tankID, timeLeft)
  if tankTimerActive then
    return
  end
  if 5 < timeLeft then
    hud_set_general_timer_paused(false)
    hud_start_general_timer(timeLeft, true)
    tankTimerActive = true
    whichTankHasDisplayTimer[tankID] = true
  end
end
function PauseTankTimer(tankID)
  tankStartPausedTime[tankID] = get_level_timer_seconds()
  if whichTankHasDisplayTimer[tankID] then
    hud_set_general_timer_paused(true)
  end
end
function UnPauseTankTimer(tankID)
  tankEndPausedTime[tankID] = get_level_timer_seconds()
  local timePaused = tankEndPausedTime[tankID] - tankStartPausedTime[tankID]
  if 0 < timePaused then
    tankPausedTime[tankID] = tankPausedTime[tankID] + timePaused
  end
  if whichTankHasDisplayTimer[tankID] then
    hud_set_general_timer_paused(false)
  end
end
function StopTankTimer(tankID)
  if whichTankHasDisplayTimer[tankID] then
    whichTankHasDisplayTimer[tankID] = false
    tankTimerActive = false
    hud_stop_general_timer()
    on_elapsed(2, CheckForActiveTankToShowTimer)
  end
end
function CheckForActiveTankToShowTimer()
  local smallestTime = -1
  local tankWithShortTime = -1
  local tankTimeRemain = -1
  local i
  for i = 1, #tankClues do
    local tank = get_moby_handle_from_setup(tankClues[i])
    if tankActive[i] and is_valid(tank) and tankAlive[i] then
      tankTimeRemain = getTankTimeRemaining(i)
      if smallestTime == -1 or 5 < tankTimeRemain and smallestTime > tankTimeRemain then
        smallestTime = tankTimeRemain
        tankWithShortTime = i
      end
    end
  end
  if 0 < smallestTime then
    DisplayInProgTankTimer(tankWithShortTime, smallestTime)
  end
end
function triggerAMBtank(tankID, startMoving)
  if tankID == nil or 3 < tankID or tankID < 1 then
    return
  end
  if checkSaveStateFlag(saveFlags[tankID]) then
    return
  end
  if eventhandle_TriggerAmbDrones ~= nil then
    unset_event(eventhandle_TriggerAmbDrones)
    eventhandle_TriggerAmbDrones = nil
  end
  triggerAmbDrones = true
  startMoving = startMoving or false
  if not startMoving then
    trigger_wave(ClueEnemySetup_tanks, tankID)
  else
    tankActive[tankID] = true
    local tank = get_moby_handle_from_setup(tankClues[tankID])
    if tank ~= nil then
      delete(tank)
    end
    on_ai_spawned(tankClues[tankID], function()
      local eTank = get_moby_handle_from_setup(tankClues[tankID])
      monitorTankTime(eTank, tankID)
      SetupQFTank(eTank, true, tankspeed[tankID])
      if tankID == 2 then
        Tank3BackupListener(eTank, tankID)
      elseif tankID == 3 then
        Tank2BackupListener(eTank, tankID)
      end
      on_death(eTank, function()
        ambientTankDead(tankID)
        unsetTank3BackupListener()
        unset_event()
      end)
      unset_event()
    end)
    trigger_squad(ClueEnemySetup_tanks, tankID, true, true, not global_newDone[1])
    global_newDone[1] = true
  end
end
function initTank(i)
  prt("initTank " .. tostring(i))
  on_ai_spawned(tankClues[i], function()
    local tank = get_moby_handle_from_setup(tankClues[i])
    enemy_set_health(tank, tankHealth, tankHealth)
    if tankStartIdle[i] then
      enemy_set_inner_awareness(tank, 0)
      enemy_set_outer_awareness(tank, 0)
      show_enemy_health_bar(tank, false)
      SetupTankDoNothing(tank)
      prt("Hide Icon NOT working")
      radar_show_map_icon(tank, false)
    end
    unset_event()
  end)
end
function SetUpTanks()
  prt("Hello I'm SetupTanks")
  local i
  for i = 2, #tankClues do
    if not checkSaveStateFlag(saveFlags[i]) then
      initTank(i)
      triggerAMBtank(i)
    end
  end
end
local eventHandleDancingTank = {
  event_handle:new(),
  event_handle:new(),
  event_handle:new()
}
local eventHandleStopDancingTank = {
  event_handle:new(),
  event_handle:new(),
  event_handle:new()
}
tankDancingStopDrones = {
  false,
  false,
  false
}
tankDancing = {
  false,
  false,
  false
}
function monitorTankTime(tank, tankID)
  prt("monitorTankTime " .. tostring(tankID) .. ", " .. tostring(tankAlive[tankID]))
  if not tankAlive[tankID] then
    unset_event(eventHandleDancingTank[tankID])
    unset_event(eventHandleStopDancingTank[tankID])
    return
  end
  eventHandleDancingTank[tankID] = on_generic_event(tank, GEN_EVENT_DANCING, function()
    tankDancing[tankID] = true
    prt("START Dancing Check: You should only see me once per dance.")
    prt("mytankID = " .. tankID)
    PauseTankTimer(tankID)
    tankDancingStopDrones[tankID] = true
  end)
  eventHandleStopDancingTank[tankID] = on_generic_event(tank, GEN_EVENT_STOP_DANCING, function()
    prt("STOP Dancing Check: You should only see me once per dance.")
    tankDancing[tankID] = false
    UnPauseTankTimer(tankID)
    on_elapsed(3, function()
      if not tankDancing[tankID] then
        prt("FALSE mytankID = " .. tankID)
        tankDancingStopDrones[tankID] = false
      end
    end)
  end)
end
function stopMonitoringTankDance(tankID)
  unset_event(eventHandleDancingTank[tankID])
  unset_event(eventHandleStopDancingTank[tankID])
end
function ambientTankDead(tankID)
  tankAlive[tankID] = false
  NumAliveTanks = NumAliveTanks - 1
  if NumAliveTanks < 0 then
    NumAliveTanks = 0
  end
  stopMonitoringTankDance(tankID)
  StopTankTimer(tankID)
  tankActive[tankID] = false
  MusicCheck_killTank = true
  SetSaveStateFlag(saveFlags[tankID])
  SetSaveStateFlag(global_newFlag[1])
end
hide(SapperIntro_Gen)
hide(gp2_BomberIntro_1)
deactivate(pod_SapperIntro)
function DroneIntro(fixup)
  prt("Hello. I'm DroneIntro")
  fixup = fixup or false
  if not checkSaveStateFlag("IntroDrones") then
    prt("SaveState NOT set. Do DroneIntro!")
    if fixup and global_doIntros then
      prt("Fixup: start_cine")
      start_cine()
    end
    if not global_doIntros then
      fade_from_black(0.5)
      trigger_squad(ClueEnemySetup_BomberIntro, 2, true, true, true)
      if not global_any_invasion_active then
        set_track_invasion(true)
      end
      global_any_invasion_active = true
      return levelStartEnableHeroes(fixup)
    else
      set_icon_flash_enabled(false)
      reveal(SapperIntro_Gen)
      reveal(gp2_BomberIntro_1)
      activate(pod_SapperIntro)
      MusicCheck_bomber = true
      on_ai_spawned(gp2_BomberIntro_2, function()
        local Bomber1 = get_moby_handle_from_setup(gp2_BomberIntro_2)
        SetupWreckingDrone(Bomber1, AnimQuery.PLACEMENT_01)
        show_enemy_health_bar(Bomber1, false)
        unset_event()
      end)
      on_ai_spawned(gp2_BomberIntro_3, function()
        local Bomber2 = get_moby_handle_from_setup(gp2_BomberIntro_3)
        SetupWreckingDrone(Bomber2, AnimQuery.PLACEMENT_02)
        show_enemy_health_bar(Bomber2, false)
        unset_event()
      end)
      on_elapsed(6.5, function()
        damage(SapperIntro_Gen, 200)
        on_death(SapperIntro_Gen, function()
          deactivate(pod_SapperIntro)
        end)
        on_elapsed(6, function()
          enable_enemy_wave_bar(true)
          set_enemy_intro("ENEMY_NAME_WRECKING_DRONE", "ENEMY_DESC_WRECKING_DRONE")
          PlayVO_WreckingDrones()
          triggerAmbDrones = true
          set_icon_flash_enabled(true)
        end)
      end)
      enable_enemy_wave_bar(false)
      trigger_squad(ClueEnemySetup_BomberIntro, 1, true, true, true)
      if not global_any_invasion_active then
        set_track_invasion(true)
      end
      global_any_invasion_active = true
      placement_operation(gp2_BomberIntro_1, AnimQuery.PLACEMENT_00)
      play_anim_with_modifier(gp2_BomberIntro_1, AnimQuery.INTRO_CAT, AnimQuery.INTRO_APPEAR, AnimQuery.Modifiers.PLACEMENT, AnimQuery.PLACEMENT_00)
      play_anim_query(gp2_BomberIntro_1, AnimQuery.WRECKINGDRONE_CAT, AnimQuery.WRECKINGDRONE_PARTIAL_1)
      ActivateCamera(CamArgAnimated_BombBotIntro)
      fade_from_black(0.5)
      on_generic_event(animCamEnt_BomberIntro, GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
        fade_to_black(0.5)
        on_elapsed(0.5, function()
          if fixup then
            end_cine()
            SetSaveStateFlag("IntroDrones")
          end
          hide(gp2_BomberIntro_1)
          fade_from_black(0.5)
          levelStartEnableHeroes(fixup)
        end)
        unset_event()
      end)
    end
  else
    prt("SaveState SET. Don't do DroneIntro!")
    levelStartEnableHeroes(fixup, true)
  end
end
SetupPlatformingFollowCam({
  volume_lightingplatforms_platCam,
  volume_barge_platCam,
  gp1_volume_PlatformCam_1,
  gp1_volume_PlatformCam_2,
  gp1_volume_PlatformCam_3
})
on_hero_enter(gp1_volume_1, function()
  reveal(rampCrateStacks)
  unset_event()
end)
on_hero_enter(gp1_volume_4, function()
  reveal(gp1_pod_swarmersSwingshot)
  unset_event()
end)
ExtendRightGrindrail = false
ExtendLeftGrindrail = false
coll_off(test_retractable_grindrail_left)
coll_off(test_retractable_grindrail_right)
deactivate(ClueGrindRail_Start13)
deactivate(ClueGrindRail_Start4)
play_anim_query(test_retractable_grindrail_left, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
play_anim_query(test_retractable_grindrail_right, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
on_hero_enter(gp1_volume_retractgrindrail_left, function()
  if ExtendLeftGrindrail == true then
    play_anim_query(test_retractable_grindrail_left, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN)
    on_all_hero_exit(gp1_volume_retractgrindrail_left, function()
      if ExtendLeftGrindrail == true then
        play_anim_query(test_retractable_grindrail_left, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
        prt("ExtendLeftGrindrail = false")
        ExtendLeftGrindrail = false
        coll_off(test_retractable_grindrail_left)
        deactivate(ClueGrindRail_Start13)
      end
    end)
  end
end)
on_hero_enter(gp1_volume_retractgrindrail_right, function()
  if ExtendRightGrindrail == true then
    play_anim_query(test_retractable_grindrail_right, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN)
    on_all_hero_exit(gp1_volume_retractgrindrail_right, function()
      if ExtendRightGrindrail == true then
        play_anim_query(test_retractable_grindrail_right, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
        prt("ExtendRightGrindrail = false")
        ExtendRightGrindrail = false
        on_elapsed(0.5, function()
          coll_off(test_retractable_grindrail_right)
        end)
        deactivate(ClueGrindRail_Start4)
      end
    end)
  end
end)
on_hero_enter(vol_grindtube_speedup_2, function()
  prt("ExtendRightGrindrail = true")
  ExtendRightGrindrail = true
  coll_on(test_retractable_grindrail_right)
  activate(ClueGrindRail_Start4)
  setgrindrailspeed()
end)
on_hero_enter(vol_loopdeloop_speedup, function()
  prt("ExtendLeftGrindrail = true")
  ExtendLeftGrindrail = true
  coll_on(test_retractable_grindrail_left)
  activate(ClueGrindRail_Start13)
  setgrindrailspeed()
end)
on_hero_enter(gp1_volume_activate_springshot_left, function()
  SetSaveStateFlag("BaseSnapShot_Left")
  reveal(gp1_springshot_left)
  activate(gp1_springshot_left)
  unset_event()
end)
on_hero_enter(gp1_volume_activate_springshot_right, function()
  SetSaveStateFlag("BaseSnapShot_Right")
  reveal(gp1_springshot_right)
  activate(gp1_springshot_right)
  unset_event()
end)
hide(pod_heroTurrets)
if get_num_active_players() > 1 then
  hide(baseHeroTurret_left)
end
function ShowHeroTurrets()
  InitHeroTurrets({
    ratchet_turret,
    clank_turret,
    qwark_turret
  }, baseHeroTurret_left, baseHeroTurret_right)
end
function HideHeroTurrets()
  if get_num_active_players() == 1 then
    set_hero_turret_closed(baseHeroTurret_left)
  end
  set_hero_turret_closed(baseHeroTurret_right)
  hide(pod_heroTurrets)
end
hide(pod_hero_actors)
local heroActors = {
  actor_ratchet,
  actor_qwark,
  actor_clankSmall,
  actor_clankAlpha
}
function ShowLandingScene()
  set_hud_fader(false)
  fade_to_black(0)
  fade_from_black(2)
  radar_disable()
  DisableHeroes()
  warp_heroes(volWarp_hero_outOfTheWay_1, volWarp_hero_outOfTheWay_2, volWarp_hero_outOfTheWay_3, volWarp_hero_outOfTheWay_4, true, false, false, false)
  start_cine()
  placement_operation(aphelion_phpre, AnimQuery.PLACEMENT_04)
  ActivateCamera(camAnim_aphLand)
  play_anim_with_modifier(aphelion_phpre, AnimQuery.INTRO_CAT, AnimQuery.INTRO_APPEAR, AnimQuery.Modifiers.PLACEMENT, AnimQuery.PLACEMENT_04)
  play_explicit_sound_spec(SoundSpecs.trig_aphelion_land_krell, get_hero())
  MusicCheck_landing = true
  on_generic_event(animCamEntity_aphelionLanding, GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
    DoHeroesJumpOutAphelion(StartLevel_PHPre, camAnim_aphLand_heroesExit, animCamEntity_aphelionLand_heroesExit, aphelionHeroFocusCam_P1, aphelionHeroFocusAnimCamMoby_P1, aphelionHeroFocusCam_P2, aphelionHeroFocusAnimCamMoby_P2, volPos_aphelion_heroExit, {volPos_aphelionLand_focus_P1, volPos_aphelionLand_focus_P2}, heroActors, actor_ratchetWrench, aphelion_phpre, camAnim_openingPan, false, false)
    unset_event()
  end)
  on_elapsed(0.25, PlayVO_PHPre_LevelStart)
end
function levelStartEnableHeroes(fixup, skipAll)
  fixup = fixup or false
  skipAll = skipAll or false
  if not skipAll then
    ActivateCamera(CamArgOpeningView_PH)
    if global_doIntros then
      end_cine()
    end
    radar_enable()
    set_hud_fader(true)
    EnableHeroes(false)
  end
  SetupVO_Zurgo_Taunt()
  if not fixup then
    on_elapsed(math.random(180, 300), StartAmbientInvasion)
    on_hero_enter(gp1_volume_zurgomonitor, function()
      PlayVO_Zurgo_Taunt()
      unset_event()
    end)
  end
end
function SpawnTank1(skipFirstCam)
  skipFirstCam = skipFirstCam or false
  fade_from_black(0.75)
  if not checkSaveStateFlag("PHP_TankDead_1") then
    local timeToStart = 5.5
    if not skipFirstCam then
      start_cine()
      ActivateCamera(TankIntroCamera)
      MusicCheck_dropIntro = true
      timeToStart = 6
    end
    on_elapsed(timeToStart, function()
      enable_enemy_wave_bar(false)
      on_ai_spawned(ClueEnemy_tank_1, function()
        local tank = get_moby_handle_from_setup(ClueEnemy_tank_1)
        play_anim_query(gp1_crane, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
        show_enemy_health_bar(tank, false)
        SetupQFTank(tank, true, tankspeed[1], AnimQuery.PLACEMENT_00)
        monitorTankTime(tank, 1)
        on_anim_percentage(tank, AnimQuery.INTRO_CAT, AnimQuery.INTRO_APPEAR, 1, function()
          set_enemy_intro("ENEMY_NAME_TANK", "ENEMY_DESC_TANK")
          on_elapsed(1.8, function()
            enable_enemy_wave_bar(true)
          end)
          StartNewTankTimer(1)
          PlayVO_Base_IncomingTank()
          on_elapsed(1, function()
            fade_to_black(1)
            on_elapsed(1, function()
              show_enemy_health_bar(tank, true)
              DeactivateCamera()
              end_cine()
              fade_from_black(1)
              CraneAnims_Right2Left()
              phpre_tankSceneActive = false
              if phpre_numTanksToQueue > 0 then
                return TankSpawnOrder(false, true, true)
              end
              if phpre_queueUnlockPDCScene then
                phpre_queueUnlockPDCScene = false
                UnlockEnemyBase()
              end
              EnableHeroes(true)
            end)
          end)
          unset_event()
        end)
        on_death(tank, function()
          ambientTankDead(1)
          unset_event()
        end)
        unset_event()
      end)
      if eventhandle_TriggerAmbDrones ~= nil then
        unset_event(eventhandle_TriggerAmbDrones)
        eventhandle_TriggerAmbDrones = nil
      end
      triggerAmbDrones = true
      tankActive[1] = true
      trigger_squad(ClueEnemySetup_tanks, 1, true, true, not global_newDone[1])
      if not global_any_invasion_active then
        set_track_invasion(true)
      end
      global_any_invasion_active = true
    end)
  end
end
on_elapsed(0.25, function()
  placement_operation(gp1_crane, AnimQuery.PLACEMENT_00)
end)
function SpawnTank1_CPFixup()
  if not checkSaveStateFlag("PHP_TankDead_1") then
    on_elapsed(1, function()
      PlayVO_Base_IncomingTank()
      triggerAMBtank(1, true)
      StartNewTankTimer(1)
      if not global_any_invasion_active then
        set_track_invasion(true)
      end
      global_any_invasion_active = true
    end)
  end
end
function AphelionLandingSequenceComplete()
  DroneIntro()
  ShowObj_GetAllKeynodes()
  checkpoint_set_respawn("cp_checkpoint_1")
  SaveGame(false)
  SetSaveStateFlag("IntroDrones")
end
function DoUnlockScreen()
  ActivateCamera(camAnim_openingPan)
  on_generic_event(GEN_EVENT_UNLOCK_MESSAGE_CLOSE, function()
    hide_unlock_message()
    DoPCHeroFocus(AphelionLandingSequenceComplete, aphelionHeroFocusCam_P2, aphelionHeroFocusAnimCamMoby_P2, aphelionHeroFocusCam_P1, aphelionHeroFocusAnimCamMoby_P1, {volPos_aphelionLand_focus_P2, volPos_aphelionLand_focus_P1}, heroActors, actor_ratchetWrench, aphelion_phpre, nil, false, false, false)
    MusicCheck_heroIntro = true
    unset_event()
  end)
  on_elapsed(1, function()
    on_no_conversation(function()
      set_new_defenses("HUD_UNLOCKED_DEFENSES", UDT_GROOVATRON_TRAP, UDT_HEAVY_BARRICADE, UDT_ROCKET_TURRET)
      set_new_enemies("HUD_UNLOCKED_ENEMIES", UET_TANK, UET_WRECKING_DRONE)
      show_unlock_message()
      unset_event()
    end)
  end)
end
function StartLevel_PHPre()
  SetUpTanks()
  if get_qf_levels_completed() >= 3 then
    DoPCHeroFocus(AphelionLandingSequenceComplete, aphelionHeroFocusCam_P2, aphelionHeroFocusAnimCamMoby_P2, aphelionHeroFocusCam_P1, aphelionHeroFocusAnimCamMoby_P1, {volPos_aphelionLand_focus_P2, volPos_aphelionLand_focus_P1}, heroActors, actor_ratchetWrench, aphelion_phpre, CamArgOpeningView_PH, true, true, true, area_heroFocusPos)
    MusicCheck_heroIntro = true
  else
    DoUnlockScreen()
  end
end
local PutAphelionInLandingPosition = function()
  reveal(aphelion_phpre)
  placement_operation(aphelion_phpre, AnimQuery.PLACEMENT_05)
  play_anim_query(aphelion_phpre, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
end
function ShowTakeOffScene(returnToPhoenix, callback, skipFade)
  if returnToPhoenix == nil then
    returnToPhoenix = true
  end
  skipFade = skipFade or false
  if getSave_NumTimesPlayerLostBase() == 0 and get_num_alive(pod_basegenerators) == 6 then
    set_medal_all_gens_alive()
  end
  stop_level_timer()
  set_current_level_complete()
  StoreAndSave_LastMissionSuccessful()
  request_auto_save()
  unset_event(eventHandle_spawnTank1)
  local delayTime = 0.1
  if not skipFade then
    fade_to_black(1)
    delayTime = 1
  end
  on_elapsed(delayTime, function()
    HideHeroTurrets()
    hide(baseHeroTurret_left)
    hide(baseHeroTurret_right)
    set_hero_invincibility(true)
    warp_heroes(volWarp_hero_outOfTheWay_1, volWarp_hero_outOfTheWay_2, volWarp_hero_outOfTheWay_3, volWarp_hero_outOfTheWay_4, true, false, false, false)
    DisableHeroes()
    start_cine()
    placement_operation(aphelion_phpre, AnimQuery.PLACEMENT_05)
    bangle_off(base_slam_buttons_1P[1], 2, true)
    fade_from_black(0.5)
    ActivateCamera(camAnim_aphTakeOff)
    MusicCheck_takeOff = true
    on_generic_event(animCamEntity_aphelionTakeOff, GEN_EVENT_ANIMATED_CAMERA_COMPLETE, function()
      set_hero_invincibility(false)
      if returnToPhoenix then
        fade_to_black(1)
        on_elapsed(0.75, function()
          on_no_conversation(function()
            set_hero_invincibility(false)
            do_most_wanted()
            unset_event()
          end)
        end)
      else
        fade_to_black(1)
        on_elapsed(0.75, function()
          on_no_conversation(function()
            set_hero_invincibility(false)
            if callback ~= nil then
              callback()
            end
            unset_event()
          end)
        end)
      end
      unset_event()
    end)
    play_anim_with_modifier(aphelion_phpre, AnimQuery.INTRO_CAT, AnimQuery.INTRO_FALL, AnimQuery.Modifiers.PLACEMENT, AnimQuery.PLACEMENT_05)
    if returnToPhoenix then
      on_elapsed(0.2, PlayVO_PHPre_LevelEnd)
    end
  end)
end
function CraneAnims_Right2Left()
  play_anim_query(gp1_crane, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN)
  on_elapsed(5, function()
    play_anim_query(gp1_crane, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_IDLE)
    on_elapsed(5, function()
      play_anim_query(gp1_crane, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
      on_elapsed(5, function()
        play_anim_query(gp1_crane, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSED_IDLE)
        on_elapsed(5, function()
          return CraneAnims_Left2Right()
        end)
      end)
    end)
  end)
end
function CraneAnims_Left2Right()
  play_anim_query(gp1_crane, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
  on_elapsed(5, function()
    play_anim_query(gp1_crane, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_IDLE)
    on_elapsed(5, function()
      play_anim_query(gp1_crane, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_OPEN)
      on_elapsed(5, function()
        play_anim_query(gp1_crane, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSED_IDLE)
        on_elapsed(5, function()
          return CraneAnims_Right2Left()
        end)
      end)
    end)
  end)
end
hide(swingshot_traversal_crates)
on_hero_enter(gp1_volume_11, function()
  reveal(gp1_pod_swarmersTop)
  reveal(swingshot_traversal_crates)
  unset_event()
end)
deactivate(all_teleporters)
function setgrindrailspeed()
  hero_set_grind_speed(15)
end
local swingshotTrainingTrigger
function ShowSwingshotTrainingHelp()
  show_training_message("TEST_HELP_SWINGSHOT", 8, 0)
end
function HideSwingshotTrainingHelp()
  kill_training_message()
end
function ActivateAllSwingshots(fixup)
  fixup = fixup or false
  if checkSaveStateFlag("MajorNodeField_Left") then
    activate(gp03_swingshots)
  end
  if fixup then
    prt("Hide all swingshot gates")
    activate(gp01_swingshots)
    activate(gp02_swingshots)
  end
  UnsetVOTrigger_NeedSwingshot()
  on_hero_enter_volume(gp2_volume_4, function()
    reveal(gp2_swarmer_13)
    reveal(gp2_swarmer_14)
    unset_event()
  end)
end
function DeactivateAllSwingshots()
  deactivate(gp01_swingshots)
  deactivate(gp02_swingshots)
  deactivate(gp03_swingshots)
end
DeactivateAllSwingshots()
function SwitchMapToPDCUnlocked()
  radar_set_map(RADAR_MAP_PLASMA_HARVESTER, 20, 190, 250, 367, 0.51, 0.51)
  radar_set_full_screen_map(RADAR_MAP_PLASMA_HARVESTER, 20, 190, 345, 460, 0.5, 0.5)
end
function SetupRadar()
  radar_point_at(ingameicon_player_base)
  if checkSaveStateFlag("pdcUnlocked") then
    SwitchMapToPDCUnlocked()
  else
    radar_set_map(RADAR_MAP_PLASMA_HARVESTER_LOCKED, 20, 190, 250, 367, 0.51, 0.51)
    radar_set_full_screen_map(RADAR_MAP_PLASMA_HARVESTER_LOCKED, 20, 190, 345, 460, 0.5, 0.5)
  end
  radar_set_base_area(area_heroBase_forMap)
end
SetupRadar()
enemy_set_inner_awareness(pod_swingshot_swarmers, 0)
enemy_set_outer_awareness(pod_swingshot_swarmers, 0)
function OpenMiddleNodeArea()
  activate(aaron_swingshot_gate_main)
  coll_off(pod_ALL_SwingshotGates)
  enemy_set_inner_awareness(pod_swingshot_swarmers, 80)
  enemy_set_outer_awareness(pod_swingshot_swarmers, 100)
  if is_alive(gp1_brawler_16) then
    enemy_set_inner_awareness(gp1_brawler_16, 40)
    enemy_set_outer_awareness(gp1_brawler_16, 60)
  end
  if is_alive(gp1_brawler_15) then
    enemy_set_inner_awareness(gp1_brawler_15, 40)
    enemy_set_outer_awareness(gp1_brawler_15, 60)
  end
  if swingshotTrainingTrigger ~= nil then
    swingshotTrainingTrigger:UnsetTrigger()
    kill_training_message()
  end
end
on_hero_enter(gp1_volume_3, function()
  SetSaveStateFlag("MiddleAreaGates")
  OpenMiddleNodeArea()
  unset_event()
end)
hide(gp1_pod_swarmersBottom)
hide(gp1_brawler_15)
hide(gp1_brawler_16)
function SetupAllTheThings()
  if is_alive(gp1_swarmer_football_1) then
    enemy_set_inner_awareness(gp1_swarmer_football_1, 35)
    enemy_set_outer_awareness(gp1_swarmer_football_1, 45)
  end
  if is_alive(gp1_swarmer_football_2) then
    enemy_set_inner_awareness(gp1_swarmer_football_2, 35)
    enemy_set_outer_awareness(gp1_swarmer_football_2, 45)
  end
  if is_alive(gp1_swarmer_football_3) then
    enemy_set_inner_awareness(gp1_swarmer_football_3, 35)
    enemy_set_outer_awareness(gp1_swarmer_football_3, 45)
  end
  if is_alive(gp1_swarmer_football_4) then
    enemy_set_inner_awareness(gp1_swarmer_football_4, 35)
    enemy_set_outer_awareness(gp1_swarmer_football_4, 45)
  end
  reveal(gp1_pod_swarmersBottom)
  reveal(gp1_brawler_15)
  reveal(gp1_brawler_16)
  SetSaveStateFlag("StartField_Down")
end
on_elapsed(0.5, function()
  SetupAllTheThings()
end)
function destroygenerators()
  damage(pod_basegenerators, 200)
end
function BringGameToCorrectState()
  on_elapsed(1, SetUpTanks)
  CheckpointFixup_Objectives()
  if checkSaveStateFlag("PHP_TankDead_1") then
    CraneAnims_Right2Left()
  end
  if checkSaveStateFlag("MiddleAreaGates") then
    OpenMiddleNodeArea()
  end
  if checkSaveStateFlag("BaseSnapShot_Left") then
    reveal(gp1_springshot_left)
    activate(gp1_springshot_left)
  end
  if checkSaveStateFlag("BaseSnapShot_Right") then
    reveal(gp1_springshot_right)
    activate(gp1_springshot_right)
  end
  if checkSaveStateFlag("PHP_TankDead_3") then
    deactivate(pod_Tank_3_Barrier_1)
    on_elapsed(1, function()
      hide(pod_Tank_3_Barrier_1)
    end)
  end
  if checkSaveStateFlag("PHP_TankDead_2") then
    deactivate(pod_Tank_2_Barrier_1)
    deactivate(pod_Tank_2_Barrier_2)
  end
  if checkSaveStateFlag("MajorNodeField_Left") then
    deactivate(pod_StartField_5)
    hide(StartField_5_Gen)
    on_elapsed(1, function()
      hide(gp3_GenEnemies_1_WatchPod_1)
    end)
    hide(gp3_Turret_1)
    hide(gp3_Turret_2)
  end
  SetupVO_Zurgo_Taunt()
  if checkSaveStateFlag("StartField_Down") then
    hide(pod_StartField_2_Enemies)
    reveal(gp1_pod_swarmersBottom)
    reveal(gp1_brawler_15)
    reveal(gp1_brawler_16)
  end
  DroneIntro(true)
  if global_allow_ambient_invasions and not checkSaveStateFlag("pdcUnlocked") then
    on_elapsed(math.random(180, 300), StartAmbientInvasion)
    if global_cameFromPhoenix then
      on_elapsed(120, StartAmbientDrones)
    end
  end
end
SetupHeroDownVO()
on_elapsed(0.5, function()
  if not checkSaveStateFlag("StartField_Down") then
    SetupVO_BaseShield(viewSensor_seeBaseShieldGen_1, viewSensor_seeBaseShieldGen_2, pod_StartField_1_Gen)
  end
end)
SetupVOTrigger_NeedSwingshot(viewSensor_spring_toRtMjr, 1)
SetupVOTrigger_NeedSwingshot(viewSensor_needSwing_toLftMjrNode, 2)
SetupVOTrigger_NeedSwingshot(viewSensor_swingshot_goldbolt, 3)
SetupVOTrigger_NeedSwingshot(viewSensor_seeBaseShieldGen_3, 4)
SetupVOTrigger_NeedSwingshot(viewSensor_seeBaseShieldGen_4, 5)
SetupVOTrigger_NeedSwingshot(viewSensor_spring_toRtMjr1, 6)
SetupVOTrigger_QwarkNearPDCWithEnemies(volDetect_heroesNearPDC, PDC_refill_1c)
function cp_fixup_default()
  set_phoenix_flag(false)
  reveal(setupPod_grenadeNode)
  hide(PDCcrates)
  deactivate(AllPDCBarriers)
  ResetSaveStateFlags()
  InitNodes()
  SetupRadar()
  ResetWeapons()
  ResetHeroBolts()
  start_level_timer()
  fade_to_black(0)
  on_elapsed(0.25, ShowLandingScene)
  enemy_set_inner_awareness(gp1_swarmer_football_1, 0)
  enemy_set_outer_awareness(gp1_swarmer_football_1, 0)
  enemy_set_inner_awareness(gp1_swarmer_football_2, 0)
  enemy_set_outer_awareness(gp1_swarmer_football_2, 0)
  enemy_set_inner_awareness(gp1_swarmer_football_3, 0)
  enemy_set_outer_awareness(gp1_swarmer_football_3, 0)
  enemy_set_inner_awareness(gp1_swarmer_football_4, 0)
  enemy_set_outer_awareness(gp1_swarmer_football_4, 0)
end
register_checkpoint_fixup("cp_default", cp_fixup_default)
function cp_fixup_checkpoint_1()
  SetCameFromPhoenix()
  ShowHeroTurrets()
  reveal(setupPod_grenadeNode)
  hide(PDCcrates)
  deactivate(AllPDCBarriers)
  SetSaveValuesFromSaveTable()
  SetupRadar()
  ResetWeapons()
  BringGameToCorrectState()
  BringNodesToCorrectStates()
  InitNodes()
  enemy_set_inner_awareness(gp1_swarmer_football_1, 0)
  enemy_set_outer_awareness(gp1_swarmer_football_1, 0)
  enemy_set_inner_awareness(gp1_swarmer_football_2, 0)
  enemy_set_outer_awareness(gp1_swarmer_football_2, 0)
  enemy_set_inner_awareness(gp1_swarmer_football_3, 0)
  enemy_set_outer_awareness(gp1_swarmer_football_3, 0)
  enemy_set_inner_awareness(gp1_swarmer_football_4, 0)
  enemy_set_outer_awareness(gp1_swarmer_football_4, 0)
  PutAphelionInLandingPosition()
  if checkSaveStateFlag("pdcTaken") then
    StartMission_ReprogPDC(true)
  end
end
register_checkpoint_fixup("cp_checkpoint_1", cp_fixup_checkpoint_1)
function cp_fixup_checkpoint_Josh()
  SetSaveStateFlag("IntroDrones")
  SetCameFromPhoenix()
  ShowHeroTurrets()
  hide(PDCcrates)
  deactivate(AllPDCBarriers)
  SetSaveValuesFromSaveTable()
  SetupRadar()
  ResetWeapons()
  BringGameToCorrectState()
  BringNodesToCorrectStates()
  InitNodes()
  PutAphelionInLandingPosition()
  on_elapsed(1, function()
    reveal(gp1_pod_swarmersBottom)
    reveal(gp1_brawler_15)
    reveal(gp1_brawler_16)
  end)
end
register_checkpoint_fixup("cp_checkpoint_Josh", cp_fixup_checkpoint_Josh)
local function cp_fixup_checkpoint_MajorAssault()
  SetCameFromPhoenix()
  ShowHeroTurrets()
  hide(PDCcrates)
  deactivate(AllPDCBarriers)
  SetSaveValuesFromSaveTable()
  SetupRadar()
  ResetWeapons()
  SetSaveStateFlag("StartField_Down")
  SetSaveStateFlag("nodeTaken_gateRight")
  SetSaveStateFlag("nodeTaken_gateLeft")
  SetSaveStateFlag("pdcUnlocked")
  SetSaveStateFlag("pdcTaken")
  SetSaveStateFlag("PHP_TankDead_1")
  SetSaveStateFlag("PHP_TankDead_2")
  SetSaveStateFlag("PHP_TankDead_3")
  BringNodesToCorrectStates()
  InitNodes()
  BringGameToCorrectState()
  PutAphelionInLandingPosition()
  StartMission_ReprogPDC(true)
end
register_checkpoint_fixup("cp_checkpoint_MajorAssault", cp_fixup_checkpoint_MajorAssault)
function cp_fixup_checkpoint_PDC_with_Opening()
  SetCameFromPhoenix()
  ShowHeroTurrets()
  SetSaveValuesFromSaveTable()
  SetupRadar()
  ResetWeapons()
  SetSaveStateFlag("StartField_Down")
  SetSaveStateFlag("nodeTaken_gateLeft")
  SetSaveStateFlag("nodeTaken_gateRight")
  UnlockPDC_skip_OpeningSequence()
  SetSaveStateFlag("PHP_TankDead_1")
  SetSaveStateFlag("PHP_TankDead_2")
  SetSaveStateFlag("PHP_TankDead_3")
  BringNodesToCorrectStates()
  InitNodes()
  BringGameToCorrectState()
  PutAphelionInLandingPosition()
  deactivate(ClueRespawn_Default)
  activate(ClueRespawn_PDCBattle)
end
register_checkpoint_fixup("cp_checkpoint_PDC_with_Opening", cp_fixup_checkpoint_PDC_with_Opening)
function cp_fixup_checkpoint_LeftNode()
  SetCameFromPhoenix()
  ShowHeroTurrets()
  SetSaveValuesFromSaveTable()
  SetupRadar()
  ResetWeapons()
  SetSaveStateFlag("StartField_Down")
  SetSaveStateFlag("nodeTaken_gateRight")
  BringGameToCorrectState()
  BringNodesToCorrectStates()
  InitNodes()
  PutAphelionInLandingPosition()
  reveal(setupPod_grenadeNode)
end
register_checkpoint_fixup("cp_checkpoint_LeftNode", cp_fixup_checkpoint_LeftNode)
function cp_fixup_checkpoint_RightNode()
  SetCameFromPhoenix()
  ShowHeroTurrets()
  SetSaveValuesFromSaveTable()
  SetupRadar()
  ResetWeapons()
  SetSaveStateFlag("StartField_Down")
  SetSaveStateFlag("nodeTaken_gateLeft")
  BringNodesToCorrectStates()
  InitNodes()
  BringGameToCorrectState()
  PutAphelionInLandingPosition()
  reveal(setupPod_rocketNode)
end
register_checkpoint_fixup("cp_checkpoint_RightNode", cp_fixup_checkpoint_RightNode)
function StopAllInvasions()
  PauseInvasion()
end
function ResumeAllInvasions()
  if not global_amb_invasion_stopped then
    UnPauseInvasion()
  end
end
PlayersOnGrindRailCheck = false
on_all_hero_enter(All_Area_Grindtubes, function()
  prt("Player(s) ON Grindrails.")
  PlayersOnGrindRailCheck = true
  if not unlockenemybasecheck then
    prt("Stop All Invasions and Ambient Drones.")
    StopAllInvasions()
    on_hero_exit(All_Area_Grindtubes, function()
      prt("Player(s) OFF Grindrails.")
      prt("Resume All Invasions and Ambient Drones.")
      PlayersOnGrindRailCheck = false
      if not unlockenemybasecheck then
        if needToTriggerDrones then
          prt("needToTriggerDrones check passed. Trigger Ambient Drones.")
          TriggerCurrentDrones()
        end
        ResumeAllInvasions()
      end
      unset_event()
    end)
  end
end)
on_hero_enter(gp1_volume_12, function()
  reveal(gp1_missile_minion_5)
  reveal(gp1_missile_minion_6)
  unset_event()
end)
on_hero_enter(gp1_volume_13, function()
  reveal(gp1_missile_minion_5)
  reveal(gp1_missile_minion_6)
  unset_event()
end)
hide(gp1_brawler_2)
on_health_percentage(gp1_brawler_1, 0.99, function()
  reveal(gp1_brawler_2)
  unset_event()
end)
local TankBackData = {
  Tank2 = {
    tankMoby = nil,
    healthTriggers = {
      0.9,
      0.7,
      0.5,
      0.3,
      0.1
    },
    allowBackup = true,
    tankScent = scent_Tank_2_Backup,
    tankBackupDir = CES_Tank2_Backup_2,
    tankBackupWave = {
      1,
      1,
      1,
      1,
      1
    },
    event_handleOnEnter = nil,
    event_handleOnDamage = nil
  },
  Tank3 = {
    tankMoby = nil,
    healthTriggers = {
      0.9,
      0.7,
      0.5,
      0.3,
      0.1
    },
    allowBackup = true,
    tankScent = scent_Tank_3_Backup,
    tankBackupDir = CES_Tank3_Backup_1,
    tankBackupWave = {
      1,
      1,
      1,
      1,
      1
    },
    event_handleOnEnter = nil,
    event_handleOnDamage = nil
  }
}
function SetupTankBrawlerBros(tankData, index)
  if index > #tankData.healthTriggers then
    tankData.allowBackup = false
  end
  if not tankData.allowBackup then
    return
  end
  if tankData.event_handleOnDamage ~= nil then
    unset_event(tankData.event_handleOnDamage)
    tankData.event_handleOnDamage = nil
  end
  tankData.event_handleOnDamage = on_health_percentage(tankData.tankMoby, tankData.healthTriggers[index], function()
    if not tankDancingStopDrones[tankData.tankID] then
      prt("Tank NOT Dancing Spawn Drones")
      prt("mytankID = " .. tankData.tankID)
      trigger_wave(tankData.tankBackupDir, tankData.tankBackupWave[index])
    end
    tankData.event_handleOnDamage = nil
    SetupTankBrawlerBros(tankData, index + 1)
    unset_event()
  end)
end
function setupTankBackup(tankName, tank, tankID)
  local tankData = TankBackData[tankName]
  prt("setup TankID = " .. tostring(tankID))
  tankData.tankMoby = tank
  tankData.tankID = tankID
  tankData.allowBackup = true
  set_move_scent(tankData.tankMoby, tankData.tankScent)
  SetupTankBrawlerBros(tankData, 1)
end
function Tank3BackupListener(tank, tankID)
  setupTankBackup("Tank3", tank, tankID)
end
function unsetTank3BackupListener()
  local tankData = TankBackData.Tank3
  if tankData.event_handleOnEnter ~= nil then
    unset_event(tankData.event_handleOnEnter)
    tankData.event_handleOnEnter = nil
  end
  if tankData.event_handleOnDamage ~= nil then
    unset_event(tankData.event_handleOnDamage)
    tankData.event_handleOnDamage = nil
  end
end
function Tank2BackupListener(tank, tankID)
  setupTankBackup("Tank2", tank, tankID)
end
function unsetTank2BackupListener()
  local tankData = TankBackData.Tank2
  if tankData.event_handleOnEnter ~= nil then
    unset_event(tankData.event_handleOnEnter)
    tankData.event_handleOnEnter = nil
  end
  if tankData.event_handleOnDamage ~= nil then
    unset_event(tankData.event_handleOnDamage)
    tankData.event_handleOnDamage = nil
  end
end
prt("End zone_gameplay_01.lua")
