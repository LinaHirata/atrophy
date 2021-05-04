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
Float RestorationXp
Float PickpocketXp
Float DestructionXp
Float HeavyArmorXp
Float SmithingXp
Float TwoHandedXp
Float LightArmorXp
Float SneakXp
Float OneHandedXp
Float IllusionXp
Float BlockXp
Float ArcheryXp
Float AlchemyXp
Float LockpickingXp
Float EnchantingXp
Float AlterationXp
Float ConjurationXp
Float SpeechXp

;-- Functions ---------------------------------------

; Skipped compiler generated GotoState

Float function GetSkillExperienceForLevel(String skillname)

	return actorvalueinfo.GetActorValueInfoByName(skillname).GetExperienceForLevel(ThePlayer.GetActorValue(skillname) as Int)
endFunction

Float function GetExperienceRemaining()

	return game.GetExperienceForLevel(ThePlayer.GetLevel()) - game.GetPlayerExperience()
endFunction

function OnInit()

	SpeechXp = actorvalueinfo.GetActorValueInfoByName("Speechcraft").GetSkillExperience()
	AlchemyXp = actorvalueinfo.GetActorValueInfoByName("Alchemy").GetSkillExperience()
	AlterationXp = actorvalueinfo.GetActorValueInfoByName("Alteration").GetSkillExperience()
	ArcheryXp = actorvalueinfo.GetActorValueInfoByName("Marksman").GetSkillExperience()
	BlockXp = actorvalueinfo.GetActorValueInfoByName("Block").GetSkillExperience()
	ConjurationXp = actorvalueinfo.GetActorValueInfoByName("Conjuration").GetSkillExperience()
	DestructionXp = actorvalueinfo.GetActorValueInfoByName("Destruction").GetSkillExperience()
	EnchantingXp = actorvalueinfo.GetActorValueInfoByName("Enchanting").GetSkillExperience()
	HeavyArmorXp = actorvalueinfo.GetActorValueInfoByName("HeavyArmor").GetSkillExperience()
	IllusionXp = actorvalueinfo.GetActorValueInfoByName("Illusion").GetSkillExperience()
	LightArmorXp = actorvalueinfo.GetActorValueInfoByName("LightArmor").GetSkillExperience()
	LockpickingXp = actorvalueinfo.GetActorValueInfoByName("Lockpicking").GetSkillExperience()
	OneHandedXp = actorvalueinfo.GetActorValueInfoByName("OneHanded").GetSkillExperience()
	PickpocketXp = actorvalueinfo.GetActorValueInfoByName("Pickpocket").GetSkillExperience()
	RestorationXp = actorvalueinfo.GetActorValueInfoByName("Restoration").GetSkillExperience()
	SmithingXp = actorvalueinfo.GetActorValueInfoByName("Smithing").GetSkillExperience()
	SneakXp = actorvalueinfo.GetActorValueInfoByName("Sneak").GetSkillExperience()
	TwoHandedXp = actorvalueinfo.GetActorValueInfoByName("TwoHanded").GetSkillExperience()
	self.RegisterForSingleUpdateGameTime((storageutil.GetIntValue(none, "DaysInterval", 1) * 24) as Float)
	self.RegisterForSleep()
endFunction

Float function GetExperienceSkill(String skillname)

	return actorvalueinfo.GetActorValueInfoByName(skillname).GetSkillExperience()
endFunction

; Skipped compiler generated GetState

function SetExperienceSkill(String skillname, Float value)

	actorvalueinfo.GetActorValueInfoByName(skillname).SetSkillExperience(value)
endFunction

function OnSleepStart(Float afSleepStartTime, Float afDesiredSleepEndTime)

	storageutil.SetintValue(none, "SleepCounter", 0)
endFunction

function OnUpdateGameTime()

	if SpeechXp == self.GetExperienceSkill("Speechcraft") && self.GetExperienceSkill("Speechcraft") >= storageutil.GetIntValue(none, "SpeechXp", 3) as Float * self.ExperienceMultiplier("Speechcraft")
		self.SetExperienceSkill("Speechcraft", self.GetExperienceSkill("Speechcraft") - storageutil.GetIntValue(none, "SpeechXp", 3) as Float * self.ExperienceMultiplier("Speechcraft"))
	elseIf SpeechXp == self.GetExperienceSkill("Speechcraft") && self.GetExperienceSkill("Speechcraft") < storageutil.GetIntValue(none, "SpeechXp", 3) as Float * self.ExperienceMultiplier("Speechcraft") && ThePlayer.GetAV("Speechcraft") > 15 as Float && (ThePlayer.GetActorValue("Speechcraft") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Speechcraft", ThePlayer.GetActorValue("Speechcraft") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Speech level")
		endIf
		self.SetExperienceSkill("Speechcraft", self.GetSkillExperienceForLevel("Speechcraft") - storageutil.GetIntValue(none, "SpeechXp", 3) as Float * self.ExperienceMultiplier("Speechcraft") + self.GetExperienceSkill("Speechcraft"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Speechcraft") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Speechcraft") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Speechcraft") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Speechcraft") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Speechcraft") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf SpeechXp == self.GetExperienceSkill("Speechcraft") && self.GetExperienceSkill("Speechcraft") < storageutil.GetIntValue(none, "SpeechXp", 3) as Float * self.ExperienceMultiplier("Speechcraft") && ThePlayer.GetAV("Speechcraft") <= 15 as Float && (ThePlayer.GetActorValue("Speechcraft") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Speechcraft", 0.000000)
	endIf
	if AlchemyXp == self.GetExperienceSkill("Alchemy") && self.GetExperienceSkill("Alchemy") >= storageutil.GetIntValue(none, "AlchemyXp", 3) as Float * self.ExperienceMultiplier("Alchemy")
		self.SetExperienceSkill("Alchemy", self.GetExperienceSkill("Alchemy") - storageutil.GetIntValue(none, "AlchemyXp", 3) as Float * self.ExperienceMultiplier("Alchemy"))
	elseIf AlchemyXp == self.GetExperienceSkill("Alchemy") && self.GetExperienceSkill("Alchemy") < storageutil.GetIntValue(none, "AlchemyXp", 3) as Float * self.ExperienceMultiplier("Alchemy") && ThePlayer.GetAV("Alchemy") > 15 as Float && (ThePlayer.GetActorValue("Alchemy") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Alchemy", ThePlayer.GetActorValue("Alchemy") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost an Alchemy level")
		endIf
		self.SetExperienceSkill("Alchemy", self.GetSkillExperienceForLevel("Alchemy") - storageutil.GetIntValue(none, "AlchemyXp", 3) as Float * self.ExperienceMultiplier("Alchemy") + self.GetExperienceSkill("Alchemy"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Alchemy") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Alchemy") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Alchemy") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Alchemy") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Alchemy") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf AlchemyXp == self.GetExperienceSkill("Alchemy") && self.GetExperienceSkill("Alchemy") < storageutil.GetIntValue(none, "AlchemyXp", 3) as Float * self.ExperienceMultiplier("Alchemy") && ThePlayer.GetAV("Alchemy") <= 15 as Float && (ThePlayer.GetActorValue("Alchemy") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Alchemy", 0.000000)
	endIf
	if AlterationXp == self.GetExperienceSkill("Alteration") && self.GetExperienceSkill("Alteration") >= storageutil.GetIntValue(none, "AlterationXp", 3) as Float * self.ExperienceMultiplier("Alteration")
		self.SetExperienceSkill("Alteration", self.GetExperienceSkill("Alteration") - storageutil.GetIntValue(none, "AlterationXp", 3) as Float * self.ExperienceMultiplier("Alteration"))
	elseIf AlterationXp == self.GetExperienceSkill("Alteration") && self.GetExperienceSkill("Alteration") < storageutil.GetIntValue(none, "AlterationXp", 3) as Float * self.ExperienceMultiplier("Alteration") && ThePlayer.GetAV("Alteration") > 15 as Float && (ThePlayer.GetActorValue("Alteration") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Alteration", ThePlayer.GetActorValue("Alteration") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost an Alteration level")
		endIf
		self.SetExperienceSkill("Alteration", self.GetSkillExperienceForLevel("Alteration") - storageutil.GetIntValue(none, "AlterationXp", 3) as Float * self.ExperienceMultiplier("Alteration") + self.GetExperienceSkill("Alteration"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Alteration") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Alteration") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Alteration") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Alteration") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Alteration") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf AlterationXp == self.GetExperienceSkill("Alteration") && self.GetExperienceSkill("Alteration") < storageutil.GetIntValue(none, "AlterationXp", 3) as Float * self.ExperienceMultiplier("Alteration") && ThePlayer.GetAV("Alteration") <= 15 as Float && (ThePlayer.GetActorValue("Alteration") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Alteration", 0.000000)
	endIf
	if ArcheryXp == self.GetExperienceSkill("Marksman") && self.GetExperienceSkill("Marksman") >= storageutil.GetIntValue(none, "ArcheryXp", 3) as Float * self.ExperienceMultiplier("Marksman")
		self.SetExperienceSkill("Marksman", self.GetExperienceSkill("Marksman") - storageutil.GetIntValue(none, "ArcheryXp", 3) as Float * self.ExperienceMultiplier("Marksman"))
	elseIf ArcheryXp == self.GetExperienceSkill("Marksman") && self.GetExperienceSkill("Marksman") < storageutil.GetIntValue(none, "ArcheryXp", 3) as Float * self.ExperienceMultiplier("Marksman") && ThePlayer.GetAV("Marksman") > 15 as Float && (ThePlayer.GetActorValue("Marksman") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Marksman", ThePlayer.GetActorValue("Marksman") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost an Archery level")
		endIf
		self.SetExperienceSkill("Marksman", self.GetSkillExperienceForLevel("Marksman") - storageutil.GetIntValue(none, "ArcheryXp", 3) as Float * self.ExperienceMultiplier("Marksman") + self.GetExperienceSkill("Marksman"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Marksman") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Marksman") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Marksman") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Marksman") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Marksman") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf ArcheryXp == self.GetExperienceSkill("Marksman") && self.GetExperienceSkill("Marksman") < storageutil.GetIntValue(none, "ArcheryXp", 3) as Float * self.ExperienceMultiplier("Marksman") && ThePlayer.GetAV("Marksman") <= 15 as Float && (ThePlayer.GetActorValue("Marksman") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Marksman", 0.000000)
	endIf
	if BlockXp == self.GetExperienceSkill("Block") && self.GetExperienceSkill("Block") >= storageutil.GetIntValue(none, "BlockXp", 3) as Float * self.ExperienceMultiplier("Block")
		self.SetExperienceSkill("Block", self.GetExperienceSkill("Block") - storageutil.GetIntValue(none, "BlockXp", 3) as Float * self.ExperienceMultiplier("Block"))
	elseIf BlockXp == self.GetExperienceSkill("Block") && self.GetExperienceSkill("Block") < storageutil.GetIntValue(none, "BlockXp", 3) as Float * self.ExperienceMultiplier("Block") && ThePlayer.GetAV("Block") > 15 as Float && (ThePlayer.GetActorValue("Block") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Block", ThePlayer.GetActorValue("Block") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Blocking level")
		endIf
		self.SetExperienceSkill("Block", self.GetSkillExperienceForLevel("Block") - storageutil.GetIntValue(none, "BlockXp", 3) as Float * self.ExperienceMultiplier("Block") + self.GetExperienceSkill("Block"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Block") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Block") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Block") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Block") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Block") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf BlockXp == self.GetExperienceSkill("Block") && self.GetExperienceSkill("Block") < storageutil.GetIntValue(none, "BlockXp", 3) as Float * self.ExperienceMultiplier("Block") && ThePlayer.GetAV("Block") <= 15 as Float && (ThePlayer.GetActorValue("Block") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Block", 0.000000)
	endIf
	if ConjurationXp == self.GetExperienceSkill("Conjuration") && self.GetExperienceSkill("Conjuration") >= storageutil.GetIntValue(none, "ConjurationXp", 3) as Float * self.ExperienceMultiplier("Conjuration")
		self.SetExperienceSkill("Conjuration", self.GetExperienceSkill("Conjuration") - storageutil.GetIntValue(none, "ConjurationXp", 3) as Float * self.ExperienceMultiplier("Conjuration"))
	elseIf ConjurationXp == self.GetExperienceSkill("Conjuration") && self.GetExperienceSkill("Conjuration") < storageutil.GetIntValue(none, "ConjurationXp", 3) as Float * self.ExperienceMultiplier("Conjuration") && ThePlayer.GetAV("Conjuration") > 15 as Float && (ThePlayer.GetActorValue("Conjuration") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Conjuration", ThePlayer.GetActorValue("Conjuration") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Conjuration level")
		endIf
		self.SetExperienceSkill("Conjuration", self.GetSkillExperienceForLevel("Conjuration") - storageutil.GetIntValue(none, "ConjurationXp", 3) as Float * self.ExperienceMultiplier("Conjuration") + self.GetExperienceSkill("Conjuration"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Conjuration") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Conjuration") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Conjuration") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Conjuration") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Conjuration") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf ConjurationXp == self.GetExperienceSkill("Conjuration") && self.GetExperienceSkill("Conjuration") < storageutil.GetIntValue(none, "ConjurationXp", 3) as Float * self.ExperienceMultiplier("Conjuration") && ThePlayer.GetAV("Conjuration") <= 15 as Float && (ThePlayer.GetActorValue("Conjuration") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Conjuration", 0.000000)
	endIf
	if DestructionXp == self.GetExperienceSkill("Destruction") && self.GetExperienceSkill("Destruction") >= storageutil.GetIntValue(none, "DestructionXp", 3) as Float * self.ExperienceMultiplier("Destruction")
		self.SetExperienceSkill("Destruction", self.GetExperienceSkill("Destruction") - storageutil.GetIntValue(none, "DestructionXp", 3) as Float * self.ExperienceMultiplier("Destruction"))
	elseIf DestructionXp == self.GetExperienceSkill("Destruction") && self.GetExperienceSkill("Destruction") < storageutil.GetIntValue(none, "DestructionXp", 3) as Float * self.ExperienceMultiplier("Destruction") && ThePlayer.GetAV("Destruction") > 15 as Float && (ThePlayer.GetActorValue("Destruction") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Destruction", ThePlayer.GetActorValue("Destruction") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Destruction level")
		endIf
		self.SetExperienceSkill("Destruction", self.GetSkillExperienceForLevel("Destruction") - storageutil.GetIntValue(none, "DestructionXp", 3) as Float * self.ExperienceMultiplier("Destruction") + self.GetExperienceSkill("Destruction"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Destruction") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Destruction") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Destruction") + 1 as Float && ThePlayer.GetLevel() > 1
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Destruction") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Destruction") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf DestructionXp == self.GetExperienceSkill("Destruction") && self.GetExperienceSkill("Destruction") < storageutil.GetIntValue(none, "DestructionXp", 3) as Float * self.ExperienceMultiplier("Destruction") && ThePlayer.GetAV("Destruction") <= 15 as Float && (ThePlayer.GetActorValue("Destruction") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Destruction", 0.000000)
	endIf
	if EnchantingXp == self.GetExperienceSkill("Enchanting") && self.GetExperienceSkill("Enchanting") >= storageutil.GetIntValue(none, "EnchantingXp", 3) as Float * self.ExperienceMultiplier("Enchanting")
		self.SetExperienceSkill("Enchanting", self.GetExperienceSkill("Enchanting") - storageutil.GetIntValue(none, "EnchantingXp", 3) as Float * self.ExperienceMultiplier("Enchanting"))
	elseIf EnchantingXp == self.GetExperienceSkill("Enchanting") && self.GetExperienceSkill("Enchanting") < storageutil.GetIntValue(none, "EnchantingXp", 3) as Float * self.ExperienceMultiplier("Enchanting") && ThePlayer.GetAV("Enchanting") > 15 as Float && (ThePlayer.GetActorValue("Enchanting") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Enchanting", ThePlayer.GetActorValue("Enchanting") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost an Enchanting level")
		endIf
		self.SetExperienceSkill("Enchanting", self.GetSkillExperienceForLevel("Enchanting") - storageutil.GetIntValue(none, "EnchantingXp", 3) as Float * self.ExperienceMultiplier("Enchanting") + self.GetExperienceSkill("Enchanting"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Enchanting") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Enchanting") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Enchanting") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Enchanting") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Enchanting") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf EnchantingXp == self.GetExperienceSkill("Enchanting") && self.GetExperienceSkill("Enchanting") < storageutil.GetIntValue(none, "EnchantingXp", 3) as Float * self.ExperienceMultiplier("Enchanting") && ThePlayer.GetAV("Enchanting") <= 15 as Float && (ThePlayer.GetActorValue("Enchanting") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Enchanting", 0.000000)
	endIf
	if HeavyArmorXp == self.GetExperienceSkill("HeavyArmor") && self.GetExperienceSkill("HeavyArmor") >= storageutil.GetIntValue(none, "HeavyArmorXp", 3) as Float * self.ExperienceMultiplier("HeavyArmor")
		self.SetExperienceSkill("HeavyArmor", self.GetExperienceSkill("HeavyArmor") - storageutil.GetIntValue(none, "HeavyArmorXp", 3) as Float * self.ExperienceMultiplier("HeavyArmor"))
	elseIf HeavyArmorXp == self.GetExperienceSkill("HeavyArmor") && self.GetExperienceSkill("HeavyArmor") < storageutil.GetIntValue(none, "HeavyArmorXp", 3) as Float * self.ExperienceMultiplier("HeavyArmor") && ThePlayer.GetAV("HeavyArmor") > 15 as Float && (ThePlayer.GetActorValue("HeavyArmor") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("HeavyArmor", ThePlayer.GetActorValue("HeavyArmor") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Heavy Armor level")
		endIf
		self.SetExperienceSkill("HeavyArmor", self.GetSkillExperienceForLevel("HeavyArmor") - storageutil.GetIntValue(none, "HeavyArmorXp", 3) as Float * self.ExperienceMultiplier("HeavyArmor") + self.GetExperienceSkill("HeavyArmor"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("HeavyArmor") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("HeavyArmor") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("HeavyArmor") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("HeavyArmor") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("HeavyArmor") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf HeavyArmorXp == self.GetExperienceSkill("HeavyArmor") && self.GetExperienceSkill("HeavyArmor") < storageutil.GetIntValue(none, "HeavyArmorXp", 3) as Float * self.ExperienceMultiplier("HeavyArmor") && ThePlayer.GetAV("HeavyArmor") <= 15 as Float && (ThePlayer.GetActorValue("HeavyArmor") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("HeavyArmor", 0.000000)
	endIf
	if IllusionXp == self.GetExperienceSkill("Illusion") && self.GetExperienceSkill("Illusion") >= storageutil.GetIntValue(none, "IllusionXp", 3) as Float * self.ExperienceMultiplier("Illusion")
		self.SetExperienceSkill("Illusion", self.GetExperienceSkill("Illusion") - storageutil.GetIntValue(none, "IllusionXp", 3) as Float * self.ExperienceMultiplier("Illusion"))
	elseIf IllusionXp == self.GetExperienceSkill("Illusion") && self.GetExperienceSkill("Illusion") < storageutil.GetIntValue(none, "IllusionXp", 3) as Float * self.ExperienceMultiplier("Illusion") && ThePlayer.GetAV("Illusion") > 15 as Float && (ThePlayer.GetActorValue("Illusion") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Illusion", ThePlayer.GetActorValue("Illusion") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost an Illusion level")
		endIf
		self.SetExperienceSkill("Illusion", self.GetSkillExperienceForLevel("Illusion") - storageutil.GetIntValue(none, "IllusionXp", 3) as Float * self.ExperienceMultiplier("Illusion") + self.GetExperienceSkill("Illusion"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Illusion") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Illusion") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Illusion") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Illusion") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Illusion") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf IllusionXp == self.GetExperienceSkill("Illusion") && self.GetExperienceSkill("Illusion") < storageutil.GetIntValue(none, "IllusionXp", 3) as Float * self.ExperienceMultiplier("Illusion") && ThePlayer.GetAV("Illusion") <= 15 as Float && (ThePlayer.GetActorValue("Illusion") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Illusion", 0.000000)
	endIf
	if LightArmorXp == self.GetExperienceSkill("LightArmor") && self.GetExperienceSkill("LightArmor") >= storageutil.GetIntValue(none, "LightArmorXp", 3) as Float * self.ExperienceMultiplier("LightArmor")
		self.SetExperienceSkill("LightArmor", self.GetExperienceSkill("LightArmor") - storageutil.GetIntValue(none, "LightArmorXp", 3) as Float * self.ExperienceMultiplier("LightArmor"))
	elseIf LightArmorXp == self.GetExperienceSkill("LightArmor") && self.GetExperienceSkill("LightArmor") < storageutil.GetIntValue(none, "LightArmorXp", 3) as Float * self.ExperienceMultiplier("LightArmor") && ThePlayer.GetAV("LightArmor") > 15 as Float && (ThePlayer.GetActorValue("LightArmor") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("LightArmor", ThePlayer.GetActorValue("LightArmor") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Light Armor level")
		endIf
		self.SetExperienceSkill("LightArmor", self.GetSkillExperienceForLevel("LightArmor") - storageutil.GetIntValue(none, "LightArmorXp", 3) as Float * self.ExperienceMultiplier("LightArmor") + self.GetExperienceSkill("LightArmor"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("LightArmor") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("LightArmor") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("LightArmor") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("LightArmor") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("LightArmor") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf LightArmorXp == self.GetExperienceSkill("LightArmor") && self.GetExperienceSkill("LightArmor") < storageutil.GetIntValue(none, "LightArmorXp", 3) as Float * self.ExperienceMultiplier("LightArmor") && ThePlayer.GetAV("LightArmor") <= 15 as Float && (ThePlayer.GetActorValue("LightArmor") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("LightArmor", 0.000000)
	endIf
	if LockpickingXp == self.GetExperienceSkill("Lockpicking") && self.GetExperienceSkill("Lockpicking") >= storageutil.GetIntValue(none, "LockpickingXp", 3) as Float * self.ExperienceMultiplier("Lockpicking")
		self.SetExperienceSkill("Lockpicking", self.GetExperienceSkill("Lockpicking") - storageutil.GetIntValue(none, "LockpickingXp", 3) as Float * self.ExperienceMultiplier("Lockpicking"))
	elseIf LockpickingXp == self.GetExperienceSkill("Lockpicking") && self.GetExperienceSkill("Lockpicking") < storageutil.GetIntValue(none, "LockpickingXp", 3) as Float * self.ExperienceMultiplier("Lockpicking") && ThePlayer.GetAV("Lockpicking") > 15 as Float && (ThePlayer.GetActorValue("Lockpicking") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Lockpicking", ThePlayer.GetActorValue("Lockpicking") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Lockpicking level")
		endIf
		self.SetExperienceSkill("Lockpicking", self.GetSkillExperienceForLevel("Lockpicking") - storageutil.GetIntValue(none, "LockpickingXp", 3) as Float * self.ExperienceMultiplier("Lockpicking") + self.GetExperienceSkill("Lockpicking"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Lockpicking") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Lockpicking") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Lockpicking") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Lockpicking") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Lockpicking") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf LockpickingXp == self.GetExperienceSkill("Lockpicking") && self.GetExperienceSkill("Lockpicking") < storageutil.GetIntValue(none, "LockpickingXp", 3) as Float * self.ExperienceMultiplier("Lockpicking") && ThePlayer.GetAV("Lockpicking") <= 15 as Float && (ThePlayer.GetActorValue("Lockpicking") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Lockpicking", 0.000000)
	endIf
	if OneHandedXp == self.GetExperienceSkill("OneHanded") && self.GetExperienceSkill("OneHanded") >= storageutil.GetIntValue(none, "OneHandedXp", 3) as Float * self.ExperienceMultiplier("OneHanded")
		self.SetExperienceSkill("OneHanded", self.GetExperienceSkill("OneHanded") - storageutil.GetIntValue(none, "OneHandedXp", 3) as Float * self.ExperienceMultiplier("OneHanded"))
	elseIf OneHandedXp == self.GetExperienceSkill("OneHanded") && self.GetExperienceSkill("OneHanded") < storageutil.GetIntValue(none, "OneHandedXp", 3) as Float * self.ExperienceMultiplier("OneHanded") && ThePlayer.GetAV("OneHanded") > 15 as Float && (ThePlayer.GetActorValue("OneHanded") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("OneHanded", ThePlayer.GetActorValue("OneHanded") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a One Handed level")
		endIf
		self.SetExperienceSkill("OneHanded", self.GetSkillExperienceForLevel("OneHanded") - storageutil.GetIntValue(none, "OneHandedXp", 3) as Float * self.ExperienceMultiplier("OneHanded") + self.GetExperienceSkill("OneHanded"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("OneHanded") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("OneHanded") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("OneHanded") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("OneHanded") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("OneHanded") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf OneHandedXp == self.GetExperienceSkill("OneHanded") && self.GetExperienceSkill("OneHanded") < storageutil.GetIntValue(none, "OneHandedXp", 3) as Float * self.ExperienceMultiplier("OneHanded") && ThePlayer.GetAV("OneHanded") <= 15 as Float && (ThePlayer.GetActorValue("OneHanded") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("OneHanded", 0.000000)
	endIf
	if PickpocketXp == self.GetExperienceSkill("Pickpocket") && self.GetExperienceSkill("Pickpocket") >= storageutil.GetIntValue(none, "PickpocketXp", 3) as Float * self.ExperienceMultiplier("Pickpocket")
		self.SetExperienceSkill("Pickpocket", self.GetExperienceSkill("Pickpocket") - storageutil.GetIntValue(none, "PickpocketXp", 3) as Float * self.ExperienceMultiplier("Pickpocket"))
	elseIf PickpocketXp == self.GetExperienceSkill("Pickpocket") && self.GetExperienceSkill("Pickpocket") < storageutil.GetIntValue(none, "PickpocketXp", 3) as Float * self.ExperienceMultiplier("Pickpocket") && ThePlayer.GetAV("Pickpocket") > 15 as Float && (ThePlayer.GetActorValue("Pickpocket") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Pickpocket", ThePlayer.GetActorValue("Pickpocket") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Pickpocket level")
		endIf
		self.SetExperienceSkill("Pickpocket", self.GetSkillExperienceForLevel("Pickpocket") - storageutil.GetIntValue(none, "PickpocketXp", 3) as Float * self.ExperienceMultiplier("Pickpocket") + self.GetExperienceSkill("Pickpocket"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Pickpocket") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Pickpocket") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Pickpocket") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Pickpocket") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Pickpocket") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf PickpocketXp == self.GetExperienceSkill("Pickpocket") && self.GetExperienceSkill("Pickpocket") < storageutil.GetIntValue(none, "PickpocketXp", 3) as Float * self.ExperienceMultiplier("Pickpocket") && ThePlayer.GetAV("Pickpocket") <= 15 as Float && (ThePlayer.GetActorValue("Pickpocket") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Pickpocket", 0.000000)
	endIf
	if RestorationXp == self.GetExperienceSkill("Restoration") && self.GetExperienceSkill("Restoration") >= storageutil.GetIntValue(none, "RestorationXp", 3) as Float * self.ExperienceMultiplier("Restoration")
		self.SetExperienceSkill("Restoration", self.GetExperienceSkill("Restoration") - storageutil.GetIntValue(none, "RestorationXp", 3) as Float * self.ExperienceMultiplier("Restoration"))
	elseIf RestorationXp == self.GetExperienceSkill("Restoration") && self.GetExperienceSkill("Restoration") < storageutil.GetIntValue(none, "RestorationXp", 3) as Float * self.ExperienceMultiplier("Restoration") && ThePlayer.GetAV("Restoration") > 15 as Float && (ThePlayer.GetActorValue("Restoration") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Restoration", ThePlayer.GetActorValue("Restoration") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Restoration level")
		endIf
		self.SetExperienceSkill("Restoration", self.GetSkillExperienceForLevel("Restoration") - storageutil.GetIntValue(none, "RestorationXp", 3) as Float * self.ExperienceMultiplier("Restoration") + self.GetExperienceSkill("Restoration"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Restoration") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Restoration") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Restoration") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Restoration") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Restoration") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf RestorationXp == self.GetExperienceSkill("Restoration") && self.GetExperienceSkill("Restoration") < storageutil.GetIntValue(none, "RestorationXp", 3) as Float * self.ExperienceMultiplier("Restoration") && ThePlayer.GetAV("Restoration") <= 15 as Float && (ThePlayer.GetActorValue("Restoration") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Restoration", 0.000000)
	endIf
	if SmithingXp == self.GetExperienceSkill("Smithing") && self.GetExperienceSkill("Smithing") >= storageutil.GetIntValue(none, "SmithingXp", 3) as Float * self.ExperienceMultiplier("Smithing")
		self.SetExperienceSkill("Smithing", self.GetExperienceSkill("Smithing") - storageutil.GetIntValue(none, "SmithingXp", 3) as Float * self.ExperienceMultiplier("Smithing"))
	elseIf SmithingXp == self.GetExperienceSkill("Smithing") && self.GetExperienceSkill("Smithing") < storageutil.GetIntValue(none, "SmithingXp", 3) as Float * self.ExperienceMultiplier("Smithing") && ThePlayer.GetAV("Smithing") > 15 as Float && (ThePlayer.GetActorValue("Smithing") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Smithing", ThePlayer.GetActorValue("Smithing") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Smithing level")
		endIf
		self.SetExperienceSkill("Smithing", self.GetSkillExperienceForLevel("Smithing") - storageutil.GetIntValue(none, "SmithingXp", 3) as Float * self.ExperienceMultiplier("Smithing") + self.GetExperienceSkill("Smithing"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Smithing") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Smithing") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Smithing") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Smithing") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Smithing") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf SmithingXp == self.GetExperienceSkill("Smithing") && self.GetExperienceSkill("Smithing") < storageutil.GetIntValue(none, "SmithingXp", 3) as Float * self.ExperienceMultiplier("Smithing") && ThePlayer.GetAV("Smithing") <= 15 as Float && (ThePlayer.GetActorValue("Smithing") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Smithing", 0.000000)
	endIf
	if SneakXp == self.GetExperienceSkill("Sneak") && self.GetExperienceSkill("Sneak") >= storageutil.GetIntValue(none, "SneakXp", 3) as Float * self.ExperienceMultiplier("Sneak")
		self.SetExperienceSkill("Sneak", self.GetExperienceSkill("Sneak") - storageutil.GetIntValue(none, "SneakXp", 3) as Float * self.ExperienceMultiplier("Sneak"))
	elseIf SneakXp == self.GetExperienceSkill("Sneak") && self.GetExperienceSkill("Sneak") < storageutil.GetIntValue(none, "SneakXp", 3) as Float * self.ExperienceMultiplier("Sneak") && ThePlayer.GetAV("Sneak") > 15 as Float && (ThePlayer.GetActorValue("Sneak") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("Sneak", ThePlayer.GetActorValue("Sneak") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Sneak level")
		endIf
		self.SetExperienceSkill("Sneak", self.GetSkillExperienceForLevel("Sneak") - storageutil.GetIntValue(none, "SneakXp", 3) as Float * self.ExperienceMultiplier("Sneak") + self.GetExperienceSkill("Sneak"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("Sneak") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("Sneak") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Sneak") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("Sneak") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("Sneak") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf SneakXp == self.GetExperienceSkill("Sneak") && self.GetExperienceSkill("Sneak") < storageutil.GetIntValue(none, "SneakXp", 3) as Float * self.ExperienceMultiplier("Sneak") && ThePlayer.GetAV("Sneak") <= 15 as Float && (ThePlayer.GetActorValue("Sneak") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("Sneak", 0.000000)
	endIf
	if TwoHandedXp == self.GetExperienceSkill("TwoHanded") && self.GetExperienceSkill("TwoHanded") >= storageutil.GetIntValue(none, "TwoHandedXp", 3) as Float * self.ExperienceMultiplier("TwoHanded")
		self.SetExperienceSkill("TwoHanded", self.GetExperienceSkill("TwoHanded") - storageutil.GetIntValue(none, "TwoHandedXp", 3) as Float * self.ExperienceMultiplier("TwoHanded"))
	elseIf TwoHandedXp == self.GetExperienceSkill("TwoHanded") && self.GetExperienceSkill("TwoHanded") < storageutil.GetIntValue(none, "TwoHandedXp", 3) as Float * self.ExperienceMultiplier("TwoHanded") && ThePlayer.GetAV("TwoHanded") > 15 as Float && (ThePlayer.GetActorValue("TwoHanded") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		ThePlayer.SetActorValue("TwoHanded", ThePlayer.GetActorValue("TwoHanded") - 1 as Float)
		if storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
			debug.Notification("You have lost a Two Handed level")
		endIf
		self.SetExperienceSkill("TwoHanded", self.GetSkillExperienceForLevel("TwoHanded") - storageutil.GetIntValue(none, "TwoHandedXp", 3) as Float * self.ExperienceMultiplier("TwoHanded") + self.GetExperienceSkill("TwoHanded"))
		if game.GetPlayerExperience() > ThePlayer.GetAV("TwoHanded") + 1 as Float && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(game.GetPlayerExperience() - ThePlayer.GetAV("TwoHanded") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("TwoHanded") + 1 as Float && ThePlayer.GetLevel() > 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerLevel(ThePlayer.GetLevel() - 1)
			if storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
				debug.Notification("Your Character level has dropped")
			endIf
			storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetIntValue(none, "Level_Down_Counter", 0) + 1)
			game.SetPlayerExperience(game.GetExperienceForLevel(ThePlayer.GetLevel()) + game.GetPlayerExperience() - ThePlayer.GetAV("TwoHanded") - 1 as Float)
		elseIf game.GetPlayerExperience() < ThePlayer.GetAV("TwoHanded") + 1 as Float && ThePlayer.GetLevel() <= 1 && !storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
			game.SetPlayerExperience(0.000000)
		endIf
	elseIf TwoHandedXp == self.GetExperienceSkill("TwoHanded") && self.GetExperienceSkill("TwoHanded") < storageutil.GetIntValue(none, "TwoHandedXp", 3) as Float * self.ExperienceMultiplier("TwoHanded") && ThePlayer.GetAV("TwoHanded") <= 15 as Float && (ThePlayer.GetActorValue("TwoHanded") != 100 as Float || storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool)
		self.SetExperienceSkill("TwoHanded", 0.000000)
	endIf
	SpeechXp = actorvalueinfo.GetActorValueInfoByName("Speechcraft").GetSkillExperience()
	AlchemyXp = actorvalueinfo.GetActorValueInfoByName("Alchemy").GetSkillExperience()
	AlterationXp = actorvalueinfo.GetActorValueInfoByName("Alteration").GetSkillExperience()
	ArcheryXp = actorvalueinfo.GetActorValueInfoByName("Marksman").GetSkillExperience()
	BlockXp = actorvalueinfo.GetActorValueInfoByName("Block").GetSkillExperience()
	ConjurationXp = actorvalueinfo.GetActorValueInfoByName("Conjuration").GetSkillExperience()
	DestructionXp = actorvalueinfo.GetActorValueInfoByName("Destruction").GetSkillExperience()
	EnchantingXp = actorvalueinfo.GetActorValueInfoByName("Enchanting").GetSkillExperience()
	HeavyArmorXp = actorvalueinfo.GetActorValueInfoByName("HeavyArmor").GetSkillExperience()
	IllusionXp = actorvalueinfo.GetActorValueInfoByName("Illusion").GetSkillExperience()
	LightArmorXp = actorvalueinfo.GetActorValueInfoByName("LightArmor").GetSkillExperience()
	LockpickingXp = actorvalueinfo.GetActorValueInfoByName("Lockpicking").GetSkillExperience()
	OneHandedXp = actorvalueinfo.GetActorValueInfoByName("OneHanded").GetSkillExperience()
	PickpocketXp = actorvalueinfo.GetActorValueInfoByName("Pickpocket").GetSkillExperience()
	RestorationXp = actorvalueinfo.GetActorValueInfoByName("Restoration").GetSkillExperience()
	SmithingXp = actorvalueinfo.GetActorValueInfoByName("Smithing").GetSkillExperience()
	SneakXp = actorvalueinfo.GetActorValueInfoByName("Sneak").GetSkillExperience()
	TwoHandedXp = actorvalueinfo.GetActorValueInfoByName("TwoHanded").GetSkillExperience()
	storageutil.SetintValue(none, "SleepCounter", storageutil.GetIntValue(none, "SleepCounter", 0) + storageutil.GetIntValue(none, "DaysInterval", 1))
	if storageutil.GetIntValue(none, "SleepCounter", 0) > 40
		storageutil.SetintValue(none, "SleepCounter", 40)
	endIf
	self.RegisterForSingleUpdateGameTime((storageutil.GetIntValue(none, "DaysInterval", 1) * 24) as Float)
endFunction

Float function ExperienceMultiplier(String skillname)

	return self.GetSkillExperienceForLevel(skillname) / (ThePlayer.GetActorValue(skillname) + 6 as Float - (storageutil.GetIntValue(none, "SleepCounter", 0) / 2 * storageutil.GetIntValue(none, "SleepToggle", 0)) as Float)
endFunction
