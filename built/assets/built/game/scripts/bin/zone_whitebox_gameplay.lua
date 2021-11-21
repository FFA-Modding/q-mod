set_weapon_xp(0)
hide(invasion_enemies_for_dependencies)
hide(pod_allTutorialObjs)
radar_set_full_screen_map(RADAR_MAP_ACID_REFINERY_PVP, -149, 222, 132, 139, 0.43, 0.43)
global_pvp_baseCam_blue = camFixed_showBase_nb
global_pvp_baseCam_red = camFixed_showBase_sb
global_pvp_gameover_hidePod = pod_gameover_hidePod
global_pvp_allBaseDefensePod = pod_allBaseDefenses
global_pvp_allBaseDefenseScent = scent_allBaseDefenses
global_pvp_infInvHidePod = hidePod_infInvasion
global_pvp_introcam = {
  introcam,
  introcam_2,
  introcam_3
}
global_pvp_baseDestFX_blue = {
  fxCont_baseDestroyed_blue_1,
  fxCont_baseDestroyed_blue_2,
  fxCont_baseDestroyed_blue_3,
  fxCont_baseDestroyed_blue_4,
  fxCont_baseDestroyed_blue_5,
  fxCont_baseDestroyed_blue_6
}
global_pvp_baseDestFX_red = {
  fxCont_baseDestroyed_red_1,
  fxCont_baseDestroyed_red_2,
  fxCont_baseDestroyed_red_3,
  fxCont_baseDestroyed_red_4,
  fxCont_baseDestroyed_red_5,
  fxCont_baseDestroyed_red_6
}
set_defense_available(WPN_FLAMETHROWER, get_defense_allowed(WPN_FLAMETHROWER))
set_defense_available(WPN_ROCKET_LAUNCHER, get_defense_allowed(WPN_ROCKET_LAUNCHER))
set_defense_available(WPN_COMBUSTER, get_defense_allowed(WPN_COMBUSTER))
set_defense_available(WPN_ICE_BEAM, get_defense_allowed(WPN_ICE_BEAM))
set_defense_available(WPN_TIME_MINE, get_defense_allowed(WPN_TIME_MINE))
set_defense_available(WPN_PLASMA_MINE, get_defense_allowed(WPN_PLASMA_MINE))
set_defense_available(WPN_MORPH_TRAP, false)
set_defense_available(WPN_GROOVITRON_TRAP, get_defense_allowed(WPN_GROOVITRON_TRAP))
set_defense_available(WPN_WEAK_BARRICADE, get_defense_allowed(WPN_WEAK_BARRICADE))
set_defense_available(WPN_HEAVY_BARRICADE, get_defense_allowed(WPN_HEAVY_BARRICADE))
set_defense_available(WPN_ELECTRO_BARRICADE, get_defense_allowed(WPN_ELECTRO_BARRICADE))
set_defense_available(WPN_PLASMA_BARRICADE, get_defense_allowed(WPN_PLASMA_BARRICADE))
clueES_inv_tank_1 = clue_handle:new(24860, 8242, 19395, 5710)
clueES_inv_tank_2 = clue_handle:new(24872, 8242, 22493, 6278)
clueES_inv_tank_3 = clue_handle:new(24876, 8242, 3738, 6614)
clueES_inv_tank_4 = clue_handle:new(24880, 8242, 26497, 6496)
local pvp_tankClues = {
  {clueES_inv_tank_1, clueES_inv_tank_2},
  {clueES_inv_tank_3, clueES_inv_tank_4}
}
healthCrate_baseLeft_12 = moby_handle:new(15776, 54457, 29466, 38326)
healthCrate_baseLeft_13 = moby_handle:new(15776, 54457, 11812, 38321)
healthCrate_baseLeft_14 = moby_handle:new(18632, 54457, 62143, 34621)
healthCrate_baseLeft_15 = moby_handle:new(18632, 54457, 30723, 34619)
ammoSpawner_NB_2 = moby_handle:new(18632, 54457, 49467, 34622)
ammoSpawner_SB_2 = moby_handle:new(15776, 54457, 59462, 38323)
local vPos_newAmmo_NB = lua_vector:new()
local vPos_newAmmo_SB = lua_vector:new()
vPos_newAmmo_NB.x = -2.594973
vPos_newAmmo_NB.y = 6.4042
vPos_newAmmo_NB.z = 64.76477
vPos_newAmmo_SB.x = -307.93048
vPos_newAmmo_SB.y = 6.955664
vPos_newAmmo_SB.z = 370.43546
local pvp_baseHealth_NB = {healthCrate_baseLeft_14, healthCrate_baseLeft_15}
local pvp_baseHealth_SB = {healthCrate_baseLeft_12, healthCrate_baseLeft_13}
local ammoPos_NB_2 = get_pos(ammoSpawner_NB_2)
ammoPos_NB_2.y = 6.224445
set_pos(ammoSpawner_NB_2, ammoPos_NB_2)
cluePur_inShield_NB_1 = clue_handle:new(65196, 54402, 16392, 42697)
cluePur_inShield_NB_2 = clue_handle:new(65196, 54402, 6324, 42704)
cluePur_inShield_SB_1 = clue_handle:new(64352, 54402, 61538, 5058)
cluePur_inShield_SB_2 = clue_handle:new(64353, 54402, 816, 5178)
inShield_NB_pad_1 = moby_handle:new(48372, 51979, 18029, 17047)
inShield_NB_pad_2 = moby_handle:new(48372, 51979, 64289, 17061)
inShield_SB_pad_1 = moby_handle:new(48372, 51979, 34137, 17030)
inShield_SB_pad_2 = moby_handle:new(48373, 51979, 57723, 17151)
barricadeFrame_NB_inner_1 = moby_handle:new(65197, 54402, 31646, 42803)
barricadeFrame_NB_inner_2 = moby_handle:new(65197, 54402, 20210, 42811)
barricadeFrame_SB_inner_1 = moby_handle:new(64530, 54402, 16366, 13020)
barricadeFrame_SB_inner_2 = moby_handle:new(64530, 54402, 47494, 13019)
local pvp_NB_innerShields = {
  barricadeFrame_NB_inner_1,
  barricadeFrame_NB_inner_2,
  inShield_NB_pad_1,
  inShield_NB_pad_2
}
local pvp_SB_innerShields = {
  barricadeFrame_SB_inner_1,
  barricadeFrame_SB_inner_2,
  inShield_SB_pad_1,
  inShield_SB_pad_2
}
local pvp_NB_innerShieldClues = {cluePur_inShield_NB_1, cluePur_inShield_NB_2}
local pvp_SB_innerShieldClues = {cluePur_inShield_SB_1, cluePur_inShield_SB_2}
heroTurret_NB_upgrade_1 = moby_handle:new(63286, 54402, 63727, 23051)
heroTurret_NB_upgrade_2 = moby_handle:new(63285, 54402, 13994, 23082)
heroTurret_NB_upgrade_3 = moby_handle:new(63286, 54402, 46943, 23045)
heroTurret_NB_upgrade_4 = moby_handle:new(63286, 54402, 4800, 23040)
heroTurret_NB_upgrade_5 = moby_handle:new(63290, 54402, 39144, 23241)
heroTurret_NB_upgrade_6 = moby_handle:new(63291, 54402, 52549, 23350)
heroTurret_NB_upgrade_7 = moby_handle:new(63288, 54402, 25276, 23227)
heroTurret_NB_upgrade_8 = moby_handle:new(63287, 54402, 36455, 23135)
heroTurret_NB_upgrade_9 = moby_handle:new(63289, 54402, 3726, 23276)
heroTurret_NB_upgrade_10 = moby_handle:new(63288, 54402, 23613, 23190)
heroTurret_NB_upgrade_11 = moby_handle:new(63287, 54402, 50832, 23112)
heroTurret_NB_upgrade_12 = moby_handle:new(63287, 54402, 36303, 23117)
heroTurret_NB_upgrade_13 = moby_handle:new(63285, 54402, 36621, 23067)
heroTurret_NB_upgrade_14 = moby_handle:new(63285, 54402, 50512, 23071)
heroTurret_NB_upgrade_15 = moby_handle:new(63288, 54402, 59697, 23204)
heroTurret_NB_upgrade_16 = moby_handle:new(63288, 54402, 37792, 23209)
heroTurret_NB_upgrade_17 = moby_handle:new(63289, 54402, 19586, 23175)
heroTurret_NB_upgrade_18 = moby_handle:new(63289, 54402, 26541, 23170)
heroTurret_NB_upgrade_19 = moby_handle:new(63287, 54402, 44024, 23114)
heroTurret_NB_upgrade_20 = moby_handle:new(63286, 54402, 43980, 23061)
heroTurret_NB_upgrade_21 = moby_handle:new(63287, 54402, 28517, 23118)
heroTurret_NB_upgrade_22 = moby_handle:new(63285, 54402, 58118, 23065)
heroTurret_NB_upgrade_23 = moby_handle:new(63288, 54402, 25972, 23201)
heroTurret_NB_upgrade_24 = moby_handle:new(63289, 54402, 59513, 23292)
heroTurret_NB_upgrade_25 = moby_handle:new(63289, 54402, 65349, 23169)
heroTurret_NB_upgrade_26 = moby_handle:new(63288, 54402, 4134, 23210)
heroTurret_SB_upgrade_1 = moby_handle:new(25142, 54457, 56941, 62780)
heroTurret_SB_upgrade_2 = moby_handle:new(25147, 54457, 21860, 62953)
heroTurret_SB_upgrade_3 = moby_handle:new(25128, 54457, 25589, 62127)
heroTurret_SB_upgrade_4 = moby_handle:new(25137, 54457, 37361, 62488)
heroTurret_SB_upgrade_5 = moby_handle:new(63082, 54402, 12871, 13968)
heroTurret_SB_upgrade_6 = moby_handle:new(63094, 54402, 30955, 14470)
heroTurret_SB_upgrade_7 = moby_handle:new(25176, 54457, 21797, 64232)
heroTurret_SB_upgrade_8 = moby_handle:new(25152, 54457, 648, 63124)
heroTurret_SB_upgrade_9 = moby_handle:new(25180, 54457, 11429, 64432)
heroTurret_SB_upgrade_10 = moby_handle:new(25186, 54457, 50600, 64668)
heroTurret_SB_upgrade_11 = moby_handle:new(62688, 54402, 59725, 61985)
heroTurret_SB_upgrade_12 = moby_handle:new(62688, 54402, 36290, 61988)
heroTurret_SB_upgrade_13 = moby_handle:new(62688, 54402, 61467, 61986)
heroTurret_SB_upgrade_14 = moby_handle:new(62688, 54402, 56400, 61983)
heroTurret_SB_upgrade_15 = moby_handle:new(25170, 54457, 27772, 63956)
heroTurret_SB_upgrade_16 = moby_handle:new(62689, 54402, 25627, 61964)
heroTurret_SB_upgrade_17 = moby_handle:new(62809, 54402, 62132, 1798)
heroTurret_SB_upgrade_18 = moby_handle:new(62809, 54402, 49234, 1796)
heroTurret_SB_upgrade_19 = moby_handle:new(62809, 54402, 58836, 1792)
heroTurret_SB_upgrade_20 = moby_handle:new(62810, 54402, 37567, 1794)
heroTurret_SB_upgrade_21 = moby_handle:new(62844, 54402, 41201, 3454)
heroTurret_SB_upgrade_22 = moby_handle:new(62844, 54402, 10466, 3454)
heroTurret_SB_upgrade_23 = moby_handle:new(62844, 54402, 14765, 3449)
heroTurret_SB_upgrade_24 = moby_handle:new(62844, 54402, 45288, 3449)
heroTurret_SB_upgrade_25 = moby_handle:new(62810, 54402, 656, 1905)
heroTurret_SB_upgrade_26 = moby_handle:new(62844, 54402, 33705, 3451)
cluePur_heroT_NB_upgrade_1 = clue_handle:new(63286, 54402, 57317, 23055)
cluePur_heroT_NB_upgrade_2 = clue_handle:new(63285, 54402, 12058, 23080)
cluePur_heroT_NB_upgrade_3 = clue_handle:new(63286, 54402, 28422, 23059)
cluePur_heroT_NB_upgrade_4 = clue_handle:new(63286, 54402, 39902, 23057)
cluePur_heroT_NB_upgrade_5 = clue_handle:new(63290, 54402, 56353, 23247)
cluePur_heroT_NB_upgrade_6 = clue_handle:new(63291, 54402, 7830, 23348)
cluePur_heroT_NB_upgrade_7 = clue_handle:new(63287, 54402, 25247, 23105)
cluePur_heroT_NB_upgrade_8 = clue_handle:new(63286, 54402, 23602, 23042)
cluePur_heroT_NB_upgrade_9 = clue_handle:new(63289, 54402, 56352, 23291)
cluePur_heroT_NB_upgrade_10 = clue_handle:new(63288, 54402, 64538, 23197)
cluePur_heroT_NB_upgrade_11 = clue_handle:new(63287, 54402, 39078, 23123)
cluePur_heroT_NB_upgrade_12 = clue_handle:new(63287, 54402, 59390, 23126)
cluePur_heroT_NB_upgrade_13 = clue_handle:new(63285, 54402, 61653, 23069)
cluePur_heroT_NB_upgrade_14 = clue_handle:new(63285, 54402, 46942, 23072)
cluePur_heroT_NB_upgrade_15 = clue_handle:new(63288, 54402, 49550, 23215)
cluePur_heroT_NB_upgrade_16 = clue_handle:new(63288, 54402, 2655, 23218)
cluePur_heroT_NB_upgrade_17 = clue_handle:new(63289, 54402, 49530, 23177)
cluePur_heroT_NB_upgrade_18 = clue_handle:new(63289, 54402, 47239, 23178)
cluePur_heroT_NB_upgrade_19 = clue_handle:new(63287, 54402, 53424, 23125)
cluePur_heroT_NB_upgrade_20 = clue_handle:new(63285, 54402, 19348, 23078)
cluePur_heroT_NB_upgrade_21 = clue_handle:new(63287, 54402, 5432, 23120)
cluePur_heroT_NB_upgrade_22 = clue_handle:new(63285, 54402, 4868, 23074)
cluePur_heroT_NB_upgrade_23 = clue_handle:new(63288, 54402, 29244, 23217)
cluePur_heroT_NB_upgrade_24 = clue_handle:new(63289, 54402, 5304, 23180)
cluePur_heroT_NB_upgrade_25 = clue_handle:new(63289, 54402, 5503, 23179)
cluePur_heroT_NB_upgrade_26 = clue_handle:new(63288, 54402, 43827, 23213)
cluePur_heroT_SB_upgrade_1 = clue_handle:new(15777, 54457, 28694, 38284)
cluePur_heroT_SB_upgrade_2 = clue_handle:new(15777, 54457, 31764, 38290)
cluePur_heroT_SB_upgrade_3 = clue_handle:new(15777, 54457, 42786, 38287)
cluePur_heroT_SB_upgrade_4 = clue_handle:new(15777, 54457, 3867, 38281)
cluePur_heroT_SB_upgrade_5 = clue_handle:new(63082, 54402, 13802, 13974)
cluePur_heroT_SB_upgrade_6 = clue_handle:new(63094, 54402, 10667, 14469)
cluePur_heroT_SB_upgrade_7 = clue_handle:new(15777, 54457, 13670, 38284)
cluePur_heroT_SB_upgrade_8 = clue_handle:new(15777, 54457, 1362, 38285)
cluePur_heroT_SB_upgrade_9 = clue_handle:new(15777, 54457, 63365, 38281)
cluePur_heroT_SB_upgrade_10 = clue_handle:new(15777, 54457, 30856, 38285)
cluePur_heroT_SB_upgrade_11 = clue_handle:new(62688, 54402, 39488, 61992)
cluePur_heroT_SB_upgrade_12 = clue_handle:new(62688, 54402, 53987, 61993)
cluePur_heroT_SB_upgrade_13 = clue_handle:new(62688, 54402, 20255, 61994)
cluePur_heroT_SB_upgrade_14 = clue_handle:new(62688, 54402, 48404, 61996)
cluePur_heroT_SB_upgrade_15 = clue_handle:new(15777, 54457, 60657, 38292)
cluePur_heroT_SB_upgrade_16 = clue_handle:new(62688, 54402, 46766, 61979)
cluePur_heroT_SB_upgrade_17 = clue_handle:new(62809, 54402, 1936, 1803)
cluePur_heroT_SB_upgrade_18 = clue_handle:new(62809, 54402, 42047, 1801)
cluePur_heroT_SB_upgrade_19 = clue_handle:new(62809, 54402, 63990, 1802)
cluePur_heroT_SB_upgrade_20 = clue_handle:new(62809, 54402, 23119, 1807)
cluePur_heroT_SB_upgrade_21 = clue_handle:new(62844, 54402, 21469, 3454)
cluePur_heroT_SB_upgrade_22 = clue_handle:new(62844, 54402, 21775, 3454)
cluePur_heroT_SB_upgrade_23 = clue_handle:new(62844, 54402, 20877, 3454)
cluePur_heroT_SB_upgrade_24 = clue_handle:new(62844, 54402, 43682, 3455)
cluePur_heroT_SB_upgrade_25 = clue_handle:new(62810, 54402, 10546, 1918)
cluePur_heroT_SB_upgrade_26 = clue_handle:new(62844, 54402, 13615, 3448)
local pvp_upgrade_NB_turretPads = {
  heroTurret_NB_upgrade_1,
  heroTurret_NB_upgrade_2,
  heroTurret_NB_upgrade_3,
  heroTurret_NB_upgrade_4,
  heroTurret_NB_upgrade_7,
  heroTurret_NB_upgrade_8,
  heroTurret_NB_upgrade_9,
  heroTurret_NB_upgrade_10,
  heroTurret_NB_upgrade_11,
  heroTurret_NB_upgrade_12,
  heroTurret_NB_upgrade_13,
  heroTurret_NB_upgrade_14,
  heroTurret_NB_upgrade_15,
  heroTurret_NB_upgrade_16,
  heroTurret_NB_upgrade_17,
  heroTurret_NB_upgrade_18,
  heroTurret_NB_upgrade_19,
  heroTurret_NB_upgrade_20,
  heroTurret_NB_upgrade_21,
  heroTurret_NB_upgrade_22,
  heroTurret_NB_upgrade_23,
  heroTurret_NB_upgrade_24,
  heroTurret_NB_upgrade_25,
  heroTurret_NB_upgrade_26
}
local pvp_upgrade_NB_turretClues = {
  cluePur_heroT_NB_upgrade_1,
  cluePur_heroT_NB_upgrade_2,
  cluePur_heroT_NB_upgrade_3,
  cluePur_heroT_NB_upgrade_4,
  cluePur_heroT_NB_upgrade_7,
  cluePur_heroT_NB_upgrade_8,
  cluePur_heroT_NB_upgrade_9,
  cluePur_heroT_NB_upgrade_10,
  cluePur_heroT_NB_upgrade_11,
  cluePur_heroT_NB_upgrade_12,
  cluePur_heroT_NB_upgrade_13,
  cluePur_heroT_NB_upgrade_14,
  cluePur_heroT_NB_upgrade_15,
  cluePur_heroT_NB_upgrade_16,
  cluePur_heroT_NB_upgrade_17,
  cluePur_heroT_NB_upgrade_18,
  cluePur_heroT_NB_upgrade_19,
  cluePur_heroT_NB_upgrade_20,
  cluePur_heroT_NB_upgrade_21,
  cluePur_heroT_NB_upgrade_22,
  cluePur_heroT_NB_upgrade_23,
  cluePur_heroT_NB_upgrade_24,
  cluePur_heroT_NB_upgrade_25,
  cluePur_heroT_NB_upgrade_26
}
local pvp_upgrade_SB_turretPads = {
  heroTurret_SB_upgrade_1,
  heroTurret_SB_upgrade_2,
  heroTurret_SB_upgrade_3,
  heroTurret_SB_upgrade_4,
  heroTurret_SB_upgrade_7,
  heroTurret_SB_upgrade_8,
  heroTurret_SB_upgrade_9,
  heroTurret_SB_upgrade_10,
  heroTurret_SB_upgrade_11,
  heroTurret_SB_upgrade_12,
  heroTurret_SB_upgrade_13,
  heroTurret_SB_upgrade_14,
  heroTurret_SB_upgrade_15,
  heroTurret_SB_upgrade_16,
  heroTurret_SB_upgrade_17,
  heroTurret_SB_upgrade_18,
  heroTurret_SB_upgrade_19,
  heroTurret_SB_upgrade_20,
  heroTurret_SB_upgrade_21,
  heroTurret_SB_upgrade_22,
  heroTurret_SB_upgrade_23,
  heroTurret_SB_upgrade_24,
  heroTurret_SB_upgrade_25,
  heroTurret_SB_upgrade_26
}
local pvp_upgrade_SB_turretClues = {
  cluePur_heroT_SB_upgrade_1,
  cluePur_heroT_SB_upgrade_2,
  cluePur_heroT_SB_upgrade_3,
  cluePur_heroT_SB_upgrade_4,
  cluePur_heroT_SB_upgrade_7,
  cluePur_heroT_SB_upgrade_8,
  cluePur_heroT_SB_upgrade_9,
  cluePur_heroT_SB_upgrade_10,
  cluePur_heroT_SB_upgrade_11,
  cluePur_heroT_SB_upgrade_12,
  cluePur_heroT_SB_upgrade_13,
  cluePur_heroT_SB_upgrade_14,
  cluePur_heroT_SB_upgrade_15,
  cluePur_heroT_SB_upgrade_16,
  cluePur_heroT_SB_upgrade_17,
  cluePur_heroT_SB_upgrade_18,
  cluePur_heroT_SB_upgrade_19,
  cluePur_heroT_SB_upgrade_20,
  cluePur_heroT_SB_upgrade_21,
  cluePur_heroT_SB_upgrade_22,
  cluePur_heroT_SB_upgrade_23,
  cluePur_heroT_SB_upgrade_24,
  cluePur_heroT_SB_upgrade_25,
  cluePur_heroT_SB_upgrade_26
}
local pvp_upgrade_NB_freeTurrets = {heroTurret_NB_upgrade_20, heroTurret_NB_upgrade_24}
local pvp_upgrade_NB_freeTurret_clues = {cluePur_heroT_NB_upgrade_20, cluePur_heroT_NB_upgrade_24}
local pvp_upgrade_SB_freeTurrets = {heroTurret_SB_upgrade_10, heroTurret_SB_upgrade_24}
local pvp_upgrade_SB_freeTurret_clues = {cluePur_heroT_SB_upgrade_10, cluePur_heroT_SB_upgrade_24}
local pvp_upgrade_NB_freeWarmongers = {heroTurret_NB_upgrade_5, heroTurret_NB_upgrade_6}
local pvp_upgrade_NB_freeWarmonger_clues = {cluePur_heroT_NB_upgrade_5, cluePur_heroT_NB_upgrade_6}
local pvp_upgrade_SB_freeWarmongers = {heroTurret_SB_upgrade_5, heroTurret_SB_upgrade_6}
local pvp_upgrade_SB_freeWarmonger_clues = {cluePur_heroT_SB_upgrade_5, cluePur_heroT_SB_upgrade_6}
blue_perk_station_1 = moby_handle:new(27573, 52091, 15779, 58800)
blue_perk_station_2 = moby_handle:new(59947, 52092, 30068, 23491)
blue_perk_station_3 = moby_handle:new(59986, 52092, 24097, 25339)
red_perk_station_1 = moby_handle:new(28423, 52091, 18383, 31042)
red_perk_station_2 = moby_handle:new(60062, 52092, 61505, 28612)
red_perk_station_3 = moby_handle:new(60090, 52092, 15080, 29915)
local pvp_perkKiosks_table = {
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
    kioskTeam = HERO.HERO_TEAM_1
  },
  {
    kioskMoby = blue_perk_station_3,
    kioskType = PERK_KIOSK_SQUAD,
    kioskTeam = HERO.HERO_TEAM_1
  },
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
    kioskTeam = HERO.HERO_TEAM_2
  },
  {
    kioskMoby = red_perk_station_3,
    kioskType = PERK_KIOSK_SQUAD,
    kioskTeam = HERO.HERO_TEAM_2
  }
}
bangle_off(squadPads_right, 0, true)
bangle_on(squadPads_right, 1, true)
local nodeData = {}
nodeData[5] = {
  node = nodePVP_1,
  dirClue = enemy_setup_node_7,
  waveScent = scent_playerNodeGuard_node7,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_7,
  barrierClue = cluePurchase_barrier_node_7,
  defensesPod = node_defenses_node_7,
  FXNeutral = FxController_major_node_neutral_1,
  FXRed = FxController_major_node_red_team_1,
  FXBlue = FxController_major_node_blue_team_1
}
nodeData[6] = {
  node = nodePVP_2,
  dirClue = enemy_setup_node_2,
  waveScent = scent_playerNodeGuard_node2,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_2,
  barrierClue = cluePurchase_barrier_node_2,
  defensesPod = node_defenses_node_2,
  FXNeutral = FxController_major_node_neutral_2,
  FXRed = FxController_major_node_red_team_2,
  FXBlue = FxController_major_node_blue_team_2
}
nodeData[7] = {
  node = nodePVP_3,
  dirClue = enemy_setup_node_3,
  waveScent = scent_playerNodeGuard_node3,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_3,
  barrierClue = cluePurchase_barrier_node_3,
  defensesPod = node_defenses_node_3,
  FXNeutral = FxController_major_node_neutral_3,
  FXRed = FxController_major_node_red_team_3,
  FXBlue = FxController_major_node_blue_team_3
}
nodeData[2] = {
  node = nodePVP_4,
  dirClue = enemy_setup_node_5,
  waveScent = scent_playerNodeGuard_node5,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_5,
  barrierClue = cluePurchase_barrier_node_5,
  defensesPod = node_defenses_node_5,
  FXNeutral = FxController_major_node_neutral_4,
  FXRed = FxController_major_node_red_team_4,
  FXBlue = FxController_major_node_blue_team_4
}
nodeData[3] = {
  node = nodePVP_5,
  dirClue = enemy_setup_node_8,
  waveScent = scent_playerNodeGuard_node8,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_8,
  barrierClue = cluePurchase_barrier_node_8,
  defensesPod = node_defenses_node_8,
  FXNeutral = FxController_major_node_neutral_5,
  FXRed = FxController_major_node_red_team_5,
  FXBlue = FxController_major_node_blue_team_5
}
nodeData[4] = {
  node = nodePVP_6,
  dirClue = enemy_setup_node_6,
  waveScent = scent_playerNodeGuard_node6,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_6,
  barrierClue = cluePurchase_barrier_node_6,
  defensesPod = node_defenses_node_6,
  FXNeutral = FxController_major_node_neutral_6,
  FXRed = FxController_major_node_red_team_6,
  FXBlue = FxController_major_node_blue_team_6
}
nodeData[1] = {
  node = nodePVP_7,
  dirClue = enemy_setup_node_4,
  waveScent = scent_playerNodeGuard_node4,
  guardWaveNum = 2,
  barrierGen = genBarrier_node_4,
  barrierClue = cluePurchase_barrier_node_4,
  defensesPod = node_defenses_node_4,
  FXNeutral = FxController_major_node_neutral_7,
  FXRed = FxController_major_node_red_team_7,
  FXBlue = FxController_major_node_blue_team_7
}
SetupCompNodes(nodeData)
local nodeFxCont = {
  FxController_major_node_neutral_1,
  FxController_major_node_neutral_2,
  FxController_major_node_neutral_3,
  FxController_major_node_neutral_4,
  FxController_major_node_neutral_5,
  FxController_major_node_neutral_6,
  FxController_major_node_neutral_7,
  FxController_major_node_red_team_1,
  FxController_major_node_red_team_2,
  FxController_major_node_red_team_3,
  FxController_major_node_red_team_4,
  FxController_major_node_red_team_5,
  FxController_major_node_red_team_6,
  FxController_major_node_red_team_7,
  FxController_major_node_blue_team_1,
  FxController_major_node_blue_team_2,
  FxController_major_node_blue_team_3,
  FxController_major_node_blue_team_4,
  FxController_major_node_blue_team_5,
  FxController_major_node_blue_team_6,
  FxController_major_node_blue_team_7
}
function ChangeNodeFXContUpdateRange()
  local i
  for i = 1, #nodeFxCont do
    set_fx_update_range(nodeFxCont[i], 10000)
  end
end
ChangeNodeFXContUpdateRange()
node_1_enemy_57 = clue_handle:new(44540, 54463, 24047, 45660)
node_1_enemy_56 = clue_handle:new(44529, 54463, 19266, 45233)
function PatchFix_Node3_BrawlerAwareness()
  on_ai_spawned(node_1_enemy_57, function()
    local brawler = get_moby_handle_from_setup(node_1_enemy_57)
    if is_valid(brawler) and is_alive(brawler) then
      enemy_set_inner_awareness(brawler, 45)
      enemy_set_outer_awareness(brawler, 55)
    end
  end)
  on_ai_spawned(node_1_enemy_56, function()
    local brawler = get_moby_handle_from_setup(node_1_enemy_56)
    if is_valid(brawler) and is_alive(brawler) then
      enemy_set_inner_awareness(brawler, 45)
      enemy_set_outer_awareness(brawler, 55)
    end
  end)
end
PatchFix_Node3_BrawlerAwareness()
redVol_lane1_warp = spawn_vol_cuboid(-312, 20, 298.12, 180, 0, 180, 20, 20, 30)
redVol_lane2_warp = spawn_vol_cuboid(-233.24, 20, 374, 0, 90, 0, 20, 20, 30)
redVol_base_warp = spawn_vol_cuboid(-323, 20, 388, 0, 45, 0, 80, 30, 80)
area_pvpwrongbasewarp_red = spawn_area(3, 0)
add_vol_to_area(area_pvpwrongbasewarp_red, 0, redVol_lane1_warp)
add_vol_to_area(area_pvpwrongbasewarp_red, 1, redVol_lane2_warp)
add_vol_to_area(area_pvpwrongbasewarp_red, 2, redVol_base_warp)
blueVol_lane1_warp = spawn_vol_cuboid(-74.75, 20, 61.64, 0, -90, 0, 20, 20, 30)
blueVol_lane2_warp = spawn_vol_cuboid(-1.88, 20, 139.75, 0, 0, 0, 20, 20, 30)
blueVol_base_warp = spawn_vol_cuboid(12, 20, 51, 0, 45, 0, 80, 30, 70)
area_pvpwrongbasewarp_blue = spawn_area(3, 0)
add_vol_to_area(area_pvpwrongbasewarp_blue, 0, blueVol_lane1_warp)
add_vol_to_area(area_pvpwrongbasewarp_blue, 1, blueVol_lane2_warp)
add_vol_to_area(area_pvpwrongbasewarp_blue, 2, blueVol_base_warp)
global_pvp_baseWarpArea_blue = area_pvpwrongbasewarp_blue
global_pvp_baseWarpArea_red = area_pvpwrongbasewarp_red
local NBTeamWarps = {hero_warp_P1_1, hero_warp_P1_2,hero_warp_P1_1, hero_warp_P1_2}
local SBTeamWarps = {hero_warp_P2_1, hero_warp_P2_2, hero_warp_P2_2, hero_warp_P2_2}
local NBPurchasePads_Left = {
  squadPad_nb_left_1,
  squadPad_nb_left_2,
  squadPad_nb_left_3,
  squadPad_nb_left_4
}
local NBPurchasePads_Right = {
  squadPad_nb_right_1,
  squadPad_nb_right_2,
  squadPad_nb_right_3,
  squadPad_nb_right_4
}
local SBPurchasePads_Left = {
  squadPad_sb_left_1,
  squadPad_sb_left_2,
  squadPad_sb_left_3,
  squadPad_sb_left_4
}
local SBPurchasePads_Right = {
  squadPad_sb_right_1,
  squadPad_sb_right_2,
  squadPad_sb_right_3,
  squadPad_sb_right_4
}
local NBGenArray = {
  baseGen_nb_left_3,
  baseGen_nb_left_2,
  baseGen_nb_left_1,
  baseGen_nb_right_1,
  baseGen_nb_right_2,
  baseGen_nb_right_3
}
local SBGenArray = {
  baseGen_sb_left_3,
  baseGen_sb_left_2,
  baseGen_sb_left_1,
  baseGen_sb_right_1,
  baseGen_sb_right_2,
  baseGen_sb_right_3
}
local function cp_fixup_default()
  ResetWeapons(true)
  radar_enable()
  SetupCompetitive(NBTeamWarps, SBTeamWarps, P1_generators, P2_generators, P1_turrets, P2_turrets, P1_base_forcefields_pod, P2_base_forcefields_pod, enemyBaseDisplay_nb, enemyBaseDisplay_sb, p1_purchase_console, p2_purchase_console, cluePurchase_waves_nb, cluePurchase_waves_sb, {
    {NBPurchasePads_Left, NBPurchasePads_Right},
    {SBPurchasePads_Left, SBPurchasePads_Right}
  }, {NBGenArray, SBGenArray}, area_detectHeroesAtNorthBase, area_detectHeroesAtSouthBase, p1_health, p2_health, NB_generators, SB_generators, slamButton_genHide_nb, slamButton_genHide_sb, pvp_perkKiosks_table, pvp_tankClues)
  show_all_info_pads = false
  hide(arrows)
  hide(tut_poi_enemy_base)
  hide(tut_poi_node)
  hide(tut_poi_squad)
end
local function cp_fixup_tutorial()
  global_pvp_introcam = nil
  request_music_track("mus_recon")
  reveal(pod_allTutorialObjs)
  run_script("tutorial")
  ResetWeapons(true)
  radar_enable()
  local i
  for i = 1, #nodeData do
    nodeData[i].guardWaveNum = 3
  end
  SetupCompetitive(NBTeamWarps, SBTeamWarps, P1_generators, P2_generators, P1_turrets, P2_turrets, P1_base_forcefields_pod, P2_base_forcefields_pod, enemyBaseDisplay_nb, enemyBaseDisplay_sb, p1_purchase_console, p2_purchase_console, cluePurchase_waves_nb, cluePurchase_waves_sb, {
    {NBPurchasePads_Left, NBPurchasePads_Right},
    {SBPurchasePads_Left, SBPurchasePads_Right}
  }, {NBGenArray, SBGenArray}, area_detectHeroesAtNorthBase, area_detectHeroesAtSouthBase, p1_health, p2_health, NB_generators, SB_generators, slamButton_genHide_nb, slamButton_genHide_sb, pvp_perkKiosks_table, pvp_tankClues)
  show_all_info_pads = true
end
register_checkpoint_fixup("cp_default", cp_fixup_default)
register_checkpoint_fixup("cp_tutorial", cp_fixup_tutorial)
