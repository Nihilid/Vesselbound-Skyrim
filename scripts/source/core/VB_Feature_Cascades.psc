Scriptname VB_Feature_Cascades extends Quest

VB_Settings Property Settings Auto
Float Property CascadeDelayMin = 1.5 Auto ; seconds between cascades (feel free to expose via MCM later)
Float Property CascadeDelayMax = 3.0 Auto

Function HandleOrgasm(Actor akActor)
    If !Settings || !Settings.CascadesEnabled || akActor == None
        return
    EndIf

    Int baseChance = Settings.ClampInt(Settings.CascadesBaseChance, 0, 100)
    Int maxHops    = Settings.ClampInt(Settings.CascadesMax, 1, 10)

    If !RollPercent(baseChance)
        VB_Log.Trace("Cascades: No cascade start (" + baseChance + "%) for " + akActor, Settings)
        return
    EndIf

    VB_Log.Trace("Cascades: Starting chain (base " + baseChance + "%, cap " + maxHops + ") for " + akActor, Settings)
    Settings.Notify("Climax Cascade starting…")

    Int hop = 0
    While hop < maxHops
        hop += 1

        ; Re-roll each hop with the same base chance (simple model; later: diminishing returns curve)
        If !RollPercent(baseChance)
            VB_Log.Trace("Cascades: Chain ended on failed roll at hop " + hop, Settings)
            Break
        EndIf

        Float waitS = Utility.RandomFloat(CascadeDelayMin, CascadeDelayMax)
        VB_Log.Trace("Cascades: Hop " + hop + " in " + waitS + "s", Settings)
        Utility.Wait(waitS)

        DoExtraOrgasm(akActor, hop)
    EndWhile
EndFunction

Bool Function RollPercent(Int chance)
    If chance <= 0
        return False
    ElseIf chance >= 100
        return True
    EndIf
    Float r = Utility.RandomFloat(0.0, 100.0)
    return (r <= chance as Float)
EndFunction

Function DoExtraOrgasm(Actor akActor, Int hopIndex)
    If akActor == None
        return
    EndIf

    Settings.Notify("Climax Cascade +" + hopIndex + "!")
    VB_Log.Trace("Cascades: Executed extra orgasm hop " + hopIndex + " for " + akActor, Settings)

    ; ---- Emit: Vesselbound_ExtraOrgasm(Actor, hopIndex) ----
    Int id = ModEvent.Create("Vesselbound_ExtraOrgasm")
    If id
        ModEvent.PushInt(id, hopIndex as Int) ; becomes argNum
        ModEvent.PushForm(id, akActor)        ; becomes sender
        ModEvent.Send(id)
    EndIf
EndFunction

