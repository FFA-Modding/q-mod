-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --
-- //						         DLC #0 - MOLONOTH:  GLOBAL                     \\ --
-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --

prt("----> LOADED molonoth global SCRIPT")

run_script("vo_pvp")
run_script("invasion_database")
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
