Scriptname VB_Events extends Quest

VB_Storage Property S Auto

; ================================
; Lifecycle
; ================================
Event OnInit()
    Debug.Trace("[Vesselbound] Events init")
EndEvent

; ================================
; Entry point from listeners
; ================================
Function OnActorOrgasm(Actor akVictim, Actor akPartner)
    If akVictim == None
        return
    EndIf

    ; ---------- OIO ----------
    If S.OIOEnabled
        Float arousalMult = 1.0
        If S.HasSLO
            arousalMult = GetArousalMult(akVictim) ; placeholder 1.0
        EndIf

        Float pOIO = Clamp01(S.OIOBaseChance * arousalMult)
        If Roll01(pOIO) || S.OIOForceOvulation
            OIO_CreateOva(akVictim, S.OIODurationHours)
        EndIf

        TryInstantFertilize(akVictim, akPartner)
    EndIf

    ; ---------- Cascades ----------
    If S.CascadeEnabled
        HandleCascade(akVictim, akPartner)
    EndIf
EndFunction

; ================================
; OIO helpers (stubs)
; ================================
Function OIO_CreateOva(Actor akVictim, Float hours)
    S.Notify("OIO: Ovulation started for " + akVictim)
    Debug.Trace("[Vesselbound] OIO_CreateOva(" + akVictim + ", " + hours + "h)")
EndFunction

Function TryInstantFertilize(Actor akVictim, Actor akPartner)
    If !S.OIOInstantFertEnabled || akVictim == None || akPartner == None
        return
    EndIf
    If S.OIORequireWombPenetration && !S.HasWombAccess(akVictim)
        return
    EndIf

    ; TODO: apply your immediate fertilization logic here
    Debug.Trace("[Vesselbound] OIO: Instant fertilization check passed for " + akVictim + " vs " + akPartner)
EndFunction

Float Function GetArousalMult(Actor akVictim)
    ; TODO: query SLO (SexLab Aroused Redux or similar). For now weight mix to 1.0
    Float arousal01 = 1.0
    Float w = Clamp01(S.OIOArousalWeight)
    Float mix = arousal01 * w + (1.0 - w)
    return Clamp01(mix)
EndFunction

; ================================
; Cascades
; ================================
Function HandleCascade(Actor akVictim, Actor akPartner)
    If akVictim == None
        return
    EndIf
    If S.CascadeGuardActive(akVictim)
        return
    EndIf

    Float mult = S.GetCascadeRollMult(akVictim)
    Float p = Clamp01(S.CascadeBaseChance * mult)
    If !Roll01(p)
        return
    EndIf

    Int maxN = S.GetCascadeMaxCount()
    S.SetCascadeGuard(akVictim, S.CascadeCooldownSec)
    TriggerCascade(akVictim, akPartner, maxN)
EndFunction

Function TriggerCascade(Actor akVictim, Actor akPartner, Int maxHops)
    Int hop = 0
    While hop < maxHops
        hop += 1

        ; chance each hop stays the same for now; feel free to add DR later
        Float minWait = S.GetCascadeDelayMinSafe()
        Float maxWait = S.GetCascadeDelayMaxSafe()
        Float waitS = RandomFloat(minWait, maxWait)
        Utility.Wait(waitS)

        FireExtraOrgasm(akVictim, hop)
    EndWhile
EndFunction

Function FireExtraOrgasm(Actor akVictim, Int hopIndex)
    If akVictim == None
        return
    EndIf
    S.Notify("Climax Cascade +" + hopIndex)
    Debug.Trace("[Vesselbound] Cascade hop " + hopIndex + " for " + akVictim)

    Int id = ModEvent.Create("Vesselbound_ExtraOrgasm")
    If id
        ModEvent.PushInt(id, hopIndex)
        ModEvent.PushForm(id, akVictim)
        ModEvent.Send(id)
    EndIf
EndFunction

; ================================
; Tiny math (local so we avoid extra deps)
; ================================
Float Function Clamp01(Float v)
    If v < 0.0
        return 0.0
    ElseIf v > 1.0
        return 1.0
    EndIf
    return v
EndFunction

Bool Function Roll01(Float p)
    If p <= 0.0
        return False
    ElseIf p >= 1.0
        return True
    EndIf
    Float r = Utility.RandomFloat(0.0, 1.0)
    return (r <= p)
EndFunction

Float Function RandomFloat(Float lo, Float hi)
    If hi < lo
        Float t = lo
        lo = hi
        hi = t
    EndIf
    return Utility.RandomFloat(lo, hi)
EndFunction
