; ==============================
; Stub: SKSE Mod Event Functions
; Provides compile-time signatures for SKSE natives.
; ==============================

Scriptname SKSE_Events Hidden

; Stub signatures — no implementation, the real ones are native
Function RegisterForModEvent(String eventName, String callback) global native
Function UnregisterForModEvent(String eventName, String callback) global native
Function SendModEvent(String eventName, String strArg = "", Float numArg = 0.0) global native
