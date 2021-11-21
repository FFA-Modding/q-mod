-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --
-- //						          DLC #0 - MOLONOTH: GAMEPLAY                     	\\ --
-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

prt("----> LOADED molonoth gameplay SCRIPT")

set_weapon_xp(0)

hide(invasion_enemies_for_dependencies)


--radar_set_full_screen_map(RADAR_MAP_PVP_DLC_0, 0, 0, 256, 256, .8, .25)
radar_set_full_screen_map(RADAR_MAP_PVP_DLC_0, 0, 0, 256, 256, .8, .35)
  --f32 center_x, f32 center_z, 
  --f32 center_texture_x, f32 center_texture_y
  --f32 texture_scale, 
  --f32 map_scale);

global_pvp_baseWarpArea_blue = area_pvpwrongbasewarp_blue
global_pvp_baseWarpArea_red = area_pvpwrongbasewarp_red

global_pvp_baseCam_blue = camFixed_baseView_blue
global_pvp_baseCam_red = camFixed_baseView_red

global_pvp_gameover_hidePod = pod_gameover_hidePod

global_pvp_allBaseDefensePod = pod_allBaseDefenses
global_pvp_allBaseDefenseScent = scent_allBaseDefenses
global_pvp_infInvHidePod = hidePod_infInvasion

-- local function SetupGrindCams()

  -- GRIND RAIL CAMERAS
  -- local grindStartVolArray = {vol_grind_rail_left, vol_grind_right, vol_grind_right_top, vol_grind_left_top,
                              -- vol_grind_red, vol_grind_blue}
  -- local grindEndVolArray = {vol_end_rail_left, vol_end_rail_right, vol_grind_right_top_end, vol_grind_left_top_end, 
                            -- vol_grind_red_end, vol_grind_blue_end}
  -- local grindCams = {CamArgIndexedRailLeft, 
                     -- CamArgIndexedRailRight, 
                     -- CamArgIndexedRailRightTop, 
                     -- CamArgIndexedRailLeftTop,
                     -- CamArgIndexedRailRed, 
                     -- CamArgIndexedRailBlue}
  -- local i;
  -- local j;
  -- local hero;
  -- for i = 0, 3, 1 do 
    -- hero = get_hero_at_player_id(i) 
    -- if (is_hero_active(hero)) then 
      -- for j = 1, #grindStartVolArray, 1 do 
        -- on_enter(get_hero_at_player_id(i), grindStartVolArray[j], function()
          -- if (is_player_local(i)) then
            -- activate_cam(grindCams[j])
          -- end
          -- on_enter(get_hero_at_player_id(i), grindEndVolArray[j], function()
            -- if (is_player_local(i)) then 
              -- activate_hero_cam()
            -- end
            -- unset_event()
          -- end)
        -- end)
      -- end
    -- end
  -- end
  
-- end -- end SetupGrindCams

-- SetupGrindCams()

-- PVP Cameras
global_pvp_introcam = {introcam}

--conveyor control
-- conveyor_reverse(conveyor_pod)
-- conveyor_reverse(conveyor_pod_upper)
conveyor_reverse(conveyor_pod_major)
--MissileFaces

on_death (missile_minion_1, function()
hide (crate_cache_forcefield2)
end)

on_death (missile_minion_2, function()
hide (crate_cache_forcefield1)
end)

global_pvp_baseDestFX_blue = {fxCont_baseDestroyed_blue_1, fxCont_baseDestroyed_blue_2, fxCont_baseDestroyed_blue_3, 
                              fxCont_baseDestroyed_blue_4, fxCont_baseDestroyed_blue_5, fxCont_baseDestroyed_blue_6}
global_pvp_baseDestFX_red = {fxCont_baseDestroyed_red_1, fxCont_baseDestroyed_red_2, fxCont_baseDestroyed_red_3, 
                             fxCont_baseDestroyed_red_4, fxCont_baseDestroyed_red_5, fxCont_baseDestroyed_red_6}
  


-- ========================================================================= --
-- ======                           KIOSK: ENEMIES                    ====== -- 
-- ========================================================================= --

local pvp_tankClues = {{clueES_inv_tank_3, clueES_inv_tank_4}, {clueES_inv_tank_1, clueES_inv_tank_2}}


-- ========================================================================= --
-- ======                     KIOSK: BASE INNER SHIELDS               ====== --
-- ========================================================================= --


local pvp_innerShields_blue = {barricadeFrame_inner_blue_1, barricadeFrame_inner_blue_2, inShield_pad_blue_1, inShield_pad_blue_2}
local pvp_innerShields_red = {barricadeFrame_inner_red_1, barricadeFrame_inner_red_2, inShield_pad_red_1, inShield_pad_red_2}
local pvp_innerShieldsClues_blue = {cluePur_inShield_blue_1, cluePur_inShield_blue_2}
local pvp_innerShieldsClues_red = {cluePur_inShield_red_1, cluePur_inShield_red_2}


-- ========================================================================= --
-- ======                       KIOSK: DEFENSE TURRETS                ====== --
-- ========================================================================= --


local pvp_upgrade_blue_turretPads = {
  heroTurret_blue_upgrade_1, heroTurret_blue_upgrade_2, heroTurret_blue_upgrade_3, heroTurret_blue_upgrade_4, 
 heroTurret_blue_upgrade_7, heroTurret_blue_upgrade_8, 
  heroTurret_blue_upgrade_9, heroTurret_blue_upgrade_10, heroTurret_blue_upgrade_11, heroTurret_blue_upgrade_12, 
  heroTurret_blue_upgrade_13, heroTurret_blue_upgrade_14, heroTurret_blue_upgrade_15, heroTurret_blue_upgrade_16, 
  heroTurret_blue_upgrade_17, heroTurret_blue_upgrade_18, heroTurret_blue_upgrade_19, heroTurret_blue_upgrade_20, 
  heroTurret_blue_upgrade_21, heroTurret_blue_upgrade_22, heroTurret_blue_upgrade_23, heroTurret_blue_upgrade_24, 
  heroTurret_blue_upgrade_25, heroTurret_blue_upgrade_26
  }
  
local pvp_upgrage_blue_turretClues = {
  cluePur_heroT_blue_upgrade_1, cluePur_heroT_blue_upgrade_2, cluePur_heroT_blue_upgrade_3, cluePur_heroT_blue_upgrade_4, 
  cluePur_heroT_blue_upgrade_7, cluePur_heroT_blue_upgrade_8, 
  cluePur_heroT_blue_upgrade_9, cluePur_heroT_blue_upgrade_10, cluePur_heroT_blue_upgrade_11, cluePur_heroT_blue_upgrade_12, 
  cluePur_heroT_blue_upgrade_13, cluePur_heroT_blue_upgrade_14, cluePur_heroT_blue_upgrade_15, cluePur_heroT_blue_upgrade_16, 
  cluePur_heroT_blue_upgrade_17, cluePur_heroT_blue_upgrade_18, cluePur_heroT_blue_upgrade_19, cluePur_heroT_blue_upgrade_20, 
  cluePur_heroT_blue_upgrade_21, cluePur_heroT_blue_upgrade_22, cluePur_heroT_blue_upgrade_23, cluePur_heroT_blue_upgrade_24, 
  cluePur_heroT_blue_upgrade_25, cluePur_heroT_blue_upgrade_26
  }
  
local pvp_upgrade_red_turretPads = {
  heroTurret_red_upgrade_1, heroTurret_red_upgrade_2, heroTurret_red_upgrade_3, heroTurret_red_upgrade_4, 
  heroTurret_red_upgrade_7, heroTurret_red_upgrade_8, 
  heroTurret_red_upgrade_9, heroTurret_red_upgrade_10, heroTurret_red_upgrade_11, heroTurret_red_upgrade_12, 
  heroTurret_red_upgrade_13, heroTurret_red_upgrade_14, heroTurret_red_upgrade_15, heroTurret_red_upgrade_16, 
  heroTurret_red_upgrade_17, heroTurret_red_upgrade_18, heroTurret_red_upgrade_19, heroTurret_red_upgrade_20, 
  heroTurret_red_upgrade_21, heroTurret_red_upgrade_22, heroTurret_red_upgrade_23, heroTurret_red_upgrade_24, 
  heroTurret_red_upgrade_25, heroTurret_red_upgrade_26
  }

local pvp_upgrage_red_turretClues = {
  cluePur_heroT_red_upgrade_1, cluePur_heroT_red_upgrade_2, cluePur_heroT_red_upgrade_3, cluePur_heroT_red_upgrade_4, 
  cluePur_heroT_red_upgrade_7, cluePur_heroT_red_upgrade_8, 
  cluePur_heroT_red_upgrade_9, cluePur_heroT_red_upgrade_10, cluePur_heroT_red_upgrade_11, cluePur_heroT_red_upgrade_12, 
  cluePur_heroT_red_upgrade_13, cluePur_heroT_red_upgrade_14, cluePur_heroT_red_upgrade_15, cluePur_heroT_red_upgrade_16, 
  cluePur_heroT_red_upgrade_17, cluePur_heroT_red_upgrade_18, cluePur_heroT_red_upgrade_19, cluePur_heroT_red_upgrade_20, 
  cluePur_heroT_red_upgrade_21, cluePur_heroT_red_upgrade_22, cluePur_heroT_red_upgrade_23, cluePur_heroT_red_upgrade_24, 
  cluePur_heroT_red_upgrade_25, cluePur_heroT_red_upgrade_26
  }
  
pvp_upgrade_blue_freeTurrets = {heroTurret_blue_upgrade_10, heroTurret_blue_upgrade_20}
pvp_upgrade_blue_freeTurret_clues = {cluePur_heroT_blue_upgrade_10, cluePur_heroT_blue_upgrade_20}
pvp_upgrade_blue_freeWarmongers = {heroTurret_blue_upgrade_5, heroTurret_blue_upgrade_6}
pvp_upgrade_blue_freeWarmonger_clues =  {cluePur_heroT_blue_upgrade_5, cluePur_heroT_blue_upgrade_6}
  
pvp_upgrade_red_freeTurrets = {heroTurret_red_upgrade_10, heroTurret_red_upgrade_20}
pvp_upgrade_red_freeTurret_clues = {cluePur_heroT_red_upgrade_10, cluePur_heroT_red_upgrade_20}
pvp_upgrade_red_freeWarmongers = {heroTurret_red_upgrade_5, heroTurret_red_upgrade_6}
pvp_upgrade_red_freeWarmonger_clues =  {cluePur_heroT_red_upgrade_5, cluePur_heroT_red_upgrade_6}



-- ========================================================================= --
-- ======                            KIOSKS                           ====== --
-- ========================================================================= --


local pvp_perkKiosks_table = {
  -- BLUE 
  {
    kioskMoby = kiosk_base_blue,
    kioskType = PERK_KIOSK_BASE,
    kioskTeam = HERO.HERO_TEAM_1,
    baseTurretArray = pvp_upgrade_blue_turretPads,
    baseTurretClueArray = pvp_upgrage_blue_turretClues,
    innerShieldMobyArray = pvp_innerShields_blue,
    innerShieldClueArray = pvp_innerShieldsClues_blue,
    freeTurretArray = pvp_upgrade_blue_freeTurrets,
    freeTurretClueArray = pvp_upgrade_blue_freeTurret_clues,
    freeWarmongerArray = pvp_upgrade_blue_freeWarmongers,
    freeWarmongerClueArray = pvp_upgrade_blue_freeWarmonger_clues
  },
  
    
  
  {
    kioskMoby = kiosk_hero_blue,
    kioskType = PERK_KIOSK_HERO,
    kioskTeam = HERO.HERO_TEAM_1
  }, 
  
  {
    kioskMoby = kiosk_squad_blue,
    kioskType = PERK_KIOSK_SQUAD,
    kioskTeam = HERO.HERO_TEAM_1
  }, 
  
 -- RED 
  {
    kioskMoby = kiosk_base_red,
    kioskType = PERK_KIOSK_BASE,
    kioskTeam = HERO.HERO_TEAM_2,
    baseTurretArray = pvp_upgrade_red_turretPads,
    baseTurretClueArray = pvp_upgrage_red_turretClues,
    innerShieldMobyArray = pvp_innerShields_red,
    innerShieldClueArray = pvp_innerShieldsClues_red,
    freeTurretArray = pvp_upgrade_red_freeTurrets,
    freeTurretClueArray = pvp_upgrade_red_freeTurret_clues,
    freeWarmongerArray = pvp_upgrade_red_freeWarmongers,
    freeWarmongerClueArray = pvp_upgrade_red_freeWarmonger_clues
  },
  
  {
    kioskMoby = kiosk_hero_red,
    kioskType = PERK_KIOSK_HERO,
    kioskTeam = HERO.HERO_TEAM_2
  }, 
  
  {
    kioskMoby = kiosk_squad_red,
    kioskType = PERK_KIOSK_SQUAD,
    kioskTeam = HERO.HERO_TEAM_2
  }, 
  
}

-- ========================================================================= --
-- ======                           SQUAD PADS                        ====== --
-- ========================================================================= --

-- give the squad pads the correct direction pad 
bangle_off(squadPads_right, 0, true)
bangle_on(squadPads_right, 1, true)

-- ========================================================================= --
-- ======                       COMP: WEAPON NODES                    ====== --
-- ========================================================================= --

local nodeData = {}
nodeData[1] = {
  node = nodePVP_1,
  dirClue = clueDir_node_1,
  waveScent = node_1_enemy_scent_w2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_1,
  barrierClue = cluePur_nodeBarrier_1,
  defensesPod = node_defenses_1,
	FXNeutral = fxCont_neutral_node_1,
	FXRed = fxCont_red_node_1,
	FXBlue = fxCont_blue_node_1
}
nodeData[2] = {
  node = nodePVP_2,
  dirClue = clueDir_node_2,
  waveScent = node_2_enemy_scent_w2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_2,
  barrierClue = cluePur_nodeBarrier_2,
  defensesPod = node_defenses_2,
	FXNeutral = fxCont_neutral_node_2,
	FXRed = fxCont_red_node_2,
	FXBlue = fxCont_blue_node_2
}
nodeData[3] = {
  node = nodePVP_3,
  dirClue = clueDir_node_3,
  waveScent = node_3_enemy_scent_w2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_3,
  barrierClue = cluePur_nodeBarrier_3,
  defensesPod = node_defenses_3,
	FXNeutral = fxCont_neutral_node_3,
	FXRed = fxCont_red_node_3,
	FXBlue = fxCont_blue_node_3
}
nodeData[4] = {
  node = nodePVP_4,
  dirClue = clueDir_node_4,
  waveScent = node_4_enemy_scent_w2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_4,
  barrierClue = cluePur_nodeBarrier_4,
  defensesPod = node_defenses_4,
	FXNeutral = fxCont_neutral_node_4,
	FXRed = fxCont_red_node_4,
	FXBlue = fxCont_blue_node_4
}
nodeData[5] = {
  node = nodePVP_5,
  dirClue = clueDir_node_5,
  waveScent = node_5_enemy_scent_w2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_5,
  barrierClue = cluePur_nodeBarrier_5,
  defensesPod = node_defenses_5,
	FXNeutral = fxCont_neutral_node_5,
	FXRed = fxCont_red_node_5,
	FXBlue = fxCont_blue_node_5
}
nodeData[6] = {
  node = nodePVP_6,
  dirClue = clueDir_node_6,
  waveScent = node_6_enemy_scent_w2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_6,
  barrierClue = cluePur_nodeBarrier_6,
  defensesPod = node_defenses_6,
	FXNeutral = fxCont_neutral_node_6,
	FXRed = fxCont_red_node_6,
	FXBlue = fxCont_blue_node_6
}
nodeData[7] = {
  node = nodePVP_7,
  dirClue = clueDir_node_7,
  waveScent = node_7_enemy_scent_w2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_7,
  barrierClue = cluePur_nodeBarrier_7,
  defensesPod = node_defenses_7,
	FXNeutral = fxCont_neutral_node_7,
	FXRed = fxCont_red_node_7,
	FXBlue = fxCont_blue_node_7
}


SetupCompNodes(nodeData)

-- ####################################################################### --
-- #######							         CHECKPOINTS					           	 ####### --
-- ####################################################################### --


-- ======================================================================= --
-- ==                           MINOR CHECKPOINTS                       == --
-- ======================================================================= --

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~ cp_default ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -- 

local blueTeamWarps = {hero_warp_blue_1, hero_warp_blue_2}
local redTeamWarps = {hero_warp_red_1, hero_warp_red_2}

local redPurchasePads_Left = {squadPad_red_left_1, squadPad_red_left_2, squadPad_red_left_3, squadPad_red_left_4}
local redPurchasePads_Right = {squadPad_red_right_1, squadPad_red_right_2, squadPad_red_right_3, squadPad_red_right_4}
local bluePurchasePads_Left = {squadPad_blue_left_1, squadPad_blue_left_2, squadPad_blue_left_3, squadPad_blue_left_4}
local bluePurchasePads_Right = {squadPad_blue_right_1, squadPad_blue_right_2, squadPad_blue_right_3, squadPad_blue_right_4}
local redGenArray = {baseGen_red_left_1, baseGen_red_left_2, baseGen_red_left_3, 
                     baseGen_red_right_1, baseGen_red_right_2, baseGen_red_right_3}
local blueGenArray = {baseGen_blue_left_1, baseGen_blue_left_2, baseGen_blue_left_3, 
                      baseGen_blue_right_1, baseGen_blue_right_2, baseGen_blue_right_3}

local function cp_fixup_default()
  ResetWeapons(true) -- will run herosetup to give the starting loadout
  radar_enable()
  SetupCompetitive(blueTeamWarps, redTeamWarps, blue_nonTurretPod, red_nonTurretPod, 
                   blue_turrets, red_turrets, blue_baseShields, red_baseShields, 
                   enemyBaseDisplay_blue, enemyBaseDisplay_red,
                   blue_purchase_console, red_purchase_console, blue_purchase_console_scent, red_purchase_console_scent, 
                   {{bluePurchasePads_Left, bluePurchasePads_Right}, {redPurchasePads_Left, redPurchasePads_Right}}, 
                   {blueGenArray, redGenArray},
                   area_detectHeroesAtBlueBase, area_detectHeroesAtRedBase, blue_baseCrates, red_baseCrates, 
                   blue_genPod, red_genPod, slamButton_genHide_blue, slamButton_genHide_red,
                   pvp_perkKiosks_table, pvp_tankClues)

end -- end fixup for cp_default 

register_checkpoint_fixup("cp_default", cp_fixup_default)
