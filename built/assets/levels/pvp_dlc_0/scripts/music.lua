-- ==================================
--  T R A C K   A S S I G N M E N T
-- ==================================

TrackA = SoundSpecs.mus_QF_acidRefinery_pre_main_lp
TrackB = SoundSpecs.mus_QF_acidRefinery_pre_defendBase_lp
TrackC = SoundSpecs.mus_QF_acidRefinery_pre_enemy_lp
TrackS1 = SoundSpecs.mus_QF_PVP_global_captureNode_stg
TrackS2 = SoundSpecs.mus_QF_PVP_global_stageOver_stg
TrackS3 = SoundSpecs.mus_QF_PVP_global_winMatch_stg
TrackS4 = SoundSpecs.mus_QF_PVP_global_incomingThreat_stg
TrackS5 = SoundSpecs.mus_QF_global_acquireItem_stg
TrackS6 = SoundSpecs.mus_QF_PVP_global_playerDead_stg
TrackS17 = SoundSpecs.mus_QF_global_upgradeBase_stg	
TrackNone = SoundSpecs.mus_nullSpec



-- ==================================
--  C H E C K P O I N T    M U S I C
-- ==================================


--this enables the music script to update while in cinematic mode.
set_cinematic_update_mode( true )

-------These volumes no longer exist and are causing script errors, so I commented them out (--Brandi)
----------Base Music
---			on_all_hero_enter (mus_vol_base,
---		function ()
---			request_music_track ("mus_base")
---			prt("Base music request made")
---		end) 


while true do
	-- ================================================================================
	-- Do checks for making track change requests here
	-- ================================================================================

  -- If checks are done in scripts other than music.lua, please list the name of the 
  -- check and name of the script that the check is done in as a comment.

	   	 ---Jungle Ruins Recon Stage
	   if MusicCheck_recon then
	       request_music_track ("mus_recon")
	       MusicCheck_recon = false
	       prt("Request recon music")
	   end	 

	   ------ Jungle Ruins Build Stage
	   if MusicCheck_build then
	       request_music_track ("mus_build")
	       MusicCheck_build = false
	       prt("JCM - request build music")
	   end

	   	------ Jungle Ruins Assault Stage
	   if MusicCheck_assault then
	       request_music_track ("mus_assault")
	       MusicCheck_assault = false
	       prt("JCM - request assault music")
	   end

 	   		------ Capture Node Stinger
	   if MusicCheck_captureNode then
	       request_music_track ("mus_captureNode", false)
	       MusicCheck_captureNode = false
	       prt("JCM - Request capture node stinger")       
	   end

	    	------ Recon Phase Over Stinger
	   if MusicCheck_reconOver then
	       request_music_track ("mus_reconOver", false)
	       MusicCheck_reconOver = false
	       prt("JCM - Request recon over stinger")
	   end

	   	  	------ Build Stage Over Stinger
	   if MusicCheck_buildOver then
	       request_music_track ("mus_buildOver", false)
	       MusicCheck_buildOver = false
	       prt("JCM - Request build stage over stinger")
	   end

	    	------ Assault Stage Over Stinger
	   if MusicCheck_assaultOver then
	       request_music_track ("mus_assaultOver", false)
	       MusicCheck_assaultOver = false
	       prt("JCM - Request assault stage over stinger")
	   end

	   	  	------ Win Match Stinger
	   if MusicCheck_winMatch then
	       request_music_track ("mus_winMatch", false)
	       MusicCheck_winMatch = false
	       prt("JCM - Request win match stinger")
	   end

     	  	------ Player Dead Stinger
	   if MusicCheck_playerDead then
	       request_music_track ("mus_playerDead", false)
	       MusicCheck_playerDead = false
	       prt("JCM - Request player dead stinger")
	   end

	  	  	------ Threat Detected Stinger
	   if MusicCheck_threatDetected then
	       request_music_track ("mus_threatDetected", false)
	       MusicCheck_threatDetected = false
	       prt("JCM - Request threat detected stinger")
	   end

	   ---Weapon Upgrade
	   if MusicCheck_upgrade then
	       request_music_track ("mus_upgrade", false)
	       MusicCheck_upgrade = false
	       prt("Request weapon upgrade stinger")
	   end
				
		------ Stop Music on Channel 0
	   if MusicCheck_stopMusic0 then
	       request_music_track ("mus_stopMusic0")
		   MusicCheck_stopMusic0 = false
	       prt("JCM - Stop music on channel 0")
	   end

	   	------ Stop Music on Channel 1
	   if MusicCheck_stopMusic1 then
	       request_music_track ("mus_stopMusic1")
		   MusicCheck_stopMusic1 = false
	       prt("JCM - Stop music on channel 1")
	   end
	   	   	   
	   ------ Stop all music
	   if MusicCheck_StopMusic then
	       request_music_track ("NoMusic")
	       MusicCheck_StopMusic = false
	       prt("PSM - Kill all music request made.")
	   end

	-- ================================================================================
	-- Check to see if a new music track has been requested
	-- ================================================================================


	if (get_music_track_request()) then
	    
		prt( "Music request = " .. MUSIC_TRACK_REQUEST )

		SAVE.auto_play_music = MUSIC_TRACK_REQUEST		

	-- ================================================================================
	-- Do checks for which track to play here
	-- ================================================================================
		 
		--Recon Stage
		 if (MUSIC_TRACK_REQUEST == "mus_recon") then
		     play_music( TrackA, 0, true, 2, 2, 0 )
	    	 prt("Play recon music")
		 end

		-- Build Stage
		 if (MUSIC_TRACK_REQUEST == "mus_build") then
		     play_music( TrackB, 0, true, 1, 3, 0 )
	    	 prt("Play build music")
		 end

		 ---Assault Phase
		 if (MUSIC_TRACK_REQUEST == "mus_assault") then
		     play_music( TrackC, 0, true, 1, 1, 0 )
	    	 prt("Play assault music")
		 end

		 ---Recon Over Stinger
		 if (MUSIC_TRACK_REQUEST == "mus_reconOver") then
		     play_music( TrackS2, 1, true, .1, 1, 0 )
	    	 prt("Play recon over stinger")
		 end
		 	
			--Build Over Stinger
		 if (MUSIC_TRACK_REQUEST == "mus_buildOver") then
		     play_music( TrackS2, 1, true, .1, 1, 0 )
	    	 prt("JCM - Play build stage over stinger")
		 end	

			--Assault Over Stinger
		 if (MUSIC_TRACK_REQUEST == "mus_assaultOver") then
		     play_music( TrackS2, 1, true, .1, 1, 0 )
	    	 prt("JCM - Play assault stage over stinger")
		 end	

			--Capture Node Stinger
		 if (MUSIC_TRACK_REQUEST == "mus_captureNode") then
		     play_music( TrackS1, 1, true, .1, 1, 0 )
	    	 prt("JCM - Play capture node stinger")
		 end

			--Win Match Stinger
		 if (MUSIC_TRACK_REQUEST == "mus_winMatch") then
		     play_music( TrackS3, 0, true, .1, 1, 0 )
	    	 prt("JCM - Play win match stinger")
		 end

			--Player Dead Stinger
		 if (MUSIC_TRACK_REQUEST == "mus_playerDead") then
		     play_music( TrackS6, 1, true, .1, 1, 0 )
	    	 prt("JCM - Play player dead stinger")
		 end

			--Threat Detected Stinger
		 if (MUSIC_TRACK_REQUEST == "mus_threatDetected") then
		     play_music( TrackS4, 1, true, .1, 1, 0 )
	    	 prt("JCM - Play threat detected stinger")
		 end
	
			--Upgrade Weapon
		 if (MUSIC_TRACK_REQUEST == "mus_upgrade") then
		     play_music( TrackS17, 1, true, .1, 1, 1 )
	    	 prt("Play weapon upgarde stinger")
		 end		

		--  Stop music on channel zero 
		 if (MUSIC_TRACK_REQUEST == "mus_stopMusic0") then
			play_music( TrackNone, 0, true, 1, 1, 0 );
			prt("Stop music on channel zero")
		 end

		 
		--  Stop music on channel 1 
		 if (MUSIC_TRACK_REQUEST == "mus_stopMusic1") then
			play_music( TrackNone, 1, true, 1, 1, 0 );
			prt("Stop music on channel 1")
		 end
		 			 
		 	
		-- Kill all Music
		if (MUSIC_TRACK_REQUEST == "noMusic") then
			play_music( TrackNone, 0, true, 0, 0, 0 );
			play_music( TrackNone, 1, true, 0, 0, 0 );
		end

	-- ================================================================================
	end -- end if the if(new_track) check
	
	wait() -- wait till next frame to check again
end

-- Music Track System Functions:
--   request_music_track( track_name ) 
--     - Submits a request to change the current music track
--   get_music_track_request() 
--     - Checks to see if there is a pending track change to run
--   do_music_track_transition_check( moby, volume, front_track, back_track, <pre_delay = 0.5>, <retrigger_delay = 5> )
--     - Does the checks for requesting a music track change from passing through the center plane
--       of the volume. The pre_delay and retrigger_delay are both optional, and do not need to be set.
--
-- Music Track System Global Values:
--   MUSIC_TRACK_REQUEST - When get_music_track_request() returns true, this value 
--                         contains the name of the new music track to play.
--   CURRENT_MUSIC_TRACK - Contains the name of the currently playing music track.


------------------from jennifer----------------------


-- on_all_hero_enter (area_cliffs_music1,
	-- function ()
		    -- request_music_track ("cliffs_music")
            -- prt("playing cliffs_music")
	-- end)
	
	--you'll need to move all these calls above where you say [-- Do checks for which track to play here]
	--to make an 'area' you make several volumes and then create a layer with all of them.  Naming convention should be area_descriptionofarea.
	

		


















