; ===== source/bridge/odf_bridge.psc =====
ScriptName VB_Bridge_ODF Hidden


Function ApplyBlessingOverlay(Actor a) Global
; TODO: use ODF to add Blessing of Burdens overlay
EndFunction


; ===== source/bridge/fiss_bridge.psc =====
ScriptName VB_Bridge_FISS Hidden


Function ExportPreset() Global
; TODO: FISS write implementation
EndFunction


Function ImportPreset() Global
; TODO: FISS read implementation
EndFunction


; ===== source/bridge/sum_bridge.psc =====
ScriptName VB_Bridge_SUM Hidden


Float Function Rand01() Global
return Utility.RandomFloat(0.0, 1.0)
EndFunction