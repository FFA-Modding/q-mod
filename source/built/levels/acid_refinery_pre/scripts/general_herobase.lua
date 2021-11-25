prt("----> LOADED general_herobase SCRIPT")
global_heroGen_pod = pod_basegenerators
global_baseArea = area_heroBase_forMap
moby_set_health(baseGen_center_fake, 1)
hero_generators = {
  baseGen_left_3,
  baseGen_left_2,
  baseGen_left_1,
  baseGen_right_1,
  baseGen_right_2,
  baseGen_right_3
}
hero_turrets = {}
local turretMobyArray = {
  sentry_2,
  sentry_5,
  sentry_6,
  sentry_7,
  sentry_8,
  sentry_9,
  sentry_10,
  sentry_13,
  sentry_14,
  sentry_15,
  sentry_18,
  sentry_21,
  sentry_22,
  sentry_23,
  sentry_24,
  sentry_25,
  sentry_26,
  sentry_27,
  sentry_28,
  sentry_29,
  sentry_30,
  sentry_31,
  sentry_33,
  sentry_35,
  sentry_36,
  sentry_37,
  sentry_38,
  sentry_40,
  sentry_42,
  sentry_43,
  sentry_45,
  baseMine_1,
  baseMine_2,
  baseMine_3,
  baseMine_4,
  baseMine_5,
  baseMine_6,
  baseMine_7,
  baseMine_8,
  baseMine_9,
  baseMine_10,
  baseMine_11,
  baseMine_12,
  baseMine_13,
  baseMine_14,
  baseMine_15,
  baseMine_16
}
local turretPurClueArray = {
  CluePurchase_turret_2,
  CluePurchase_turret_5,
  CluePurchase_turret_6,
  CluePurchase_turret_7,
  CluePurchase_turret_8,
  CluePurchase_turret_9,
  CluePurchase_turret_10,
  CluePurchase_turret_13,
  CluePurchase_turret_14,
  CluePurchase_turret_15,
  CluePurchase_turret_18,
  CluePurchase_turret_21,
  CluePurchase_turret_22,
  CluePurchase_turret_23,
  CluePurchase_turret_24,
  CluePurchase_turret_25,
  CluePurchase_turret_26,
  CluePurchase_turret_27,
  CluePurchase_turret_28,
  CluePurchase_turret_29,
  CluePurchase_turret_30,
  CluePurchase_turret_31,
  CluePurchase_turret_33,
  CluePurchase_turret_35,
  CluePurchase_turret_36,
  CluePurchase_turret_37,
  CluePurchase_turret_38,
  CluePurchase_turret_40,
  CluePurchase_turret_42,
  CluePurchase_turret_43,
  CluePurchase_turret_45,
  CluePur_mine_1,
  CluePur_mine_2,
  CluePur_mine_3,
  CluePur_mine_4,
  CluePur_mine_5,
  CluePur_mine_6,
  CluePur_mine_7,
  CluePur_mine_8,
  CluePur_mine_9,
  CluePur_mine_10,
  CluePur_mine_11,
  CluePur_mine_12,
  CluePur_mine_13,
  CluePur_mine_14,
  CluePur_mine_15,
  CluePur_mine_16
}
local function InitHeroTurrets_Table()
  local i, turretID
  for i = 1, #turretMobyArray do
    turretID = "turret" .. tostring(i)
    hero_turrets[turretID] = {}
    hero_turrets[turretID].id = i
    hero_turrets[turretID].turretMoby = turretMobyArray[i]
    hero_turrets[turretID].purchaseClue = turretPurClueArray[i]
    hero_turrets[turretID].purchaseListener = event_handle:new()
    hero_turrets[turretID].curLevel = 0
    if i > numHeroTurrets then
      hero_turrets[turretID].defenseType = "mine"
    end
  end
end
InitHeroTurrets_Table()
on_elapsed(0.25, InitHeroBase)
