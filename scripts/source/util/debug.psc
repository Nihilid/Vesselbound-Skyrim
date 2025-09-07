; ==============================
; Vesselbound — Util: Debug
; File: source/util/debug.psc
; Notes: Provides logging helpers for Vesselbound scripts.
; ==============================

Scriptname VB_Debug Hidden

Bool _enabled = True

Function SetEnabled(Bool b) Global
    _enabled = b
EndFunction

Bool Function IsEnabled() Global
    return _enabled
EndFunction

Function Log(String msg) Global
    if _enabled
        Debug.Trace("[Vesselbound] " + msg)
    endif
EndFunction

Function Warn(String msg) Global
    Debug.Trace("[Vesselbound][WARN] " + msg)
EndFunction

Function Error(String msg) Global
    Debug.Trace("[Vesselbound][ERROR] " + msg)
EndFunction
