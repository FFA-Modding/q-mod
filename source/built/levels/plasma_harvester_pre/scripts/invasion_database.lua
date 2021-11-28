prt("----> LOADED invasion database SCRIPT")
global_earlySpawnPercent = 0.3
allowAmbDrones = true
triggerAmbDrones = true
eventhandle_TriggerAmbDrones = nil
ambDronesActive = false
local getRandomWaveTime = function()
  local minWaveTime = 420
  local maxWaveTime = 600
  if get_num_active_players() > 1 then
    minWaveTime = 360
    maxWaveTime = 480
  end
  return (math.random(minWaveTime, maxWaveTime))
end
global_newDone = {false, false}
global_newFlag = {
  "newEnemyDone_tank",
  "newEnemyDone_sapper"
}
local SetNewIconStatus = function()
  if get_qf_levels_completed() >= 3 then
    global_newDone = {true, true}
  else
    local i
    for i = 1, #global_newFlag do
      if global_newFlag[i] ~= nil and checkSaveStateFlag(global_newFlag[i]) then
        global_newDone[i] = true
      end
    end
  end
end
on_elapsed(2, SetNewIconStatus)
global_invDropshipInfo = {
  ship_spawners = {CarSpawner_InvasionShip_LEFT, CarSpawner_InvasionShip_RIGHT},
  shipDetect_vols = {volDetect_dropshipSpawn_left, volDetect_dropshipSpawn_right}
}
local ambInvasion_1 = {}
ambInvasion_1[1] = {
  squadClues = {
    clueDir_L1_brawler,
    clueDir_L1_brawler,
    clueDir_L2_brawler
  },
  squadWave = {
    1,
    2,
    2
  },
  lane = {
    1,
    1,
    2
  },
  count = {
    2,
    1,
    2
  },
  spawn_delay = {
    0,
    5,
    25
  },
  min_time = 10,
  next_phase_delay = getRandomWaveTime,
  allow_timer = true
}
ambInvasion_1[2] = {
  squadClues = {
    clueDir_L1_brawler,
    clueDir_L2_shooter,
    clueDir_L1_mortar
  },
  squadWave = {
    3,
    2,
    2
  },
  lane = {
    1,
    2,
    1
  },
  count = {
    2,
    1,
    1
  },
  spawn_delay = {
    0,
    10,
    30
  },
  min_time = 5,
  next_phase_delay = getRandomWaveTime,
  allow_timer = true
}
ambInvasion_1[3] = {
  squadClues = {
    clueDir_L2_mortar,
    clueDir_L2_shooter,
    clueDir_L1_mortar,
    clueDir_L1_mortar
  },
  squadWave = {
    6,
    2,
    3,
    2
  },
  lane = {
    2,
    2,
    1,
    1
  },
  count = {
    1,
    2,
    1,
    2
  },
  spawn_delay = {
    0,
    15,
    36,
    50
  },
  min_time = 8,
  next_phase_delay = getRandomWaveTime,
  allow_timer = true
}
ambInvasion_1[4] = {
  squadClues = {
    clueDir_L1_mortar,
    clueDir_L1_brawler,
    clueDir_L2_mortar,
    clueDir_L2_boss_mm
  },
  squadWave = {
    5,
    3,
    4,
    1
  },
  lane = {
    1,
    1,
    2,
    2
  },
  count = {
    2,
    2,
    2,
    1
  },
  spawn_delay = {
    0,
    10,
    24,
    35
  },
  min_time = 20,
  next_phase_delay = getRandomWaveTime,
  allow_timer = true
}
ambInvasion_1[5] = {
  squadClues = {
    clueDir_L2_boss_mm,
    clueDir_L1_shooter,
    clueDir_L2_mortar,
    clueDir_L1_mortar,
    clueDir_L2_shooter,
    clueDir_L1_boss_mm
  },
  squadWave = {
    1,
    2,
    2,
    2,
    2,
    1
  },
  lane = {
    2,
    1,
    2,
    1,
    2,
    1
  },
  count = {
    1,
    1,
    1,
    1,
    1,
    1
  },
  spawn_delay = {
    0,
    20,
    25,
    30,
    45,
    53
  },
  min_time = 10,
  next_phase_delay = getRandomWaveTime,
  allow_timer = true
}
ambInvasion_1[6] = {
  squadClues = {
    clueDir_L2_shooter,
    clueDir_L2_mortar,
    clueDir_L1_shooter,
    clueDir_L1_boss_mm,
    clueDir_L2_brawler,
    clueDir_L1_brawler
  },
  squadWave = {
    2,
    2,
    2,
    1,
    3,
    3
  },
  lane = {
    2,
    2,
    1,
    1,
    2,
    1
  },
  count = {
    1,
    2,
    1,
    1,
    2,
    2
  },
  spawn_delay = {
    0,
    12,
    20,
    35,
    45,
    51
  },
  min_time = 6,
  next_phase_delay = getRandomWaveTime,
  allow_timer = true,
  infinite = true
}
function getAmbInvasionArray()
  return ambInvasion_1
end
local baseInvasion_1 = {}
baseInvasion_1[1] = {
  squadClues = {clueDir_L2_mortar, clueDir_L1_shooter},
  squadWave = {4, 3},
  lane = {2, 1},
  count = {2, 2},
  spawn_delay = {0, 12},
  min_time = 8,
  next_phase_delay = 9
}
baseInvasion_1[2] = {
  squadClues = {
    clueDir_L1_mortar,
    clueDir_L2_shooter,
    clueDir_L2_brawler
  },
  squadWave = {
    2,
    2,
    3
  },
  lane = {
    1,
    2,
    2
  },
  count = {
    2,
    2,
    3
  },
  spawn_delay = {
    0,
    16,
    34
  },
  min_time = 8,
  next_phase_delay = 8
}
baseInvasion_1[3] = {
  squadClues = {
    clueDir_L1_sapper,
    clueDir_L1_brawler,
    clueDir_L2_mortar,
    clueDir_L1_swarmerFootball,
    clueDir_L2_sapper,
    clueDir_L2_brawler
  },
  squadWave = {
    1,
    3,
    5,
    2,
    2,
    3
  },
  lane = {
    1,
    1,
    2,
    1,
    2,
    2
  },
  count = {
    1,
    3,
    2,
    2,
    1,
    3
  },
  is_new = {
    2,
    -1,
    -1,
    -1,
    -1,
    -1
  },
  spawn_delay = {
    0,
    8,
    21,
    29,
    37,
    42
  },
  min_time = 8,
  is_drone = {
    true,
    false,
    false,
    false,
    true,
    false
  },
  next_phase_delay = 8
}
baseInvasion_1[4] = {
  squadClues = {
    clueDir_L1_boss_mm,
    clueDir_L2_shooter,
    clueDir_L2_mortar
  },
  squadWave = {
    1,
    3,
    5
  },
  lane = {
    1,
    2,
    2
  },
  count = {
    1,
    2,
    2
  },
  spawn_delay = {
    0,
    5,
    20
  },
  min_time = 8,
  next_phase_delay = 5
}
baseInvasion_1[5] = {
  squadClues = {
    clueDir_L2_mortar,
    clueDir_L1_sapper,
    clueDir_L1_shooter,
    clueDir_L2_brawler,
    clueDir_L1_brawler
  },
  squadWave = {
    2,
    2,
    2,
    3,
    3
  },
  lane = {
    2,
    1,
    1,
    2,
    1
  },
  count = {
    2,
    1,
    2,
    3,
    3
  },
  spawn_delay = {
    0,
    8,
    14,
    22,
    30
  },
  min_time = 8,
  is_drone = {
    false,
    true,
    false,
    false,
    false
  },
  next_phase_delay = 15
}
local tankWave = 6
local tank1Index = 2
baseInvasion_1[6] = {
  squadClues = {
    clueDir_L1_mortar,
    clueDir_L1_boss_tank,
    clueDir_L2_mortar,
    clueDir_L2_sapper,
    clueDir_L2_mortar,
    clueDir_L1_sapper,
    clueDir_L1_brawler,
    clueDir_L2_shooter
  },
  squadWave = {
    5,
    1,
    5,
    2,
    2,
    2,
    2,
    3
  },
  lane = {
    1,
    1,
    2,
    2,
    2,
    1,
    1,
    2
  },
  count = {
    2,
    1,
    2,
    1,
    2,
    1,
    3,
    2
  },
  spawn_delay = {
    0,
    18,
    14,
    32,
    40,
    58,
    68,
    68
  },
  min_time = 8,
  is_drone = {
    false,
    false,
    false,
    true,
    false,
    true,
    false,
    false
  },
  is_tank = {
    false,
    true,
    false,
    false,
    false,
    false,
    false,
    false
  }
}
local baseInvasion_2 = {}
baseInvasion_2[1] = {
  squadClues = {
    clueDir_L2_mortar,
    clueDir_L2_mortar,
    clueDir_L2_boss_mm,
    clueDir_L1_shooter,
    clueDir_L1_mortar
  },
  lane = {
    2,
    2,
    2,
    1,
    1
  },
  squadWave = {
    5,
    4,
    1,
    2,
    2
  },
  count = {
    1,
    1,
    1,
    2,
    2
  },
  spawn_delay = {
    0,
    5,
    10,
    0,
    5
  },
  min_time = 10,
  next_phase_delay = 9
}
baseInvasion_2[2] = {
  squadClues = {
    clueDir_L1_brawler,
    clueDir_L1_boss_mm,
    clueDir_L2_shooter,
    clueDir_L2_brawler
  },
  lane = {
    1,
    1,
    2,
    2
  },
  squadWave = {
    2,
    1,
    3,
    3
  },
  count = {
    2,
    1,
    2,
    2
  },
  spawn_delay = {
    0,
    10,
    2,
    12
  },
  min_time = 5,
  next_phase_delay = 8
}
baseInvasion_2[3] = {
  squadClues = {
    clueDir_L1_sapper,
    clueDir_L1_brawler,
    clueDir_L1_mortar,
    clueDir_L2_mortar,
    clueDir_L2_sapper,
    clueDir_L2_brawler
  },
  lane = {
    1,
    1,
    1,
    2,
    2,
    2
  },
  squadWave = {
    2,
    3,
    5,
    5,
    2,
    3
  },
  count = {
    1,
    2,
    2,
    2,
    1,
    2
  },
  is_new = {
    2,
    -1,
    -1,
    -1,
    -1,
    -1
  },
  spawn_delay = {
    0,
    8,
    19,
    3,
    17,
    22
  },
  min_time = 6,
  is_drone = {
    true,
    false,
    false,
    false,
    true,
    false
  },
  next_phase_delay = 8
}
baseInvasion_2[4] = {
  squadClues = {
    clueDir_L1_boss_mm,
    clueDir_L1_mortar,
    clueDir_L2_boss_mm,
    clueDir_L2_shooter
  },
  lane = {
    1,
    1,
    2,
    2
  },
  squadWave = {
    1,
    5,
    1,
    3
  },
  count = {
    1,
    2,
    1,
    2
  },
  spawn_delay = {
    0,
    10,
    0,
    10
  },
  min_time = 5,
  next_phase_delay = 5
}
baseInvasion_2[5] = {
  squadClues = {
    clueDir_L1_sapper,
    clueDir_L1_shooter,
    clueDir_L1_brawler,
    clueDir_L2_mortar,
    clueDir_L2_brawler
  },
  lane = {
    1,
    1,
    1,
    2,
    2
  },
  squadWave = {
    3,
    2,
    3,
    2,
    3
  },
  count = {
    1,
    2,
    2,
    3,
    2
  },
  spawn_delay = {
    0,
    6,
    12,
    6,
    12
  },
  min_time = 12,
  is_drone = {
    true,
    false,
    false,
    false,
    false
  },
  next_phase_delay = 10
}
baseInvasion_2[6] = {
  squadClues = {
    clueDir_L1_mortar,
    clueDir_L1_boss_tank2,
    clueDir_L1_sapper,
    clueDir_L1_brawler,
    clueDir_L2_shooter,
    clueDir_L2_boss_tank,
    clueDir_L2_sapper,
    clueDir_L2_mortar
  },
  lane = {
    1,
    1,
    1,
    1,
    2,
    2,
    2,
    2
  },
  squadWave = {
    5,
    1,
    3,
    3,
    2,
    1,
    3,
    5
  },
  count = {
    2,
    1,
    1,
    3,
    2,
    1,
    1,
    2
  },
  spawn_delay = {
    0,
    15,
    25,
    35,
    5,
    20,
    30,
    35
  },
  min_time = 5,
  is_drone = {
    false,
    false,
    true,
    false,
    false,
    false,
    true,
    false
  },
  is_tank = {
    false,
    true,
    false,
    false,
    false,
    true,
    false,
    false
  }
}
local baseInvasion = {baseInvasion_1}
function getBaseInvasionArray(level)
  if level > #baseInvasion then
    level = #baseInvasion
  end
  if level < 1 then
    level = 1
  end
  local invArray = baseInvasion[level]
  if 1 < get_num_active_players() then
    invArray = baseInvasion_2
  end
  return invArray
end
local droneClues = {
  ClueEnemy_Sapper_1,
  ClueEnemy_Sapper_2,
  ClueEnemy_Sapper_3,
  ClueEnemy_Sapper_4,
  ClueEnemy_Sapper_5,
  ClueEnemy_Sapper_6,
  ClueEnemy_Sapper_7,
  ClueEnemy_Sapper_8,
  ClueEnemy_Sapper_9
}
function droneSpeedTest()
  local i
  for i = 1, #droneClues do
    on_ai_spawned(droneClues[i], function()
      local droneFred = get_moby_handle_from_setup(droneClues[i])
      SetupWreckingDrone(droneFred, nil, 2)
      unset_event()
    end)
  end
end
currentDroneSet = -1
needToTriggerDrones = false
TimeToSpawnDrones = 80
PlayersAtKeyAndPDC = false
on_all_hero_enter(area_KeynodeAndPDC, function()
  prt("Safe Area: Keynode and PDC active. Stop Drones.")
  PlayersAtKeyAndPDC = true
  on_hero_exit(area_KeynodeAndPDC, function()
    PlayersAtKeyAndPDC = false
    prt("Safe Area: Exited KeynodeAndPDC.")
    if needToTriggerDrones then
      prt("Restart Drones.")
      TriggerCurrentDrones()
    end
    unset_event()
  end)
end)
disallowTrigAmbDrones = false
function TriggerCurrentDrones()
  if not needToTriggerDrones or disallowTrigAmbDrones then
    return
  end
  needToTriggerDrones = false
  if event_handleTimeToSpawnDrones ~= nil then
    unset_event(event_handleTimeToSpawnDrones)
    event_handleTimeToSpawnDrones = nil
  end
  event_handleTimeToSpawnDrones = on_elapsed(TimeToSpawnDrones, function()
    event_handleTimeToSpawnDrones = nil
    prt("Trigger Current Drones")
    TriggerRandomDrones()
  end)
end
local DroneBufferMet = true
local DroneBufferTime = 35
local NeedToQueueAmbDrone = false
event_handle_waitForDroneBuffer = nil
function TriggerRandomDrones()
  ambDronesActive = true
  eventhandle_TriggerAmbDrones = nil
  if not (allowAmbDrones and DroneBufferMet) or disallowTrigAmbDrones then
    if not droneBufferMet then
      prt("Not enough time passed since last Ambient Drones. Please wait.")
      NeedToQueueAmbDrone = true
    end
    return
  end
  DroneBufferMet = false
  if event_handle_waitForDroneBuffer ~= nil then
    unset_event(event_handle_waitForDroneBuffer)
    event_handle_waitForDroneBuffer = nil
  end
  event_handle_waitForDroneBuffer = on_elapsed(DroneBufferTime, function()
    DroneBufferMet = true
    if NeedToQueueAmbDrone then
      prt("Drone Buffer Expired. Setup Next Amb Drone.")
      SetupNextAmbDroneWave()
    end
  end)
  if not PlayersOnGrindRailCheck and not PlayersAtKeyAndPDC then
    do
      local waveNums = {
        1,
        2,
        3,
        4,
        5,
        6
      }
      local randomWave = {}
      local i
      for i = 1, 2 do
        randomWave[i] = table.remove(waveNums, math.random(1, #waveNums))
      end
      PlayVO_WreckingDrones()
      trigger_squad(ClueEnemySetup_Drones_1, randomWave[1], true, true)
      on_elapsed(2, function()
        trigger_squad(ClueEnemySetup_Drones_1, randomWave[2], true, true)
        triggerAmbDrones = true
        if not global_any_invasion_active then
          set_track_invasion(true)
        end
        global_any_invasion_active = true
      end)
    end
  else
    currentDroneSet = 4
    needToTriggerDrones = true
  end
end
function SetupNextAmbDroneWave()
  ambDronesActive = true
  if disallowTrigAmbDrones then
    return
  end
  if eventhandle_TriggerAmbDrones == nil then
    prt("Queing next AMBIENT drone wave.")
    local droneSpawnTime = math.random(70, 180)
    prt("Drone Spawn Time Is: " .. droneSpawnTime)
    eventhandle_TriggerAmbDrones = on_elapsed(droneSpawnTime, TriggerRandomDrones)
  end
end
function SetupTankDroneWave()
  ambDronesActive = true
  prt("Queing Next TANK drone wave.")
  if eventhandle_TriggerAmbDrones ~= nil then
    unset_event(eventhandle_TriggerAmbDrones)
    eventhandle_TriggerAmbDrones = nil
  end
  if event_handle_waitForDroneBuffer ~= nil then
    unset_event(event_handle_waitForDroneBuffer)
    event_handle_waitForDroneBuffer = nil
  end
  local droneSpawnTime = math.random(30, 60)
  prt("Drone Spawn Time Is: " .. droneSpawnTime)
  eventhandle_TriggerAmbDrones = on_elapsed(droneSpawnTime, TriggerRandomDrones)
end
function StartAmbientDrones()
  if allowAmbDrones and triggerAmbDrones and not ambDronesActive then
    ambDronesActive = true
    SetupNextAmbDroneWave()
  end
end
function InvasionOverCallback()
  if allowAmbDrones and triggerAmbDrones then
    if event_handle_waitForDroneBuffer ~= nil then
      unset_event(event_handle_waitForDroneBuffer)
      event_handle_waitForDroneBuffer = nil
    end
    prt("Invasion Over Callback Triggered.")
    ambDronesActive = true
    NeedToQueueAmbDrone = false
    DroneBufferMet = true
    triggerAmbDrones = false
    SetupNextAmbDroneWave()
  end
end
