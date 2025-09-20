Scriptname VB_Feature_OIO extends Quest

VB_Storage Property S Auto

; Entry point: called by FeatureManager after an orgasm
Function HandleOrgasm(Actor akActor)
    If !Settings || !Settings.OIOEnabled || akActor == None
        return
    EndIf

    Int chance = Settings.ClampInt(Settings.OIOBaseChance, 0, 100)
    Bool forceFlag = Settings.OIOForceOvulation

    If forceFlag
        VB_Log.Trace("OIO: Force Ovulation active -> applying ovulation to " + akActor, Settings)
        ApplyOvulation(akActor, True)
        Settings.Notify("OIO: Forced ovulation applied")
        return
    EndIf

    If RollPercent(chance)
        VB_Log.Trace("OIO: Success (" + chance + "%) for " + akActor, Settings)
        ApplyOvulation(akActor, False)
        Settings.Notify("OIO: Ovulation triggered")
    Else
        VB_Log.Trace("OIO: Failed roll (" + chance + "%) for " + akActor, Settings)
    EndIf
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

; Stub: replace with your cycle/fertility system call
Function ApplyOvulation(Actor akActor, Bool forced)
    ; TODO: integrate with Vesselbound fertility subsystem (Skyrim branch)
    ; e.g., call into your ovulation controller or set a mod event flag
    ; For now: no-op
EndFunction
