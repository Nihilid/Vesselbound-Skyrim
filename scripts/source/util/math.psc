; ============================== ; Vesselbound — Util: Math ; File: source/util/math.psc ; Notes: Provides common math helpers for Vesselbound scripts. ; ==============================

Scriptname VB_Math Hidden

Float Function Clamp(Float x, Float lo, Float hi) Global if x < lo return lo elseif x > hi return hi endif return x EndFunction

Float Function Lerp(Float a, Float b, Float t) Global return a + (b - a) * t EndFunction

Bool Function Roll(Float p01) Global if p01 <= 0.0 return False elseif p01 >= 1.0 return True endif return Utility.RandomFloat(0.0, 1.0) <= p01 EndFunction