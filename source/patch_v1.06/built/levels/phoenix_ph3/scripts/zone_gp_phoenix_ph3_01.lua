prt("----> LOADED gp_phoenix_ph3_01 SCRIPT")
function test()
  warp(qwark_phoenix, volAmbActPos_bridge_galMapConsole)
end
set_phoenix_flag(true)
global_curLevelPhoenix = true
radar_disable()
ResetWeapons(false)
disable_weapon_select()
ResetHeroBolts()
hide(pod_actor_UnusedHeroes)
play_anim_query(aphelion, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
hide(phoLeavePlanet)
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
local function SetupAmbientQwark(setupVO)
  local ambQwark = qwark_phoenix
  warp(ambQwark, qwarkAmbPos[ambPosIndex])
  reveal(ambQwark)
  SetupAmbQwark_IdleLoop(ambQwark)
  if setupVO then
    SetupVO_PH_AmbHero(3, qwarkNearAmbPos[ambPosIndex])
  end
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
local function SetupAmbientClank(setupVO)
  local ambClank = clank_phoenix
  warp(ambClank, clankAmbPos[ambPosIndex])
  reveal(ambClank)
  SetupAmbClank_IdleLoop(ambClank)
  if setupVO then
    SetupVO_PH_AmbHero(2, clankNearAmbPos[ambPosIndex])
  end
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
function SetupAmbientRatchet(setupVO)
  local ambRatchet = ratchet_phoenix
  warp(ambRatchet, ratchetAmbPos[ambPosIndex])
  reveal(ambRatchet)
  SetupAmbRatchet_IdleLoop(ambRatchet)
  if setupVO then
    SetupVO_PH_AmbHero(1, ratchetNearAmbPos[ambPosIndex])
  end
end
local function SetupAmbientHero(hero, setupVO)
  if setupVO == nil then
    setupVO = true
  end
  if hero == "qwark" then
    SetupAmbientQwark(setupVO)
  elseif hero == "clank" then
    SetupAmbientClank(setupVO)
  elseif hero == "ratchet" then
    SetupAmbientRatchet(setupVO)
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
    end
  end
end
function SetAmbientHeroesForPhoNoob()
  qwarkAmbPos = {
    volAmbActPos_bridge_galMapConsole,
    volAmbActPos_bridge_galMapConsole,
    volAmbActPos_bridge_galMapConsole
  }
  clankAmbPos = {
    volAmbActPos_bridge_atMap_1,
    volAmbActPos_bridge_atMap_1,
    volAmbActPos_bridge_atMap_1
  }
  ratchetAmbPos = {
    volAmbActPos_bridge_atMap_3,
    volAmbActPos_bridge_atMap_3,
    volAmbActPos_bridge_atMap_3
  }
  qwarkNearAmbPos = {
    volNear_AmbActPos_nearBridge_console_1,
    volNear_AmbActPos_nearBridge_console_1,
    volNear_AmbActPos_nearBridge_console_1
  }
  clankNearAmbPos = {
    volNear_AmbActPos_bridge_atMap_2,
    volNear_AmbActPos_bridge_atMap_2,
    volNear_AmbActPos_bridge_atMap_2
  }
  ratchetNearAmbPos = {
    volNear_AmbActPos_bridge_atMap_1,
    volNear_AmbActPos_bridge_atMap_1,
    volNear_AmbActPos_bridge_atMap_1
  }
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
  for i = 1, 3 do
    if not is_hero_active(heroes[i]) then
      SetupAmbientHero(hero_names[i], false)
    end
  end
end
function SetAmbientHeroesForPostPhoNoob()
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
  local postPos = {
    volAmbActPos_bridge_atMap_1,
    volAmbActPos_bridge_atMap_2,
    volAmbActPos_nearBridge_console_1
  }
  local postNearPos = {
    volNear_AmbActPos_bridge_atMap_1,
    volNear_AmbActPos_bridge_atMap_2,
    volNear_AmbActPos_nearBridge_console_1
  }
  local i
  for i = 1, 3 do
    if not is_hero_active(heroes[i]) then
      warp(actors[i], postPos[i])
      SetupVO_PH_AmbHero(i, postNearPos[i])
    end
  end
  RevealAmbientHeroes()
end
function PutUsedAmbHeroesInHidePod(hidePod)
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
      add_to_pod(hidePod, actors[i])
    end
  end
end
hide(blop_path)
hide(bleep_path)
function PlayAnim_Blop_WalkTwitch()
  play_anim_query(blop_path, AnimQuery.MOVE_CAT, AnimQuery.MOVEHOVER_TAKEOFF)
  on_anim_percentage(blop_path, AnimQuery.MOVE_CAT, AnimQuery.MOVEHOVER_TAKEOFF, 1, function()
    play_anim_query(blop_path, AnimQuery.MOVE_CAT, AnimQuery.MOVEFORWARD)
    on_elapsed(math.random(5, 20), PlayAnim_Blop_WalkTwitch)
    unset_event()
  end)
end
function PlayAnim_Bleep_WalkTwitch()
  play_anim_query(bleep_path, AnimQuery.MOVE_CAT, AnimQuery.MOVEHOVER_TAKEOFF)
  on_anim_percentage(bleep_path, AnimQuery.MOVE_CAT, AnimQuery.MOVEHOVER_TAKEOFF, 1, function()
    play_anim_query(bleep_path, AnimQuery.MOVE_CAT, AnimQuery.MOVEFORWARD)
    on_elapsed(math.random(7, 22), PlayAnim_Bleep_WalkTwitch)
    unset_event()
  end)
end
function SetupBleepNBlop_TwitchWalk()
  hide(actor_bleep)
  hide(actor_blop)
  reveal(blop_path)
  reveal(bleep_path)
  play_anim_query(bleep_path, AnimQuery.MOVE_CAT, AnimQuery.MOVEFORWARD)
  play_anim_query(blop_path, AnimQuery.MOVE_CAT, AnimQuery.MOVEFORWARD)
  on_elapsed(math.random(7, 14), PlayAnim_Bleep_WalkTwitch)
  on_elapsed(math.random(5, 12), PlayAnim_Blop_WalkTwitch)
end
local playingSpecialAnim_bNb = false
local eventHandle_bloopTwitchRestore
function PlayAnim_Blop_Twitch()
  if not playingSpecialAnim_bNb then
    play_anim_query(actor_blop, AnimQuery.REACT_CAT, AnimQuery.REACT_TWITCH, 1, 0.5)
    if eventHandle_bloopTwitchRestore ~= nil then
      unset_event(eventHandle_bloopTwitchRestore)
      eventHandle_bloopTwitchRestore = nil
    end
    eventHandle_bloopTwitchRestore = on_anim_percentage(actor_blop, AnimQuery.REACT_CAT, AnimQuery.REACT_TWITCH, 1, function()
      play_anim_query(actor_blop, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND, 1, 0.5)
      eventHandle_bloopTwitchRestore = nil
      unset_event()
    end)
  end
  on_elapsed(math.random(1, 12), PlayAnim_Blop_Twitch)
end
function PlayAnim_Bleep_Twitch()
  if not playingSpecialAnim_bNb then
    play_anim_query(actor_bleep, AnimQuery.REACT_CAT, AnimQuery.REACT_TWITCH, 1, 0.5)
    on_anim_percentage(actor_bleep, AnimQuery.REACT_CAT, AnimQuery.REACT_TWITCH, 1, function()
      play_anim_query(actor_bleep, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND, 1, 0.5)
      unset_event()
    end)
  end
  on_elapsed(math.random(7, 14), PlayAnim_Bleep_Twitch)
end
local numBlopHits = 0
function PlayAnim_BleepNBlop_Hit(animSubCat)
  playingSpecialAnim_bNb = true
  play_anim_query(actor_bleep, AnimQuery.REACT_CAT, animSubCat)
  play_anim_query(actor_blop, AnimQuery.REACT_CAT, animSubCat)
  on_anim_percentage(actor_bleep, AnimQuery.REACT_CAT, animSubCat, 1, function()
    play_anim_query(actor_bleep, AnimQuery.IDLE_STAND, AnimQuery.IDLE_STAND)
    on_elapsed(math.random(5, 30), BleepNBlop_HardKnocks_Hit)
    unset_event()
  end)
  on_anim_percentage(actor_blop, AnimQuery.REACT_CAT, animSubCat, 1, function()
    play_anim_query(actor_blop, AnimQuery.IDLE_STAND, AnimQuery.IDLE_STAND)
    playingSpecialAnim_bNb = false
    unset_event()
  end)
end
function BleepNBlop_HardKnocks_Hit()
  numBlopHits = numBlopHits + 1
  if numBlopHits % 3 == 0 then
    PlayAnim_BleepNBlop_Hit(AnimQuery.REACT_FLATTENED)
  else
    PlayAnim_BleepNBlop_Hit(AnimQuery.REACT_HIT_BY_WAVE)
  end
end
function BleepNBlop_HardKnocks_Idle()
  play_anim_query(actor_bleep, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
  play_anim_query(actor_blop, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STAND)
  on_elapsed(math.random(5, 30), BleepNBlop_HardKnocks_Hit)
  on_elapsed(math.random(5, 12), PlayAnim_Blop_Twitch)
end
function SetupBleepNBlop_HardKnocks()
  warp(actor_bleep, volPos_bleep_hit)
  warp(actor_blop, volPos_blop_hit)
  BleepNBlop_HardKnocks_Idle()
end
function SetupBlop_HangsFromBanner()
  warp(actor_blop, volPos_blop_hang)
  play_anim_query(actor_blop, AnimQuery.IDLE_CAT, AnimQuery.IDLE_SLEEP)
end
function SetupBleepNBlop_BashHead(doAlt)
  doAlt = doAlt or false
  warp(actor_bleep, volPos_bleep_bashHead)
  play_anim_query(actor_bleep, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STUNNED)
  if not doAlt then
    warp(actor_blop, volPos_blop_bashHead)
    play_anim_query(actor_blop, AnimQuery.IDLE_CAT, AnimQuery.IDLE_STUNNED)
  else
    SetupBlop_HangsFromBanner()
  end
end
function SetupBleepNBlop()
  local sceneToUse = getSaveData_NumTimesVisitedPhoenix() % 4
  if sceneToUse == 0 then
    SetupBleepNBlop_BashHead()
  elseif sceneToUse == 1 then
    SetupBleepNBlop_HardKnocks()
  elseif sceneToUse == 2 then
    SetupBleepNBlop_BashHead(true)
  else
    SetupBleepNBlop_TwitchWalk()
  end
end
function SetPhoenix3State(waitForBridgeAlert)
  waitForBridgeAlert = waitForBridgeAlert or false
  if has_cinematic_played("pho_noob_rt") then
    StartMusic_BGTrololoSong()
    PlayVO_PH3_RepeatSong()
    if is_jungle_ruins_post_completed() then
      on_elapsed(2, function()
        PlayVO_PH3_UnlockJRBoss(AllowVO_PH3_Zurgo)
      end)
    else
      AllowVO_PH3_Zurgo()
    end
  elseif not waitForBridgeAlert then
    on_elapsed(5, PlayVO_PH3_ReportToBridge)
  else
    on_hero_enter(volDetect_leftEngineRoom, function()
      if not global_repeatingReportToBridge then
        PlayVO_PH3_ReportToBridge()
      end
      unset_event()
    end)
  end
end
function StartLevel_Phoenix(camToUse)
  if camToUse == nil then
    camToUse = camFixed_startingView
    ActivateCamera(camToUse)
    on_elapsed(0.5, function()
      DeactivateCamera(camToUse)
      on_elapsed(1, PlayVO_PH3_SuccessfulMission)
      on_elapsed(2, SetPhoenix3State)
    end)
  else
    fade_to_black(0.5)
    on_elapsed(0.5, function()
      end_cine()
      ActivateCamera(camToUse)
      fade_from_black(1)
      on_elapsed(0.5, function()
        EnableHeroes(false)
        on_elapsed(1, PlayVO_PH3_SuccessfulMission)
        on_elapsed(2, function()
          SetPhoenix3State(true)
        end)
      end)
    end)
  end
end
local function cp_fixup_default()
  SaveData_Increment_NumTimesVisitedPhoenix()
  SetupBleepNBlop()
  if not has_cinematic_played("pho_noob_rt") then
    SetAmbientHeroesForPhoNoob()
    deactivate(galacticMapActivator)
    on_hero_enter(volDetect_heroesAtBridge, function()
      UnsetPlayVO_PH3_ReportToBridgeRepeat()
      on_next_cine_end(function()
        protagonist_force_stand_all(false)
        warp_heroes(volWarp_byMap_3, volWarp_byMap_2, volWarp_byMap_1, volAmbActPos_nearBridge_console_2)
        SetAmbientHeroesForPostPhoNoob()
        on_elapsed(2, PlayVO_PH3_AfterNoobCine)
        on_elapsed(math.random(120, 300), PlayVO_PH3_BarryAmbient)
        SetupVO_PH3_BarrySneeze()
        unlock_skillpoint(SKILLPOINT_REVENGE_OF_THE_NERD)
        activate(galacticMapActivator)
        unset_event()
      end)
      PutUsedAmbHeroesInHidePod(Pho_Noob_RT_cinematic_HIDE_)
      KillScreens()
      protagonist_force_stand_all(true)
      queue_cinematic("pho_noob_rt", {
        abort = true,
        hide_pod = Pho_Noob_RT_cinematic_HIDE_,
        reveal_pod = Pho_Noob_RT_cinematic_HIDE_
      })
      unset_event()
    end)
  else
    ShowAmbientHeroes()
    SetupVO_PH3_BarrySneeze()
    on_elapsed(math.random(120, 300), PlayVO_PH3_BarryAmbient)
  end
  ActivateCamera(camFixed_startingView)
  on_next_cine_end(function()
    CheckIfPromotionAvailable(StartLevel_Phoenix)
    unset_event()
  end)
  queue_cinematic("pho_arriv_rt", {abort = true})
end
register_checkpoint_fixup("cp_default", cp_fixup_default)
local cp_fixup_skipCine = function()
  queue_cinematic("pho_arriv_rt", {abort = true})
end
register_checkpoint_fixup("cp_test_skipCine", cp_fixup_skipCine)
