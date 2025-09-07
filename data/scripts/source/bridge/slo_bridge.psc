; ===== source/bridge/slo_bridge.psc =====
ScriptName VB_Bridge_SLO Hidden


Float Function GetArousal01(Actor a) Global
; TODO: call into SLO NG API to get 0..1 arousal; return 0.5 as placeholder
return 0.5
EndFunction


; ===== source/bridge/slso_bridge.psc =====
ScriptName VB_Bridge_SLSO Hidden


Function RegisterOrgasmEvents(Quest q) Global
; TODO: RegisterForModEvent hooks for SLSO
EndFunction


; ===== source/bridge/slate_bridge.psc =====
ScriptName VB_Bridge_SLATE Hidden


Bool Function IsVaginalAct(Actor a) Global
; TODO: query SLATE tag context
return True
EndFunction