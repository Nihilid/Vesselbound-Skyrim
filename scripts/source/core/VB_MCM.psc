Scriptname VB_MCM Extends SKI_ConfigBase

VB_Storage Property S Auto

Int pageGeneral
Int pageOIO
Int pageWomb
Int pageParasites

Event OnConfigInit()
    ModName = "Vesselbound"
    pageGeneral   = AddPage("General")
    pageOIO       = AddPage("OIO")
    pageWomb      = AddPage("Womb Access")
    pageParasites = AddPage("Parasites")
EndEvent

Event OnPageReset(String page)
    if S == None
        AddToggleOption("Storage not bound", False)
        return
    endif

    if page == "General"
        AddToggleOption("Debug Logging", VB_Debug.IsEnabled())

    elseif page == "OIO"
        AddToggleOption("Enable OIO", S.OIOEnabled)
        AddSliderOption("Base Chance", S.OIOBaseChance, 0.0, 1.0)
        AddSliderOption("Duration (hrs)", S.OIODurationHours, 1.0, 72.0)
        AddToggleOption("Instant Fertilization", S.OIOInstantFertEnabled)
        AddToggleOption("Require Womb Penetration", S.OIORequireWombPenetration)
        AddSliderOption("Arousal Weight", S.OIOArousalWeight, 0.0, 1.0)

    elseif page == "Womb Access"
        AddSliderOption("Size Threshold", S.WombSizeThreshold, 0.0, 100.0)
        AddSliderOption("Base Chance", S.WombAccessBaseChance, 0.0, 1.0)
        AddSliderOption("Retry Bonus", S.WombAccessRetryBonus, 0.0, 1.0)
        AddSliderOption("Pleasure Multiplier", S.WombAccessPleasureMult, 0.5, 3.0)

    elseif page == "Parasites"
        AddSliderOption("Pleasure Gain Rate", S.ParasitePleasureGainRate, 0.0, 5.0)
        AddSliderOption("Resist Interval (s)", S.ParasiteResistInterval, 1.0, 120.0)
        AddSliderOption("Resist Difficulty", S.ParasiteResistDifficulty, 0.0, 100.0)
        AddSliderOption("Resist Success Reduction", S.ParasiteResistSuccessReduction, 0.0, 1.0)
        AddToggleOption("Parasite Orgasms Trigger OIO", S.ParasiteOrgasmTriggersOIO)
    endif
EndEvent
