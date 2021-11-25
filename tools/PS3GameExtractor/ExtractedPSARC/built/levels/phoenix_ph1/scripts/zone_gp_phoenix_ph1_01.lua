prt("----> LOADED gp_phoenix_ph1_01 SCRIPT")
hide(cleaner_bots)
hide(pod_actor_UnusedHeroes)
global_phoenixCurHelpMsg = "none"
set_phoenix_flag(true)
global_curLevelPhoenix = true
radar_disable()
disable_weapon_select()
ResetWeapons(false)
ResetHeroBolts()
play_anim_query(aphelion, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
hide(phoLeavePlanet)
postPhoIntroState = false
local InitDisplayWeapons = function()
  local wpns = {
    WPN_COMBUSTER,
    WPN_GROOVITRON,
    WPN_ROCKET_LAUNCHER,
    WPN_SWINGSHOT,
    WPN_BUZZ_BLADES,
    WPN_DECOY,
    WPN_FLAMETHROWER,
    WPN_ICE_BEAM,
    WPN_GRENADE_LAUNCHER,
    WPN_ZURKON,
    WPN_SUBWOOFER,
    WPN_THUNDERSTRIKE
  }
  local wpnMoby = {
    combuster_display,
    groovitron_ball_display,
    warmonger_display,
    swingshot_display,
    buzz_blades_display,
    decoy_display_3,
    flamethrower_display,
    icebeam_display,
    pbl_display,
    zurkon_display,
    subwoofer_display,
    thundersmack_display
  }
  local wpnMoby2 = {
    combuster_display,
    groovitron_glove_display,
    warmonger_display,
    swingshot_display,
    buzz_blades_upgrade_display,
    decoy_display_3,
    flamethrower_display,
    icebeam_display,
    pbl_display,
    zurkon_display,
    subwoofer_display,
    thundersmack_glove_display
  }
  local i
  for i = 1, #wpns do
    set_display_weapon(wpns[i], wpnMoby[i], wpnMoby2[i])
  end
end
local function InitDisplayCases()
  local displayObjs = {zurkon_display, decoy_display_3}
  local i
  for i = 1, #displayObjs do
    play_anim_query(displayObjs[i], AnimQuery.IDLE_CAT, AnimQuery.IDLE_SLEEP)
  end
  play_anim_query(subwoofer_display, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_IDLE)
  play_anim_query(thundersmack_display, AnimQuery.OBJECT_CAT, AnimQuery.OBJECT_CLOSE)
  hide(buzz_blades_upgrade_display)
  InitDisplayWeapons()
end
InitDisplayCases()
local qwarkAmbPos = {
  volAmbActPos_nearBridge_console_1,
  volAmbActPos_engineRoom_console_1,
  volAmbActPos_hall_console_2
}
local clankAmbPos = {
  volAmbActPos_nearBridge_console_2,
  volAmbActPos_nearBridge_console_1,
  volAmbActPos_bridge_atMap_1
}
local ratchetAmbPos = {
  volAmbActPos_hall_console_1,
  volAmbActPos_nearBridge_console_2,
  volAmbActPos_bridge_atMap_2
}
local qwarkNearAmbPos = {
  volNear_AmbActPos_nearBridge_console_1,
  volNear_AmbActPos_engineRoom_console_1,
  volNear_AmbActPos_hall_console_2
}
local clankNearAmbPos = {
  volNear_AmbActPos_nearBridge_console_2,
  volNear_AmbActPos_nearBridge_console_1,
  volNear_AmbActPos_bridge_atMap_1
}
local ratchetNearAmbPos = {
  volNear_AmbActPos_hall_console_1,
  volNear_AmbActPos_nearBridge_console_2,
  volNear_AmbActPos_bridge_atMap_2
}
local ambPosIndex = 1
deactivate(viewSensor_clankAfterPhoIntro)
deactivate(viewSensor_ratchetAfterPhoIntro)
local eventHandle_movePostPhoIntroClank = event_handle:new()
local eventHandle_movePostPhoIntroRatchet = event_handle:new()
local eventHandle_detectHeroesAwayFromBridge = event_handle:new()
local eventHandle_ambBridgeHeroes_pcNear = event_handle:new()
local clankOrigAmbPos1 = volAmbActPos_nearBridge_console_2
local ratchetOrigAmbPos1 = volAmbActPos_nearBridge_console_2
function SetupPostPhoIntroClank()
  clankAmbPos[1] = volWarp_bridge_3
  clankNearAmbPos[1] = volNear_Warp_bridge_3
  eventHandle_ambBridgeHeroes_pcNear = on_hero_enter(vol_move_amb_bridge_heroes, function()
    deactivate(viewSensor_clankAfterPhoIntro)
    if eventHandle_movePostPhoIntroClank ~= nil then
      unset_event(eventHandle_movePostPhoIntroClank)
      eventHandle_movePostPhoIntroClank = nil
    end
    if eventHandle_detectHeroesAwayFromBridge ~= nil then
      unset_event(eventHandle_detectHeroesAwayFromBridge)
      eventHandle_detectHeroesAwayFromBridge = nil
    end
    eventHandle_detectHeroesAwayFromBridge = on_all_hero_exit(vol_move_amb_bridge_heroes, function()
      eventHandle_movePostPhoIntroClank = on_generic_event(viewSensor_clankAfterPhoIntro, GEN_EVENT_NONE_IN_VIEW, function()
        warp(clank_phoenix, volAmbActPos_bridge_console5)
        eventHandle_movePostPhoIntroClank = nil
        deactivate(viewSensor_clankAfterPhoIntro)
        UnsetTriggerAmbBridgeHeroMove()
        unset_event()
      end)
      activate(viewSensor_clankAfterPhoIntro)
      unset_event()
    end)
  end)
end
function SetupPostPhoIntroRatchet()
  ratchetAmbPos[1] = volWarp_bridge_1
  ratchetNearAmbPos[1] = volNear_Warp_bridge_1
  eventHandle_ambBridgeHeroes_pcNear = on_hero_enter(vol_move_amb_bridge_heroes, function()
    deactivate(viewSensor_ratchetAfterPhoIntro)
    if eventHandle_movePostPhoIntroRatchet ~= nil then
      unset_event(eventHandle_movePostPhoIntroRatchet)
      eventHandle_movePostPhoIntroRatchet = nil
    end
    if eventHandle_detectHeroesAwayFromBridge ~= nil then
      unset_event(eventHandle_detectHeroesAwayFromBridge)
      eventHandle_detectHeroesAwayFromBridge = nil
    end
    eventHandle_detectHeroesAwayFromBridge = on_all_hero_exit(vol_move_amb_bridge_heroes, function()
      eventHandle_movePostPhoIntroRatchet = on_generic_event(viewSensor_ratchetAfterPhoIntro, GEN_EVENT_NONE_IN_VIEW, function()
        warp(ratchet_phoenix, volAmbActPos_bridge_atMap_3)
        eventHandle_movePostPhoIntroRatchet = nil
        deactivate(viewSensor_ratchetAfterPhoIntro)
        UnsetTriggerAmbBridgeHeroMove()
        unset_event()
      end)
      activate(viewSensor_ratchetAfterPhoIntro)
      unset_event()
    end)
  end)
end
function SetupPostPhoIntro_AmbRatchetNClank()
  postPhoIntroState = true
  if is_hero_active(get_ratchet()) and not is_hero_active(get_clank()) then
    SetupPostPhoIntroClank()
  elseif is_hero_active(get_clank()) and not is_hero_active(get_ratchet()) then
    SetupPostPhoIntroRatchet()
  else
    clankAmbPos[1] = volWarp_bridge_3
    clankNearAmbPos[1] = volNear_Warp_bridge_3
    ratchetAmbPos[1] = volWarp_bridge_1
    ratchetNearAmbPos[1] = volNear_Warp_bridge_1
  end
end
function RestoreAmbRatchetNClank()
  clankAmbPos[1] = volWarp_byMap_2
  clankNearAmbPos[1] = volNear_Warp_byMap_2
  warp(clank_phoenix, volWarp_byMap_2)
  ratchetAmbPos[1] = volWarp_byMap_3
  warp(ratchet_phoenix, volWarp_byMap_3)
  ratchetNearAmbPos[1] = volNear_Warp_byMap_3
  qwarkAmbPos[1] = volWarp_byMap_5
  qwarkNearAmbPos[1] = volNear_Warp_byMap_5
  warp(qwark_phoenix, volWarp_byMap_5)
  bangle_on(qwark_phoenix, 26, true)
  bangle_off(qwark_phoenix, 1, true)
  bangle_off(qwark_phoenix, 2, true)
  bangle_off(qwark_phoenix, 3, true)
  bangle_off(qwark_phoenix, 4, true)
end
function UnsetTriggerAmbBridgeHeroMove()
  if eventHandle_ambBridgeHeroes_pcNear ~= nil then
    unset_event(eventHandle_ambBridgeHeroes_pcNear)
    eventHandle_ambBridgeHeroes_pcNear = nil
  end
  if eventHandle_detectHeroesAwayFromBridge ~= nil then
    unset_event(eventHandle_detectHeroesAwayFromBridge)
    eventHandle_detectHeroesAwayFromBridge = nil
  end
  if eventHandle_movePostPhoIntroClank ~= nil then
    unset_event(eventHandle_movePostPhoIntroClank)
  end
  if eventHandle_movePostPhoIntroRatchet ~= nil then
    unset_event(eventHandle_movePostPhoIntroRatchet)
  end
end
hide(qwark_amb_bathrobe_path)
deactivate(viewSensor_seeQwarkBashCleaner)
local whichQwark_altIdle = 1
local doManage_qwarkAltIdles = false
local doQwarkCleaner_end = false
local eventHandles_onAnimComp_qwarkBash = {}
local qwarkBashBot = false
function PlayAmbientQwarkBashBotAnim_RegIdle()
  play_anim_query(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_SPLATTERED)
  play_anim_query(swarmerAnim_qwarkBash, AnimQuery.INTRO_CAT, AnimQuery.INTRO_SPLATTERED)
end
function PlayAmbientQwarkBashBotAnim_AltIdle1()
  play_anim_query(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_CANNED)
  play_anim_query(swarmerAnim_qwarkBash, AnimQuery.INTRO_CAT, AnimQuery.INTRO_CANNED)
end
function PlayAmbientQwarkBashBotAnim_AltIdle2()
  play_anim_query(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_MERGED)
  play_anim_query(swarmerAnim_qwarkBash, AnimQuery.INTRO_CAT, AnimQuery.INTRO_MERGED)
end
function QwarkBashInView()
end
local function LoopAmbientQwark_ClearnerBot()
  eventHandles_onAnimComp_qwarkBash[1] = on_anim_percentage(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_SPLATTERED, 1, function()
    if doQwarkCleaner_end then
      PlayAmbientQwarkBashBotAnim_End()
    elseif doQwark_altIdle then
      if whichQwark_altIdle == 1 then
        PlayAmbientQwarkBashBotAnim_AltIdle1()
      else
        PlayAmbientQwarkBashBotAnim_AltIdle2()
      end
    else
      PlayAmbientQwarkBashBotAnim_RegIdle()
    end
  end)
  eventHandles_onAnimComp_qwarkBash[2] = on_anim_percentage(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_CANNED, 1, function()
    doQwark_altIdle = false
    if doQwarkCleaner_end then
      PlayAmbientQwarkBashBotAnim_End()
    else
      PlayAmbientQwarkBashBotAnim_RegIdle()
    end
  end)
  eventHandles_onAnimComp_qwarkBash[3] = on_anim_percentage(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_MERGED, 1, function()
    doQwark_altIdle = false
    if doQwarkCleaner_end then
      PlayAmbientQwarkBashBotAnim_End()
    else
      PlayAmbientQwarkBashBotAnim_RegIdle()
    end
  end)
end
function ManageWhichQwarkBashAltIdle()
  if not doManage_qwarkAltIdles then
    return
  end
  whichQwark_altIdle = 1
  on_elapsed(math.random(5, 12), function()
    whichQwark_altIdle = 2
    on_elapsed(math.random(7, 12), ManageWhichQwarkBashAltIdle)
  end)
end
function ManageQwarkAltIdle()
  on_elapsed(math.random(3, 7), function()
    if doManage_qwarkAltIdles then
      doQwark_altIdle = true
      ManageQwarkAltIdle()
    end
  end)
end
function QwarkBash_GotoBridge()
  play_anim_query(qwark_amb_bathrobe_path, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_4, 1, 0.5)
  set_pf_speed(qwark_amb_bathrobe_path, 2, 100)
  switch_pf_path(qwark_amb_bathrobe_path, path_qwarkBash_exit)
  set_pf_speed(qwark_amb_bathrobe_path, 25, 8)
  on_enter(qwark_amb_bathrobe_path, volDetect_qwarkBash_atBridge, function()
    set_pf_speed(qwark_amb_bathrobe_path, 18, 6)
    on_elapsed(0.5, function()
      set_pf_speed(qwark_amb_bathrobe_path, 12, 6)
    end)
    on_elapsed(0.8, function()
      set_pf_speed(qwark_amb_bathrobe_path, 8, 6)
    end)
    on_elapsed(1.2, function()
      set_pf_speed(qwark_amb_bathrobe_path, 2, 6)
      on_elapsed(0.25, function()
        play_anim_query(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_CROUCHTOSTAND)
        on_anim_percentage(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_CROUCHTOSTAND, 1, function()
          play_anim_query(qwark_amb_bathrobe_path, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
          unset_event()
        end)
      end)
      on_elapsed(0.75, function()
        set_pf_speed(qwark_amb_bathrobe_path, 0, 100)
      end)
    end)
    unset_event()
  end)
end
local qwarkBashReadyToGo = false
function ReadyForQwarkBashToGoToBridge()
  if qwarkBashReadyToGo then
    return QwarkBash_GotoBridge()
  else
    qwarkBashReadyToGo = true
  end
end
function PlayAmbientQwarkBashBotAnim_End()
  qwarkBashBot = false
  UnsetQwarkBashVO()
  PlayVO_QwarkBash_Success(ReadyForQwarkBashToGoToBridge)
  on_anim_percentage(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_PEEKED, 1, function()
    play_anim_query(qwark_amb_bathrobe_path, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
    on_elapsed(0.25, ReadyForQwarkBashToGoToBridge)
    hide(swarmerAnim_qwarkBash)
    unset_event()
  end)
  play_anim_query(qwark_amb_bathrobe_path, AnimQuery.INTRO_CAT, AnimQuery.INTRO_PEEKED)
  play_anim_query(swarmerAnim_qwarkBash, AnimQuery.INTRO_CAT, AnimQuery.INTRO_PEEKED)
end
function QwarkBashLeave()
  doQwarkCleaner_end = true
end
function OnViewQwarkBashLeave()
  on_generic_event(viewSensor_seeQwarkBashCleaner, GEN_EVENT_IN_VIEW, function()
    QwarkBashLeave()
    unset_event()
  end)
  activate(viewSensor_seeQwarkBashCleaner)
end
function SetupAmbientQwark_CleanerBot()
  doQwark_altIdle = false
  doManage_qwarkAltIdles = true
  doQwarkCleaner_end = false
  ManageQwarkAltIdle()
  ManageWhichQwarkBashAltIdle()
  hide(qwark_phoenix)
  reveal(qwark_amb_bathrobe_path)
  bangle_on(qwark_amb_bathrobe_path, 26, true)
  bangle_off(qwark_amb_bathrobe_path, 1, true)
  bangle_off(qwark_amb_bathrobe_path, 2, true)
  bangle_off(qwark_amb_bathrobe_path, 3, true)
  bangle_off(qwark_amb_bathrobe_path, 4, true)
  set_pf_position(qwark_amb_bathrobe_path, volPos_qwarkBash)
  reveal(swarmerAnim_qwarkBash)
  warp(swarmerAnim_qwarkBash, volPos_qwarkBash)
  qwarkBashBot = true
  LoopAmbientQwark_ClearnerBot()
  PlayAmbientQwarkBashBotAnim_RegIdle()
  on_num_alive(cleaner_bots, 5, function()
    OnViewQwarkBashLeave()
    unset_event()
  end)
  on_num_alive(cleaner_bots, 3, function()
    QwarkBashLeave()
    unset_event()
  end)
end
function HideAmbientQwark_CleanerBot()
  hide(qwark_amb_bathrobe_path)
  hide(swarmerAnim_qwarkBash)
  local i
  for i = 1, #eventHandles_onAnimComp_qwarkBash do
    unset_event(eventHandles_onAnimComp_qwarkBash[i])
  end
  UnsetQwarkBashVO()
end
local doQwark_altIdle = false
function PlayAmbQwark_AltIdle(ambQwark)
  play_anim_query(ambQwark, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_2)
  on_anim_percentage(ambQwark, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_2, 1, function()
    SetupAmbQwark_IdleLoop(ambQwark)
    unset_event()
  end)
end
function PlayAmbQwark_RegIdle(ambQwark)
  play_anim_query(ambQwark, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_1)
  on_anim_percentage(ambQwark, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_1, 1, function()
    if doQwark_altIdle then
      PlayAmbQwark_AltIdle(ambQwark)
    else
      PlayAmbQwark_RegIdle(ambQwark)
    end
    unset_event()
  end)
end
function SetupAmbQwark_IdleLoop(ambQwark)
  doQwark_altIdle = false
  on_elapsed(math.random(5, 15), function()
    doQwark_altIdle = true
  end)
  PlayAmbQwark_RegIdle(ambQwark)
end
local function SetupAmbientQwark()
  local ambQwark = qwark_phoenix
  warp(ambQwark, qwarkAmbPos[ambPosIndex])
  reveal(ambQwark)
  SetupAmbQwark_IdleLoop(ambQwark)
  SetupVO_PH_AmbHero(3, qwarkNearAmbPos[ambPosIndex])
end
local doClank_altIdle = false
function PlayAmbClank_AltIdle(ambClank)
  play_anim_query(ambClank, AnimQuery.IDLE_CAT, AnimQuery.IDLE_GRAVY)
  on_anim_percentage(ambClank, AnimQuery.IDLE_CAT, AnimQuery.IDLE_GRAVY, 1, function()
    SetupAmbClank_IdleLoop(ambClank)
    unset_event()
  end)
end
function PlayAmbClank_RegIdle(ambClank)
  play_anim_query(ambClank, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_1)
  on_anim_percentage(ambClank, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_1, 1, function()
    if doClank_altIdle then
      PlayAmbClank_AltIdle(ambClank)
    else
      PlayAmbClank_RegIdle(ambClank)
    end
    unset_event()
  end)
end
function SetupAmbClank_IdleLoop(ambClank)
  doClank_altIdle = false
  on_elapsed(math.random(4, 20), function()
    doClank_altIdle = true
  end)
  PlayAmbClank_RegIdle(ambClank)
end
local function SetupAmbientClank()
  local ambClank = clank_phoenix
  warp(ambClank, clankAmbPos[ambPosIndex])
  reveal(ambClank)
  SetupAmbClank_IdleLoop(ambClank)
  SetupVO_PH_AmbHero(2, clankNearAmbPos[ambPosIndex])
end
local doRatchet_altIdle = false
function PlayAmbRatchet_AltIdle(ambRatchet)
  play_anim_query(ambRatchet, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_2)
  on_anim_percentage(ambRatchet, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_2, 1, function()
    SetupAmbRatchet_IdleLoop(ambRatchet)
    unset_event()
  end)
end
function PlayAmbRatchet_RegIdle(ambRatchet)
  play_anim_query(ambRatchet, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_1)
  on_anim_percentage(ambRatchet, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_1, 1, function()
    if doRatchet_altIdle then
      PlayAmbQwark_AltIdle(ambRatchet)
    else
      PlayAmbRatchet_RegIdle(ambRatchet)
    end
    unset_event()
  end)
end
function SetupAmbRatchet_IdleLoop(ambRatchet)
  doRatchet_altIdle = false
  on_elapsed(math.random(6, 12), function()
    doRatchet_altIdle = true
  end)
  PlayAmbRatchet_RegIdle(ambRatchet)
end
function SetupAmbRatchet_StandIdle(ambRatchet)
  play_anim_query(ambRatchet, AnimQuery.MANIPULATE_CAT, AnimQuery.MANIPULATE_WHEEL_IDLE)
end
function SetupAmbientRatchet()
  local ambRatchet = ratchet_phoenix
  warp(ambRatchet, ratchetAmbPos[ambPosIndex])
  reveal(ambRatchet)
  if postPhoIntroState then
    SetupAmbRatchet_StandIdle(ambRatchet)
  else
    SetupAmbRatchet_IdleLoop(ambRatchet)
  end
  SetupVO_PH_AmbHero(1, ratchetNearAmbPos[ambPosIndex])
end
local function SetupAmbientHero(hero)
  if hero == "qwark" then
    SetupAmbientQwark()
  elseif hero == "clank" then
    SetupAmbientClank()
  elseif hero == "ratchet" then
    SetupAmbientRatchet()
  end
end
local function ShowAmbientHeroes(doNotDoQwark)
  doNotDoQwark = doNotDoQwark or false
  ambPosIndex = 1 + getSaveData_NumTimesVisitedPhoenix() % 3
  local heroes = {
    get_ratchet(),
    get_clank(),
    get_qwark()
  }
  local hero_names = {
    "ratchet",
    "clank",
    "qwark"
  }
  local i
  local endIndex = 3
  if doNotDoQwark then
    endIndex = 2
  end
  for i = 1, endIndex do
    if not is_hero_active(heroes[i]) then
      SetupAmbientHero(hero_names[i])
    end
  end
end
function HideAmbientHeroes()
  hide(pod_actor_UnusedHeroes)
end
function RevealAmbientHeroes()
  local heroes = {
    get_ratchet(),
    get_clank(),
    get_qwark()
  }
  local actors = {
    ratchet_phoenix,
    clank_phoenix,
    qwark_phoenix
  }
  local i
  for i = 1, 3 do
    if not is_hero_active(heroes[i]) then
      reveal(actors[i])
      if i == 3 then
        play_anim_query(actors[i], AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
        on_anim_percentage(actors[i], AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND, 1, function()
          play_anim_query(actors[i], AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
        end)
      end
    end
  end
end
hide(bleep_phoenix)
hide(blop_phoenix)
function SetRobots_Walking()
  reveal(blop_phoenix)
  reveal(bleep_phoenix)
  play_anim_query(bleep_phoenix, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
  play_anim_query(blop_phoenix, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
end
function SetRobots_AtConsole1()
  warp(blop_anim, volPos_robots_atLeftMidConsole_1)
  warp(bleep_anim, volPos_robots_atLeftMidConsole_2)
  play_anim_query(blop_anim, AnimQuery.IDLE_CAT, AnimQuery.IDLE_VAR_1)
  play_anim_query(bleep_anim, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
end
local PutPCQwarkInRobe = function()
  if is_hero_active(get_qwark()) then
    activate_qwark_bathrobe()
  end
end
local eventHandle_detectHeroesAtBridge
local player_at_bridge = false
local doTrigger_phoZurgo = false
local numCleanersKilled = 0
local function SetupListenForPlayerAtBridge()
  eventHandle_detectHeroesAtBridge = on_hero_enter(volDetect_heroesAtBridge, function()
    player_at_bridge = true
    if doTrigger_phoZurgo then
      PlayPhoZurgo()
    end
    on_all_hero_exit(volDetect_heroesAtBridge, function()
      player_at_bridge = false
      unset_event()
    end)
  end)
end
function Phoenix_FirstLoad()
  PutPCQwarkInRobe()
  hide(plumber)
  SetupVO_PH1_Plumber_BugProblem()
  warp_heroes(volWarp_bridge_1, volWarp_bridge_3, volWarp_bridge_2, volWarp_bridge_4)
  deactivate(galacticMapActivator)
  on_next_cine_end(function()
    ShowAmbientHeroes(true)
    ActivateCamera(camFixed_orientCamTowardsEngineRoom)
    GiveHelp_BasicControls()
    Phoenix_SwarmerMission_Start()
    on_elapsed(0.5, DeactivateCamera)
    unset_event()
  end)
  DisableHeroes()
  queue_cinematic("pho_intro_rt", {
    abort = true,
    hide_pod = Pho_Intro_RT_cinematic_HIDE_,
    reveal_pod = Pho_Intro_RT_cinematic_HIDE_,
    post_fade_in = CINE_FADE_BLACK,
    pre_fade_in = CINE_FADE_BLACK_SNAP
  })
end
local function ListenDestroyCleanerBot(cleaner)
  on_death(cleaner, function()
    numCleanersKilled = numCleanersKilled + 1
    UpdateCounter(numCleanersKilled)
    unset_event()
  end)
end
function Phoenix_SwarmerMission_Start()
  SetRobots_AtConsole1()
  SetupListenForPlayerAtBridge()
  if not is_hero_active(get_qwark()) then
    SetupAmbientQwark_CleanerBot()
  end
  on_hero_enter(inner_vol_swarmers, function()
    kill_training_message()
    SetupVO_PH1_CleanerBotMission()
    if not is_hero_active(get_qwark()) then
      SetupQwarkBashVO()
    end
    on_elapsed(1, function()
      global_phoenixCurHelpMsg = "melee"
      if global_phoenixNumDisplayUp == 0 then
        show_training_message("HELP_GEN_CONTROLS_MELEE", 8000, 0)
      end
    end)
    unset_event()
  end)
  ShowMission_PHO_1()
  reveal(cleaner_bots)
  StartCounter(get_num_alive(cleaner_bots), 0, true)
  for_each_moby_in_pod(cleaner_bots, ListenDestroyCleanerBot)
  on_num_alive(cleaner_bots, 0, function()
    Phoenix_SwarmerMission_Complete()
    unset_event()
  end)
end
function Phoenix_SwarmerMission_Complete()
  CompleteMission_PHO_CleanerBots()
  SetupPlumber_Before2ndCine_TeleOut()
  global_phoenixCurHelpMsg = "none"
  on_elapsed(0.5, kill_training_message)
  on_elapsed(1, EndCounter)
  on_elapsed(2, function()
    UnsetVO_PH_AllAmbHero_OnEnter()
    PlayVO_PH1_ReturnToBridge()
    on_no_conversation(function()
      ShowMission_PHO_AnswerComm()
      on_elapsed(1.75, ShowHelp_Hoverboot)
      on_elapsed(4, function()
        if player_at_bridge then
          PlayPhoZurgo()
        else
          doTrigger_phoZurgo = true
        end
      end)
      unset_event()
    end)
  end)
end
function ActivatePostPhoZurgoCams()
  local heroes = {
    get_ratchet(),
    get_clank(),
    get_qwark()
  }
  local cams = {
    camFixed_postPhoZurgo_ratchet,
    camFixed_postPhoZurgo_clank,
    camFixed_postPhoZurgo_qwark
  }
  for i = 1, 3 do
    if is_hero_active(heroes[i]) then
      activate_cam(heroes[i], cams[i])
    end
  end
end
function PlayPhoZurgo()
  doTrigger_phoZurgo = false
  on_next_cine_end(function()
    ActivatePostPhoZurgoCams()
    HideAmbientQwark_CleanerBot()
    warp_heroes(volWarp_byMap_3, volWarp_byMap_2, volWarp_byMap_1, volWarp_byMap_4, true, false)
    protagonist_force_stand_all(false)
    activate(galacticMapActivator)
    on_elapsed(1, CompleteMissionGoToBridge_PHO_1)
    on_elapsed(3.25, function()
      global_phoenixCurHelpMsg = "map"
      if global_phoenixNumDisplayUp == 0 and is_host() then
        show_training_message("GEN_HELP_GALACTICMAP", 8000, 0)
      end
    end)
    on_elapsed(2, function()
      unlock_skillpoint(SKILLPOINT_Q_FORCE)
    end)
    RestoreAmbRatchetNClank()
    RevealAmbientHeroes()
    SetupPlumber_After2ndCine()
    if eventHandle_detectHeroesAtBridge ~= nil then
      unset_event(eventHandle_detectHeroesAtBridge)
    end
    unset_event()
  end)
  UnsetPlumber_TeleOut()
  UnsetPlayVO_ReturnToBridgeReminders()
  UnsetTriggerAmbBridgeHeroMove()
  add_to_pod(Pho_Zurgo_RT_cinematic_HIDE_, clank_phoenix)
  add_to_pod(Pho_Zurgo_RT_cinematic_HIDE_, ratchet_phoenix)
  add_to_pod(Pho_Zurgo_RT_cinematic_HIDE_, qwark_phoenix)
  add_to_pod(Pho_Zurgo_RT_cinematic_HIDE_, qwark_amb_bathrobe_path)
  global_phoenixCurHelpMsg = "none"
  kill_training_message()
  KillScreens()
  postPhoIntroState = false
  protagonist_force_stand_all(true)
  queue_cinematic("pho_zurgo_rt", {
    abort = true,
    hide_pod = Pho_Zurgo_RT_cinematic_HIDE_,
    reveal_pod = Pho_Zurgo_RT_cinematic_REVEAL_,
    post_fade_in = CINE_FADE_BLACK,
    pre_fade_in = CINE_FADE_BLACK
  })
end
local gaveHoverHelp = false
function RestoreHelpMsg()
  if global_phoenixNumDisplayUp == 0 then
    if global_phoenixCurHelpMsg == "hoverboots" then
      show_training_message("TEST_HELP_HOVERBOOTS", 8000, 0)
    elseif global_phoenixCurHelpMsg == "map" then
      if is_host() then
        show_training_message("GEN_HELP_GALACTICMAP", 8000, 0)
      end
    elseif global_phoenixCurHelpMsg == "melee" then
      if 0 < get_num_alive(cleaner_bots) then
        show_training_message("HELP_GEN_CONTROLS_MELEE", 8000, 0)
      else
        global_phoenixCurHelpMsg = "none"
      end
    end
  end
end
function ShowHelp_Hoverboot()
  if not gaveHoverHelp then
    gaveHoverHelp = true
    kill_training_message()
    on_elapsed(1, function()
      global_phoenixCurHelpMsg = "hoverboots"
      if global_phoenixNumDisplayUp == 0 then
        show_training_message("TEST_HELP_HOVERBOOTS", 8000, 0)
      end
    end)
  end
end
function GiveHelp_BasicControls()
  show_training_message("HELP_GEN_BASIC_CONTROLS", 8000, 0)
end
function StartLevel_Phoenix(camToUse)
  if camToUse == nil then
    camToUse = camFixed_startingView
    ActivateCamera(camToUse)
    on_elapsed(0.5, function()
      DeactivateCamera(camToUse)
      on_elapsed(1, PlayVO_PH1_MissionSuccess)
    end)
  else
    fade_to_black(0.5)
    on_elapsed(0.5, function()
      end_cine()
      ActivateCamera(camToUse)
      fade_from_black(1)
      on_elapsed(0.5, function()
        EnableHeroes(false)
        on_elapsed(1, PlayVO_PH1_MissionSuccess)
      end)
    end)
  end
end
local function cp_fixup_default()
  if get_qf_levels_completed() == 0 and not has_cinematic_played("pho_intro_rt") then
    setSaveData_NumTimesVisitedPhoenix(0)
    Phoenix_FirstLoad()
    SetupPostPhoIntro_AmbRatchetNClank()
  elseif get_qf_levels_completed() == 0 and has_cinematic_played("pho_intro_rt") and not has_cinematic_played("pho_zurgo_rt") then
    setSaveData_NumTimesVisitedPhoenix(0)
    SetupPostPhoIntro_AmbRatchetNClank()
    PutPCQwarkInRobe()
    SetupVO_PH1_Plumber_BugProblem()
    warp_heroes(volWarp_bridge_1, volWarp_bridge_3, volWarp_bridge_2, volWarp_bridge_4)
    ShowAmbientHeroes(true)
    on_elapsed(0.25, function()
      ActivateCamera(camFixed_orientCamTowardsEngineRoom)
    end)
    on_elapsed(0.75, DeactivateCamera)
    hide(plumber)
    deactivate(galacticMapActivator)
    on_elapsed(0.5, Phoenix_SwarmerMission_Start)
  else
    SaveData_Increment_NumTimesVisitedPhoenix()
    SetRobots_Walking()
    ActivateCamera(camFixed_startingView)
    on_next_cine_end(function()
      CheckIfPromotionAvailable(StartLevel_Phoenix)
      unset_event()
    end)
    queue_cinematic("pho_arriv_rt", global_cineTable_skippable)
    if not is_jungle_ruins_post_completed() then
      SetupPlumberScene(2)
    end
    ShowAmbientHeroes()
  end
end
register_checkpoint_fixup("cp_default", cp_fixup_default)
local function cp_fixup_cleanerMission()
  warp_heroes(volWarp_bridge_1, volWarp_bridge_3, volWarp_bridge_2, volWarp_bridge_4)
  hide(plumber)
  SetupVO_PH1_Plumber_BugProblem()
  deactivate(galacticMapActivator)
  ShowAmbientHeroes(true)
  on_elapsed(0.5, Phoenix_SwarmerMission_Start)
end
register_checkpoint_fixup("cp_test_cleanerMission", cp_fixup_cleanerMission)
local cp_fixup_phoZurgo = function()
  deactivate(galacticMapActivator)
  Phoenix_SwarmerMission_Complete()
end
register_checkpoint_fixup("cp_test_PhoZurgo", cp_fixup_phoZurgo)
local cp_fixup_after2ndCine = function()
  SetupPlumberScene(1)
end
register_checkpoint_fixup("cp_test_after2ndCine", cp_fixup_after2ndCine)
