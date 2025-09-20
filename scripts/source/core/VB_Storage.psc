Scriptname VB_Storage extends Quest

; ================================
; Vesselbound – Central Settings
; ================================

; ---------- Feature Toggles ----------
Bool  Property OIOEnabled           = True  Auto
Bool  Property CascadeEnabled       = True  Auto

; ---------- OIO (Orgasm-Induced Ovulation) ----------
; Base chance 0.0–1.0
Float Property OIOBaseChance        = 0.25  Auto
; Force ovulation regardless of cycle checks
Bool  Property OIOForceOvulation    = False Auto
; Weight (0–1) for arousal influence (when SLO present)
Float Property OIOArousalWeight     = 0.50  Auto
; Duration of ovulation (hours)
Float Property OIODurationHours     = 24.0  Auto
; Instant fertilization gates
Bool  Property OIOInstantFertEnabled      = False Auto
Bool  Property OIORequireWombPenetration  = False Auto

; External framework availability
Bool  Property HasSLO               = False Auto
Bool  Property HasSLSO              = False Auto

; ---------- Climax Cascades ----------
; Base chance 0.0–1.0
Float Property CascadeBaseChance    = 0.10  Auto
Int   Property CascadeMaxCount      = 3     Auto
Float Property CascadeDelayMin      = 1.5   Auto
Float Property CascadeDelayMax      = 3.0   Auto
; Cooldown (seconds) per actor to prevent re-trigger spam
Float Property CascadeCooldownSec   = 20.0  Auto

; ---------- Debug / UX ----------
Bool  Property DebugEnabled         = True  Auto
Bool  Property NotificationsEnabled = True  Auto

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

Function Notify(String msg)
    If NotificationsEnabled
        Debug.Notification("[Vesselbound] " + msg)
    EndIf
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

Float Function GetCascadeDelayMinSafe()
    Float minV = CascadeDelayMin
    Float maxV = CascadeDelayMax
    If maxV < 0.0
        maxV = 0.0
    EndIf
    If minV < 0.0
        minV = 0.0
    EndIf
    If minV > maxV
        return maxV
    EndIf
    return minV
EndFunction

Float Function GetCascadeDelayMaxSafe()
    Float minV = CascadeDelayMin
    Float maxV = CascadeDelayMax
    If maxV < 0.0
        maxV = 0.0
    EndIf
    If minV < 0.0
        minV = 0.0
    EndIf
    If maxV < minV
        return minV
    EndIf
    return maxV
EndFunction

; ================================
; Stubs expected by VB_Events
; ================================

; Return whether actor has womb access right now (placeholder)
Bool Function HasWombAccess(Actor akVictim)
    ; TODO: integrate real check (animation tags, equipment, etc.)
    return True
EndFunction

; Return per-actor multiplier for cascade roll (1.0 default)
Float Function GetCascadeRollMult(Actor akVictim)
    ; TODO: integrate fatigue, perks, corruption, etc.
    return 1.0
EndFunction

; Simple guard against repeated cascades within a cooldown window.
; NOTE: For now this is a no-op to keep compile-time simple.
Bool Function CascadeGuardActive(Actor akVictim)
    return False
EndFunction

Function SetCascadeGuard(Actor akVictim, Float seconds)
    ; TODO: implement with StorageUtil/Factions/ActiveEffects if desired
EndFunction
