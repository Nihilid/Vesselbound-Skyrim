Scriptname VB_Settings extends Quest

; === Feature Toggles ===
Bool Property OIOEnabled = True Auto
Bool Property CascadesEnabled = True Auto

; === OIO ===
Int  Property OIOBaseChance = 25 Auto    ; 0–100
Bool Property OIOForceOvulation = False Auto

; === Climax Cascades ===
Int  Property CascadesBaseChance = 10 Auto   ; 0–100
Int  Property CascadesMax = 3 Auto           ; 1–10 (clamped at runtime)

; === Debug/UX ===
Bool Property DebugEnabled = True Auto
Bool Property NotificationsEnabled = True Auto

; --- helpers ---
Int Function ClampInt(Int v, Int lo, Int hi)
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
