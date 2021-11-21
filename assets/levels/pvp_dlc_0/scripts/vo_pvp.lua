-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --
-- //						              DLC #0 - MOLONOTH: VO     	            	\\ --
-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

prt("----> LOADED  molonoth vo pvp SCRIPT")

-- ======================================================================= --
-- ======                          COMPETITIVE                      ====== --
-- ======================================================================= --

local teamGenPod = {}
local allowPVPVO = true 

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ HERO DOWN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

-- blue, red
local heroDownLines = {DialogueSpecs.PVP_COMP_PA_MISC001, DialogueSpecs.PVP_COMP_PA_MISC002}

-- ------------------------- PlayVO_Comp_Gen_HeroDown ------------------------- --
function PlayVO_Comp_Gen_HeroDown(hero)
--/ Play a hero down line (random, no repeat). \--

  if (not allowPVPVO) then 
    return; 
  end 
  
  prt("Yo., playing a hero down line")
  if (not is_conv_active()) then 
    play_line(heroDownLines[get_node_team(hero)])
  end
  -- #MUSIC player is dead
  MusicCheck_playerDead = true
  
end -- end PlayVO_Comp_Gen_HeroDown


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CAPTURED NODE ~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

local redCapturedNodes = {DialogueSpecs.PVP_COMP_PA_MISC004, DialogueSpecs.PVP_COMP_PA_MISC005, 
      DialogueSpecs.PVP_COMP_PA_MISC006, DialogueSpecs.PVP_COMP_PA_MISC007, DialogueSpecs.PVP_COMP_PA_MISC008, 
      DialogueSpecs.PVP_COMP_PA_MISC009, DialogueSpecs.PVP_COMP_PA_MISC010, DialogueSpecs.PVP_COMP_PA_MISC011, 
      DialogueSpecs.PVP_COMP_PA_MISC012, DialogueSpecs.PVP_COMP_PA_MISC013}
local blueCaptureNodes = {DialogueSpecs.PVP_COMP_PA_MISC015, DialogueSpecs.PVP_COMP_PA_MISC016, 
      DialogueSpecs.PVP_COMP_PA_MISC017, DialogueSpecs.PVP_COMP_PA_MISC018, DialogueSpecs.PVP_COMP_PA_MISC019,
      DialogueSpecs.PVP_COMP_PA_MISC020, DialogueSpecs.PVP_COMP_PA_MISC021, DialogueSpecs.PVP_COMP_PA_MISC022, 
      DialogueSpecs.PVP_COMP_PA_MISC023, DialogueSpecs.PVP_COMP_PA_MISC024}

-- ----------------------- PlayVO_Comp_CapturedNode ---------------------- --
function PlayVO_Comp_CapturedNode(teamID, nodeID)

  if (not allowPVPVO) then 
    return; 
  end 
  
  local lineToPlay;
  local playGenLine = false 
  if ((nodeID == nil) or (nodeID < 0) or (nodeID > #redCapturedNodes)) then
    playGenLine = true 
  end 
  
  if (teamID == HERO.HERO_TEAM_1) then -- blue 
    if (playGenLine) then
      -- blue team captured a node (generic version)
      lineToPlay = DialogueSpecs.PVP_COMP_PA_MISC014
    else
      lineToPlay = blueCaptureNodes[nodeID]
    end
  else 
    if (playGenLine) then 
      -- red team captured a node (generic line)
      lineToPlay = DialogueSpecs.PVP_COMP_PA_MISC003
    else
      lineToPlay = redCapturedNodes[nodeID]
    end
  end
  
  on_no_conversation(function()
    play_line(lineToPlay)
    unset_event()
  end)
  
end -- end PlayVO_Comp_CapturedNode

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ENEMIES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

-- ------------------------- PlayVO_PVP_IncomingSpecEnemy ---------------- --
function PlayVO_PVP_IncomingSpecEnemy(boughtByTeam, lineToSay)

  local forTeam = HERO.HERO_TEAM_1
  if (boughtByTeam == HERO.HERO_TEAM_1) then 
    forTeam = HERO.HERO_TEAM_2
  end
  
  -- only play the vo for the team the drone is for (and that they are local)
  local teamHeroes = {}
  local teamNum;
  local i; 
  for i = 0, 3, 1 do 
    teamNum = get_team_at_player_id(i)
    if ((teamNum == forTeam) and (is_player_local(i))) then 
      if (allowPVPVO and not is_conv_active()) then 
        play_line(lineToSay) 
      end
    end
  end
  
end -- end PlayVO_PVP_IncomingSpecEnemy

-- ------------------------- PlayVO_PVP_IncomingTank --------------------- --
function PlayVO_PVP_IncomingTank(boughtByTeam)

  -- "Grungarian tank spotted near the QForce base!"
  PlayVO_PVP_IncomingSpecEnemy(boughtByTeam, DialogueSpecs.QGEN_COMP_PA_MISC013) 
  
end -- end PlayVO_PVP_IncomingTank

-- ------------------------- PlayVO_PVP_IncomingDrone -------------------- -- 
function PlayVO_PVP_IncomingDrone(boughtByTeam)
	
  -- "Grungarian Wrecking Drones detected."
  PlayVO_PVP_IncomingSpecEnemy(boughtByTeam, DialogueSpecs.QGEN_COMP_PA_MISC090)
  
end -- end PlayVO_PVP_IncomingDrone


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BASE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --

-- blue, red 
local line_genDestroyed = {DialogueSpecs.PVP_COMP_PA_MISC026, 
                          DialogueSpecs.PVP_COMP_PA_MISC025}
local line_gen1Remains = {DialogueSpecs.PVP_COMP_PA_MISC028,
                          DialogueSpecs.PVP_COMP_PA_MISC027}
                          
-- ------------------------- PlayVO_Comp_OneGenRemains ------------------- --
function PlayVO_Comp_OneGenRemains(teamID)

  if (not allowPVPVO) then 
    return; 
  end 
  
  on_no_conversation(function()
    play_line(line_gen1Remains[teamID])
    unset_event()
  end)
  
end -- end PlayVO_Comp_OneGenRemains

-- ------------------------- PlayVO_Comp_GenDestroyed -------------------- --
function PlayVO_Comp_GenDestroyed(teamID)
  
  -- do not play the gen destroyed vo if the game is over or the game was forfeited 
  if (not allowPVPVO or (pvp_global_forfeit)) then  
    return; 
  end 
  
  if (get_num_alive(teamGenPod[teamID]) == 1) then 
    PlayVO_Comp_OneGenRemains(teamID)
  else
    on_no_conversation(function()
      play_line(line_genDestroyed[teamID])
      unset_event()
    end)
  end
  
end -- end PlayVO_Comp_GenDestroyed

-- ------------------------- SetupVO_Comp_GenDestroyed ------------------- --
function SetupVO_Comp_GenDestroyed(gen, teamID)

  on_death(gen, function()
    play_explicit_sound_spec(SoundSpecs.trig_QF_generator_explode, gen)
    PlayVO_Comp_GenDestroyed(teamID)
    unset_event() -- unsets automatically, but for clarity do it manually :^)
  end)
  
end -- end SetupVO_Comp_GenDestroyed

-- ---------------------- SetupVO_Comp_GenPod --------------------------- --
function SetupVO_Comp_GenPod(genPod, teamID)

  local gen = genPod:get_first()
  while (is_valid(gen)) do 
    SetupVO_Comp_GenDestroyed(gen, teamID)
    gen = genPod:get_next()
  end
  
end -- end SetupVO_Comp_GenPod

-- ---------------------- SetupVO_Comp_Generators ------------------------ --
function SetupVO_Comp_Generators(genPod, teamID)

  SetupVO_Comp_GenPod(genPod, teamID)
  teamGenPod[teamID] = genPod
  
end -- end SetupVO_Comp_Generators

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GAME STATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PlayVO_Comp_Winner ~~~~~~~~~~~~~~~~~~~~~~~ --
function PlayVO_Comp_Winner(teamID, callback) 

  allowPVPVO = false -- no more VO after the winner VO 
  
  on_no_conversation(function()
    if (teamID == 1) then  -- blue wins 
      play_line(DialogueSpecs.PVP_COMP_PA_MISC030)
    else -- red wins 
      play_line(DialogueSpecs.PVP_COMP_PA_MISC029)
    end
    on_conversation_complete(function()
      if (callback ~= nil) then 
        callback()
      end
      unset_event()
    end)
    unset_event()
  end)
  
end -- end PlayVO_Comp_Winner

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~ PlayVO_Comp_Stage_ReconStart ~~~~~~~~~~~~~~~~~ --
function PlayVO_Comp_Stage_ReconStart()

  if (not allowPVPVO) then 
    return; 
  end 
  
  on_no_conversation(function()
    play_line(DialogueSpecs.PVP_COMP_PA_MISC032)
    unset_event()
  end)
  
end -- end PlayVO_Comp_Stage_ReconStart

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~ PlayVO_Comp_Stage_ReconOver ~~~~~~~~~~~~~~~~~ --
function PlayVO_Comp_Stage_ReconOver()

  if (not allowPVPVO) then 
    return; 
  end 
  
  on_no_conversation(function()
    play_line(DialogueSpecs.PVP_COMP_PA_MISC033)
    unset_event()
  end)
  
end -- end PlayVO_Comp_Stage_ReconOver

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~ PlayVO_Comp_Stage_BuildStart ~~~~~~~~~~~~~~~~~ --
function PlayVO_Comp_Stage_BuildStart()

  if (not allowPVPVO) then 
    return; 
  end 
  
  on_no_conversation(function()
    
    conv_start()
    conv_add_line(DialogueSpecs.PVP_COMP_PA_MISC034) -- squad stage start
    conv_add_line(DialogueSpecs.PVP_COMP_PA_MISC035, nil, nil, 1) -- a line about what squad stage is for
    conv_play()
    
    unset_event()
  end)

end -- end PlayVO_Comp_Stage_BuildStart

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~ PlayVO_Comp_Stage_BuildOver ~~~~~~~~~~~~~~~~~ --
function PlayVO_Comp_Stage_BuildOver()

  if (not allowPVPVO) then 
    return; 
  end 
  
  on_no_conversation(function()
    play_line(DialogueSpecs.PVP_COMP_PA_MISC036)
    unset_event()
  end)
  
end -- end PlayVO_Comp_Stage_BuildOver

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~ PlayVO_Comp_Stage_InvasionStart ~~~~~~~~~~~~~~~~~ --
function PlayVO_Comp_Stage_InvasionStart()

  if (not allowPVPVO) then 
    return; 
  end 
  
  on_no_conversation(function()
    play_line(DialogueSpecs.PVP_COMP_PA_MISC037)
    unset_event()
  end)
  
end -- end PlayVO_Comp_Stage_InvasionStart

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~ PlayVO_Comp_Stage_InvasionOver ~~~~~~~~~~~~~~~~~ --
function PlayVO_Comp_Stage_InvasionOver()

  if (not allowPVPVO) then 
    return; 
  end 
  
  on_no_conversation(function()
    play_line(DialogueSpecs.PVP_COMP_PA_MISC038)
    unset_event()
  end)
  
end -- end PlayVO_Comp_Stage_InvasionOver

