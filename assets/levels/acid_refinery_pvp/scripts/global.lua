-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --
-- //						             PATCH AR PVP:  GLOBAL                      \\ --
-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

prt("----> LOADED global SCRIPT")

run_script("vo_global")
run_script("invasion_database")
run_script("herosetup")
run_script("zone_whitebox_gameplay")
run_script("music")

---------------------
-- Weapon Pool 
---------------------

set_unlockable_weapon_priority(WPN_DECOY, 1)
set_unlockable_weapon_priority(WPN_ICE_BEAM, 1)
set_unlockable_weapon_priority(WPN_FLAMETHROWER, 1)
set_unlockable_weapon_priority(WPN_THUNDERSTRIKE, 1)
set_unlockable_weapon_priority(WPN_ZURKON, 1)
set_unlockable_weapon_priority(WPN_SUBWOOFER, 1)
set_unlockable_weapon_priority(WPN_TIMEFIELD, 1) -- Set the Time-bomb to unlocked.
--set_unlockable_weapon_priority(WPN_BUZZ_BLADES, 1)
--set_unlockable_weapon_priority(WPN_GROOVITRON, 1)
--set_unlockable_weapon_priority(WPN_CRITTER_STRIKE, 1)

set_defense_available(WPN_PLASMA_BARRICADE, get_defense_allowed(WPN_PLASMA_BARRICADE))

---------------------
-- Invisible collision (patch)
---------------------

-- Lua Exposure
moby_invisible_collision_wall_00 = moby_handle:new( 35339, 65140, 24076, 30962 ); -- 0x78F25E0CFE748A0B
moby_invisible_collision_wall_01 = moby_handle:new( 35339, 65140, 26380, 30963 ); -- 0x78F3670CFE748A0B
moby_invisible_collision_wall_02 = moby_handle:new( 35339, 65140, 49072, 30963 ); -- 0x78F3BFB0FE748A0B
moby_invisible_collision_wall_03 = moby_handle:new( 35339, 65140, 43801, 30963 ); -- 0x78F3AB19FE748A0B

global_pvp_addlShieldInvisiColl = {{moby_invisible_collision_wall_00, moby_invisible_collision_wall_01},
                                   {moby_invisible_collision_wall_02, moby_invisible_collision_wall_03}}
-- blue base add'l shield blockage
collision_hack(2, 1.2, 1, 0, -90, 0, -107.1, 18.8, 61.4, moby_invisible_collision_wall_00)
collision_hack(2, 1.2, 1, 0, 0, 0, 0, 18.8, 173.0, moby_invisible_collision_wall_01)
-- ditto for the red base 
collision_hack(2, 1.2, 1, 0, 90, 0, -201.5, 18.8, 374, moby_invisible_collision_wall_02)
collision_hack(2, 1.2, 1, 0, 180, 0, -312.7, 18, 265.7, moby_invisible_collision_wall_03)

moby_invisible_collision_wall_04 = moby_handle:new( 35339, 65140, 54903, 30963 ); -- 0x78F3D677FE748A0B
collision_hack(1, 1, 1, 0, 90, 0, -222, 25, 213, moby_invisible_collision_wall_04)

-- bridges
collision_hack(11, 7, 11, 0, 0, 0, -300, 7, -38)
collision_hack(11, 7, 11, 0, 0, 0, -270, 7, -38)
--collision_hack(11, 7, 11, 0, 55, 0, -387.5, 7, 7)
--collision_hack(11, 7, 11, 0, 33, 0, -350, 7, -28)
collision_hack(11, 7, 11, 0, -7, 0, -402.5, 6, 59.3)
collision_hack(11, 7, 11, 0, -7, 0, -406.2, 6, 89.16)

-- silos
collision_hack(12, 15, 2, 0, 40, 0, -312, -2, -16)
collision_hack(12, 15, 2, 0, 85, 0, -317, -2, -5.7)
collision_hack(12, 15, 2, 0, -5, 0, -302, -2, -20)
collision_hack(12, 15, 2, 0, -50, 0, -292, -2, -14)
collision_hack(12, 15, 2, 0, 40, 0, -376, -2, 45.5)
collision_hack(12, 15, 2, 0, 85, 0, -381, -2, 55.6)
collision_hack(12, 15, 2, 0, -5, 0, -366, -2, 41.5)
collision_hack(12, 15, 2, 0, -50, 0, -378, -2, 66)

-- technically this isn't a collision hack, but we're repositioning a moby
gp_ar_plant_tree_1_breakable83 = moby_handle:new( 49719, 57806, 58967, 9221 ); -- 0x2405E657E1CEC237
collision_hack(0.75, 0.75, 0.75, -156, -40, 180, -202, 7, 101, gp_ar_plant_tree_1_breakable83)

-- block hovering into node 5
collision_hack(15, 10, 1, 0, -75, 0, 29, 24, 273)

-- stuck between rocks
collision_hack(3, 3, 3, 0, 0, 0, -251, 4, 151)

-- block blue right archway
collision_hack(3, 20, 40, 0, -15, 0, -95, 30, 60)

-- block red right archway
collision_hack(4, 20, 4, 0, 10, 0, -202.5, 7, 363)

-- block some pipes 
collision_hack(7, 20, 7, 0, 0, 0, -226.5, 35, 242)
collision_hack(7, 20, 7, 0, 0, 0, -343, 21, 259)
