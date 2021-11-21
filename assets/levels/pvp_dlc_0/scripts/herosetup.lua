-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --
-- //					    	             PHPVP: HEROSETUP                      	\\ --
-- //                                                                   \\ --
-- ////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ --


  -- ################################################################### --
	-- #######                        WEAPONS                      ####### --
	-- ################################################################### --
	
-- ----------------------------- EquipAllHeroes ------------------------ --
local function EquipAllHeroes(wpn)

  local i; 
  local hero;
  for i = 0, 3, 1 do 
    hero = get_hero_at_player_id(i)
    hero_equip(hero, wpn)
  end
  
end -- end EquipAllHeroes
	
hero_give_weapon(WPN_COMBUSTER, 3)
EquipAllHeroes(WPN_COMBUSTER)

	-- #################################################################### --
	-- #######                        GADGETS                       ####### --
	-- #################################################################### --

hero_give_weapon(WPN_SWINGSHOT)
