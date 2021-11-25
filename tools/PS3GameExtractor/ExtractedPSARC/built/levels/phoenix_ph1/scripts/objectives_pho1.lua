function ShowMission_PHO_1()
  set_major_objective("PHO_OBJ_CLEANERBOTS", false)
end
function CompleteMission_PHO_CleanerBots()
  complete_major_objective(false)
end
function ShowMission_PHO_AnswerComm()
  set_major_objective("PHO_OBJ_ANSWERCOMM", false)
end
function CompleteMissionGoToNext_PHO_1()
  complete_major_objective(false)
  set_major_objective("PHO_OBJ_ANSWERCOMM", false)
end
function CompleteMissionGoToBridge_PHO_1()
  complete_major_objective(false)
end
