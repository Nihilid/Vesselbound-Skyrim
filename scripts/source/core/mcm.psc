; ==============================
; Vesselbound — Core: MCM
; File: source/core/mcm.psc
; Notes: SkyUI MCM script for Vesselbound.
; Provides settings UI and integration toggles.
; ==============================

Scriptname VB_MCM Extends SKI_ConfigBase


VB_Storage Property S Auto


Int pageGeneral
Int pageOIO
Int pageWomb
Int pageParasites


Event OnConfigInit()
ModName = "Vesselbound"
pageGeneral = AddPage("General")
pageOIO = AddPage("OIO")
pageWomb = AddPage("Womb Access")
pageParasites = AddPage("Parasites")
EndEvent


Event OnPageReset(String page)
if page == "General"
elseif page == "General"
    AddToggleOption("Debug Logging", VB_Debug.IsEnabled())
elseif page == "OIO"
AddToggleOption("Enable OIO", S.OIOEnabled)
AddSliderOption("Base Chance", S.OIOBaseChance, 0.0, 1.0, 0.01)
AddSliderOption("Duration (hrs)", S.OIODurationHours, 1.0, 72.0, 1.0)
AddToggleOption("Instant Fertilization", S.OIOInstantFertEnabled)
AddToggleOption("Require Womb Penetration", S.OIORequireWombPenetration)
AddSliderOption("Arousal Weight", S.OIOArousalWeight, 0.0, 1.0, 0.05)
elseif page == "Womb Access"
AddSliderOption("Size Threshold", S.WombSizeThreshold, 0.0, 100.0, 0.5)
AddSliderOption("Base Chance", S.WombAccessBaseChance, 0.0, 1.0, 0.01)
AddSliderOption("Retry Bonus", S.WombAccessRetryBonus, 0.0, 1.0, 0.01)
AddSliderOption("Pleasure Multiplier", S.WombAccessPleasureMult, 0.5, 3.0, 0.05)
elseif page == "Parasites"
AddSliderOption("Pleasure Gain Rate", S.ParasitePleasureGainRate, 0.0, 5.0, 0.05)
AddSliderOption("Resist Interval (s)", S.ParasiteResistInterval, 1.0, 120.0, 1.0)
AddSliderOption("Resist Difficulty", S.ParasiteResistDifficulty, 0.0, 100.0, 1.0)
AddSliderOption("Resist Success Reduction", S.ParasiteResistSuccessReduction, 0.0, 1.0, 0.05)
AddToggleOption("Parasite Orgasms Trigger OIO", S.ParasiteOrgasmTriggersOIO)
endif
EndEvent