; ===== source/util/debug.psc =====
ScriptName VB_Debug Hidden


Bool Property gDebug Auto


Function Log(String msg)
if gDebug
Debug.Trace("[Vesselbound] " + msg)
endif
EndFunction


Function Warn(String msg)
Debug.Trace("[Vesselbound][WARN] " + msg)
EndFunction


Function Error(String msg)
Debug.Trace("[Vesselbound][ERROR] " + msg)
EndFunction


; ===== source/util/math.psc =====
ScriptName VB_Math Hidden


Float Function Clamp(Float x, Float lo, Float hi) Global
if x < lo
return lo
elseif x > hi
return hi
endif
return x
EndFunction


Float Function Lerp(Float a, Float b, Float t) Global
return a + (b - a) * t
EndFunction


Bool Function Roll(Float p01) Global
if p01 <= 0.0
return False
elseif p01 >= 1.0
return True
endif
return Utility.RandomFloat(0.0, 1.0) <= p01
EndFunction