-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --
-- //						        PATCH JUNGLE RUINS COMPETITIVE                  \\ --
-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

set_weapon_xp(0)

hide(invasion_enemies_for_dependencies)
deactivate(crate_cache_generator)
--radar_point_at(player_base_icon)
--radar_set_map(RADAR_MAP_COMP_TEST, 55, 125, 320, 495, 0.75, 0.75)   
  radar_set_full_screen_map(RADAR_MAP_JUNGLE_RUINS_PVP, 56, 56, 139, 139, .43, .43)
  --f32 center_x, f32 center_z, 
  --f32 center_texture_x, f32 center_texture_y
  --f32 texture_scale, 
  --f32 map_scale);

global_pvp_baseCam_blue = camFixed_baseView_team1
global_pvp_baseCam_red = camFixed_baseView_team2
global_pvp_gameover_hidePod = pod_gameover_hidePod

global_pvp_allBaseDefensePod = pod_allBaseDefenses
global_pvp_allBaseDefenseScent = scent_allBaseDefenses
global_pvp_infInvHidePod = hidePod_infInvasion

-- PVP Cameras
global_pvp_introcam = {introcam, introcam_2, introcam_3 }
-- global_pvp_introcam = {introcam_2, introcam_2, introcam_2 }

global_pvp_baseDestFX_blue = {fxCont_baseDestroyed_blue_1, fxCont_baseDestroyed_blue_2, fxCont_baseDestroyed_blue_3, 
                              fxCont_baseDestroyed_blue_4, fxCont_baseDestroyed_blue_5, fxCont_baseDestroyed_blue_6}
global_pvp_baseDestFX_red = {fxCont_baseDestroyed_red_1, fxCont_baseDestroyed_red_2, fxCont_baseDestroyed_red_3, 
                             fxCont_baseDestroyed_red_4, fxCont_baseDestroyed_red_5, fxCont_baseDestroyed_red_6}

set_defense_available(WPN_FLAMETHROWER, get_defense_allowed(WPN_FLAMETHROWER))
set_defense_available(WPN_ROCKET_LAUNCHER, get_defense_allowed(WPN_ROCKET_LAUNCHER))
set_defense_available(WPN_COMBUSTER, get_defense_allowed(WPN_COMBUSTER))
set_defense_available(WPN_ICE_BEAM, get_defense_allowed(WPN_ICE_BEAM))

set_defense_available(WPN_TIME_MINE, get_defense_allowed(WPN_TIME_MINE))
set_defense_available(WPN_PLASMA_MINE, get_defense_allowed(WPN_PLASMA_MINE))
set_defense_available(WPN_MORPH_TRAP, false)
set_defense_available(WPN_GROOVITRON_TRAP, get_defense_allowed(WPN_GROOVITRON_TRAP))
-- set_defense_available(WPN_WEAK_BARRICADE, get_defense_allowed(WPN_BARRICADE))
set_defense_available(WPN_HEAVY_BARRICADE, get_defense_allowed(WPN_HEAVY_BARRICADE))
set_defense_available(WPN_ELECTRO_BARRICADE, get_defense_allowed(WPN_ELECTRO_BARRICADE))

enemy_set_inner_awareness(crate_cache_missileface, 30)
enemy_set_outer_awareness(crate_cache_missileface, 60)

-- ========================================================================= --
-- ======                           KIOSK: ENEMIES                    ====== -- 
-- ========================================================================= --

-- LUA EXPOSURE 
clueES_inv_tank_1 = clue_handle:new( 24772, 54423, 46300, 19717 ); -- 0x4D05B4DCD49760C4
clueES_inv_tank_2 = clue_handle:new( 24772, 54423, 31101, 19716 ); -- 0x4D04797DD49760C4
clueES_inv_tank_3 = clue_handle:new( 24772, 54423, 1647, 19716 ); -- 0x4D04066FD49760C4
clueES_inv_tank_4 = clue_handle:new( 24772, 54423, 26767, 19716 ); -- 0x4D04688FD49760C4

local pvp_tankClues = {{clueES_inv_tank_1, clueES_inv_tank_2}, {clueES_inv_tank_3, clueES_inv_tank_4}}

-- ========================================================================= --
-- ======                     KIOSK: BASE CRATE SPAWNERS              ====== --
-- ========================================================================= --

-- LUA EXPOSURE
healthCrate_baseLeft_12 = moby_handle:new( 33394, 54420, 20492, 37837 ); -- 0x93CD500CD4948272
healthCrate_baseLeft_13 = moby_handle:new( 33394, 54420, 62712, 37838 ); -- 0x93CEF4F8D4948272
healthCrate_baseLeft_14 = moby_handle:new( 33393, 54420, 36349, 37879 ); -- 0x93F78DFDD4948271
healthCrate_baseLeft_15 = moby_handle:new( 33393, 54420, 20509, 37875 ); -- 0x93F3501DD4948271

-- Ammo spawners renamed for simplicity
ammoSpawner_NB_2 = moby_handle:new( 33393, 54420, 27857, 37873 ); -- 0x93F16CD1D4948271
ammoSpawner_SB_2 = moby_handle:new( 33394, 54420, 47261, 37839 ); -- 0x93CFB89DD4948272

-- the 2nd purchased ammo spawner will need to be spawned via code 
local vPos_newAmmo_NB = lua_vector:new()
local vPos_newAmmo_SB = lua_vector:new()

vPos_newAmmo_NB.x = -158.191803
vPos_newAmmo_NB.y = 6.421022
vPos_newAmmo_NB.z = 137.356827
vPos_newAmmo_SB.x = 269.763855
vPos_newAmmo_SB.y = 6.146364
vPos_newAmmo_SB.z = 141.034760


local pvp_baseHealth_NB = {healthCrate_baseLeft_14, healthCrate_baseLeft_15}
local pvp_baseHealth_SB = {healthCrate_baseLeft_12, healthCrate_baseLeft_13}

-- the red health crate is on the ramp - move it off 
local leftHealthCrate_SB_loc = get_pos(healthCrate_baseLeft_12)
leftHealthCrate_SB_loc.z = 130.654434
set_pos(healthCrate_baseLeft_12, leftHealthCrate_SB_loc)

-- ========================================================================= --
-- ======                     KIOSK: BASE INNER SHIELDS               ====== --
-- ========================================================================= --

-- LUA EXPOSURE 
-- (note: renamed for simplicity)
cluePur_inShield_NB_1 = clue_handle:new( 33393, 54420, 27630, 37886 ); -- 0x93FE6BEED4948271
cluePur_inShield_NB_2 = clue_handle:new( 33401, 54420, 37428, 38185 ); -- 0x95299234D4948279
cluePur_inShield_SB_1 = clue_handle:new( 33392, 54420, 55585, 37785 ); -- 0x9399D921D4948270
cluePur_inShield_SB_2 = clue_handle:new( 33392, 54420, 61223, 37811 ); -- 0x93B3EF27D4948270
inShield_NB_pad_1 = moby_handle:new( 48473, 51979, 16864, 21520 ); -- 0x541041E0CB0BBD59
inShield_NB_pad_2 = moby_handle:new( 48472, 51979, 33933, 21528 ); -- 0x5418848DCB0BBD58
inShield_SB_pad_1 = moby_handle:new( 48473, 51979, 21207, 21615 ); -- 0x546F52D7CB0BBD59
inShield_SB_pad_2 = moby_handle:new( 48473, 51979, 20543, 21626 ); -- 0x547A503FCB0BBD59

barricadeFrame_NB_inner_1 = moby_handle:new( 33393, 54420, 1455, 37886 ); -- 0x93FE05AFD4948271
barricadeFrame_NB_inner_2 = moby_handle:new( 33401, 54420, 43175, 38172 ); -- 0x951CA8A7D4948279
barricadeFrame_SB_inner_1 = moby_handle:new( 33393, 54420, 41690, 37760 ); -- 0x9380A2DAD4948271
barricadeFrame_SB_inner_2 = moby_handle:new( 33393, 54420, 9319, 37763 ); -- 0x93832467D4948271

local pvp_NB_innerShields = {barricadeFrame_NB_inner_1, barricadeFrame_NB_inner_2, inShield_NB_pad_1, inShield_NB_pad_2}
local pvp_SB_innerShields = {barricadeFrame_SB_inner_1, barricadeFrame_SB_inner_2, inShield_SB_pad_1, inShield_SB_pad_2}
local pvp_NB_innerShieldClues = {cluePur_inShield_NB_1, cluePur_inShield_NB_2}
local pvp_SB_innerShieldClues = {cluePur_inShield_SB_1, cluePur_inShield_SB_2}

-- ========================================================================= --
-- ======                       KIOSK: DEFENSE TURRETS                ====== --
-- ========================================================================= --

-- LUA EXPOSURE
-- (note: these are renamed here from the names in the scene editor for simplicity)
heroTurret_NB_upgrade_1 = moby_handle:new( 33394, 54420, 46349, 37825 ); -- 0x93C1B50DD4948272
heroTurret_NB_upgrade_2 = moby_handle:new( 33394, 54420, 14131, 37825 ); -- 0x93C13733D4948272
heroTurret_NB_upgrade_3 = moby_handle:new( 33395, 54420, 41775, 37949 ); -- 0x943DA32FD4948273
heroTurret_NB_upgrade_4 = moby_handle:new( 33394, 54420, 58735, 37824 ); -- 0x93C0E56FD4948272
heroTurret_NB_upgrade_5 = moby_handle:new( 33395, 54420, 25725, 37933 ); -- 0x942D647DD4948273
heroTurret_NB_upgrade_6 = moby_handle:new( 33395, 54420, 7235, 37925 ); -- 0x94251C43D4948273
heroTurret_NB_upgrade_7 = moby_handle:new( 33395, 54420, 41151, 37937 ); -- 0x9431A0BFD4948273
heroTurret_NB_upgrade_8 = moby_handle:new( 33395, 54420, 62605, 37937 ); -- 0x9431F48DD4948273
heroTurret_NB_upgrade_9 = moby_handle:new( 33395, 54420, 6243, 37937 ); -- 0x94311863D4948273
heroTurret_NB_upgrade_10 = moby_handle:new( 33395, 54420, 61687, 37942 ); -- 0x9436F0F7D4948273
heroTurret_NB_upgrade_11 = moby_handle:new( 33395, 54420, 261, 37941 ); -- 0x94350105D4948273
heroTurret_NB_upgrade_12 = moby_handle:new( 33395, 54420, 41383, 37941 ); -- 0x9435A1A7D4948273
heroTurret_NB_upgrade_13 = moby_handle:new( 33395, 54420, 62142, 37941 ); -- 0x9435F2BED4948273
heroTurret_NB_upgrade_14 = moby_handle:new( 33395, 54420, 44212, 37928 ); -- 0x9428ACB4D4948273
heroTurret_NB_upgrade_15 = moby_handle:new( 33395, 54420, 52423, 37943 ); -- 0x9437CCC7D4948273
heroTurret_NB_upgrade_16 = moby_handle:new( 33395, 54420, 22264, 37929 ); -- 0x942956F8D4948273
heroTurret_NB_upgrade_17 = moby_handle:new( 33394, 54420, 17557, 37826 ); -- 0x93C24495D4948272
heroTurret_NB_upgrade_18 = moby_handle:new( 33394, 54420, 59867, 37826 ); -- 0x93C2E9DBD4948272
heroTurret_NB_upgrade_19 = moby_handle:new( 33394, 54420, 3193, 37826 ); -- 0x93C20C79D4948272
heroTurret_NB_upgrade_20 = moby_handle:new( 33394, 54420, 55013, 37827 ); -- 0x93C3D6E5D4948272
heroTurret_NB_upgrade_21 = moby_handle:new( 33395, 54420, 27741, 37951 ); -- 0x943F6C5DD4948273
heroTurret_NB_upgrade_22 = moby_handle:new( 33395, 54420, 42716, 37948 ); -- 0x943CA6DCD4948273
heroTurret_NB_upgrade_23 = moby_handle:new( 33395, 54420, 53594, 37951 ); -- 0x943FD15AD4948273
heroTurret_NB_upgrade_24 = moby_handle:new( 33395, 54420, 34687, 37951 ); -- 0x943F877FD4948273
heroTurret_NB_upgrade_25 = moby_handle:new( 33395, 54420, 3548, 37945 ); -- 0x94390DDCD4948273
heroTurret_NB_upgrade_26 = moby_handle:new( 33395, 54420, 13539, 37939 ); -- 0x943334E3D4948273

heroTurret_SB_upgrade_1 = moby_handle:new( 33402, 54420, 25914, 38240 ); -- 0x9560653AD494827A
heroTurret_SB_upgrade_2 = moby_handle:new( 33402, 54420, 5592, 38236 ); -- 0x955C15D8D494827A
heroTurret_SB_upgrade_3 = moby_handle:new( 33402, 54420, 38496, 38236 ); -- 0x955C9660D494827A
heroTurret_SB_upgrade_4 = moby_handle:new( 33402, 54420, 16987, 38233 ); -- 0x9559425BD494827A
heroTurret_SB_upgrade_5 = moby_handle:new( 33393, 54420, 45213, 37885 ); -- 0x93FDB09DD4948271
heroTurret_SB_upgrade_6 = moby_handle:new( 33393, 54420, 5542, 37762 ); -- 0x938215A6D4948271
heroTurret_SB_upgrade_7 = moby_handle:new( 33392, 54420, 57521, 37823 ); -- 0x93BFE0B1D4948270
heroTurret_SB_upgrade_8 = moby_handle:new( 33392, 54420, 1255, 37823 ); -- 0x93BF04E7D4948270
heroTurret_SB_upgrade_9 = moby_handle:new( 33392, 54420, 61401, 37820 ); -- 0x93BCEFD9D4948270
heroTurret_SB_upgrade_10 = moby_handle:new( 33392, 54420, 35073, 37820 ); -- 0x93BC8901D4948270
heroTurret_SB_upgrade_11 = moby_handle:new( 33392, 54420, 44671, 37697 ); -- 0x9341AE7FD4948270
heroTurret_SB_upgrade_12 = moby_handle:new( 33392, 54420, 33444, 37697 ); -- 0x934182A4D4948270
heroTurret_SB_upgrade_13 = moby_handle:new( 33392, 54420, 55335, 37697 ); -- 0x9341D827D4948270
heroTurret_SB_upgrade_14 = moby_handle:new( 33392, 54420, 58392, 37697 ); -- 0x9341E418D4948270
heroTurret_SB_upgrade_15 = moby_handle:new( 33392, 54420, 32178, 37823 ); -- 0x93BF7DB2D4948270
heroTurret_SB_upgrade_16 = moby_handle:new( 33392, 54420, 64601, 37696 ); -- 0x9340FC59D4948270
heroTurret_SB_upgrade_17 = moby_handle:new( 33402, 54420, 24143, 38247 ); -- 0x95675E4FD494827A
heroTurret_SB_upgrade_18 = moby_handle:new( 33402, 54420, 24102, 38246 ); -- 0x95665E26D494827A
heroTurret_SB_upgrade_19 = moby_handle:new( 33402, 54420, 53309, 38247 ); -- 0x9567D03DD494827A
heroTurret_SB_upgrade_20 = moby_handle:new( 33402, 54420, 56116, 38244 ); -- 0x9564DB34D494827A
heroTurret_SB_upgrade_21 = moby_handle:new( 33403, 54420, 40246, 38231 ); -- 0x95579D36D494827B
heroTurret_SB_upgrade_22 = moby_handle:new( 33403, 54420, 24597, 38235 ); -- 0x955B6015D494827B
heroTurret_SB_upgrade_23 = moby_handle:new( 33403, 54420, 6427, 38230 ); -- 0x9556191BD494827B
heroTurret_SB_upgrade_24 = moby_handle:new( 33403, 54420, 34662, 38230 ); -- 0x95568766D494827B
heroTurret_SB_upgrade_25 = moby_handle:new( 33402, 54420, 47213, 38251 ); -- 0x956BB86DD494827A
heroTurret_SB_upgrade_26 = moby_handle:new( 33394, 54420, 8979, 37828 ); -- 0x93C42313D4948272


cluePur_heroT_NB_upgrade_1 = clue_handle:new( 33394, 54420, 12419, 37827 ); -- 0x93C33083D4948272
cluePur_heroT_NB_upgrade_2 = clue_handle:new( 33394, 54420, 26595, 37827 ); -- 0x93C367E3D4948272
cluePur_heroT_NB_upgrade_3 = clue_handle:new( 33395, 54420, 61297, 37949 ); -- 0x943DEF71D4948273
cluePur_heroT_NB_upgrade_4 = clue_handle:new( 33394, 54420, 17353, 37827 ); -- 0x93C343C9D4948272
cluePur_heroT_NB_upgrade_5 = clue_handle:new( 33395, 54420, 21965, 37932 ); -- 0x942C55CDD4948273
cluePur_heroT_NB_upgrade_6 = clue_handle:new( 33395, 54420, 28733, 37925 ); -- 0x9425703DD4948273
cluePur_heroT_NB_upgrade_7 = clue_handle:new( 33395, 54420, 7379, 37936 ); -- 0x94301CD3D4948273
cluePur_heroT_NB_upgrade_8 = clue_handle:new( 33395, 54420, 39427, 37936 ); -- 0x94309A03D4948273
cluePur_heroT_NB_upgrade_9 = clue_handle:new( 33395, 54420, 15494, 37936 ); -- 0x94303C86D4948273
cluePur_heroT_NB_upgrade_10 = clue_handle:new( 33395, 54420, 63933, 37936 ); -- 0x9430F9BDD4948273
cluePur_heroT_NB_upgrade_11 = clue_handle:new( 33395, 54420, 54699, 37940 ); -- 0x9434D5ABD4948273
cluePur_heroT_NB_upgrade_12 = clue_handle:new( 33395, 54420, 4386, 37940 ); -- 0x94341122D4948273
cluePur_heroT_NB_upgrade_13 = clue_handle:new( 33395, 54420, 13046, 37940 ); -- 0x943432F6D4948273
cluePur_heroT_NB_upgrade_14 = clue_handle:new( 33395, 54420, 63273, 37940 ); -- 0x9434F729D4948273
cluePur_heroT_NB_upgrade_15 = clue_handle:new( 33395, 54420, 8035, 37942 ); -- 0x94361F63D4948273
cluePur_heroT_NB_upgrade_16 = clue_handle:new( 33395, 54420, 36454, 37928 ); -- 0x94288E66D4948273
cluePur_heroT_NB_upgrade_17 = clue_handle:new( 33394, 54420, 28135, 37949 ); -- 0x943D6DE7D4948272
cluePur_heroT_NB_upgrade_18 = clue_handle:new( 33394, 54420, 21148, 37949 ); -- 0x943D529CD4948272
cluePur_heroT_NB_upgrade_19 = clue_handle:new( 33394, 54420, 62571, 37826 ); -- 0x93C2F46BD4948272
cluePur_heroT_NB_upgrade_20 = clue_handle:new( 33395, 54420, 51807, 37949 ); -- 0x943DCA5FD4948273
cluePur_heroT_NB_upgrade_21 = clue_handle:new( 33395, 54420, 19948, 37950 ); -- 0x943E4DECD4948273
cluePur_heroT_NB_upgrade_22 = clue_handle:new( 33395, 54420, 14897, 37950 ); -- 0x943E3A31D4948273
cluePur_heroT_NB_upgrade_23 = clue_handle:new( 33395, 54420, 24665, 37950 ); -- 0x943E6059D4948273
cluePur_heroT_NB_upgrade_24 = clue_handle:new( 33395, 54420, 1406, 37950 ); -- 0x943E057ED4948273
cluePur_heroT_NB_upgrade_25 = clue_handle:new( 33394, 54420, 40868, 37825 ); -- 0x93C19FA4D4948272
cluePur_heroT_NB_upgrade_26 = clue_handle:new( 33395, 54420, 9691, 37948 ); -- 0x943C25DBD4948273

cluePur_heroT_SB_upgrade_1 = clue_handle:new( 33399, 54420, 47417, 38125 ); -- 0x94EDB939D4948277
cluePur_heroT_SB_upgrade_2 = clue_handle:new( 33399, 54420, 52103, 38132 ); -- 0x94F4CB87D4948277
cluePur_heroT_SB_upgrade_3 = clue_handle:new( 33399, 54420, 16999, 38129 ); -- 0x94F14267D4948277
cluePur_heroT_SB_upgrade_4 = clue_handle:new( 33399, 54420, 59332, 38124 ); -- 0x94ECE7C4D4948277
cluePur_heroT_SB_upgrade_5 = clue_handle:new( 33393, 54420, 39076, 37885 ); -- 0x93FD98A4D4948271
cluePur_heroT_SB_upgrade_6 = clue_handle:new( 33393, 54420, 11855, 37762 ); -- 0x93822E4FD4948271
cluePur_heroT_SB_upgrade_7 = clue_handle:new( 33392, 54420, 56715, 37823 ); -- 0x93BFDD8BD4948270
cluePur_heroT_SB_upgrade_8 = clue_handle:new( 33392, 54420, 52763, 37823 ); -- 0x93BFCE1BD4948270
cluePur_heroT_SB_upgrade_9 = clue_handle:new( 33392, 54420, 11269, 37823 ); -- 0x93BF2C05D4948270
cluePur_heroT_SB_upgrade_10 = clue_handle:new( 33392, 54420, 47123, 37823 ); -- 0x93BFB813D4948270
cluePur_heroT_SB_upgrade_11 = clue_handle:new( 33392, 54420, 25782, 37696 ); -- 0x934064B6D4948270
cluePur_heroT_SB_upgrade_12 = clue_handle:new( 33392, 54420, 19173, 37696 ); -- 0x93404AE5D4948270
cluePur_heroT_SB_upgrade_13 = clue_handle:new( 33392, 54420, 32659, 37696 ); -- 0x93407F93D4948270
cluePur_heroT_SB_upgrade_14 = clue_handle:new( 33392, 54420, 11299, 37696 ); -- 0x93402C23D4948270
cluePur_heroT_SB_upgrade_15 = clue_handle:new( 33392, 54420, 3894, 37699 ); -- 0x93430F36D4948270
cluePur_heroT_SB_upgrade_16 = clue_handle:new( 33392, 54420, 54467, 37820 ); -- 0x93BCD4C3D4948270
cluePur_heroT_SB_upgrade_17 = clue_handle:new( 33402, 54420, 56031, 38246 ); -- 0x9566DADFD494827A
cluePur_heroT_SB_upgrade_18 = clue_handle:new( 33402, 54420, 59453, 38246 ); -- 0x9566E83DD494827A
cluePur_heroT_SB_upgrade_19 = clue_handle:new( 33402, 54420, 42889, 38246 ); -- 0x9566A789D494827A
cluePur_heroT_SB_upgrade_20 = clue_handle:new( 33402, 54420, 30702, 38241 ); -- 0x956177EED494827A
cluePur_heroT_SB_upgrade_21 = clue_handle:new( 33399, 54420, 60944, 38134 ); -- 0x94F6EE10D4948277
cluePur_heroT_SB_upgrade_22 = clue_handle:new( 33399, 54420, 9449, 38129 ); -- 0x94F124E9D4948277
cluePur_heroT_SB_upgrade_23 = clue_handle:new( 33399, 54420, 24489, 38134 ); -- 0x94F65FA9D4948277
cluePur_heroT_SB_upgrade_24 = clue_handle:new( 33399, 54420, 34522, 38129 ); -- 0x94F186DAD4948277
cluePur_heroT_SB_upgrade_25 = clue_handle:new( 33402, 54420, 2824, 38244 ); -- 0x95640B08D494827A
cluePur_heroT_SB_upgrade_26 = clue_handle:new( 33394, 54420, 17450, 37835 ); -- 0x93CB442AD4948272

local pvp_upgrade_NB_turretPads = {
  heroTurret_NB_upgrade_1, heroTurret_NB_upgrade_2, heroTurret_NB_upgrade_3, heroTurret_NB_upgrade_4, 
  heroTurret_NB_upgrade_7, heroTurret_NB_upgrade_8, 
  heroTurret_NB_upgrade_9, heroTurret_NB_upgrade_10, heroTurret_NB_upgrade_11, heroTurret_NB_upgrade_12, 
  heroTurret_NB_upgrade_13, heroTurret_NB_upgrade_14, heroTurret_NB_upgrade_15, heroTurret_NB_upgrade_16, 
  heroTurret_NB_upgrade_17, heroTurret_NB_upgrade_18, heroTurret_NB_upgrade_19, heroTurret_NB_upgrade_20, 
  heroTurret_NB_upgrade_21, heroTurret_NB_upgrade_22, heroTurret_NB_upgrade_23, heroTurret_NB_upgrade_24, 
  heroTurret_NB_upgrade_25, heroTurret_NB_upgrade_26
  }
  
local pvp_upgrade_NB_turretClues = {
  cluePur_heroT_NB_upgrade_1, cluePur_heroT_NB_upgrade_2, cluePur_heroT_NB_upgrade_3, cluePur_heroT_NB_upgrade_4, 
  cluePur_heroT_NB_upgrade_7, cluePur_heroT_NB_upgrade_8, 
  cluePur_heroT_NB_upgrade_9, cluePur_heroT_NB_upgrade_10, cluePur_heroT_NB_upgrade_11, cluePur_heroT_NB_upgrade_12, 
  cluePur_heroT_NB_upgrade_13, cluePur_heroT_NB_upgrade_14, cluePur_heroT_NB_upgrade_15, cluePur_heroT_NB_upgrade_16, 
  cluePur_heroT_NB_upgrade_17, cluePur_heroT_NB_upgrade_18, cluePur_heroT_NB_upgrade_19, cluePur_heroT_NB_upgrade_20, 
  cluePur_heroT_NB_upgrade_21, cluePur_heroT_NB_upgrade_22, cluePur_heroT_NB_upgrade_23, cluePur_heroT_NB_upgrade_24, 
  cluePur_heroT_NB_upgrade_25, cluePur_heroT_NB_upgrade_26
  }
  
local pvp_upgrade_SB_turretPads = {
  heroTurret_SB_upgrade_1, heroTurret_SB_upgrade_2, heroTurret_SB_upgrade_3, heroTurret_SB_upgrade_4, 
  heroTurret_SB_upgrade_7, heroTurret_SB_upgrade_8, 
  heroTurret_SB_upgrade_9, heroTurret_SB_upgrade_10, heroTurret_SB_upgrade_11, heroTurret_SB_upgrade_12, 
  heroTurret_SB_upgrade_13, heroTurret_SB_upgrade_14, heroTurret_SB_upgrade_15, heroTurret_SB_upgrade_16, 
  heroTurret_SB_upgrade_17, heroTurret_SB_upgrade_18, heroTurret_SB_upgrade_19, heroTurret_SB_upgrade_20, 
  heroTurret_SB_upgrade_21, heroTurret_SB_upgrade_22, heroTurret_SB_upgrade_23, heroTurret_SB_upgrade_24, 
  heroTurret_SB_upgrade_25, heroTurret_SB_upgrade_26
  }

local pvp_upgrade_SB_turretClues = {
  cluePur_heroT_SB_upgrade_1, cluePur_heroT_SB_upgrade_2, cluePur_heroT_SB_upgrade_3, cluePur_heroT_SB_upgrade_4, 
  cluePur_heroT_SB_upgrade_7, cluePur_heroT_SB_upgrade_8, 
  cluePur_heroT_SB_upgrade_9, cluePur_heroT_SB_upgrade_10, cluePur_heroT_SB_upgrade_11, cluePur_heroT_SB_upgrade_12, 
  cluePur_heroT_SB_upgrade_13, cluePur_heroT_SB_upgrade_14, cluePur_heroT_SB_upgrade_15, cluePur_heroT_SB_upgrade_16, 
  cluePur_heroT_SB_upgrade_17, cluePur_heroT_SB_upgrade_18, cluePur_heroT_SB_upgrade_19, cluePur_heroT_SB_upgrade_20, 
  cluePur_heroT_SB_upgrade_21, cluePur_heroT_SB_upgrade_22, cluePur_heroT_SB_upgrade_23, cluePur_heroT_SB_upgrade_24, 
  cluePur_heroT_SB_upgrade_25, cluePur_heroT_SB_upgrade_26
  }
local pvp_upgrade_NB_freeTurrets = {
  heroTurret_NB_upgrade_20,
  heroTurret_NB_upgrade_14
  }
local pvp_upgrade_NB_freeTurret_clues = {
  cluePur_heroT_NB_upgrade_20,
  cluePur_heroT_NB_upgrade_14
  }
local pvp_upgrade_SB_freeTurrets = {
  heroTurret_SB_upgrade_10,
  heroTurret_SB_upgrade_24
  }
local pvp_upgrade_SB_freeTurret_clues = {
  cluePur_heroT_SB_upgrade_10,
  cluePur_heroT_SB_upgrade_24
  }
local pvp_upgrade_NB_freeWarmongers = {
  heroTurret_NB_upgrade_5,
  heroTurret_NB_upgrade_6
  }
local pvp_upgrade_NB_freeWarmonger_clues = {
  cluePur_heroT_NB_upgrade_5, 
  cluePur_heroT_NB_upgrade_6
  }
local pvp_upgrade_SB_freeWarmongers = {
  heroTurret_SB_upgrade_5, 
  heroTurret_SB_upgrade_6
  }
local pvp_upgrade_SB_freeWarmonger_clues = {
  cluePur_heroT_SB_upgrade_5, 
  cluePur_heroT_SB_upgrade_6
  }

-- ========================================================================= --
-- ======                            KIOSKS                           ====== --
-- ========================================================================= --

-- LUA EXPOSURE
blue_perk_station_1 = moby_handle:new( 29086, 52091, 35596, 60613 ); -- 0xECC58B0CCB7B719E
blue_perk_station_2 = moby_handle:new( 60443, 52092, 2432, 45671 ); -- 0xB2670980CB7CEC1B
blue_perk_station_3 = moby_handle:new( 60457, 52092, 19881, 46321 ); -- 0xB4F14DA9CB7CEC29

red_perk_station_1 = moby_handle:new( 29127, 52091, 27270, 62498 ); -- 0xF4226A86CB7B71C7
red_perk_station_2 = moby_handle:new( 60515, 52092, 136, 48879 ); -- 0xBEEF0088CB7CEC63
red_perk_station_3 = moby_handle:new( 60531, 52092, 44589, 49539 ); -- 0xC183AE2DCB7CEC73

                        
local pvp_perkKiosks_table = {
  -- BLUE 
  {
    kioskMoby = blue_perk_station_2,
    kioskType = PERK_KIOSK_BASE,
    kioskTeam = HERO.HERO_TEAM_1,
    baseTurretArray = pvp_upgrade_NB_turretPads,
    baseTurretClueArray = pvp_upgrade_NB_turretClues,
    healthSpawnerArray = pvp_baseHealth_NB,
    purAmmoSpawner = ammoSpawner_NB_2,
    purAmmoSpawnerLoc = vPos_newAmmo_NB,
    innerShieldMobyArray = pvp_NB_innerShields,
    innerShieldClueArray = pvp_NB_innerShieldClues,
    freeTurretArray = pvp_upgrade_NB_freeTurrets,
    freeTurretClueArray = pvp_upgrade_NB_freeTurret_clues,
    freeWarmongerArray = pvp_upgrade_NB_freeWarmongers,
    freeWarmongerClueArray = pvp_upgrade_NB_freeWarmonger_clues
  },
  
  {
    kioskMoby = blue_perk_station_1,
    kioskType = PERK_KIOSK_HERO,
    kioskTeam = HERO.HERO_TEAM_1,
  }, 
  
  {
    kioskMoby = blue_perk_station_3,
    kioskType = PERK_KIOSK_SQUAD,
    kioskTeam = HERO.HERO_TEAM_1,
  }, 
  
 -- RED 
  {
    kioskMoby = red_perk_station_2,
    kioskType = PERK_KIOSK_BASE,
    kioskTeam = HERO.HERO_TEAM_2,
    baseTurretArray = pvp_upgrade_SB_turretPads,
    baseTurretClueArray = pvp_upgrade_SB_turretClues,
    healthSpawnerArray = pvp_baseHealth_SB,
    purAmmoSpawner = ammoSpawner_SB_2,
    purAmmoSpawnerLoc = vPos_newAmmo_SB,
    innerShieldMobyArray = pvp_SB_innerShields,
    innerShieldClueArray = pvp_SB_innerShieldClues,
    freeTurretArray = pvp_upgrade_SB_freeTurrets,
    freeTurretClueArray = pvp_upgrade_SB_freeTurret_clues,
    freeWarmongerArray = pvp_upgrade_SB_freeWarmongers,
    freeWarmongerClueArray = pvp_upgrade_SB_freeWarmonger_clues
  },
  
  {
    kioskMoby = red_perk_station_1,
    kioskType = PERK_KIOSK_HERO,
    kioskTeam = HERO.HERO_TEAM_2,
  }, 
  
  {
    kioskMoby = red_perk_station_3,
    kioskType = PERK_KIOSK_SQUAD,
    kioskTeam = HERO.HERO_TEAM_2,
  }, 
  
}

-- /////////////////////////////////////////////////////////////////////////
-- --------------------------- SQUAD PADS ------------------------------- --
-- /////////////////////////////////////////////////////////////////////////

-- give the squad pads the correct direction pad 
--bangle_all_off(squadPads_left, true)
--bangle_on(squadPads_left, 0, true) 
bangle_off(squadPads_right, 0, true)
bangle_on(squadPads_right, 1, true)

-- /////////////////////////////////////////////////////////////////////////
-- ----------------------- BASE LOGIC P1 (BLUE) ---------------------- --
-- /////////////////////////////////////////////////////////////////////////


-- /////////////////////////////////////////////////////////////////////////
-- ----------------------- BASE LOGIC P2 (RED) ---------------------- --
-- /////////////////////////////////////////////////////////////////////////



-- /////////////////////////////////////////////////////////////////////////
-- ----------------------- CRATE CACHE ---------------------- --
-- /////////////////////////////////////////////////////////////////////////

on_death(crate_cache_missileface,
	function()
	activate(crate_cache_generator)
	end)

on_death(crate_cache_generator,
	function()
	hide(crate_cache_forcefield)
	end)
-- ========================================================================= --
-- ======                       COMP: WEAPON NODES                    ====== --
-- ========================================================================= --

local nodeData = {}
nodeData[1] = {
  node = nodePVP_1,
  dirClue = enemy_setup_node_8,
  waveScent = node_8_enemy_pod2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_8,
  barrierClue = cluePurchase_barrier_node_8,
  defensesPod = node_defenses_node_8,
	FXNeutral = FxController_major_node_neutral_1,
	FXRed = FxController_major_node_red_team_1,
	FXBlue = FxController_major_node_blue_team_1
}
nodeData[2] = {
  node = nodePVP_2,
  dirClue = enemy_setup_node_2,
  waveScent = node_2_enemy_pod2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_2,
  barrierClue = cluePurchase_barrier_node_2,
  defensesPod = node_defenses_node_2,
	FXNeutral = FxController_major_node_neutral_2,
	FXRed = FxController_major_node_red_team_2,
	FXBlue = FxController_major_node_blue_team_2
}
nodeData[3] = {
  node = nodePVP_3,
  dirClue = enemy_setup_node_3,
  waveScent = node_3_enemy_pod2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_3,
  barrierClue = cluePurchase_barrier_node_3,
  defensesPod = node_defenses_node_3,
	FXNeutral = FxController_major_node_neutral_3,
	FXRed = FxController_major_node_red_team_3,
	FXBlue = FxController_major_node_blue_team_3
}
nodeData[4] = {
  node = nodePVP_4,
  dirClue = enemy_setup_node_4,
  waveScent = node_4_enemy_pod2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_4,
  barrierClue = cluePurchase_barrier_node_4,
  defensesPod = node_defenses_node_4,
	FXNeutral = FxController_major_node_neutral_4,
	FXRed = FxController_major_node_red_team_4,
	FXBlue = FxController_major_node_blue_team_4
}
nodeData[5] = {
  node = nodePVP_5,
  dirClue = enemy_setup_node_5,
  waveScent = node_5_enemy_pod2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_5,
  barrierClue = cluePurchase_barrier_node_5,
  defensesPod = node_defenses_node_5,
	FXNeutral = FxController_major_node_neutral_5,
	FXRed = FxController_major_node_red_team_5,
	FXBlue = FxController_major_node_blue_team_5
}
nodeData[6] = {
  node = nodePVP_6,
  dirClue = enemy_setup_node_6,
  waveScent = node_6_enemy_pod2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_6,
  barrierClue = cluePurchase_barrier_node_6,
  defensesPod = node_defenses_node_6,
	FXNeutral = FxController_major_node_neutral_6,
	FXRed = FxController_major_node_red_team_6,
	FXBlue = FxController_major_node_blue_team_6
}
nodeData[7] = {
  node = nodePVP_7,
  dirClue = enemy_setup_node_7,
  waveScent = node_7_enemy_pod2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_7,
  barrierClue = cluePurchase_barrier_node_7,
  defensesPod = node_defenses_node_7,
	FXNeutral = FxController_major_node_neutral_7,
	FXRed = FxController_major_node_red_team_7,
	FXBlue = FxController_major_node_blue_team_7
}


SetupCompNodes(nodeData)

-- ####################################################################### --
-- ######                          PATCH                            ###### --
-- ####################################################################### --

-------------------------------
-- Node 1 has 2 enemies in the default wave scent that are in walls 
--------------------------------

-- Lua Exposure
node_1_enemy_55 = clue_handle:new( 33401, 54420, 8117, 38170 ); -- 0x951A1FB5D4948279
node_1_enemy_56 = clue_handle:new( 33401, 54420, 42843, 38161 ); -- 0x9511A75BD4948279


-- there is no "remove from scent" function, so we will just delete these two enemies when
-- they spawn [as the default enemies, they will only spawn once])
on_ai_spawned(node_1_enemy_55, function()
  local badEnemy = get_moby_handle_from_setup(node_1_enemy_55)
  on_elapsed(0.5, function() -- small delay to make sure the code is done with him before we delete him
    delete(badEnemy)
  end)
  unset_event()
end)

on_ai_spawned(node_1_enemy_56, function()
  local badEnemy = get_moby_handle_from_setup(node_1_enemy_56)
  on_elapsed(0.75, function() -- small delay to make sure the code is done with him before we delete him
    delete(badEnemy)
  end)
  unset_event()
end)

---------------------------
-- Invisible Collision 
---------------------------

-- scale x, y, z; rotate x, y, z; pos x, y, z
collision_hack(24.3, 51.4, 22.1, 0, 43, 0, 294, -0.35, -141) -- node 6 tree  
collision_hack(20.5, 27.4, 27.4, 0, 0, 0, 52.2, 31.6, 75.6) -- could get onto node 2
collision_hack(7.7, 23.7, 30, 0, -55, 0, -292.6, 3.3, -88.3) -- block getting to some rocks at behind node 3
collision_hack(5.7, 29.5, 59.4, 0, 0, 0, -66.9, 18.4, -240.1) -- block climbing the wall near node 4
collision_hack(5.7, 29.5, 59.4, 0, 0, 0, 177, 18.4, -240.1) -- block climbing the wall near node 5


-- block the front entrance archways to nodes 4 and 5 
collision_hack(14.9, 25.4, 7.9, 0, 0, 0, 168.8, 18.7, -209.9)
collision_hack(6.7, 29.9, 7.95, 0, 0, 0, 120.7, 18.7, -209.9)
collision_hack(6.7, 29.9, 7.95, 0, 0, 0, -11.75, 18.7, -209.9)
collision_hack(14.9, 25.4, 7.9, 0, 0, 0, -59.1, 18.7, -209.9)

-- keep heroes from passing through the walls around nodes 4 and 5 
collision_hack(6.7, 3.2, 3.3, 0, 26.2, 0, 107.1, 8.9, -155.6)
collision_hack(21.8, 11, 2.2, 0, 0, 0, 110, 6.9, -156)
collision_hack(30.7, 11, 2.2, 0, 0, 0, 34.1, 1.4, -144.4) 

-- keep heroes from jumping on the top of nodes 4 and 5
collision_hack(68.1, 34, 8.2, 0, 0, 0, 144, 18.7, -272)
collision_hack(21.8, 42, 21.3, 42.7, 0, 0, 144, 32, -278)
collision_hack(68, 34, 8.2, 0, 0, 0, -37, 19, -271)
collision_hack(21.8, 42.3, 21.3, 43, 0, 0, -38, 32, -278) 


-- block climbing to the top of the trees at node 1
--collision_hack(3.4, 27.8, 20, 0, -46.5, 0, 9.9, 37.9, -51.2) -- broke this up into 2 coll obj to not block open sky
collision_hack(3.4, 10, 20, 0, -46.5, 0, 9.9, 49, -51.2) 
collision_hack(3.4, 27.8, 7, 0, -46.5, 0, 9.9, 37.9, -51.2)
--collision_hack(3.4, 30.1, 20, 0, 47.1, 0, 91.5, 42.3, -50.7) -- shrinked this to not block open sky
collision_hack(3.4, 30.1, 8, 0, 47.1, 0, 91.5, 42.3, -50.7)

collision_hack(7.7, 31, 47, 0, 0, 0, -6, 42, -166) -- block a ramp from letting you get out of the level  

-- right corner of the tunnel over some rocks
collision_hack(5, 5, 6, 7.82, -11.29, 8.8, 92.25, 7.02, -151.16) 
collision_hack(6, 3, 4, 14.54, -0.93, 2.66, 95.36, 6.59, -150.81)

-----------------------------------
-- Enemy base volume adjustments
-----------------------------------

-- Lua exposure 
volDetect_heroesAtSouthBase_1 = volume_handle:new( 33402, 54420, 53857, 38264 ); -- 0x9578D261D494827A
volDetect_heroesAtNorthBase_3 = volume_handle:new( 33402, 54420, 9050, 38144 ); -- 0x9500235AD494827A
volDetect_heroesAtNorthBase_2 = volume_handle:new( 33401, 54420, 43137, 38159 ); -- 0x950FA881D4948279

move_vol(volDetect_heroesAtSouthBase_1, 215.263, 19.854, 198.263, 0, -45, 0, 15, 20, 31)
move_vol(volDetect_heroesAtNorthBase_3, -100.306, 19.891, 77.271, -180, 45, 180, 15, 20, 37)
move_vol(volDetect_heroesAtNorthBase_2, -103.663, 19.890, 195.697, 0, 45, 0, 15, 20, 32)

------------------------------------
-- Node Color FX Controllers 
------------------------------------

local nodeFxCont = {FxController_major_node_neutral_1, FxController_major_node_neutral_2, FxController_major_node_neutral_3, 
                    FxController_major_node_neutral_4, FxController_major_node_neutral_5, FxController_major_node_neutral_6, 
                    FxController_major_node_neutral_7, 
                    FxController_major_node_red_team_1, FxController_major_node_red_team_2, FxController_major_node_red_team_3, 
                    FxController_major_node_red_team_4, FxController_major_node_red_team_5, FxController_major_node_red_team_6, 
                    FxController_major_node_red_team_7,
                    FxController_major_node_blue_team_1, FxController_major_node_blue_team_2, FxController_major_node_blue_team_3, 
                    FxController_major_node_blue_team_4, FxController_major_node_blue_team_5, FxController_major_node_blue_team_6, 
                    FxController_major_node_blue_team_7}
                    
-- -------------------- ChangeNodeFXContUpdateRange ---------------------- --
function ChangeNodeFXContUpdateRange()

  local i; 
  for i = 1, #nodeFxCont, 1 do 
    set_fx_update_range(nodeFxCont[i], 10000)
  end
  
end -- end ChangeNodeFXContUpdateRange

ChangeNodeFXContUpdateRange()

----------------------------------------
-- Wrong Base in Wrong Phase Warp Area 
----------------------------------------

redVol_lane1_warp = spawn_vol_cuboid(222.77, 20, 190.24, 0, -45, 0, 25, 20, 35)
redVol_lane2_warp = spawn_vol_cuboid(221.58, 20, 87.58, 180, -45, 180, 25, 20, 35)
redVol_base_warp = spawn_vol_cuboid(291, 28, 138, 0, -90, 0, 80, 40, 80)
area_pvpwrongbasewarp_red = spawn_area(3, 0)
add_vol_to_area(area_pvpwrongbasewarp_red, 0, redVol_lane1_warp)
add_vol_to_area(area_pvpwrongbasewarp_red, 1, redVol_lane2_warp)
add_vol_to_area(area_pvpwrongbasewarp_red, 2, redVol_base_warp)

blueVol_lane1_warp = spawn_vol_cuboid(-104.02, 20, 81.45, 180, 45, 180, 25, 20, 35)
blueVol_lane2_warp = spawn_vol_cuboid(-111.11, 20, 190.44, 0, 45, 0, 25, 20, 35)
blueVol_base_warp = spawn_vol_cuboid(-177, 20, 138, 0, 90, 0, 80, 40, 80)
area_pvpwrongbasewarp_blue = spawn_area(3, 0)
add_vol_to_area(area_pvpwrongbasewarp_blue, 0, blueVol_lane1_warp)
add_vol_to_area(area_pvpwrongbasewarp_blue, 1, blueVol_lane2_warp)
add_vol_to_area(area_pvpwrongbasewarp_blue, 2, blueVol_base_warp)

global_pvp_baseWarpArea_blue = area_pvpwrongbasewarp_blue
global_pvp_baseWarpArea_red = area_pvpwrongbasewarp_red


-- ####################################################################### --
-- #######							         CHECKPOINTS					           	 ####### --
-- ####################################################################### --


-- ======================================================================= --
-- ==                           MINOR CHECKPOINTS                       == --
-- ======================================================================= --

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~ cp_default ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -- 

local NBPurchasePads_Left = {squadPad_p1_left_1, squadPad_p1_left_2, squadPad_p1_left_3, squadPad_p1_left_4}
local NBPurchasePads_Right = {squadPad_p1_right_1, squadPad_p1_right_2, squadPad_p1_right_3, squadPad_p1_right_4}
local SBPurchasePads_Left = {squadPad_p2_left_1, squadPad_p2_left_2, squadPad_p2_left_3, squadPad_p2_left_4}
local SBPurchasePads_Right = {squadPad_p2_right_1, squadPad_p2_right_2, squadPad_p2_right_3, squadPad_p2_right_4}
local NBGenArray = {baseGen_left_6, baseGen_left_3, baseGen_left_5, baseGen_right_6, baseGen_right_8, baseGen_right_7}
local SBGenArray = {baseGen_left_1, baseGen_left_2, baseGen_left_4, baseGen_right_3, baseGen_right_2, baseGen_right_1}


local function cp_fixup_default()
  ResetWeapons(true) -- will run herosetup to give the starting loadout
  radar_enable()
  SetupCompetitive({hero_warp_P1_1, hero_warp_P1_2}, {hero_warp_P2_1, hero_warp_P2_2}, P1_generators, P2_generators, P1_turrets, P2_turrets,
                   P1_base_forcefields_pod, P2_base_forcefields_pod, enemyBaseDisplay_p1, enemyBaseDisplay_p2, 
                   p1_purchase_console, p2_purchase_console, p1_purchase_console_scent, p2_purchase_console_scent, 
                   {{NBPurchasePads_Left, NBPurchasePads_Right}, {SBPurchasePads_Left, SBPurchasePads_Right}}, 
                   {NBGenArray, SBGenArray},
                   area_detectHeroesAtNorthBase, area_detectHeroesAtSouthBase, baseHealthCrates, baseHealthCrates2, 
                   NB_generators, SB_generators,slamButton_genHide_nb, slamButton_genHide_sb, 
                   pvp_perkKiosks_table, pvp_tankClues)
  
end -- end fixup for cp_default 

register_checkpoint_fixup("cp_default", cp_fixup_default)
