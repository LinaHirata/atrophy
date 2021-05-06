scriptName Atrophy_Function extends Quest

;-- Properties --------------------------------------
actor property ThePlayer auto

;-- Variables ---------------------------------------
Float SpeechXp
Float AlchemyXp
Float AlterationXp
Float ArcheryXp
Float BlockXp
Float ConjurationXp
Float DestructionXp
Float EnchantingXp
Float HeavyArmorXp
Float IllusionXp
Float LightArmorXp
Float LockpickingXp
Float OneHandedXp
Float PickpocketXp
Float RestorationXp
Float SmithingXp
Float SneakXp
Float TwoHandedXp

;-- Events ---------------------------------------

event OnInit()
	SpeechXp 		= ActorValueInfo.GetActorValueInfoByName("Speechcraft").GetSkillExperience()
	AlchemyXp 		= ActorValueInfo.GetActorValueInfoByName("Alchemy").GetSkillExperience()
	AlterationXp 	= ActorValueInfo.GetActorValueInfoByName("Alteration").GetSkillExperience()
	ArcheryXp 		= ActorValueInfo.GetActorValueInfoByName("Marksman").GetSkillExperience()
	BlockXp 		= ActorValueInfo.GetActorValueInfoByName("Block").GetSkillExperience()
	ConjurationXp 	= ActorValueInfo.GetActorValueInfoByName("Conjuration").GetSkillExperience()
	DestructionXp 	= ActorValueInfo.GetActorValueInfoByName("Destruction").GetSkillExperience()
	EnchantingXp 	= ActorValueInfo.GetActorValueInfoByName("Enchanting").GetSkillExperience()
	HeavyArmorXp 	= ActorValueInfo.GetActorValueInfoByName("HeavyArmor").GetSkillExperience()
	IllusionXp 		= ActorValueInfo.GetActorValueInfoByName("Illusion").GetSkillExperience()
	LightArmorXp 	= ActorValueInfo.GetActorValueInfoByName("LightArmor").GetSkillExperience()
	LockpickingXp 	= ActorValueInfo.GetActorValueInfoByName("Lockpicking").GetSkillExperience()
	OneHandedXp 	= ActorValueInfo.GetActorValueInfoByName("OneHanded").GetSkillExperience()
	PickpocketXp 	= ActorValueInfo.GetActorValueInfoByName("Pickpocket").GetSkillExperience()
	RestorationXp 	= ActorValueInfo.GetActorValueInfoByName("Restoration").GetSkillExperience()
	SmithingXp 		= ActorValueInfo.GetActorValueInfoByName("Smithing").GetSkillExperience()
	SneakXp 		= ActorValueInfo.GetActorValueInfoByName("Sneak").GetSkillExperience()
	TwoHandedXp 	= ActorValueInfo.GetActorValueInfoByName("TwoHanded").GetSkillExperience()

	RegisterForSingleUpdateGameTime((StorageUtil.GetIntValue(none, "DaysInterval", 1) * 24) as Float)
	RegisterForSleep()
endEvent

event OnSleepStart(Float afSleepStartTime, Float afDesiredSleepEndTime)
	StorageUtil.SetintValue(none, "SleepCounter", 0)
endEvent

event OnUpdateGameTime()
	;Debug.StartStackProfiling()
; -----------------------------------------------------------------------------------------------
; -------------------------------------------- Init ---------------------------------------------
; -----------------------------------------------------------------------------------------------
	bool SUExperienceToggle = StorageUtil.GetIntValue(none, "ExperienceToggle", 0) as bool
	bool SUUncappedToggle 	= StorageUtil.GetIntValue(none, "UncappedToggle", 0) as bool
	bool SUNotifToggleSkill = StorageUtil.GetIntValue(none, "NotifToggleSkill", 0) as bool
	bool SUNotifToggle 		= StorageUtil.GetIntValue(none, "NotifToggle", 0) as bool

	float SUSleepCounter 	= StorageUtil.GetIntValue(none, "SleepCounter", 0) as float
	float SUSleepToggle 	= StorageUtil.GetIntValue(none, "SleepToggle", 0) as float
	float fSleepModifier 	= 6.0 - (SUSleepCounter / 2.0 * SUSleepToggle)

	int SULevel_Down_Counter = StorageUtil.GetIntValue(none, "Level_Down_Counter", 0)

	float playerXP = Game.GetPlayerExperience()
	int playerLVL = ThePlayer.GetLevel()

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- Speechcraft -----------------------------------------
; -----------------------------------------------------------------------------------------------
	ActorValueInfo skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Speechcraft")

	;float skillAV 			= ThePlayer.GetActorValue("Speechcraft") 			; current level ; TODO - check which one is faster :thinking:
	float skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer) 			; current level
	float skillXP 			= skillAVInfo.GetSkillExperience()					; current level experience
	float skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int) ; experience to get to next level

	float fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	float SUskillXPDrop = StorageUtil.GetIntValue(none, "SpeechXp", 3) as float
	float fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	; skill hasnt progressed
	if SpeechXp == skillXP
		; case 1: decreasing skill experience wont cause level drop
		if skillXP >= fDecreaseSkillBy
			; decrease skill experience
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)

		; case 2: skill isnt capped
		elseif (skillAV != 100.0 || SUUncappedToggle)
			; decreasing skill level wont cause to to drop further than 15
			if skillAV > 15.0
				; decrease skill level
				ThePlayer.SetActorValue("Speechcraft", skillAV - 1.0)

				; notify player
				if SUNotifToggleSkill
					Debug.Notification("You have lost a level in Speech")
				endif

				; decrease skill experience to match new level
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)

				; Experience mod isnt installed
				if !SUExperienceToggle
					; case 1: decreasing character experience wont cause level drop
					if playerXP >= skillAV + 1.0
						; decrease character experience
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)

					; case 2: decreasing character experience will cause level drop
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0 ; no need to check for < as checking for >= perviously implies else being <
						; decrease character level
						Game.SetPlayerLevel(playerLVL - 1)

						; notify player
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif

						; increase 'level down' counter
						SULevel_Down_Counter += 1

						; decrease character experience to match new level
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)

					; case 3: decreasing character experience will cause level drop further than 1
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1 ; no need to check for either as previous check imply this case being the only option left
						; set character experience to 0
						Game.SetPlayerExperience(0.000000)
					endif
				endif

			; case 3: decreasing skill experience will cause level drop further than 15
			else ; skillAV <= 15.0 ; no need to check for <= as checking for > previously implies else being <=
				; set skill experience to 0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ------------------------------------------- Alchemy -------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Alchemy")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "AlchemyXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if AlchemyXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Alchemy", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a level in Alchemy")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- Alteration ------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Alteration")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "AlterationXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if AlterationXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Alteration", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost an Alteration level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ------------------------------------------ Marksman -------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Marksman")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "ArcheryXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if ArcheryXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Marksman", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost an Archery level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; -------------------------------------------- Block --------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Block")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "BlockXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if BlockXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Block", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Blocking level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- Conjuration -----------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Conjuration")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "ConjurationXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if ConjurationXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Conjuration", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Conjuration level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- Destruction -----------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Destruction")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "DestructionXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if DestructionXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Destruction", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Destruction level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- Enchanting ------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Enchanting")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "EnchantingXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if EnchantingXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Enchanting", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost an Enchanting level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- HeavyArmor ------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("HeavyArmor")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "HeavyArmorXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if HeavyArmorXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("HeavyArmor", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Heavy Armor level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ------------------------------------------ Illusion -------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Illusion")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "IllusionXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if IllusionXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Illusion", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost an Illusion level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ------------------------------------------ LightArmor -----------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("LightArmor")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "LightArmorXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if LightArmorXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("LightArmor", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Light Armor level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- Lockpicking -----------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Lockpicking")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "LockpickingXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if LockpickingXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Lockpicking", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Lockpicking level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ------------------------------------------ OneHanded ------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("OneHanded")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "OneHandedXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if OneHandedXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("OneHanded", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a One Handed level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- Pickpocket ------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Pickpocket")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "PickpocketXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if PickpocketXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Pickpocket", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Pickpocket level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- Restoration -----------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Restoration")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "RestorationXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if RestorationXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Restoration", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Restoration level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ------------------------------------------ Smithing -------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Smithing")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "SmithingXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if SmithingXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Smithing", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Smithing level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; -------------------------------------------- Sneak --------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("Sneak")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "SneakXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if SneakXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("Sneak", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Sneak level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ------------------------------------------ TwoHanded ------------------------------------------
; -----------------------------------------------------------------------------------------------
	skillAVInfo = ActorValueInfo.GetActorValueInfoByName("TwoHanded")

	skillAV 			= skillAVInfo.GetCurrentValue(ThePlayer)
	skillXP 			= skillAVInfo.GetSkillExperience()
	skillXPForLevel 	= skillAVInfo.GetExperienceForLevel(skillAV as Int)

	fXPMultiplier = skillXPForLevel / (skillAV + fSleepModifier)

	SUskillXPDrop = StorageUtil.GetIntValue(none, "TwoHandedXp", 3) as float
	fDecreaseSkillBy = SUskillXPDrop * fXPMultiplier

	if TwoHandedXp == skillXP
		if skillXP >= fDecreaseSkillBy
			skillAVInfo.SetSkillExperience(skillXP - fDecreaseSkillBy)
		elseif (skillAV != 100.0 || SUUncappedToggle)
			if skillAV > 15.0
				ThePlayer.SetActorValue("TwoHanded", skillAV - 1.0)
				if SUNotifToggleSkill
					Debug.Notification("You have lost a Two Handed level")
				endif
				skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
				if !SUExperienceToggle 
					if playerXP >= skillAV + 1.0
						Game.SetPlayerExperience(playerXP - skillAV - 1.0)
					elseif playerLVL > 1 ; playerXP < skillAV + 1.0
						Game.SetPlayerLevel(playerLVL - 1)
						if SUNotifToggle
							Debug.Notification("Your Character level has dropped")
						endif
						SULevel_Down_Counter += 1
						Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
					else ; playerXP < skillAV + 1.0 && playerLVL <= 1
						Game.SetPlayerExperience(0.000000)
					endif
				endif
			else ; skillAV <= 15.0
				skillAVInfo.SetSkillExperience(0.000000)
			endif
		endif
	endif

; -----------------------------------------------------------------------------------------------
; ----------------------------------------- Maintenance -----------------------------------------
; -----------------------------------------------------------------------------------------------
	StorageUtil.SetintValue(none, "Level_Down_Counter", SULevel_Down_Counter)

	SpeechXp 		= ActorValueInfo.GetActorValueInfoByName("Speechcraft").GetSkillExperience()
	AlchemyXp 		= ActorValueInfo.GetActorValueInfoByName("Alchemy").GetSkillExperience()
	AlterationXp 	= ActorValueInfo.GetActorValueInfoByName("Alteration").GetSkillExperience()
	ArcheryXp 		= ActorValueInfo.GetActorValueInfoByName("Marksman").GetSkillExperience()
	BlockXp 		= ActorValueInfo.GetActorValueInfoByName("Block").GetSkillExperience()
	ConjurationXp 	= ActorValueInfo.GetActorValueInfoByName("Conjuration").GetSkillExperience()
	DestructionXp 	= ActorValueInfo.GetActorValueInfoByName("Destruction").GetSkillExperience()
	EnchantingXp 	= ActorValueInfo.GetActorValueInfoByName("Enchanting").GetSkillExperience()
	HeavyArmorXp 	= ActorValueInfo.GetActorValueInfoByName("HeavyArmor").GetSkillExperience()
	IllusionXp 		= ActorValueInfo.GetActorValueInfoByName("Illusion").GetSkillExperience()
	LightArmorXp 	= ActorValueInfo.GetActorValueInfoByName("LightArmor").GetSkillExperience()
	LockpickingXp 	= ActorValueInfo.GetActorValueInfoByName("Lockpicking").GetSkillExperience()
	OneHandedXp 	= ActorValueInfo.GetActorValueInfoByName("OneHanded").GetSkillExperience()
	PickpocketXp 	= ActorValueInfo.GetActorValueInfoByName("Pickpocket").GetSkillExperience()
	RestorationXp 	= ActorValueInfo.GetActorValueInfoByName("Restoration").GetSkillExperience()
	SmithingXp 		= ActorValueInfo.GetActorValueInfoByName("Smithing").GetSkillExperience()
	SneakXp 		= ActorValueInfo.GetActorValueInfoByName("Sneak").GetSkillExperience()
	TwoHandedXp 	= ActorValueInfo.GetActorValueInfoByName("TwoHanded").GetSkillExperience()

	int SUDaysInterval = StorageUtil.GetIntValue(none, "DaysInterval", 1)

	int newSUSleepCounter = SUSleepCounter as int + SUDaysInterval
	if newSUSleepCounter > 40
		newSUSleepCounter = 40
	endif
	StorageUtil.SetintValue(none, "SleepCounter", newSUSleepCounter)

	RegisterForSingleUpdateGameTime((SUDaysInterval * 24) as Float)
	;Debug.StopStackProfiling()
endEvent
