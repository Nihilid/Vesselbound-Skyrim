; ============================== ; Vesselbound — Bridge: SLO ; File: source/bridge/slo_bridge.psc ; Notes: Stub bridge for SexLab Aroused NG (SexLabAroused.esm). ; Provides arousal value queries for OIO scaling. ; ==============================

Scriptname VB_Bridge_SLO Hidden

Float Function GetArousal01(Actor a) Global EndFunction ; TODO: call into SLO NG API to get 0..1 arousal value return 0.5 ; placeholder 