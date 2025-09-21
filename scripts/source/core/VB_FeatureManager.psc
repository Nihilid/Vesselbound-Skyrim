Scriptname VB_Feature_Cascades extends Quest

; Central settings
VB_Storage Property S Auto

Function HandleOrgasm(Actor akActor)
    If akActor == None || S == None
        return
    EndIf
    If !S.CascadeEnabled
        return
    EndIf
    If S.CascadeGuardActive(akActor)
        return
    EndIf

    Float p = Clamp01(S.GetCascadeBaseChance01() * S.GetCascadeRollMult(akActor))
    If !Roll01(p)
        VB_Log.Trace("Cascades: No cascade start (" + ((p * 100.0) as Int) + "%) for " + akActor, S)
        return
    EndIf

    Int maxHops = S.GetCascadeMaxCount()
    S.Notify("Climax Cascade starting…")
    VB_Log.Trace("Cascades: Starting chain (p=" + ((p * 100.0) as Int) + "%, cap " + maxHops + ") for " + akActor, S)

    S.SetCascadeGuard(akActor, S.CascadeCooldownSec)

    Int hop = 0
    While hop < maxHops
        hop += 1

        Float minWait = S.GetCascadeDelayMinSafe()
        Float maxWait = S.GetCascadeDelayMaxSafe()
        Float waitS = RandomFloat(minWait, maxWait)
        VB_Log.Trace("Cascades: Hop " + hop + " in " + waitS + "s", S)
        Utility.Wait(waitS)

        DoExtraOrgasm(akActor, hop)
    EndWhile
EndFunction

Function DoExtraOrgasm(Actor akActor, Int hopIndex)
    If akActor == None || S == None
        return
    EndIf
    S.Notify("Climax Cascade +" + hopIndex + "!")
    VB_Log.Trace("Cascades: Executed extra orgasm hop " + hopIndex + " for " + akActor, S)

    Int id = ModEvent.Create("Vesselbound_ExtraOrgasm")
    If id
        ModEvent.PushInt(id, hopIndex)
        ModEvent.PushForm(id, akActor)
        ModEvent.Send(id)
    EndIf
EndFunction

; --- helpers ---
Bool Function Roll01(Float p)
    If p <= 0.0
        return False
    ElseIf p >= 1.0
        return True
    EndIf
    Float r = Utility.RandomFloat(0.0, 1.0)
    return (r <= p)
EndFunction

Float Function Clamp01(Float v)
    If v < 0.0
        return 0.0
    ElseIf v > 1.0
        return 1.0
    EndIf
    return v
EndFunction

Float Function RandomFloat(Float lo, Float hi)
    If hi < lo
        Float t = lo
        lo = hi
        hi = t
    EndIf
    return Utility.RandomFloat(lo, hi)
EndFunction
