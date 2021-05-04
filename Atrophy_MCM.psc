;/ Decompiled by Champollion V1.0.1
Source   : Atrophy_MCM.psc
Modified : 2021-05-04 10:48:10
Compiled : 2021-05-04 11:08:51
User     : Payam
Computer : DESKTOP-QDPS8AP
/;
scriptName Atrophy_MCM extends SKI_ConfigBase

;-- Properties --------------------------------------

;-- Variables ---------------------------------------
Int SmithingXp
Bool UncappedToggle
Int TwoHandedXp
Int EnchantingXp
Bool NotifToggle
Int LockpickingXp
Int LightArmorXp
Bool NotifToggleSkill
Int AlterationXp
Int SpeechXp
Int RestorationXp
Int SneakXp
Int PickpocketXp
Int DaysInterval
Bool ExperienceToggle
Int BlockXp
Int ArcheryXp
Int AlchemyXp
Int HeavyArmorXp
Bool SleepToggle
Int IllusionXp
Int ConjurationXp
Int DestructionXp
Int OneHandedXp

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

function OnPageReset(String page)

	SpeechXp = storageutil.GetIntValue(none, "SpeechXp", 3)
	AlchemyXp = storageutil.GetIntValue(none, "AlchemyXp", 3)
	AlterationXp = storageutil.GetIntValue(none, "AlterationXp", 3)
	ArcheryXp = storageutil.GetIntValue(none, "ArcheryXp", 3)
	BlockXp = storageutil.GetIntValue(none, "BlockXp", 3)
	ConjurationXp = storageutil.GetIntValue(none, "ConjurationXp", 3)
	DestructionXp = storageutil.GetIntValue(none, "DestructionXp", 3)
	EnchantingXp = storageutil.GetIntValue(none, "EnchantingXp", 3)
	HeavyArmorXp = storageutil.GetIntValue(none, "HeavyArmorXp", 3)
	IllusionXp = storageutil.GetIntValue(none, "IllusionXp", 3)
	LightArmorXp = storageutil.GetIntValue(none, "LightArmorXp", 3)
	LockpickingXp = storageutil.GetIntValue(none, "LockpickingXp", 3)
	OneHandedXp = storageutil.GetIntValue(none, "OneHandedXp", 3)
	PickpocketXp = storageutil.GetIntValue(none, "PickpocketXp", 3)
	RestorationXp = storageutil.GetIntValue(none, "RestorationXp", 3)
	SmithingXp = storageutil.GetIntValue(none, "SmithingXp", 3)
	SneakXp = storageutil.GetIntValue(none, "SneakXp", 3)
	TwoHandedXp = storageutil.GetIntValue(none, "TwoHandedXp", 3)
	DaysInterval = storageutil.GetIntValue(none, "DaysInterval", 1)
	ExperienceToggle = storageutil.GetIntValue(none, "ExperienceToggle", 0) as Bool
	UncappedToggle = storageutil.GetIntValue(none, "UncappedToggle", 0) as Bool
	SleepToggle = storageutil.GetIntValue(none, "SleepToggle", 0) as Bool
	NotifToggle = storageutil.GetIntValue(none, "NotifToggle", 0) as Bool
	NotifToggleSkill = storageutil.GetIntValue(none, "NotifToggleSkill", 0) as Bool
	self.SetCursorFillMode(self.LEFT_TO_RIGHT)
	self.SetCursorPosition(0)
	self.AddHeaderOption("Skill-Use Check Interval", 0)
	self.AddHeaderOption("Unused Skill Progress Drop Rate", 0)
	self.AddEmptyOption()
	self.AddEmptyOption()
	self.AddSliderOptionST("Option_Days", "Check Every", DaysInterval as Float, "{0} Days", 0)
	self.SetCursorFillMode(self.TOP_TO_BOTTOM)
	self.AddSliderOptionST("Option_Alchemy_XP", "Alchemy", AlchemyXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Alteration_XP", "Alteration", AlterationXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Archery_XP", "Archery", ArcheryXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Block_XP", "Block", BlockXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Conjuration_XP", "Conjuration", ConjurationXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Destruction_XP", "Destruction", DestructionXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Enchanting_XP", "Enchanting", EnchantingXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Heavy_Armor_XP", "Heavy Armor", HeavyArmorXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Illusion_XP", "Illusion", IllusionXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Light_Armor_XP", "Light Armor", LightArmorXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Lockpicking_XP", "Lockpicking", LockpickingXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_One_Handed_XP", "One Handed", OneHandedXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Pickpocket_XP", "Pickpocket", PickpocketXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Restoration_XP", "Restoration", RestorationXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Smithing_XP", "Smithing", SmithingXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Sneak_XP", "Sneak", SneakXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Speech_XP", "Speech", SpeechXp as Float, "X{0}", 0)
	self.AddSliderOptionST("Option_Two_Handed_XP", "Two Handed", TwoHandedXp as Float, "X{0}", 0)
	self.AddTextOption("The progress drop rate sliders act as multipliers.", "", 1)
	self.AddTextOption("On X1, it takes three weeks for a skill to drop from", "", 1)
	self.AddTextOption("level 16 to level 15, on the default X3, it takes", "", 1)
	self.AddTextOption("only one week for a skill to drop the same amount,", "", 1)
	self.AddTextOption("and on X10 it'll only take about 2 days.", "", 1)
	self.SetCursorPosition(6)
	self.AddTextOption("Increasing the checking interval will give you", "", 1)
	self.AddTextOption("more time to use your skills and avoid losing", "", 1)
	self.AddTextOption("skill progress, note that, it has no effect on", "", 1)
	self.AddTextOption("the amount of progress lost per day.", "", 1)
	self.AddEmptyOption()
	self.AddHeaderOption("Additional Modifiers", 0)
	self.AddToggleOptionST("Option_Sleep", "Hardcore Mode: Sleep", SleepToggle, 0)
	self.AddEmptyOption()
	self.AddHeaderOption("Compatibility Options", 0)
	self.AddToggleOptionST("Option_Experience", "Compatibility with Experience", ExperienceToggle, 0)
	self.AddToggleOptionST("Option_Uncapped", "Compatibility with Uncapped Skills", UncappedToggle, 0)
	self.AddEmptyOption()
	self.AddHeaderOption("Notification Options", 0)
	self.AddToggleOptionST("Option_Messages", "Notification for losing a character level", NotifToggle, 0)
	self.AddToggleOptionST("Option_Messages_Skill", "Notifications for losing a skill level", NotifToggleSkill, 0)
endFunction

; Skipped compiler generated GotoState

function OnConfigClose()

	storageutil.SetIntValue(none, "SpeechXp", SpeechXp)
	storageutil.SetIntValue(none, "AlchemyXp", AlchemyXp)
	storageutil.SetIntValue(none, "AlterationXp", AlterationXp)
	storageutil.SetIntValue(none, "ArcheryXp", ArcheryXp)
	storageutil.SetIntValue(none, "BlockXp", BlockXp)
	storageutil.SetIntValue(none, "ConjurationXp", ConjurationXp)
	storageutil.SetIntValue(none, "DestructionXp", DestructionXp)
	storageutil.SetIntValue(none, "EnchantingXp", EnchantingXp)
	storageutil.SetIntValue(none, "HeavyArmorXp", HeavyArmorXp)
	storageutil.SetIntValue(none, "IllusionXp", IllusionXp)
	storageutil.SetIntValue(none, "LightArmorXp", LightArmorXp)
	storageutil.SetIntValue(none, "LockpickingXp", LockpickingXp)
	storageutil.SetIntValue(none, "OneHandedXp", OneHandedXp)
	storageutil.SetIntValue(none, "PickpocketXp", PickpocketXp)
	storageutil.SetIntValue(none, "RestorationXp", RestorationXp)
	storageutil.SetIntValue(none, "SmithingXp", SmithingXp)
	storageutil.SetIntValue(none, "SneakXp", SneakXp)
	storageutil.SetIntValue(none, "TwoHandedXp", TwoHandedXp)
	storageutil.SetIntValue(none, "DaysInterval", DaysInterval)
	storageutil.SetIntValue(none, "ExperienceToggle", ExperienceToggle as Int)
	storageutil.SetIntValue(none, "UncappedToggle", UncappedToggle as Int)
	storageutil.SetIntValue(none, "SleepToggle", SleepToggle as Int)
	storageutil.SetIntValue(none, "NotifToggle", NotifToggle as Int)
	storageutil.SetIntValue(none, "NotifToggleSkill", NotifToggleSkill as Int)
endFunction

;-- State -------------------------------------------
state Option_Days

	function OnSliderAcceptST(Float value)

		DaysInterval = value as Int
		self.SetSliderOptionValueST(DaysInterval as Float, "{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("How many days should pass between the times \n skill-use is checked")
	endFunction

	function OnDefaultST()

		DaysInterval = 1
		self.SetSliderOptionValueST(DaysInterval as Float, "{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(DaysInterval as Float)
		self.SetSliderDialogDefaultValue(1 as Float)
		self.SetSliderDialogRange(1 as Float, 7 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Restoration_XP

	function OnSliderAcceptST(Float value)

		RestorationXp = value as Int
		self.SetSliderOptionValueST(RestorationXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		RestorationXp = 3
		self.SetSliderOptionValueST(RestorationXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(RestorationXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Illusion_XP

	function OnSliderAcceptST(Float value)

		IllusionXp = value as Int
		self.SetSliderOptionValueST(IllusionXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		IllusionXp = 3
		self.SetSliderOptionValueST(IllusionXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(IllusionXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Experience

	function OnDefaultST()

		ExperienceToggle = false
		self.SetToggleOptionValueST(ExperienceToggle, false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("Selecting this stops skills' effects on character level")
	endFunction

	function OnSelectST()

		ExperienceToggle = !ExperienceToggle
		self.SetToggleOptionValueST(ExperienceToggle, false, "")
	endFunction
endState

;-- State -------------------------------------------
state Option_Conjuration_XP

	function OnSliderAcceptST(Float value)

		ConjurationXp = value as Int
		self.SetSliderOptionValueST(ConjurationXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		ConjurationXp = 3
		self.SetSliderOptionValueST(ConjurationXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(ConjurationXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Enchanting_XP

	function OnSliderAcceptST(Float value)

		EnchantingXp = value as Int
		self.SetSliderOptionValueST(EnchantingXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		EnchantingXp = 3
		self.SetSliderOptionValueST(EnchantingXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(EnchantingXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Messages_Skill

	function OnDefaultST()

		NotifToggleSkill = false
		self.SetToggleOptionValueST(NotifToggleSkill, false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("Select if you want to be notified when a skill's level drops")
	endFunction

	function OnSelectST()

		NotifToggleSkill = !NotifToggleSkill
		self.SetToggleOptionValueST(NotifToggleSkill, false, "")
	endFunction
endState

;-- State -------------------------------------------
state Option_Alchemy_XP

	function OnSliderAcceptST(Float value)

		AlchemyXp = value as Int
		self.SetSliderOptionValueST(AlchemyXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		AlchemyXp = 3
		self.SetSliderOptionValueST(AlchemyXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(AlchemyXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Destruction_XP

	function OnSliderAcceptST(Float value)

		DestructionXp = value as Int
		self.SetSliderOptionValueST(DestructionXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		DestructionXp = 3
		self.SetSliderOptionValueST(DestructionXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(DestructionXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Smithing_XP

	function OnSliderAcceptST(Float value)

		SmithingXp = value as Int
		self.SetSliderOptionValueST(SmithingXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		SmithingXp = 3
		self.SetSliderOptionValueST(SmithingXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(SmithingXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Two_Handed_XP

	function OnSliderAcceptST(Float value)

		TwoHandedXp = value as Int
		self.SetSliderOptionValueST(TwoHandedXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		TwoHandedXp = 3
		self.SetSliderOptionValueST(TwoHandedXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(TwoHandedXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Alteration_XP

	function OnSliderAcceptST(Float value)

		AlterationXp = value as Int
		self.SetSliderOptionValueST(AlterationXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		AlterationXp = 3
		self.SetSliderOptionValueST(AlterationXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(AlterationXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Heavy_Armor_XP

	function OnSliderAcceptST(Float value)

		HeavyArmorXp = value as Int
		self.SetSliderOptionValueST(HeavyArmorXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		HeavyArmorXp = 3
		self.SetSliderOptionValueST(HeavyArmorXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(HeavyArmorXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Messages

	function OnDefaultST()

		NotifToggle = false
		self.SetToggleOptionValueST(NotifToggle, false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("Select if you want to be notified when your character drops a level")
	endFunction

	function OnSelectST()

		NotifToggle = !NotifToggle
		self.SetToggleOptionValueST(NotifToggle, false, "")
	endFunction
endState

;-- State -------------------------------------------
state Option_Lockpicking_XP

	function OnSliderAcceptST(Float value)

		LockpickingXp = value as Int
		self.SetSliderOptionValueST(LockpickingXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		LockpickingXp = 3
		self.SetSliderOptionValueST(LockpickingXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(LockpickingXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Sneak_XP

	function OnSliderAcceptST(Float value)

		SneakXp = value as Int
		self.SetSliderOptionValueST(SneakXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		SneakXp = 3
		self.SetSliderOptionValueST(SneakXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(SneakXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Uncapped

	function OnDefaultST()

		UncappedToggle = false
		self.SetToggleOptionValueST(UncappedToggle, false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("Selecting this stops skills' maxing out on level 100")
	endFunction

	function OnSelectST()

		UncappedToggle = !UncappedToggle
		self.SetToggleOptionValueST(UncappedToggle, false, "")
	endFunction
endState

;-- State -------------------------------------------
state Option_Pickpocket_XP

	function OnSliderAcceptST(Float value)

		PickpocketXp = value as Int
		self.SetSliderOptionValueST(PickpocketXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		PickpocketXp = 3
		self.SetSliderOptionValueST(PickpocketXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(PickpocketXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Sleep

	function OnDefaultST()

		SleepToggle = false
		self.SetToggleOptionValueST(SleepToggle, false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("The more days you go on without sleep, the faster you lose skill progress")
	endFunction

	function OnSelectST()

		SleepToggle = !SleepToggle
		self.SetToggleOptionValueST(SleepToggle, false, "")
	endFunction
endState

;-- State -------------------------------------------
state Option_Block_XP

	function OnSliderAcceptST(Float value)

		BlockXp = value as Int
		self.SetSliderOptionValueST(BlockXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		BlockXp = 3
		self.SetSliderOptionValueST(BlockXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(BlockXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Archery_XP

	function OnSliderAcceptST(Float value)

		ArcheryXp = value as Int
		self.SetSliderOptionValueST(ArcheryXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		ArcheryXp = 3
		self.SetSliderOptionValueST(ArcheryXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(ArcheryXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Speech_XP

	function OnSliderAcceptST(Float value)

		SpeechXp = value as Int
		self.SetSliderOptionValueST(SpeechXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		SpeechXp = 3
		self.SetSliderOptionValueST(SpeechXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(SpeechXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_One_Handed_XP

	function OnSliderAcceptST(Float value)

		OneHandedXp = value as Int
		self.SetSliderOptionValueST(OneHandedXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		OneHandedXp = 3
		self.SetSliderOptionValueST(OneHandedXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(OneHandedXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState

;-- State -------------------------------------------
state Option_Light_Armor_XP

	function OnSliderAcceptST(Float value)

		LightArmorXp = value as Int
		self.SetSliderOptionValueST(LightArmorXp as Float, "X{0}", false, "")
	endFunction

	function OnHighlightST()

		self.SetInfoText("At which rate should the skill progress drop \n if it remains unused")
	endFunction

	function OnDefaultST()

		LightArmorXp = 3
		self.SetSliderOptionValueST(LightArmorXp as Float, "X{0}", false, "")
	endFunction

	function OnSliderOpenST()

		self.SetSliderDialogStartValue(LightArmorXp as Float)
		self.SetSliderDialogDefaultValue(3 as Float)
		self.SetSliderDialogRange(1 as Float, 10 as Float)
		self.SetSliderDialogInterval(1 as Float)
	endFunction
endState
