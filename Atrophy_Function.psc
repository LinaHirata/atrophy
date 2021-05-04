;/ Decompiled by Champollion V1.0.1
Source   : Atrophy_Function.psc
Modified : 2021-05-04 11:07:59
Compiled : 2021-05-04 11:08:43
User     : Payam
Computer : DESKTOP-QDPS8AP
/;
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

	;float skillAV 			= ThePlayer.GetActorValue("Speechcraft") 			; current level
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

		; case 2: decreasing skill experience will cause level drop
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			; decrease skill level
			ThePlayer.SetActorValue("Speechcraft", skillAV - 1.0)

			; notify player
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Speech level")
			endIf

			; decrease skill experience to match new level
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)

			; Experience mod isnt installed
			if !SUExperienceToggle 
				; case 1: decreasing character experience wont cause level drop
				if playerXP > skillAV + 1.0
					; decrease character experience
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)

				; case 2: decreasing character experience will cause level drop
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					; decrease character level
					Game.SetPlayerLevel(playerLVL - 1)

					; notify player
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf

					; increase 'level down' counter
					SULevel_Down_Counter += 1

					; decrease character experience to match new level
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)

				; case 3: decreasing character experience will cause level drop further than 1
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					; set character experience to 0
					Game.SetPlayerExperience(0.000000)
				endIf
			endif

		; case 3: decreasing skill experience will cause level drop further than 15
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			; set skill experience to 0
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Alchemy", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost an Alchemy level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Alteration", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost an Alteration level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Marksman", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost an Archery level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Block", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Blocking level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Conjuration", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Conjuration level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Destruction", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Destruction level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Enchanting", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost an Enchanting level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("HeavyArmor", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Heavy Armor level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Illusion", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost an Illusion level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("LightArmor", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Light Armor level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Lockpicking", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Lockpicking level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("OneHanded", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a One Handed level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Pickpocket", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Pickpocket level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Restoration", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Restoration level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Smithing", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Smithing level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("Sneak", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Sneak level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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
		elseIf skillXP < fDecreaseSkillBy && skillAV > 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			ThePlayer.SetActorValue("TwoHanded", skillAV - 1.0)
			if SUNotifToggleSkill
				Debug.Notification("You have lost a Two Handed level")
			endIf
			skillAVInfo.SetSkillExperience(skillXPForLevel - fDecreaseSkillBy + skillXP)
			if !SUExperienceToggle 
				if playerXP > skillAV + 1.0
					Game.SetPlayerExperience(playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL > 1
					Game.SetPlayerLevel(playerLVL - 1)
					if SUNotifToggle
						Debug.Notification("Your Character level has dropped")
					endIf
					SULevel_Down_Counter += 1
					Game.SetPlayerExperience(Game.GetExperienceForLevel(playerLVL) + playerXP - skillAV - 1.0)
				elseIf playerXP < skillAV + 1.0 && playerLVL <= 1
					Game.SetPlayerExperience(0.000000)
				endIf
			endif
		elseIf skillXP < fDecreaseSkillBy && skillAV <= 15.0 && (skillAV != 100.0 || SUUncappedToggle)
			skillAVInfo.SetSkillExperience(0.000000)
		endIf
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

	int newSUSleepCounter = SUSleepCounter + SUDaysInterval
	if newSUSleepCounter > 40
		newSUSleepCounter = 40
	endIf
	StorageUtil.SetintValue(none, "SleepCounter", newSUSleepCounter)

	RegisterForSingleUpdateGameTime((SUDaysInterval * 24) as Float)
endEvent
