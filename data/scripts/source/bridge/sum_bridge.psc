; ============================== ; Vesselbound — Bridge: SUM ; File: source/bridge/sum_bridge.psc ; Notes: Stub bridge for Skyrim – Utility Mod (SUM). ; Provides math/helpers fallback wrappers. ; ==============================

Scriptname VB_Bridge_SUM Hidden

Float Function Rand01() Global ; Returns a random float between 0.0 and 1.0 return Utility.RandomFloat(0.0, 1.0) EndFunction