; ===== source/core/mcm.psc =====


Event OnPageReset(String page)
if page == "General"
AddToggleOption("Debug Logging", S as VB_Debug.gDebug)
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


; NOTE: Replace AddToggleOption/AddSliderOption bodies with MCM Helper bindings as desired.


; ===== Helpers: array util (inline to avoid extra file) =====
ScriptName VB_ArrayUtil Hidden


String[] Function PushString(String[] src, String v) Global
if src == None
String[] t = new String[1]
t[0] = v
return t
endif
Int n = src.Length
String[] out = Utility.CreateStringArray(n + 1)
Int i = 0
while i < n
out[i] = src[i]
i += 1
endwhile
out[n] = v
return out
EndFunction


Float[] Function PushFloat(Float[] src, Float v) Global
if src == None
Float[] t = new Float[1]
t[0] = v
return t
endif
Int n = src.Length
Float[] out = Utility.CreateFloatArray(n + 1)
Int i = 0
while i < n
out[i] = src[i]
i += 1
endwhile
out[n] = v
return out
EndFunction