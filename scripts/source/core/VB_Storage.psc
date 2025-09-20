Scriptname VB_Storage extends Quest

; ================================
; Vesselbound – Central Settings
; ================================
; Notes:
; - No trailing comments after Property lines (Papyrus parser limitation).
; - Float chances are stored 0.0–1.0. Use the getters below to clamp.

; ---------- Feature Toggles ----------
Bool Property OIOEnabled = True Auto
Bool Property CascadeEnabled = True Auto

; ---------- OIO (Orgasm-Induced Ovulation) ----------
; Chance to trigger OIO on orgasm (0.0–1.0)
Float Property OIOBaseChance = 0.25 Auto
; If true, force ovulation regardless of cycle checks
Bool Property OIOForceOvulation = False Auto

; ---------- Climax Cascades ----------
; Base chance to start or continue a cascade (0.0–1.0)
Float Property CascadeBaseChance = 0.10 Auto
; Maximum number of additional orgasms (1–10)
Int Property CascadeMaxCount = 3 Auto
; Minimum delay between cascade hops (seconds)
Float Property CascadeDelayMin = 1.5 Auto
; Maximum delay between cascade hops (seconds)
Float Property CascadeDelayMax = 3.0 Auto

; ---------- Debug / UX ----------
; Enable Papyrus logging for Vesselbound
Bool Property DebugEnabled = True Auto
; Show on-screen notifications
Bool Property NotificationsEnabled = True Auto

; ================================
; Helpers
; ================================

Int Function ClampInt(Int v, Int lo, Int hi)
    If v < lo
        return lo
    ElseIf v > hi
        return hi
    EndIf
    return v
EndFunction

Float Function ClampFloat(Float v, Float lo, Float hi)
    If v < lo
        return lo
    ElseIf v > hi
        return hi
    EndIf
    return v
EndFunction

; ----- Normalized getters (clamped) -----

Float Function GetOIOBaseChance01()
    return ClampFloat(OIOBaseChance, 0.0, 1.0)
EndFunction

Float Function GetCascadeBaseChance01()
    return ClampFloat(CascadeBaseChance, 0.0, 1.0)
EndFunction

Int Function GetCascadeMaxCount()
    return ClampInt(CascadeMaxCount, 1, 10)
EndFunction

Float Function GetCascadeDelayMin()
    Float minV = CascadeDelayMin
    Float maxV = CascadeDelayMax
    ; Ensure non-negative
    If maxV < 0.0
        maxV = 0.0
    EndIf
    If minV < 0.0
        minV = 0.0
    EndIf
    ; Ensure Min <= Max
    If minV > maxV
        return maxV
    EndIf
    return minV
EndFunction

Float Function GetCascadeDelayMax()
    Float minV = CascadeDelayMin
    Float maxV = CascadeDelayMax
    ; Ensure non-negative
    If maxV < 0.0
        maxV = 0.0
    EndIf
    If minV < 0.0
        minV = 0.0
    EndIf
    ; Ensure Max >= Min
    If maxV < minV
        return minV
    EndIf
    return maxV
EndFunction

; ----- UX -----

Function Notify(String msg)
    If NotificationsEnabled
        Debug.Notification("[Vesselbound] " + msg)
    EndIf
EndFunction
