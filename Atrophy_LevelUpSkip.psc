;/ Decompiled by Champollion V1.0.1
Source   : Atrophy_LevelUpSkip.psc
Modified : 2021-05-04 10:27:26
Compiled : 2021-05-04 10:28:22
User     : Payam
Computer : DESKTOP-QDPS8AP
/;
scriptName Atrophy_LevelUpSkip extends ReferenceAlias

;-- Properties --------------------------------------
message property SRPLevelupMessage auto
actor property ThePlayerRef auto

;-- Variables ---------------------------------------
Float ActorHealth
Float ActorStamina
Float ActorMagicka

;-- Events ---------------------------------------

function OnInit()
	OnPlayerLoadGame()
endFunction

function OnPlayerLoadGame()
	RegisterForMenu("LevelUp Menu")
endFunction

function OnMenuOpen(String menu)
	if menu == "LevelUp Menu" && storageutil.GetintValue(none, "Level_Down_Counter", 0) > 0 && !storageutil.GetintValue(none, "ExperienceToggle", 0) as Bool
		SRPLevelupMessage.Show(0 as Float, 0 as Float, 0 as Float, 0 as Float, 0 as Float, 0 as Float, 0 as Float, 0 as Float, 0 as Float)
		ActorHealth = ThePlayerRef.GetActorValue("Health")
		ActorMagicka = ThePlayerRef.GetActorValue("Magicka")
		ActorStamina = ThePlayerRef.GetActorValue("Stamina")
	endIf
endFunction

function OnMenuClose(String menu)
	if menu == "LevelUp Menu" && storageutil.GetintValue(none, "Level_Down_Counter", 0) > 0 && !storageutil.GetintValue(none, "ExperienceToggle", 0) as Bool
		ThePlayerRef.SetActorValue("Health", ActorHealth)
		ThePlayerRef.SetActorValue("Magicka", ActorMagicka)
		ThePlayerRef.SetActorValue("Stamina", ActorStamina)
		game.ModPerkPoints(-1)
		storageutil.SetintValue(none, "Level_Down_Counter", storageutil.GetintValue(none, "Level_Down_Counter", 0) - 1)
	endIf
endFunction
