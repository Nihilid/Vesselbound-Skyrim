; ============================== ; Vesselbound — Util: Debug ; File: source/util/debug.psc ; Notes: Provides logging helpers for Vesselbound scripts. ; ==============================

Scriptname VB_Debug Hidden

Bool Property gDebug Auto

Function Log(String msg) if gDebug Debug.Trace("[Vesselbound] " + msg) endif EndFunction

Function Warn(String msg) Debug.Trace("[Vesselbound][WARN] " + msg) EndFunction

Function Error(String msg) Debug.Trace("[Vesselbound][ERROR] " + msg) EndFunction